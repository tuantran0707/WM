# Google Docs Output Directory

This directory contains generated Google Docs (.docx) files from the markdown documentation in the DUT folders.

## Directory Structure

```
GoogleDocs-Output/
 Gen1/                      # Generation 1 devices
    MicroEdge/            # MicroEdge .docx files
 Gen2/                      # Generation 2 devices
    ACB-M/                # ACB-M .docx files
    ZC-LCD/               # ZC-LCD .docx files
    ZC-Controller-Damper/ # Zone Controller Damper .docx files
    Droplet/              # Droplet .docx files
 SupportBoards/            # Support board documentation
    AC-Connect/           # AC-Connect .docx files
    ZC-Input-14In-8out/   # ZC-Input-14In-8out board .docx files
 sample/                   # Sample documentation templates
```

## Purpose

This folder organizes all Google Docs compatible files (.docx) generated from markdown documentation for:
- Easy upload to Google Drive
- Sharing with non-technical team members
- Factory floor documentation (printed or viewed on tablets)
- Archive of released documentation versions

## Styling

All generated .docx files use custom styling:
- **Primary Color:** `#329a9b` (Teal)
- **Font:** Roboto
- **Table of Contents:** Automatically generated

See [../STYLING.md](../STYLING.md) for detailed styling configuration.

## Generate Documentation

### Generate Individual Device Documentation

To convert a specific device's markdown documentation to .docx format with custom styling:

#### MicroEdge (Gen1)
```bash
pandoc DUT/GEN1/MicroEdge/MicroEdge_Flashing_and_Testing_v1.0.1.md \
  --reference-doc=reference-document.docx \
  --toc \
  -o GoogleDocs-Output/Gen1/MicroEdge/MicroEdge_Flashing_and_Testing_v1.0.1.docx
```

#### ACB-M (Gen2)
```bash
pandoc DUT/GEN2/ACB-M/[FILENAME].md \
  --reference-doc=reference-document.docx --toc \
  -o GoogleDocs-Output/Gen2/ACB-M/[FILENAME].docx
```

#### ZC-LCD (Gen2)
```bash
pandoc DUT/GEN2/ZC-LCD/[FILENAME].md \
  --reference-doc=reference-document.docx --toc \
  -o GoogleDocs-Output/Gen2/ZC-LCD/[FILENAME].docx
```

#### ZC-Controller-Damper (Gen2)
```bash
pandoc DUT/GEN2/ZC-Controller-Damper/[FILENAME].md \
  --reference-doc=reference-document.docx --toc \
  -o GoogleDocs-Output/Gen2/ZC-Controller-Damper/[FILENAME].docx
```

#### Droplet (Gen2)
```bash
pandoc DUT/GEN2/Droplet/[FILENAME].md \
  --reference-doc=reference-document.docx --toc \
  -o GoogleDocs-Output/Gen2/Droplet/[FILENAME].docx
```

#### Support Boards
```bash
# AC-Connect
pandoc DUT/SupportBoards/AC-Connect/[FILENAME].md \
  --reference-doc=reference-document.docx --toc \
  -o GoogleDocs-Output/SupportBoards/AC-Connect/[FILENAME].docx

# ZC-Input-14In-8out
pandoc DUT/SupportBoards/ZC-Input-14In-8out/[FILENAME].md \
  --reference-doc=reference-document.docx --toc \
  -o GoogleDocs-Output/SupportBoards/ZC-Input-14In-8out/[FILENAME].docx
```

### Generate All Documentation

To generate all .docx files at once, use this bash script:

```bash
#!/bin/bash
# Generate all DUT documentation to Google Docs format

# Gen1 - MicroEdge
find DUT/GEN1/MicroEdge -name "*.md" -type f | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" -o "GoogleDocs-Output/Gen1/MicroEdge/${filename}.docx"
    echo "Generated: GoogleDocs-Output/Gen1/MicroEdge/${filename}.docx"
done

# Gen2 - ACB-M
find DUT/GEN2/ACB-M -name "*.md" -type f | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" -o "GoogleDocs-Output/Gen2/ACB-M/${filename}.docx"
    echo "Generated: GoogleDocs-Output/Gen2/ACB-M/${filename}.docx"
done

# Gen2 - ZC-LCD
find DUT/GEN2/ZC-LCD -name "*.md" -type f | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" -o "GoogleDocs-Output/Gen2/ZC-LCD/${filename}.docx"
    echo "Generated: GoogleDocs-Output/Gen2/ZC-LCD/${filename}.docx"
done

# Gen2 - ZC-Controller-Damper
find DUT/GEN2/ZC-Controller-Damper -name "*.md" -type f | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" -o "GoogleDocs-Output/Gen2/ZC-Controller-Damper/${filename}.docx"
    echo "Generated: GoogleDocs-Output/Gen2/ZC-Controller-Damper/${filename}.docx"
done

# Gen2 - Droplet
find DUT/GEN2/Droplet -name "*.md" -type f | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" -o "GoogleDocs-Output/Gen2/Droplet/${filename}.docx"
    echo "Generated: GoogleDocs-Output/Gen2/Droplet/${filename}.docx"
done

# Support Boards - AC-Connect
find DUT/SupportBoards/AC-Connect -name "*.md" -type f | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" -o "GoogleDocs-Output/SupportBoards/AC-Connect/${filename}.docx"
    echo "Generated: GoogleDocs-Output/SupportBoards/AC-Connect/${filename}.docx"
done

# Support Boards - ZC-Input-14In-8out
find DUT/SupportBoards/ZC-Input-14In-8out -name "*.md" -type f | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" -o "GoogleDocs-Output/SupportBoards/ZC-Input-14In-8out/${filename}.docx"
    echo "Generated: GoogleDocs-Output/SupportBoards/ZC-Input-14In-8out/${filename}.docx"
done

echo "All documentation generated successfully!"
```

Save this as `generate-all-docs.sh` and run:
```bash
chmod +x generate-all-docs.sh
./generate-all-docs.sh
```

### Generate Main README
```bash
pandoc README.md --reference-doc=reference-document.docx --toc \
  -o "GoogleDocs-Output/EOL_Factory_Documentation.docx"
```

## Upload to Google Drive

After generation:
1. Upload .docx files to your Google Drive
2. Google Drive will automatically convert them to Google Docs format
3. Share with team members as needed
4. Files can be opened and edited in Google Docs

## File Naming Convention

Use descriptive names with version numbers:
- `DeviceName_Flashing_and_Testing_vX.Y.Z.docx`
- Example: `MicroEdge_Flashing_and_Testing_v1.0.1.docx`

## Version Control

- Keep version numbers in filenames
- Archive old versions when updating documentation
- Document changes in the markdown source files first
- Regenerate .docx files after markdown updates

## Notes

 **Important:**
- Always regenerate .docx files after updating markdown documentation
- Ensure Pandoc is installed: `sudo apt-get install pandoc`
- Generated files are for distribution only - edit markdown sources, not .docx files
- Images in markdown should be in the `images/` subfolder of each device

## Sample Documentation

The `sample/` folder contains reference documentation showing the expected format and structure for EOL testing guides.

---

**Last Updated:** March 11, 2026
