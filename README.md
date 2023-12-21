# AZ900-Capstone
A simple program to pull data from a csv file hosted on a public repo and store into Azure Blob Storage with private endpoint.

<img width="415" alt="image" src="https://github.com/tarynduong/AZ900-Capstone/assets/85856280/8c7a53d9-4b2b-41d2-85e1-6365956bac38">

Conditions:
- Create a VM that has only a private IP to access to Azure Blob Storage
- Use RDP to access to the VM
- Demonstrate accessing the blob by 3 ways: a) shared access (SAS) keys, b) managed identity, c) SAS key retrieved from Azure Key Vault

## Azure Resources Needed
| NAME	 | TYPE	|LOCATION |
| ------------- | ------------- |------------- |
| vm  | Data collection rule  |Southeast Asia|
|B1s-demo-vm_OsDisk_1_ad7b24595e1f4bf882b3a89050958aa0  | Disk  |Southeast Asia|
|kv-demo-sea|Key vault|	Southeast Asia|
|log-vm|	Log Analytics workspace	|Southeast Asia|
|b1s-demo-vm8	|Network Interface	|Southeast Asia|
|kv-prvt-epnt.nic.3739f667-0d39-40cc-bb7a-5605fd579981|	Network Interface|	Southeast Asia|
|st-prvt-epnt-nic|	Network Interface	|Southeast Asia|
|B1s-demo-vm-nsg	|Network security group|	Southeast Asia|
|privatelink.blob.core.windows.net|	Private DNS zone	|Global|
|privatelink.table.core.windows.net	|Private DNS zone	|Global|
|privatelink.vaultcore.azure.net|	Private DNS zone|	Global|
|kv-prvt-epnt	|Private endpoint|	Southeast Asia|
|st-prvt-epnt	|Private endpoint|	Southeast Asia|
|pip-uservpn	|Public IP address|	Southeast Asia|
|pip-vgw-dev-southeastasia-01	|Public IP address|	Southeast Asia|
|pip-vgw-dev-southeastasia-02	|Public IP address|	Southeast Asia|
|stcapstonedemo|	Storage account|	Southeast Asia|
|B1s-demo-vm|	Virtual machine	|Southeast Asia|
|B1s-demo-vm-vnet	|Virtual network	|Southeast Asia|
|vgw-dev-southeastasia-01|	Virtual network gateway	|Southeast Asia|

**1. Use RDP to access to the VM**

![image](https://github.com/tarynduong/AZ900-Capstone/assets/85856280/c6aa6d8d-0eaa-4310-9f82-e17a759c6b8d)

Set up a P2S VPN Gateway connection in the same virtual network of the VM:
> [How to RDP to my Azure VM with no public IP](https://stackoverflow.com/questions/67949180/how-to-rdp-to-my-azure-vm-with-no-public-ip-or-bastion-host)
- Install Azure VPN Client: [Microsoft app](https://apps.microsoft.com/detail/9NP355QT2SQB?hl=en-US&gl=US)
- Configure Point-to-Site server configuration using self-signed root certificate: (Microsoft Learn)[https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal]
- Generate and export certificates for P2S: [PowerShell - Azure VPN Gateway](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-certificates-point-to-site)

*`Note`*: If you fail to login to the VM because of auto append email address capability of Windows Security while you want to use the same address pool as given in the example from Microsoft, check solution [here](https://answers.microsoft.com/en-us/windows/forum/all/failed-login-windows-security-appends-email/18894193-86c1-45a4-aec4-18f6b007fa10)

**2. Access Azure Storage Account by 3 ways**
I write PowerShell script to access to the blob.
