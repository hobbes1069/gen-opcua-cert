param (
    [string]$hostname
)

# Define the output directory
$outputDir = ".\$hostname"

# Create the directory if it doesn't exist
if (!(Test-Path -Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Path to the template file
$templateFile = "extensions.conf.in"
$outputFile = "$outputDir\$hostname.conf"

# Read the template file and replace placeholders with the hostname
if (Test-Path -Path $templateFile) {
    $templateContent = Get-Content -Path $templateFile -Raw
    $processedContent = $templateContent -replace '{{hostname}}', $hostname
    Set-Content -Path $outputFile -Value $processedContent
} else {
    Write-Output "Template file '$templateFile' not found."
    exit
}

# Generate a private key
openssl genrsa -out "$outputDir\${hostname}_privkey.pem" 2048

# Create a Certificate Signing Request (CSR)
openssl req -new -key "$outputDir\${hostname}_privkey.pem" -out "$outputDir\${hostname}.csr" -subj "/C=US/O=Smith & Nephew/OU=Operational Technology/CN=$hostname"

# Generate a self-signed certificate
openssl x509 -req -days 3650 -extfile "$outputDir\$hostname.conf" -in "$outputDir\${hostname}.csr" -signkey "$outputDir\${hostname}_privkey.pem" -out "$outputDir\${hostname}.cer"

# Convert PEM to DER format
openssl x509 -in "$outputDir\${hostname}.cer" -inform PEM -out "$outputDir\${hostname}.der" -outform DER
