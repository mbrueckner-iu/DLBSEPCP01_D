# README
Welcome to my project!
Please follow the steps to run a web site based on AWS with high availabilty all over the world.

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

# How to use the Terraform scripts
## Variables
If you are fine with the infrastructure setting of the scripts, you have to maintain the variables only. Please adjust them to your requirments.