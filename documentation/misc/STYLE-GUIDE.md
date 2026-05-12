# Quick Style Customization Guide

## Applying Custom Styles to reference-document.docx

### Step 1: Open the Reference Document

```bash
# Linux
libreoffice reference-document.docx

# Windows
start reference-document.docx

# macOS
open reference-document.docx
```

### Step 2: Access Styles Panel

**LibreOffice:**
- Press `F11` or go to `Format`  `Styles`

**Microsoft Word:**
- Go to `Home` tab  `Styles` group  Click arrow to expand styles pane

### Step 3: Modify Heading Styles

For each heading style (Heading 1, 2, 3, 4):

1. Right-click on the style name  Select "Modify"
2. Set the following:
   - **Font:** Roboto
   - **Font Color:** `#329a9b` (RGB: 50, 154, 155)
   - **Bold:** Yes
   - **Sizes:**
     - Heading 1: 24pt
     - Heading 2: 20pt
     - Heading 3: 16pt
     - Heading 4: 14pt

### Step 4: Modify Body Text

1. Find "Normal" or "Body Text" style
2. Right-click  Modify
3. Set:
   - **Font:** Roboto
   - **Size:** 11pt
   - **Color:** Black (#000000)

### Step 5: Modify Hyperlink Style

1. Find "Hyperlink" or "Internet Link" style
2. Right-click  Modify
3. Set:
   - **Font Color:** `#329a9b`
   - **Underline:** Yes

### Step 6: Modify Code/Monospace Style

1. Find "Source Text" or "Code" style
2. Right-click  Modify
3. Set:
   - **Font:** Roboto Mono
   - **Size:** 10pt
   - **Background:** Light gray (#f0f0f0)

### Step 7: Modify Table Styles

1. Insert a sample table if not present
2. Select the table
3. Apply/create table style with:
   - **Header Row Background:** `#329a9b`
   - **Header Text Color:** White
   - **Header Font:** Roboto Bold
   - **Border Color:** Light gray (#cccccc)
   - **Alternate Row Shading:** Very light gray (#f8f8f8)

### Step 8: Save and Test

1. **Save** the reference-document.docx
2. Close the document
3. Run the generation script:
   ```bash
   ./generate-all-docs.sh
   ```
4. Open a generated file to verify styles are applied

## Color Reference

```
Primary Color:   #329a9b (RGB: 50, 154, 155)
Light Teal:      #4db8b9
Dark Teal:       #267879
Very Light:      #e6f5f5 (backgrounds)
Black:           #000000 (body text)
Light Gray:      #f0f0f0 (code background)
Border Gray:     #cccccc
```

## Font Installation

### Install Roboto (if not already installed)

**Ubuntu/Debian:**
```bash
sudo apt-get install fonts-roboto
```

**Windows:**
1. Download from: https://fonts.google.com/specimen/Roboto
2. Extract and double-click each .ttf file
3. Click "Install"

**macOS:**
```bash
brew install --cask font-roboto
```

## Verification

After applying styles, open the generated .docx files and check:
- [ ] All headings appear in color #329a9b
- [ ] All headings use Roboto font
- [ ] Body text uses Roboto at 11pt
- [ ] Links are colored #329a9b
- [ ] Code blocks use Roboto Mono
- [ ] Table headers have teal background
- [ ] Table of contents is properly formatted

## Troubleshooting

**Styles not saving:**
- Ensure you're modifying the style definition, not just formatting text
- Save as .docx format, not .odt

**Colors look different:**
- Use RGB values: 50, 154, 155
- Ensure document is in RGB color mode, not CMYK

**Fonts not showing:**
- Verify Roboto is installed on your system
- Restart the application after installing fonts
- Font will embed in the reference document for consistency
