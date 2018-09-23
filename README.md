# Sample Project - Terraform and Inspec
This project will create an ec2 instance and security group, install a webserver, create a webpage, and then validate through preconfigured tests. I used this project to try out Inspec, and a few terraform things.

## Requirements
Please note, this project was created and tested on MacOS. There may be modifications required for other OSes.

* Access to an AWS account with permissions to create ec2 and security groups
    * Create or use an existing access key and secret from the AWS account - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey
    * Create or use an existing access key pair for ssh access in AWS - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair
    * Place the .pem file for the key pair in the `secrets` directory of this project
* Install Terraform - https://www.terraform.io/intro/getting-started/install.html
    * Ensure the Terraform executable is in your local path
* Install Inspec - https://www.inspec.io/downloads/
    * Ensure the Inspec executable is in your local path

## Setup
1. Clone this repository to your local machine

```
git clone https://github.com/ericharris/sample-terraform-inspec.git
```

2. Edit the `bin/webapp-deploy.sh` file to use the AWS access key and secret you obtained in the Requirements section

3. Ensure your .pem file for the AWS access key pair is in the `secrets` directory

4. Edit the 'terraform/modules/webserver/webserver.tf` file to include the IP address or block you will connect to the instance from
```ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["nnn.nnn.nnn.nnn/nn"]
  }
```

## Build the webserver
The `webapp-deploy.sh` script will execute the commands to build and test the webserver.

From the project's base directory, execute the following commands.

```
cd bin
sh webapp-deploy.sh
```

During the run, you will see these outputs:

1. Terraform will output what it plans to build or change
2. Terraform will create the webserver
3. Once it is created, Terraform outputs some details about what it built (IP, Instance ID, DNS, URL, Security Group ID)
4. Inspec will test the webserver by checking that the security group exists, the instance is running and is the right type, and if the webpage is returning a 200 status and matches the content we provided

Once this show successful completion, your webserver is built!

## Destroy the webserver
Now that we're done with the project, you will want to clean this up to prevent further billing from AWS.

From the project's base directory, execute the following commands.

```
cd terraform/dev
terraform destroy
```

Terraform will show you what it plans to destroy. If this looks correct, type `yes`.

## Notes
This project was setup with the following in mind.

### Terraform
* All Terraform code is in the `terraform` directory
* It is configured to use modules, which can help in code re-use when building multiple of the same resource (instances)
* This can be expanded to multiple environments with slightly differing configs by copying the `dev` directory to `stage` or `prod` and modifying the `terraform.tfvars` file

### Inspec
* All Inspec code is in the `terraform/test` directory
* Inspec was used to test the webserver because I was interested in trying Inspec's AWS platform support
* There are two profiles due to a limitation in the http resource, which does not work when the `-t //aws` is used for the AWS platform support
