# README
Welcome to my project!
Please follow the steps to run a web site based on AWS with high availabilty all over the world.

***Pleae note, that the use of this script and all upcoming costs are at your own risk!***

# Prerequisites
## Tools and Tutorials
- [Visual Studio Code](https://code.visualstudio.com/download)
  - [Git](https://git-scm.com/downloads/win)
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
  - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

## AWS
You need an active AWS account with associated credentials, which are allowed to create resources.
How to create a new user and enable CLI access:
- IAM --> Create user --> Enter a username --> Permission options "Attach policies directly" --> Enable policy "AdministratorAccess" --> Create user
- Select newly created user --> tab "Security credentials" --> Create access key --> Select "Command Line Interface (CLI)" --> Create access key
Please store your credentials at a safe place. The script itself isn't a safe place. It will request your credentials on demand.

# How to use the Terraform scripts
## Variables
In general there is no need to adjust any of the settings within the modules. If you are fine with the infrastructure setting of the scripts, you have to maintain the variables file of the root directory only. Please adjust them to your requirments.
All variables beginning with _internal*_ used for transferring values from one module to another.

## Output
The output file of the root directory will show important configuration values after the script was successfully applied.
Please check the output of *application_url* to get immediately access to the created instances.

## First run
You can easily run the script with following Terraform commands. For example in the Visual Studio Code Terminal.
- `terraform init`: This will initialize and prepare anything on your local environment to run the script.
- `terraform validate`: Optional command. Just check if the script seems to be fine. If validation fails, I would appreciate, to get a note from you.
- `terraform apply`: The script will create all resources on AWS. Please add your credentials and confirm the plan with typing *yes*. Please note, that from now on, costs will be charged by AWS.
- `terraform destroy`: Important if you are running a test, on productive environments be careful. The command will disable and delete all resources on AWS. Please add your credentials and confirm the plan with typing *yes*. After this is successful finished, no further costs will be charged.