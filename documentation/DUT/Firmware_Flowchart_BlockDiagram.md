# Firmware Architecture — AVC Ultrasonic Water Meter

**MCU:** STM32WL5C  •  **Radio:** LoRaWAN AS923-2 (Việt Nam)  •  **Pipe:** DN15

---

## 1. Sơ đồ khối hệ thống

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

## 2. Kiến trúc Firmware (HAL + Application)

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
    H_ADC --> FLOW & ALARM
    H_LCD --> DISP
    H_GPIO --> DISP
    H_IR --> IRCMD
    H_RF --> LWAN
    H_RTC --> PWR & LOG
    H_NVM --> CFG & LOG

    FLOW --> LOG & DISP & ALARM
    CFG --> FLOW & LWAN
    LOG --> LWAN
    ALARM --> LWAN & DISP
    IRCMD --> CFG
    PWR --> FLOW & LWAN

    style APP fill:#e3f2fd,stroke:#1565C0
    style HAL fill:#f0f4c3,stroke:#827717
```

---

## 3. Lưu đồ giải thuật chính

```mermaid
flowchart TD
    START([Power On / Reset]) --> INIT["Init HW<br/>Clock • GPIO • SPI • LPUART • ADC • RTC"]
    INIT --> CFG["Load Config từ Flash<br/>(DevEUI, AppKey, Interval, Cal)"]
    CFG --> VALID{Config<br/>hợp lệ?}
    VALID -- Không --> DEF["Nạp Default Config"] --> JOIN
    VALID -- Có --> JOIN

    JOIN["OTAA Join Request<br/>AS923-2"] --> JOK{Join<br/>Accept?}
    JOK -- Không --> BACK["Exponential Backoff"] --> JOIN
    JOK -- Có --> IDLE

    IDLE(["💤 STOP2 Sleep<br/>~2µA"]) --> WK{Wakeup Source?}

    WK -- "RTC 15s" --> MEAS[/"Đo Ultrasonic<br/>(Mục 4)"/]
    WK -- "RTC 24h" --> RPT[/"Báo cáo LoRaWAN<br/>(Mục 5)"/]
    WK -- "Button" --> SCR[/"Chuyển màn hình<br/>(Mục 6)"/]
    WK -- "IR RX" --> IRC[/"Xử lý AT Command<br/>(Mục 7)"/]

    MEAS --> IDLE
    RPT --> IDLE
    SCR --> IDLE
    IRC --> IDLE

    style START fill:#4CAF50,color:#fff
    style IDLE fill:#2196F3,color:#fff
```

---

## 4. Đo lường Ultrasonic (Time-of-Flight)

```mermaid
flowchart TD
    A([Bắt đầu đo]) --> B["Power ON TDC + Transducers"]
    B --> C["Đo ToF Upstream → t₁"]
    C --> D["Đo ToF Downstream → t₂"]
    D --> E{t₁, t₂<br/>hợp lệ?}
    E -- Không --> F{Retry<br/>< 3?}
    F -- Có --> C
    F -- Không --> FAIL["⚠️ Sensor Fault<br/>Status D6=1"]

    E -- Có --> G["Lặp N=4-8 lần<br/>Loại outlier, lấy trung bình"]
    G --> H["Tính Δt = t₁ - t₂<br/>Q = K · L · Δt / (t₁ · t₂) · A"]
    H --> I["Bù nhiệt độ<br/>(NTC qua ADC)"]
    I --> J{Δt < 0?}
    J -- Có --> K["Reverse Volume += Q·dt<br/>Set Reverse Flag"]
    J -- Không --> L["Forward Volume += Q·dt"]
    K --> M["Cập nhật RAM:<br/>flow, vol, temp, battery"]
    L --> M
    M --> N["Kiểm tra Alarm:<br/>Leak • Burst • Low Bat"]
    N --> O["Power OFF TDC"]
    FAIL --> O
    O --> END([Kết thúc])

    style A fill:#4CAF50,color:#fff
    style END fill:#4CAF50,color:#fff
    style FAIL fill:#f44336,color:#fff
```

---

## 5. Báo cáo LoRaWAN

```mermaid
flowchart TD
    A([Bắt đầu Report]) --> B["Freeze daily record<br/>Lưu History Buffer"]
    B --> C["Đóng gói Payload<br/>(IOTST1501.2 — Mục 8)"]
    C --> D["Uplink LoRaWAN<br/>Port 2, Confirmed"]
    D --> E{ACK?}
    E -- Có --> F["success++"]
    E -- Không --> G{Retry < 3?}
    G -- Có --> D
    G -- Không --> H["fail++ • Log error"]
    F --> I{Có Downlink?}
    H --> I
    I -- Có --> J["Parse Downlink:<br/>• Update Interval<br/>• Update Params<br/>• Remote Reset"]
    J --> K["Apply + Save Flash"]
    I -- Không --> K
    K --> END([Kết thúc])

    style A fill:#4CAF50,color:#fff
    style END fill:#4CAF50,color:#fff
```

---

## 6. Xử lý nút ấn — Chuyển màn hình

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
    S0 & S1 & S2 & S3 & S4 & S5 & S6 --> E["Refresh LCD<br/>Start auto-off 30s"]
    E --> F{Timeout 30s?}
    F -- Không --> F
    F -- Có --> G["Về màn hình mặc định<br/>Tắt backlight"]
    G --> END([Kết thúc])

    style A fill:#4CAF50,color:#fff
    style END fill:#4CAF50,color:#fff
```

---

## 7. Xử lý IR AT Command

```mermaid
flowchart TD
    A([LPUART RX IRQ]) --> B["Buffer ký tự đến CR/LF"]
    B --> C{Parse AT}
    C -- "AT+xxx?" --> R1["Đọc Config / Status"]
    C -- "AT+xxx=val" --> R2["Validate → Save Flash"]
    C -- "AT+DIAG" --> R3["Self-diagnostic<br/>TDC • Sensor • RF • Bat"]
    C -- "AT+RESET" --> R4["NVIC_SystemReset()"]
    C -- "AT+FACTORY" --> R5["Restore Default"]
    C -- "Unknown" --> R6["Return ERROR"]
    R1 & R2 & R3 & R5 & R6 --> T["Gửi Response qua IR TX"]
    R4 --> RST([Reset])
    T --> END([Kết thúc])

    style A fill:#4CAF50,color:#fff
    style END fill:#4CAF50,color:#fff
```

---

## 8. Cấu trúc Uplink Payload (IOTST1501.2)

```mermaid
flowchart LR
    F1["68H<br/>Start"] --> F2["Type<br/>10H"] --> F3["Addr<br/>7B BCD"] --> F4["Ctrl<br/>81H"] --> F5["Len"] --> F6["Header<br/>DI0/DI1/SER<br/>+Timestamp"]
    F6 --> F7["Forward<br/>Vol 5B"] --> F8["Reverse<br/>Vol 5B"] --> F9["Instant<br/>Flow 5B"] --> F10["Temp<br/>4B"] --> F11["WorkTime<br/>2B"] --> F12["Vbat<br/>2B"]
    F12 --> F13["Status<br/>4B"] --> F14["Daily<br/>History"] --> F15["Comm<br/>Stats"] --> F16["CS"] --> F17["16H<br/>End"]
```

---

## 9. Chế độ hoạt động & năng lượng

| Chế độ | Trigger | Thời gian | Dòng | Mô tả |
|---|---|---|---|---|
| **STOP2 Sleep** | Mặc định | ~99.9% | ~2 µA | RAM giữ, RTC chạy |
| **Measure** | RTC 15 s | ~50 ms | ~15 mA | Đo ToF + tính flow |
| **Report** | RTC 24 h | 2–5 s | ~120 mA (TX) | Uplink LoRaWAN |
| **Display** | Button | 30 s | ~5 mA | LCD bật |
| **IR Config** | IR RX | Theo session | ~10 mA | AT command |
| **Join** | Boot / Rejoin | 3–10 s | ~120 mA (TX) | OTAA |

**Wakeup sources từ STOP2:** RTC Alarm A (measure), RTC Alarm B (report), EXTI button, LPUART RX (IR).

---

## 10. Bảng AT Commands (IR Interface)

| Command | Mô tả |
|---|---|
| `AT` | Test connection → `OK` |
| `AT+DEVEUI?` / `AT+DEVEUI=<hex>` | Đọc / Ghi DevEUI |
| `AT+APPEUI?` / `AT+APPEUI=<hex>` | Đọc / Ghi JoinEUI |
| `AT+APPKEY=<hex>` | Ghi AppKey (32 hex) |
| `AT+REGION?` / `AT+REGION=AS923_2` | Đọc / Ghi Region |
| `AT+INTERVAL?` / `AT+INTERVAL=<min>` | Đọc / Ghi Report Interval |
| `AT+FLOWCAL?` / `AT+FLOWCAL=<K>,<off>` | Đọc / Ghi hệ số hiệu chuẩn |
| `AT+STATUS?` | Vol • Flow • Temp • Bat • RSSI |
| `AT+DIAG` | Self-diagnostic |
| `AT+VER?` | Firmware version |
| `AT+RESET` | Software reset |
| `AT+FACTORY` | Factory reset |
