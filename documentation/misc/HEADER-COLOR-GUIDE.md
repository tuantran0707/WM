# Header Color Verification Guide

## Critical Requirement

**ALL headers in the documentation MUST be teal color: #329a9b**

## Headers That Must Be Teal

### Main Section Headers (Heading 1)
- "1. Programs Required for Testing"
- "2. Hardware Materials Required"
- "3. Firmware Information"
- "4. Preparation and Setup"
- etc.

### Subsection Headers (Heading 2)
- "Required Software"
- "Hardware Connection Order"
- "Test Sequence"
- etc.

### Sub-subsection Headers (Heading 3)
- "Test 1: 3 Analog Inputs"
- "Issue: Serial Port Not Appearing"
- etc.

### Detailed Headers (Heading 4)
- Any fourth-level headers
- All nested section titles

## Verifying Teal Color in Reference Document

### Step 1: Open Reference Document

```bash
# Linux
libreoffice reference-document.docx

# Windows
start reference-document.docx
```

### Step 2: Check Each Heading Style

1. Open **Styles** panel (F11 in LibreOffice, Home  Styles in Word)

2. For **each** heading style (Heading 1, 2, 3, 4):
   - Right-click  Modify
   - Check Font Color
   - **MUST be:** #329a9b (RGB: 50, 154, 155)
   - If not, change it to #329a9b
   - Ensure "Bold" is enabled
   - Save the style

### Step 3: Verify in Generated Documents

After modifying the reference document:

```bash
# Regenerate all documents
./generate-all-docs.sh

# Open a generated document
xdg-open GoogleDocs-Output/Gen1/MicroEdge/MicroEdge_Flashing_and_Testing_v1.0.1.docx
```

**Check that ALL headers appear in teal color:**
-  "1. Programs Required for Testing" - Should be teal
-  "Required Software" - Should be teal
-  "2. Hardware Materials Required" - Should be teal
-  All other section headers - Should be teal

## RGB Color Values

To ensure exact color match:

```
Hex:  #329a9b
RGB:  50, 154, 155
HSL:  181, 51%, 40%
```

## Common Issues

### Headers Are Black Instead of Teal

**Problem:** Style color not set in reference document

**Solution:**
1. Open `reference-document.docx`
2. Access Styles panel
3. Modify each Heading style (1-4)
4. Set font color to #329a9b
5. Save document
6. Regenerate all docs

### Only Some Headers Are Teal

**Problem:** Not all heading styles were modified

**Solution:**
- Check and modify ALL heading styles: Heading 1, 2, 3, 4
- Ensure each one has color #329a9b
- Don't forget Heading 4!

### Color Looks Different

**Problem:** Color mode or display settings

**Solution:**
- Use exact RGB values: 50, 154, 155
- Ensure document is in RGB color mode (not CMYK)
- Test on different displays to verify

## Title Page Setup

Documents should start with a title page including:

### YAML Front Matter in Markdown

```yaml
---
title: "MicroEdge Flashing and Testing"
subtitle: "End-of-Line (EOL) Factory Testing Guide"
version: "1.0.1"
device: "MicroEdge (GEN 1)"
date: "March 11, 2026"
author: "NubeIO"
---
```

### Elements on Title Page

1. **Title** (large, bold, can be teal or black)
2. **Subtitle** (medium, normal weight)
3. **Version number**
4. **Device name**
5. **Date**
6. **Company name/logo**

### First Page Footer

- Add footer image: `GoogleDocs-Output/Common/Footer-Text/FirstPage/FirstPage_Footer.png`
- Include contact information
- NubeIO branding

## Verification Checklist

Before finalizing any document:

- [ ] All Heading 1 styles are teal (#329a9b)
- [ ] All Heading 2 styles are teal (#329a9b)
- [ ] All Heading 3 styles are teal (#329a9b)
- [ ] All Heading 4 styles are teal (#329a9b)
- [ ] Title page is present with all metadata
- [ ] First page footer is formatted correctly
- [ ] Fonts are Roboto throughout
- [ ] Table of contents is properly formatted
- [ ] Links are teal colored

## Quick Test

Generate a test document and verify:

```bash
# Generate MicroEdge documentation
pandoc DUT/GEN1/MicroEdge/MicroEdge_Flashing_and_Testing_v1.0.1.md \
  --reference-doc=reference-document.docx \
  --toc \
  -o test-headers.docx

# Open and verify all headers are teal
xdg-open test-headers.docx
```

**Look for these specific headers and confirm they're teal:**
1. "Programs Required for Testing"  Must be teal
2. "Required Software"  Must be teal
3. "Hardware Materials Required"  Must be teal

If ANY header is not teal, the reference document needs to be updated.

---

**Color Reference:** #329a9b (RGB: 50, 154, 155)  
**Status:** Headers must be verified in reference-document.docx  
**Action Required:** Check and update if needed
