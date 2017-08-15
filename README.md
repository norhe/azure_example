# Basic Azure config using

A basic example of creating a VM in Azure using Terraform.

## Usage
To run Terraform:
```
$ terraform init
$ terraform plan
$ terraform apply
```

You need to create a user with access to your Azure account: 
https://www.terraform.io/docs/providers/azurerm/index.html#creating-credentials

After doing so you can use azure_creds.sh file:
```
$ source azure_creds.sh
```

... or populate the variables in terraform.tfvars.  

Other methods exist as well:
https://www.terraform.io/docs/configuration/variables.html

## License
MIT

