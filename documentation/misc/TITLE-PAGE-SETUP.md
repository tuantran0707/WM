# Title Page and Header Styling - Action Required

##  Header Color Requirement

**CRITICAL:** All section headers must be displayed in **teal color #329a9b**

### Examples of Headers That Must Be Teal:
-  "1. Programs Required for Testing"
-  "Required Software"
-  "2. Hardware Materials Required"
-  "Checklist"
-  All section and subsection titles

##  Title Page Added

The MicroEdge documentation now includes a title page with:
- Document title: "MicroEdge Flashing and Testing"
- Subtitle: "End-of-Line (EOL) Factory Testing Guide"
- Version: 1.0.1
- Device: MicroEdge (GEN 1)
- Date: March 11, 2026
- Author: NubeIO

##  Available Assets

### Header Logo
Location: `GoogleDocs-Output/Common/Header-Image/NubeiO-Logo-Header.png`
- Use in page headers for branding

### First Page Footer
Location: `GoogleDocs-Output/Common/Footer-Text/FirstPage/FirstPage_Footer.png`
- Contains company information
- Should be added to first page footer

##  Current Status

**Document Generated:**  With title page metadata  
**Header Color in Reference Doc:**  **NEEDS VERIFICATION**

The company template (`reference-document.docx`) should already have teal headers, but this needs to be verified.

##  How to Verify and Fix Header Colors

### Step 1: Open Reference Document

```bash
# Open the reference document
libreoffice reference-document.docx
# or on Windows: start reference-document.docx
```

### Step 2: Check Heading Styles

1. Press **F11** (LibreOffice) or go to **Home  Styles** (Word)
2. Find **Heading 1** style
3. Right-click  **Modify**
4. Check the **Font Color**
5. **It should be:** #329a9b (RGB: 50, 154, 155)

Repeat for:
- Heading 1
- Heading 2
- Heading 3
- Heading 4

### Step 3: Update If Needed

If any heading is NOT teal (#329a9b):

1. Right-click the heading style
2. Select **Modify**
3. Change font color to #329a9b
4. Click **OK**
5. **Save** the reference document

### Step 4: Regenerate Documents

```bash
./generate-all-docs.sh
```

### Step 5: Verify

Open generated document:
```bash
xdg-open GoogleDocs-Output/Gen1/MicroEdge/MicroEdge_Flashing_and_Testing_v1.0.1.docx
```

**Check these specific headers are teal:**
- "Programs Required for Testing"  Should be teal
- "Required Software"  Should be teal
- "Hardware Materials Required"  Should be teal

##  Adding First Page Footer (Manual)

Since Pandoc doesn't directly support custom footers for the first page only, you'll need to:

### Option 1: Edit in Word/LibreOffice After Generation

1. Open generated .docx file
2. Go to first page
3. Insert  Footer  First Page Footer
4. Add the footer image: `GoogleDocs-Output/Common/Footer-Text/FirstPage/FirstPage_Footer.png`
5. Save as template or repeat for each document

### Option 2: Add Footer to Reference Document

1. Open `reference-document.docx`
2. Insert  Header & Footer
3. Check "Different First Page"
4. Add footer content to first page
5. Save reference document
6. Regenerate all documents

##  Color Reference

```
Teal Color (Primary):
  Hex: #329a9b
  RGB: 50, 154, 155
  Use for: All headings, links, table headers
```

##  Documentation Files

- **HEADER-COLOR-GUIDE.md** - Detailed guide for header styling
- **STYLING.md** - Complete styling reference
- **STYLE-GUIDE.md** - Quick customization steps

##  Next Steps

1. **Verify** header colors in `reference-document.docx`
2. **Update** if needed (change heading styles to #329a9b)
3. **Add** first page footer (manual or via reference document)
4. **Regenerate** all documentation
5. **Verify** all headers appear in teal in generated docs

---

**Status:** Title page added, header colors need verification  
**Action Required:** Check and update reference-document.docx heading styles  
**Target Color:** #329a9b (Teal)
