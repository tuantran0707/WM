# Generate all DUT documentation to Google Docs format (.docx)
# With custom styling: Primary color #329a9b, Font: Roboto

Write-Host "Starting documentation generation with custom styling..." -ForegroundColor Cyan
Write-Host "========================================================"

# Check if reference document exists
if (-not (Test-Path "reference-document.docx")) {
    Write-Host "Warning: reference-document.docx not found. Generating without custom styles." -ForegroundColor Yellow
    $referenceDoc = ""
} else {
    $referenceDoc = "--reference-doc=reference-document.docx"
    Write-Host "Using custom style reference document" -ForegroundColor Green
}

# Ensure output directories exist
$outputDirs = @(
    "GoogleDocs-Output\Gen1\MicroEdge",
    "GoogleDocs-Output\Gen2\ACB-M",
    "GoogleDocs-Output\Gen2\ZC-LCD",
    "GoogleDocs-Output\Gen2\ZC-Controller-Damper",
    "GoogleDocs-Output\Gen2\Droplet",
    "GoogleDocs-Output\Gen2\LoRa-UART",
    "GoogleDocs-Output\SupportBoards\AC-Connect",
    "GoogleDocs-Output\SupportBoards\ZC-Input-14In-8out",
    "GoogleDocs-Output\Applications\BrotherPrinterInstall"
)
foreach ($dir in $outputDirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

# Gen1 - MicroEdge
Write-Host "Generating Gen1 documentation..." -ForegroundColor Cyan
Get-ChildItem -Path "DUT/GEN1/MicroEdge" -Filter "*.md" -File | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    $filename = $_.BaseName
    $sourceDir = $_.DirectoryName
    $outputPath = "$PWD\GoogleDocs-Output\Gen1\MicroEdge\$filename.docx"
    $refDoc = if ($referenceDoc -ne "") { "$PWD\reference-document.docx" } else { "" }
    
    Push-Location $sourceDir
    if ($refDoc -ne "") {
        & pandoc $_.Name "--reference-doc=$refDoc" --toc -o $outputPath
    } else {
        & pandoc $_.Name --toc -o $outputPath
    }
    Pop-Location
    Write-Host "Generated: GoogleDocs-Output/Gen1/MicroEdge/$filename.docx" -ForegroundColor Green
}

# Gen2 - ACB-M
Write-Host "Generating Gen2/ACB-M documentation..." -ForegroundColor Cyan
Get-ChildItem -Path "DUT/GEN2/ACB-M" -Filter "*.md" -File | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    $filename = $_.BaseName
    $sourceDir = $_.DirectoryName
    $outputPath = "$PWD\GoogleDocs-Output\Gen2\ACB-M\$filename.docx"
    $refDoc = if ($referenceDoc -ne "") { "$PWD\reference-document.docx" } else { "" }
    
    Push-Location $sourceDir
    if ($refDoc -ne "") {
        & pandoc $_.Name "--reference-doc=$refDoc" --toc -o $outputPath
    } else {
        & pandoc $_.Name --toc -o $outputPath
    }
    Pop-Location
    Write-Host "Generated: GoogleDocs-Output/Gen2/ACB-M/$filename.docx" -ForegroundColor Green
}

# Gen2 - ZC-LCD
Write-Host "Generating Gen2/ZC-LCD documentation..." -ForegroundColor Cyan
Get-ChildItem -Path "DUT/GEN2/ZC-LCD" -Filter "*.md" -File | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    $filename = $_.BaseName
    $sourceDir = $_.DirectoryName
    $outputPath = "$PWD\GoogleDocs-Output\Gen2\ZC-LCD\$filename.docx"
    $refDoc = if ($referenceDoc -ne "") { "$PWD\reference-document.docx" } else { "" }
    
    Push-Location $sourceDir
    if ($refDoc -ne "") {
        & pandoc $_.Name "--reference-doc=$refDoc" --toc -o $outputPath
    } else {
        & pandoc $_.Name --toc -o $outputPath
    }
    Pop-Location
    Write-Host "Generated: GoogleDocs-Output/Gen2/ZC-LCD/$filename.docx" -ForegroundColor Green
}

# Gen2 - ZC-Controller-Damper
Write-Host "Generating Gen2/ZC-Controller-Damper documentation..." -ForegroundColor Cyan
Get-ChildItem -Path "DUT/GEN2/ZC-Controller-Damper" -Filter "*.md" -File | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    $filename = $_.BaseName
    $sourceDir = $_.DirectoryName
    $outputPath = "$PWD\GoogleDocs-Output\Gen2\ZC-Controller-Damper\$filename.docx"
    $refDoc = if ($referenceDoc -ne "") { "$PWD\reference-document.docx" } else { "" }
    
    Push-Location $sourceDir
    if ($refDoc -ne "") {
        & pandoc $_.Name "--reference-doc=$refDoc" --toc -o $outputPath
    } else {
        & pandoc $_.Name --toc -o $outputPath
    }
    Pop-Location
    Write-Host "Generated: GoogleDocs-Output/Gen2/ZC-Controller-Damper/$filename.docx" -ForegroundColor Green
}

# Gen2 - Droplet
Write-Host "Generating Gen2/Droplet documentation..." -ForegroundColor Cyan
Get-ChildItem -Path "DUT/GEN2/Droplet" -Filter "*.md" -File | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    $filename = $_.BaseName
    $sourceDir = $_.DirectoryName
    $outputPath = "$PWD\GoogleDocs-Output\Gen2\Droplet\$filename.docx"
    $refDoc = if ($referenceDoc -ne "") { "$PWD\reference-document.docx" } else { "" }
    
    Push-Location $sourceDir
    if ($refDoc -ne "") {
        & pandoc $_.Name "--reference-doc=$refDoc" --toc -o $outputPath
    } else {
        & pandoc $_.Name --toc -o $outputPath
    }
    Pop-Location
    Write-Host "Generated: GoogleDocs-Output/Gen2/Droplet/$filename.docx" -ForegroundColor Green
}

    # Gen2 - LoRa-UART
    Write-Host "Generating Gen2/LoRa-UART documentation..." -ForegroundColor Cyan
    Get-ChildItem -Path "DUT/GEN2/LoRa-UART" -Filter "*.md" -File | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
        $filename = $_.BaseName
        $sourceDir = $_.DirectoryName
        $outputPath = "$PWD\GoogleDocs-Output\Gen2\LoRa-UART\$filename.docx"
        $refDoc = if ($referenceDoc -ne "") { "$PWD\reference-document.docx" } else { "" }
    
        Push-Location $sourceDir
        if ($refDoc -ne "") {
            & pandoc $_.Name "--reference-doc=$refDoc" --toc -o $outputPath
        } else {
            & pandoc $_.Name --toc -o $outputPath
        }
        Pop-Location
        Write-Host "Generated: GoogleDocs-Output/Gen2/LoRa-UART/$filename.docx" -ForegroundColor Green
    }

# Support Boards - AC-Connect
Write-Host "Generating SupportBoards/AC-Connect documentation..." -ForegroundColor Cyan
Get-ChildItem -Path "DUT/SupportBoards/AC-Connect" -Filter "*.md" -File | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    $filename = $_.BaseName
    $sourceDir = $_.DirectoryName
    $outputPath = "$PWD\GoogleDocs-Output\SupportBoards\AC-Connect\$filename.docx"
    $refDoc = if ($referenceDoc -ne "") { "$PWD\reference-document.docx" } else { "" }
    
    Push-Location $sourceDir
    if ($refDoc -ne "") {
        & pandoc $_.Name "--reference-doc=$refDoc" --toc -o $outputPath
    } else {
        & pandoc $_.Name --toc -o $outputPath
    }
    Pop-Location
    Write-Host "Generated: GoogleDocs-Output/SupportBoards/AC-Connect/$filename.docx" -ForegroundColor Green
}

# Support Boards - ZC-Input-14In-8out
Write-Host "Generating SupportBoards/ZC-Input-14In-8out documentation..." -ForegroundColor Cyan
Get-ChildItem -Path "DUT/SupportBoards/ZC-Input-14In-8out" -Filter "*.md" -File | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    $filename = $_.BaseName
    $sourceDir = $_.DirectoryName
    $outputPath = "$PWD\GoogleDocs-Output\SupportBoards\ZC-Input-14In-8out\$filename.docx"
    $refDoc = if ($referenceDoc -ne "") { "$PWD\reference-document.docx" } else { "" }
    
    Push-Location $sourceDir
    if ($refDoc -ne "") {
        & pandoc $_.Name "--reference-doc=$refDoc" --toc -o $outputPath
    } else {
        & pandoc $_.Name --toc -o $outputPath
    }
    Pop-Location
    Write-Host "Generated: GoogleDocs-Output/SupportBoards/ZC-Input-14In-8out/$filename.docx" -ForegroundColor Green
}

# Applications - Brother Printer Install
Write-Host "Generating Applications/BrotherPrinterInstall documentation..." -ForegroundColor Cyan
Get-ChildItem -Path "Applications/BrotherPrinterInstall" -Filter "*.md" -File | Where-Object { $_.Name -ne "README.md" } | ForEach-Object {
    $filename = $_.BaseName
    $sourceDir = $_.DirectoryName
    $outputPath = "$PWD\GoogleDocs-Output\Applications\BrotherPrinterInstall\$filename.docx"
    $refDoc = if ($referenceDoc -ne "") { "$PWD\reference-document.docx" } else { "" }
    
    Push-Location $sourceDir
    if ($refDoc -ne "") {
        & pandoc $_.Name "--reference-doc=$refDoc" --toc --number-sections -o $outputPath
    } else {
        & pandoc $_.Name --toc --number-sections -o $outputPath
    }
    Pop-Location
    Write-Host "Generated: GoogleDocs-Output/Applications/BrotherPrinterInstall/$filename.docx" -ForegroundColor Green
}

# Main README
Write-Host "Generating main EOL Factory Documentation..." -ForegroundColor Cyan
if ($referenceDoc -ne "") {
    & pandoc "README.md" $referenceDoc --toc -o "GoogleDocs-Output/EOL_Factory_Documentation.docx"
} else {
    & pandoc "README.md" --toc -o "GoogleDocs-Output/EOL_Factory_Documentation.docx"
}
Write-Host "Generated: GoogleDocs-Output/EOL_Factory_Documentation.docx" -ForegroundColor Green

Write-Host "========================================================"
Write-Host "All documentation generated successfully with custom styling!" -ForegroundColor Green
Write-Host "  Primary Color: #329a9b (Teal)" -ForegroundColor Cyan
Write-Host "  Font: Roboto" -ForegroundColor Cyan
Write-Host "Files are ready in GoogleDocs-Output/ directory" -ForegroundColor Cyan
