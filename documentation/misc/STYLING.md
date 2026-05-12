# Pandoc Styling Configuration

This directory contains styling configuration for generating Google Docs (.docx) files from markdown.

## Design Specifications

- **Primary Color:** `#329a9b` (Teal/Turquoise)
- **Font Family:** Roboto
- **Monospace Font:** Roboto Mono

## Files

### `pandoc-config.yaml`
Pandoc configuration file with metadata and basic settings.

### `reference-document.docx`
Reference document that defines the styling for all generated .docx files.

## Customizing Styles

The `reference-document.docx` file controls the appearance of generated documents. To customize:

### Using Microsoft Word or LibreOffice

1. **Open the reference document:**
   ```bash
   # On Linux with LibreOffice
   libreoffice reference-document.docx
   
   # On Windows with Microsoft Word
   start reference-document.docx
   ```

2. **Modify Styles:**
   - Go to **Format**  **Styles** (or press F11 in LibreOffice)
   - Modify the following styles to use color `#329a9b`:
     - **Heading 1** - Set font color to #329a9b, font to Roboto, size 24pt, bold
     - **Heading 2** - Set font color to #329a9b, font to Roboto, size 20pt, bold
     - **Heading 3** - Set font color to #329a9b, font to Roboto, size 16pt, bold
     - **Heading 4** - Set font color to #329a9b, font to Roboto, size 14pt, bold
     - **Hyperlink** - Set font color to #329a9b, underline
     - **Normal** - Set font to Roboto, size 11pt, color black
     - **Code** - Set font to Roboto Mono, background light gray
     - **Table** - Set header background to #329a9b with white text

3. **Save the reference document**

4. **Regenerate documentation:**
   ```bash
   ./generate-all-docs.sh
   ```

## Manual Style Application

If Roboto font is not installed on your system, install it first:

### Linux (Ubuntu/Debian)
```bash
sudo apt-get install fonts-roboto
```

### Windows
1. Download Roboto from [Google Fonts](https://fonts.google.com/specimen/Roboto)
2. Install the font files

### macOS
```bash
brew tap homebrew/cask-fonts
brew install --cask font-roboto
```

## Styling Tips

### Color Palette

Primary Color: `#329a9b` (RGB: 50, 154, 155)
- Use for: Headings, links, table headers, important highlights
- Complementary colors for accents:
  - Light: `#4db8b9` 
  - Dark: `#267879`
  - Very light (backgrounds): `#e6f5f5`

### Typography Hierarchy

**All headings MUST use teal color #329a9b:**

```
Heading 1: Roboto Bold, 24pt, #329a9b (TEAL - REQUIRED)
Heading 2: Roboto Bold, 20pt, #329a9b (TEAL - REQUIRED)
Heading 3: Roboto Bold, 16pt, #329a9b (TEAL - REQUIRED)
Heading 4: Roboto Bold, 14pt, #329a9b (TEAL - REQUIRED)
Body Text: Roboto Regular, 11pt, #000000
Code: Roboto Mono Regular, 10pt, #000000 on light gray background
```

**Examples of headers that must be teal:**
- "1. Programs Required for Testing"
- "Required Software"
- "2. Hardware Materials Required"
- All section headings and subheadings

### Table Styling

- Header row: Background #329a9b, Text white, Roboto Bold
- Body rows: Alternate white and very light gray (#f8f8f8)
- Border: Light gray (#cccccc)

### Title Page & Footer

Each document should include:

**Title Page Elements:**
- Document title (large, centered)
- Subtitle: "End-of-Line (EOL) Factory Testing Guide"
- Version number
- Device name
- Date
- NubeIO logo (optional)

**First Page Footer:**
- Reference image: `GoogleDocs-Output/Common/Footer-Text/FirstPage/FirstPage_Footer.png`
- Should include company information and contact details

**Header Image:**
- NubeIO logo: `GoogleDocs-Output/Common/Header-Image/NubeiO-Logo-Header.png`
- Can be added to page headers

## Generation Commands

### With Custom Styling

Generate all documents with the reference document:
```bash
./generate-all-docs.sh
```

Generate individual file with styling:
```bash
pandoc README.md \
  --reference-doc=reference-document.docx \
  --toc \
  -o GoogleDocs-Output/EOL_Factory_Documentation.docx
```

### Testing Styles

Generate a test document to preview styles:
```bash
pandoc /tmp/reference-template.md \
  --reference-doc=reference-document.docx \
  --toc \
  -o test-output.docx
```

## Notes

 **Important:**
- The reference document must be a properly formatted .docx file
- Pandoc uses style names from the reference document, not direct formatting
- After modifying styles, regenerate all documentation to apply changes
- Font availability depends on the system where documents are opened
- If Roboto is not available, system will fall back to default font

## Troubleshooting

**Styles not applying:**
- Ensure reference-document.docx is in the root directory
- Verify style names in the reference document match Pandoc's style names
- Check that fonts are installed on your system

**Colors not showing:**
- Open reference-document.docx and verify colors are applied to styles
- Ensure you're modifying styles, not just direct formatting

**Fonts not appearing in output:**
- Install Roboto font family on your system
- Restart any open Office applications after installing fonts
