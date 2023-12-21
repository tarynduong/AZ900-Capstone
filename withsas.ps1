# Pull data from github
Invoke-WebRequest -Uri "https://github.com/tarynduong/DS-projects/blob/main/Homework/Data/BuyComputer.csv" -OutFile "C:\User\trucduong\BuyComputer.csv"

# Install Az module to connect to Azure portal
Get-Module -ListAvailable | Where-Object {$_.Name -like 'AzureRM*'} | Uninstall-Module
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

# Define variables
$subscriptionId = "b4572332-a936-4d5b-a535-ec14cc73e0ad"
$storageAccountRG = "Truc_RG"
$storageAccountName = "stcapstonedemo"
$storageContainerName = "sample"
$localPath = "C:\Users\trucduong\BuyComputer.csv"

# Choose subscription
Connect-AzAccount
Get-AzSubscription
Select-AzSubscription -SubscriptionId $subscriptionId

# Get SAS token and use it to upload file to container
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $storageAccountRG -AccountName $storageAccountName).Value[0]
$context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
$containerSASURI = New-AzStorageContainerSASToken -Context $context -ExpiryTime(Get-Date).AddSeconds(3600) -FullUri -Name $storageContainerName -Permission rwdl
azcopy copy $localPath $containerSASURI --recursive
Write-Host "Upload successfully"

# Check container
Get-AzStorageContainer -Name $storageContainerName -Context $context