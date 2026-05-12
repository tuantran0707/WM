# URGENT: Fix Header Colors - Step by Step

## Problem
Headers like "1. Programs Required for Testing" and "Required Software" are NOT appearing in teal color (#329a9b) in generated documents.

## Root Cause
The `reference-document.docx` file doesn't have heading styles set to teal color.

## Solution (MUST BE DONE MANUALLY)

### Step 1: Open Reference Document

```bash
libreoffice reference-document.docx
```

Or on Windows:
```cmd
start reference-document.docx
```

### Step 2: Open Styles Panel

**In LibreOffice:**
- Press `F11` key
- Or go to: `Format`  `Styles`

**In Microsoft Word:**
- Go to `Home` tab
- Find `Styles` section
- Click the small arrow to expand the Styles pane

### Step 3: Modify Each Heading Style

You MUST modify all 4 heading styles. For each one:

#### Heading 1
1. In Styles panel, find "Heading 1"
2. **Right-click** on "Heading 1"
3. Select **"Modify"** or **"Edit Style"**
4. Click on **Font** or **Character** formatting
5. Change **Font Color** to: `#329a9b`
   - RGB: Red=50, Green=154, Blue=155
6. Ensure **Bold** is checked
7. Click **OK**

#### Heading 2
1. Right-click "Heading 2"  Modify
2. Font Color: `#329a9b` (RGB: 50, 154, 155)
3. Bold: Yes
4. Click OK

#### Heading 3
1. Right-click "Heading 3"  Modify
2. Font Color: `#329a9b` (RGB: 50, 154, 155)
3. Bold: Yes
4. Click OK

#### Heading 4
1. Right-click "Heading 4"  Modify
2. Font Color: `#329a9b` (RGB: 50, 154, 155)
3. Bold: Yes
4. Click OK

### Step 4: Save the Reference Document

**IMPORTANT:** Save the file after making all changes.

- File  Save
- Or `Ctrl+S`

### Step 5: Regenerate All Documents

```bash
cd /home/fw/qs/repos/eol-verification-docs
./generate-all-docs.sh
```

### Step 6: Verify

Open a generated document:

```bash
xdg-open GoogleDocs-Output/Gen1/MicroEdge/MicroEdge_Flashing_and_Testing_v1.0.1.docx
```

**Check these headers are NOW TEAL:**
 "1. Programs Required for Testing" - Should be TEAL
 "Required Software" - Should be TEAL  
 "2. Hardware Materials Required" - Should be TEAL
 All other headers - Should be TEAL

## Exact Color Values

When setting the color in the style editor:

```
Method 1: Use Hex Code
#329a9b

Method 2: Use RGB Values
Red:   50
Green: 154
Blue:  155

Method 3: Use More Colors Dialog
Hex: 329a9b
```

## Why This Must Be Done Manually

- Pandoc copies styles from the reference document
- The reference document MUST have heading styles pre-configured with teal color
- There's no way to override heading colors via command line
- The company template you provided doesn't have teal headings by default

## Quick Check Before Regenerating

After modifying styles in reference-document.docx:

1. Type some text in the document
2. Apply "Heading 1" style to it
3. Does it appear TEAL?  If yes, proceed
4. If no, the style wasn't saved correctly - try again

## Alternative: Use Original Template

If you have the original company template with teal headers already configured:

```bash
cp /path/to/original-template-with-teal-headers.docx reference-document.docx
./generate-all-docs.sh
```

---

**ACTION REQUIRED:** Open reference-document.docx and set ALL heading colors to #329a9b
**TIME NEEDED:** ~5 minutes
**MUST DO:** This cannot be automated - requires manual style editing
