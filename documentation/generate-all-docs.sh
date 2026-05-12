#!/bin/bash
# Generate all DUT documentation to Google Docs format (.docx)
# With custom styling: Primary color #329a9b, Font: Roboto

echo "Starting documentation generation with custom styling..."
echo "========================================================"

# Ensure output directories exist
mkdir -p "GoogleDocs-Output/Gen1/MicroEdge" \
         "GoogleDocs-Output/Gen2/ACB-M" \
         "GoogleDocs-Output/Gen2/ZC-LCD" \
         "GoogleDocs-Output/Gen2/ZC-Controller-Damper" \
         "GoogleDocs-Output/Gen2/Droplet" \
         "GoogleDocs-Output/Gen2/LoRa-UART" \
         "GoogleDocs-Output/SupportBoards/AC-Connect" \
         "GoogleDocs-Output/SupportBoards/ZC-Input-14In-8out" \
         "GoogleDocs-Output/Applications/BrotherPrinterInstall"

# Check if reference document exists
if [ ! -f "reference-document.docx" ]; then
    echo "  Warning: reference-document.docx not found. Generating without custom styles."
    REFERENCE_DOC=""
else
    REFERENCE_DOC="--reference-doc=reference-document.docx"
    echo " Using custom style reference document"
fi

# Gen1 - MicroEdge
echo "Generating Gen1 documentation..."
find DUT/GEN1/MicroEdge -name "*.md" -type f ! -name "README.md" | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" $REFERENCE_DOC --toc -o "GoogleDocs-Output/Gen1/MicroEdge/${filename}.docx"
    echo " Generated: GoogleDocs-Output/Gen1/MicroEdge/${filename}.docx"
done

# Gen2 - ACB-M
echo "Generating Gen2/ACB-M documentation..."
find DUT/GEN2/ACB-M -name "*.md" -type f ! -name "README.md" | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" $REFERENCE_DOC --toc -o "GoogleDocs-Output/Gen2/ACB-M/${filename}.docx"
    echo " Generated: GoogleDocs-Output/Gen2/ACB-M/${filename}.docx"
done

# Gen2 - ZC-LCD
echo "Generating Gen2/ZC-LCD documentation..."
find DUT/GEN2/ZC-LCD -name "*.md" -type f ! -name "README.md" | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" $REFERENCE_DOC --toc -o "GoogleDocs-Output/Gen2/ZC-LCD/${filename}.docx"
    echo " Generated: GoogleDocs-Output/Gen2/ZC-LCD/${filename}.docx"
done

# Gen2 - ZC-Controller-Damper
echo "Generating Gen2/ZC-Controller-Damper documentation..."
find DUT/GEN2/ZC-Controller-Damper -name "*.md" -type f ! -name "README.md" | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" $REFERENCE_DOC --toc -o "GoogleDocs-Output/Gen2/ZC-Controller-Damper/${filename}.docx"
    echo " Generated: GoogleDocs-Output/Gen2/ZC-Controller-Damper/${filename}.docx"
done

# Gen2 - Droplet
echo "Generating Gen2/Droplet documentation..."
find DUT/GEN2/Droplet -name "*.md" -type f ! -name "README.md" | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" $REFERENCE_DOC --toc -o "GoogleDocs-Output/Gen2/Droplet/${filename}.docx"
    echo " Generated: GoogleDocs-Output/Gen2/Droplet/${filename}.docx"
done

# Gen2 - LoRa-UART
echo "Generating Gen2/LoRa-UART documentation..."
find DUT/GEN2/LoRa-UART -name "*.md" -type f ! -name "README.md" | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" $REFERENCE_DOC --toc -o "GoogleDocs-Output/Gen2/LoRa-UART/${filename}.docx"
    echo " Generated: GoogleDocs-Output/Gen2/LoRa-UART/${filename}.docx"
done

# Support Boards - AC-Connect
echo "Generating SupportBoards/AC-Connect documentation..."
find DUT/SupportBoards/AC-Connect -name "*.md" -type f ! -name "README.md" | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" $REFERENCE_DOC --toc -o "GoogleDocs-Output/SupportBoards/AC-Connect/${filename}.docx"
    echo " Generated: GoogleDocs-Output/SupportBoards/AC-Connect/${filename}.docx"
done

# Support Boards - ZC-Input-14In-8out
echo "Generating SupportBoards/ZC-Input-14In-8out documentation..."
find DUT/SupportBoards/ZC-Input-14In-8out -name "*.md" -type f ! -name "README.md" | while read file; do
    filename=$(basename "$file" .md)
    pandoc "$file" $REFERENCE_DOC --toc -o "GoogleDocs-Output/SupportBoards/ZC-Input-14In-8out/${filename}.docx"
    echo " Generated: GoogleDocs-Output/SupportBoards/ZC-Input-14In-8out/${filename}.docx"
done

# Main README
echo "Generating main EOL Factory Documentation..."
pandoc README.md $REFERENCE_DOC --toc -o "GoogleDocs-Output/EOL_Factory_Documentation.docx"
echo " Generated: GoogleDocs-Output/EOL_Factory_Documentation.docx"

echo "========================================================"
echo " All documentation generated successfully with custom styling!"
echo "  Primary Color: #329a9b (Teal)"
echo "  Font: Roboto"
echo "Files are ready in GoogleDocs-Output/ directory"
