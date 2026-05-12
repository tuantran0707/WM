# Firmware Architecture — AVC Ultrasonic Water Meter

**MCU:** STM32WL5C  •  **Radio:** LoRaWAN AS923-2 (Vietnam)  •  **Pipe:** DN15

---

## 1. System Block Diagram

```mermaid
flowchart LR
    subgraph PWR["⚡ Power"]
        BAT["Battery<br/>3.6V Lithium"]
        LDO["LDO 3.3V"]
        BAT --> LDO
    end

    subgraph SENS["🌊 Sensing"]
        US_TX["Ultrasonic TX"]
        US_RX["Ultrasonic RX"]
        NTC["NTC Temperature"]
        TDC["TDC Chip<br/>(TDC7200)"]
        US_TX --> TDC
        US_RX --> TDC
    end

    subgraph MCU["🧠 STM32WL5C"]
        CORE["Cortex-M4 Core<br/>+ Sub-GHz Radio<br/>+ Flash 256KB"]
    end

    subgraph HMI["👤 HMI"]
        LCD["LCD Display"]
        BTN["Push Button"]
        IR["IR TX/RX<br/>(AT Command)"]
    end

    subgraph RF["📡 RF"]
        ANT["Antenna<br/>AS923-2"]
        GW["LoRaWAN Gateway"]
        SRV["Network Server"]
    end

    LDO --> CORE
    TDC -- SPI --> CORE
    NTC -- ADC --> CORE
    BAT -- ADC --> CORE
    CORE -- SPI --> LCD
    BTN -- GPIO/EXTI --> CORE
    IR -- LPUART --> CORE
    CORE -- RF --> ANT
    ANT --> GW --> SRV
```

---

## 2. Firmware Architecture (HAL + Application)

```mermaid
flowchart TB
    subgraph APP["Application Layer"]
        FLOW["Flow Engine<br/>ToF • Volume • Direction"]
        DISP["Display Manager<br/>Screen pages • Button"]
        IRCMD["IR AT Command<br/>Parser • Config R/W"]
        LWAN["LoRaWAN App<br/>Join • Uplink • Downlink"]
        LOG["Data Logger<br/>Daily freeze • History"]
        ALARM["Alarm Manager<br/>Leak • Burst • Fault"]
        CFG["Config Store<br/>Keys • Params (NVM)"]
        PWR["Power Manager<br/>STOP2 • Wakeup"]
    end

    subgraph HAL["HAL / Drivers"]
        H_TDC["TDC SPI"]
        H_LCD["LCD SPI"]
        H_IR["LPUART (IR)"]
        H_RF["Sub-GHz Radio"]
        H_RTC["RTC"]
        H_ADC["ADC"]
        H_GPIO["GPIO/EXTI"]
        H_NVM["Flash NVM"]
    end

    H_TDC --> FLOW
    H_ADC --> FLOW
    H_ADC --> ALARM
    H_LCD --> DISP
    H_GPIO --> DISP
    H_IR --> IRCMD
    H_RF --> LWAN
    H_RTC --> PWR
    H_RTC --> LOG
    H_NVM --> CFG
    H_NVM --> LOG

    FLOW --> LOG
    FLOW --> DISP
    FLOW --> ALARM
    CFG --> FLOW
    CFG --> LWAN
    LOG --> LWAN
    ALARM --> LWAN
    ALARM --> DISP
    IRCMD --> CFG
    PWR --> FLOW
    PWR --> LWAN

    style APP fill:#e3f2fd,stroke:#1565C0
    style HAL fill:#f0f4c3,stroke:#827717
```

---

## 3. Main Firmware Flowchart

```mermaid
flowchart TD
    START([Power On / Reset]) --> INIT["HW Init<br/>Clock • GPIO • SPI • LPUART • ADC • RTC"]
    INIT --> CFG["Load Config from Flash<br/>(DevEUI, AppKey, Interval, Cal)"]
    CFG --> VALID{Config<br/>valid?}
    VALID -- No --> DEF["Load Default Config"]
    DEF --> JOIN
    VALID -- Yes --> JOIN

    JOIN["OTAA Join Request<br/>AS923-2"] --> JOK{Join<br/>Accept?}
    JOK -- No --> BACK["Exponential Backoff"]
    BACK --> JOIN
    JOK -- Yes --> IDLE

    IDLE(["💤 STOP2 Sleep<br/>~2µA"]) --> WK{Wakeup Source?}

    WK -- "RTC 15s" --> MEAS[/"Ultrasonic Measurement<br/>(Section 4)"/]
    WK -- "RTC 24h" --> RPT[/"LoRaWAN Report<br/>(Section 5)"/]
    WK -- "Button" --> SCR[/"Screen Switch<br/>(Section 6)"/]
    WK -- "IR RX" --> IRC[/"AT Command Handler<br/>(Section 7)"/]

    MEAS --> IDLE
    RPT --> IDLE
    SCR --> IDLE
    IRC --> IDLE

    style START fill:#4CAF50,color:#fff
    style IDLE fill:#2196F3,color:#fff
```

---

## 4. Ultrasonic Measurement (Time-of-Flight)

```mermaid
flowchart TD
    A([Start Measurement]) --> B["Power ON TDC + Transducers"]
    B --> C["Measure ToF Upstream → t₁"]
    C --> D["Measure ToF Downstream → t₂"]
    D --> E{t₁, t₂<br/>valid?}
    E -- No --> F{Retry<br/>< 3?}
    F -- Yes --> C
    F -- No --> FAIL["⚠️ Sensor Fault<br/>Status D6=1"]

    E -- Yes --> G["Repeat N=4-8 times<br/>Remove outliers, average"]
    G --> H["Compute Δt = t₁ - t₂<br/>Q = K · L · Δt / (t₁ · t₂) · A"]
    H --> I["Temperature compensation<br/>(NTC via ADC)"]
    I --> J{Δt < 0?}
    J -- Yes --> K["Reverse Volume += Q·dt<br/>Set Reverse Flag"]
    J -- No --> L["Forward Volume += Q·dt"]
    K --> M["Update RAM:<br/>flow, vol, temp, battery"]
    L --> M
    M --> N["Check Alarms:<br/>Leak • Burst • Low Battery"]
    N --> O["Power OFF TDC"]
    FAIL --> O
    O --> END([End])

    style A fill:#4CAF50,color:#fff
    style END fill:#4CAF50,color:#fff
    style FAIL fill:#f44336,color:#fff
```

---

## 5. LoRaWAN Report

```mermaid
flowchart TD
    A([Start Report]) --> B["Freeze daily record<br/>Save to history buffer"]
    B --> C["Build payload<br/>(IOTST1501.2 — Section 8)"]
    C --> D["LoRaWAN Uplink<br/>Port 2, Confirmed"]
    D --> E{ACK?}
    E -- Yes --> F["success++"]
    E -- No --> G{Retry < 3?}
    G -- Yes --> D
    G -- No --> H["fail++ • Log error"]
    F --> I{Downlink<br/>received?}
    H --> I
    I -- Yes --> J["Parse Downlink:<br/>• Update Interval<br/>• Update Params<br/>• Remote Reset"]
    J --> K["Apply + Save to Flash"]
    I -- No --> K
    K --> END([End])

    style A fill:#4CAF50,color:#fff
    style END fill:#4CAF50,color:#fff
```

---

## 6. Button Handling — Screen Switching

```mermaid
flowchart TD
    A([Button IRQ]) --> B["Debounce 20ms"]
    B --> C["screen_index = (screen_index+1) % 7"]
    C --> D{Screen}
    D -- 0 --> S0["Forward Volume (m³)"]
    D -- 1 --> S1["Instant Flow (m³/h)"]
    D -- 2 --> S2["Reverse Volume (m³)"]
    D -- 3 --> S3["Water Temperature (°C)"]
    D -- 4 --> S4["Battery Voltage (V)"]
    D -- 5 --> S5["LoRaWAN: RSSI / Join"]
    D -- 6 --> S6["DevEUI / FW Version"]
    S0 --> E
    S1 --> E
    S2 --> E
    S3 --> E
    S4 --> E
    S5 --> E
    S6 --> E["Refresh LCD<br/>Start auto-off timer (30s)"]
    E --> F{Timeout 30s?}
    F -- No --> F
    F -- Yes --> G["Return to default screen<br/>Disable backlight"]
    G --> END([End])

    style A fill:#4CAF50,color:#fff
    style END fill:#4CAF50,color:#fff
```

---

## 7. IR AT Command Handler

```mermaid
flowchart TD
    A([LPUART RX IRQ]) --> B["Buffer chars until CR/LF"]
    B --> C{Parse AT}
    C -- "AT+xxx?" --> R1["Read Config / Status"]
    C -- "AT+xxx=val" --> R2["Validate → Save to Flash"]
    C -- "AT+DIAG" --> R3["Self-diagnostic<br/>TDC • Sensor • RF • Battery"]
    C -- "AT+RESET" --> R4["NVIC_SystemReset()"]
    C -- "AT+FACTORY" --> R5["Restore Defaults"]
    C -- "Unknown" --> R6["Return ERROR"]
    R1 --> T
    R2 --> T
    R3 --> T
    R5 --> T
    R6 --> T["Send response via IR TX"]
    R4 --> RST([Reset])
    T --> END([End])

    style A fill:#4CAF50,color:#fff
    style END fill:#4CAF50,color:#fff
```

---

## 8. Uplink Payload Structure (IOTST1501.2)

### 8.1 Frame layout

| Offset | Field | Size | Description |
|---:|---|---:|---|
| 0 | Start | 1 B | `0x68` |
| 1 | Type | 1 B | Instrument type (`0x10`) |
| 2 | Address | 7 B | BCD little-endian |
| 9 | Control | 1 B | `0x81` |
| 10 | Length | 1 B | Data field length |
| 11 | Data Header | 11 B | DI0, DI1, SER, timestamp, protocol no. |
| 22 | Forward Volume | 5 B | Unit + 4 B BCD value |
| 27 | Reverse Volume | 5 B | Unit + 4 B BCD value |
| 32 | Instant Flow | 5 B | Unit + 4 B BCD value |
| 37 | Water Temperature | 4 B | Signed, 0.01 °C |
| 41 | Working Time | 2 B | Hours |
| 43 | Battery Voltage | 2 B | Unit 0.01 V |
| 45 | Status Word 1 + 2 | 4 B | Faults / mode bits |
| 49 | Daily History | N · 14 B | Frozen records |
| ... | Comm Stats | 14 B | Intervals, success/fail counters, RSSI |
| ... | Identifiers | 22 B | ICCID, IMEI, protocol version |
| -2 | Checksum (CS) | 1 B | Sum of bytes mod 256 |
| -1 | End | 1 B | `0x16` |

### 8.2 Sequence diagram (frame composition)

```mermaid
flowchart LR
    F1["0x68<br/>Start"] --> F2["Type<br/>0x10"] --> F3["Addr<br/>7 B"] --> F4["Ctrl<br/>0x81"] --> F5["Len"]
    F5 --> F6["Data Header<br/>11 B"] --> F7["Fwd Vol<br/>5 B"] --> F8["Rev Vol<br/>5 B"] --> F9["Flow<br/>5 B"]
    F9 --> F10["Temp<br/>4 B"] --> F11["WorkTime<br/>2 B"] --> F12["Vbat<br/>2 B"] --> F13["Status<br/>4 B"]
    F13 --> F14["Daily<br/>History"] --> F15["Comm<br/>Stats"] --> F16["IDs<br/>ICCID/IMEI"] --> F17["CS"] --> F18["0x16<br/>End"]
```

### 8.3 Status Word 1 (bit definitions)

| Bit | Name | Description |
|---:|---|---|
| D7 | Direction | `0` Forward / `1` Reverse |
| D6 | Flow sensor / air-in-pipe | `0` OK / `1` Fault |
| D5 | Temperature sensor | `0` OK / `1` Fault |
| D4 | Pipe leak | `0` OK / `1` Detected |
| D3 | Pipe burst | `0` OK / `1` Detected |
| D2 | Main power | `0` Normal / `1` Under-voltage |
| D1–D0 | Reserved | — |

---

## 9. Operating Modes & Power Profile

| Mode | Trigger | Duration | Current | Notes |
|---|---|---|---:|---|
| **STOP2 Sleep** | Default | ~99.9% | ~2 µA | RAM retained, RTC running |
| **Measure** | RTC 15 s | ~50 ms | ~15 mA | ToF + flow calc |
| **Report** | RTC 24 h | 2–5 s | ~120 mA (TX) | LoRaWAN uplink |
| **Display** | Button | 30 s | ~5 mA | LCD active |
| **IR Config** | IR RX | Per session | ~10 mA | AT command R/W |
| **Join** | Boot / Rejoin | 3–10 s | ~120 mA (TX) | OTAA |

**Wakeup sources from STOP2:** RTC Alarm A (measure), RTC Alarm B (report), EXTI button, LPUART RX (IR).

---

## 10. AT Command Set (IR Interface)

| Command | Description |
|---|---|
| `AT` | Connection test → `OK` |
| `AT+DEVEUI?` / `AT+DEVEUI=<hex>` | Read / Write DevEUI |
| `AT+APPEUI?` / `AT+APPEUI=<hex>` | Read / Write JoinEUI |
| `AT+APPKEY=<hex>` | Write AppKey (32 hex chars) |
| `AT+REGION?` / `AT+REGION=AS923_2` | Read / Write region |
| `AT+INTERVAL?` / `AT+INTERVAL=<min>` | Read / Write report interval |
| `AT+FLOWCAL?` / `AT+FLOWCAL=<K>,<off>` | Read / Write calibration |
| `AT+STATUS?` | Volume • Flow • Temp • Battery • RSSI |
| `AT+DIAG` | Self-diagnostic |
| `AT+VER?` | Firmware version |
| `AT+RESET` | Software reset |
| `AT+FACTORY` | Factory reset |
