#Set the varables needed to do client credential flow
$clientId = "<app_ID>"
$appSecret = "<client_secret>"
$tenantID = "<Azue_Tenant_ID>"
#set the resource ie...https://graph.microsoft.com, https://storage.azure.com
$resourceAppIdUri = 'https://graph.microsoft.com'
$oAuthUri = "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token"
 

$authBody = [Ordered] @{
    client_id = $clientId
    client_secret = $appSecret
    grant_type = 'client_credentials'
    scope = 'https://graph.microsoft.com/.default'
} 
$authResponse = Invoke-RestMethod -Method Post -Uri $oAuthUri -Body $authBody -ErrorAction Stop
$token = $authResponse.access_token 

 
#Will display the access token.  
echo $token



