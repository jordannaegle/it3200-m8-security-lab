# IT3200 Azure Security Lab

Terraform provisions exactly three VMs: Ubuntu Linux, Kali Linux, and Windows Server. No additional tools or packages are installed.

## Infrastructure

The root configuration calls the reusable module in `modules/security_lab`.

The module creates:
- One resource group, virtual network, and subnet.
- Three VMs, each with an OS disk, network interface, public IP, and network security group.
- SSH access to Linux and RDP access to Windows, restricted to `allowed_source_cidr`.

## Operating system images

| VM | Publisher | Offer | SKU | Version | Size |
|---|---|---|---|---|---|
| Ubuntu | Canonical | ubuntu-24_04-lts | server | 24.04.202610250 | Standard_D2ds_v4 |
| Kali | kali-linux | kali | kali-2026-2 | 2026.2.0 | Standard_D2ds_v4 |
| Windows | MicrosoftWindowsServer | WindowsServer | 2022-datacenter-g2 | 20348.5773.261025 | Standard_D2s_v4 |

All images are x64, Generation 2. Image selection is defined in the `source_image_reference` blocks in the module's `ubuntu.tf`, `kali.tf`, and `windows.tf` files. Versions are pinned for reproducibility.

Kali requires Marketplace plan publisher `kali-linux`, product `kali`, and name `kali-2026-2`. Its terms must be accepted separately in the deploying subscription. Ubuntu and Windows have no Marketplace purchase plan. Windows licensing is included in the Azure image's applicable usage charges.

## Naming

VM names use `resource-uvu-it3200-studentname`, for example:
- ubuntu-uvu-it3200-jordan-naegle
- kali-uvu-it3200-jordan-naegle
- windows-uvu-it3200-jordan-naegle

The `student_name` variable controls the student identifier. Use a short identifier containing lowercase letters, numbers, or hyphens.

The Windows Azure resource retains the full required name. Its internal hostname is `win-it3200` to accommodate Windows' 15-character hostname limit.

## Prerequisites

- Terraform >= 1.10 and < 2.0.
- Azure CLI and an active Azure subscription.
- Permission to create Compute and Network resources and register required resource providers.
- An SSH key pair and a strong Windows administrator password.
- An allowed deployment region with the specified images and VM sizes.
- At least 6 available regional vCPUs: 4 in Standard DDSv4 and 2 in Standard DSv4.

The deployment was verified in `westus3`. Subscription region policies vary. East US was blocked by the original subscription's allowed-region policy. Check policies, quotas, and size availability in your own subscription before applying.

## Deployment using PowerShell

Clone this repository and open PowerShell in its root directory.

Sign in and select your own subscription:

```powershell
az login
az account set --subscription "<your subscription name or ID>"
```

Generate your own SSH key pair. Do not overwrite an existing key:

```powershell
ssh-keygen -t rsa -b 4096 -f .\lab_ssh.key -C "uvu-it3200-lab"
```

Copy the example settings and edit all relevant values:

```powershell
Copy-Item terraform.tfvars.example terraform.tfvars
notepad terraform.tfvars
```

Set `subscription_id` to your subscription ID, `student_name` to your identifier, and `allowed_source_cidr` to your public IPv4 address followed by `/32`. The example address is a placeholder.

Review the Kali license and Marketplace terms:

```powershell
$terms = az vm image terms show --urn "kali-linux:kali:kali-2026-2:2026.2.0" | ConvertFrom-Json
Start-Process $terms.licenseTextLink
Start-Process $terms.marketplaceTermsLink
```

If you agree, record acceptance in your subscription:

```powershell
az vm image terms accept --urn "kali-linux:kali:kali-2026-2:2026.2.0"
```

Set a unique Windows password with uppercase, lowercase, numbers, and symbols. Use 16-24 characters and avoid including the administrator username:

```powershell
$labPassword = Read-Host "Windows VM password" -AsSecureString
$env:TF_VAR_windows_admin_password = [System.Net.NetworkCredential]::new("", $labPassword).Password
Remove-Variable labPassword
$env:TF_VAR_windows_admin_password.Length
```

Confirm the displayed length matches the password you entered. Keep this PowerShell session open for subsequent Terraform commands.

Initialize, check, and preview:

```powershell
terraform init
terraform fmt -recursive
terraform validate
terraform plan "-out=lab.tfplan"
```

Review the plan, then deploy. Applying creates billable Azure resources:

```powershell
terraform apply "lab.tfplan"
terraform output
```

The configuration creates all three VMs and their supporting infrastructure without manually creating resources in the portal.

## Verification

```powershell
az vm list --resource-group "rg-uvu-it3200-<your-student-name>" --show-details --query "[].{Name:name,Power:powerState,Status:provisioningState,Offer:storageProfile.imageReference.offer,SKU:storageProfile.imageReference.sku}" --output table
```

The original deployment returned `VM running` and `Succeeded` for all three required operating systems.

## Credentials and Git

Never commit private keys, passwords, Terraform state, saved plans, or actual variable files. The supplied `.gitignore` excludes these files. Commit `.terraform.lock.hcl` and `terraform.tfvars.example`.

Terraform state and saved plans can contain the Windows password even though its variable is marked sensitive. Keep them protected locally. Generate your own credentials when reproducing this lab.

## Cleanup

When finished, review and confirm destruction of this lab's resources:

```powershell
terraform destroy
```

Keep the Terraform state until cleanup is complete. Verify destruction succeeded to avoid ongoing VM, disk, and public IP charges. If the password environment variable is needed in a new session, set it again before running Terraform.
