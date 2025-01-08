#This script is use to query the Login.microsoftonline.com/common endpoint to validate if the user's email is register to a Microsoft Account


# Define the output CSV file path
$outputCsv = "C:\Users\Public\userrealm_results.csv"

# Define the list of user emails (or import from a file)
# $userEmails = Get-Content -Path "C:\Path\To\Your\File.txt"
$userEmails = @(
    "xxxl@xxx.com"
    
    
)

# Create an array to store results
$results = @()

# Function to check user realm
function Check-UserRealm {
    param (
        [string]$UserEmail
    )
    $url = "https://login.microsoftonline.com/common/userrealm?user=$UserEmail&api-version=2.1&checkForMicrosoftAccount=true"

    try {
        # Send a GET request
        $response = Invoke-RestMethod -Uri $url -Method Get

        # Check response type and parse
        if ($response -is [System.Xml.XmlDocument]) {
            # Handle XML response
            $props = @{}
            $response.DocumentElement.ChildNodes | ForEach-Object {
                $props[$_.Name] = $_.InnerText
            }
            return $props
        } elseif ($response -is [PSCustomObject]) {
            # Handle JSON response
            return $response
        } else {
            Write-Host "Unexpected response type for $UserEmail"
            return @{ "Email" = $UserEmail; "Error" = "Unexpected response type" }
        }
    } catch {
        Write-Host "Failed to retrieve data for $UserEmail. Error: $_"
        return @{ "Email" = $UserEmail; "Error" = $_.Exception.Message }
    }
}

# Process each user and collect results
foreach ($email in $userEmails) {
    Write-Host "Checking realm for: $email"
    $result = Check-UserRealm -UserEmail $email

    # Add email to the result for context
    if ($result -is [PSCustomObject]) {
        $result | Add-Member -MemberType NoteProperty -Name "Email" -Value $email -Force
    } elseif ($result -is [hashtable]) {
        $result["Email"] = $email
    }

    # Add the result to the results array
    $results += $result
}

# Export results to CSV
$results | Export-Csv -Path $outputCsv -NoTypeInformation -Force

Write-Host "Results exported to $outputCsv"
