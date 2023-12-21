# Pull data from github
Invoke-WebRequest -Uri "https://github.com/tarynduong/DS-projects/blob/main/Homework/Data/PVD_Asset.csv" -OutFile "C:\User\trucduong\PVD_Asset.csv"

# Define variables
$subscriptionId = "b4572332-a936-4d5b-a535-ec14cc73e0ad"
$storageAccountRG = "Truc_RG"
$storageAccountName = "stcapstonedemo"
$storageContainerName = "sample"
$localPath = "C:\Users\trucduong\PVD_Asset.csv"
$keyVaultName = "kv-demo-sea"

# Login to Azure portal
Connect-AzAccount

# Select subscription in case there are many subscriptions available
Select-AzSubscription -SubscriptionId $subscriptionId

# Get the storage account key to access storage account
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $storageAccountRG -AccountName $storageAccountName).Value[0]

# Access storage account, or say standing in the storage account context
$storageAccountContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

# Get the SAS token for the storage container
$SasToken = New-AzStorageContainerSASToken -Name $storageContainerName -Permission rwdl -Context $storageAccountContext

# Convert the SAS token to secure string in Key Vault, then give it a name, i.e. SAS, which is our key
$keyValue = ConvertTo-SecureString $SasToken -AsPlainText -Force

# Get the secret associated with the key
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "SAS" -SecretValue $keyValue
$secret = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name "SAS" -AsPlainText

# Create a context with the secret value, which is SAS Token previously
$SasContext = New-AzStorageContext -StorageAccountName $storageAccountName -SasToken $secret

# Upload file
Set-AzStorageBlobContent -File $localPath -Container $storageContainerName -Context $SasContext