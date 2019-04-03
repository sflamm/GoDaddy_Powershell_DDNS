#
This script is used to check and update your GoDaddy DNS server to the IP address of your current internet connection.

First go to GoDaddy developer site to create a developer account and get your key and secret

https://developer.godaddy.com/getstarted
 
Update the first 4 varriables with your information
 
#>
$domain = 'your.domain.to.update'  # your domain
$name = 'name_of_host' #name of the A record to update
$key = 'key' #key for godaddy developer API
$secret = 'Secret' #Secret for godday developer API

$Headers = @{}
$Headers["Authorization"] = 'sso-key ' + $apiKey + ':' + $apiSecret

$result = Invoke-WebRequest https://api.godaddy.com/v1/domains/$domain/records/A/$name -Method Get -Headers $Headers
$content = ConvertFrom-Json $result.content
$dnsIp = $content.data
$currentIp = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip

if ( $currentIp -ne $dnsIp) {
    $json = ConvertTo-Json @(@{data=$currentIp;ttl=600})
    Invoke-WebRequest https://api.godaddy.com/v1/domains/$domain/records/A/$name -Method put -headers $headers -Body $json -ContentType 'application/json'
}
# Print Update
# Invoke-WebRequest https://api.godaddy.com/v1/domains/$domain/records/A/$name -Method Get -Headers $Headers | ConvertFrom-Json
