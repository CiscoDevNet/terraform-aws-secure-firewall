## **Getting Started with pre-commit**

The idea behind pre-commit, is that it 
runs a set of commands to check your .tf files before you commit your changes to github.With pre-commit , you can ensure your Terraform module documentation is kept up-to-date each time you make a commit.

### <ins> Installation:</ins>
If this is your first time using pre-commit-              
1. Install [pre-commit](https://pre-commit.com).         
2. Run *pre-commit* install in the repo once.

Now each time anyone commits a code change regarding terraform, the hooks in the hooks: config will execute by itself.

### <ins> Details:</ins>
The .pre-commit-config.yaml file in our case consists of the following hooks: 

1. ***terraform-fmt***: Automatically run terraform fmt on all terraform code (*.tf files).

2. ***terraform_docs*** is a utility to automatically generate documentation from Terraform modules and base repositories in various output formats.  

3. ***terraform_tflint*** is a linter that checks for possible errors, best practices etc in your terraform code.

