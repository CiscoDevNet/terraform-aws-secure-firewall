## **<ins>GO INSTALLATION</ins>**
To run these scripts one would need *GO* downloaded and installed on their system.To do that follow the instructions given [here](https://go.dev/doc/install).  

### **GETTING STARTED**

This github repository uses ***terratest***, a service provided by gruntwork.io to test three different examples of terraform scripts(under */examples*) with one go script for each of them 
(under */test*). 

We will run the go scripts as follows: 

### 1. **<ins>For centralized architecture</ins>**

-- **/test/centralized_architecture_test.go** file contains the terratest script as mentioned above. This script helps to test the terraform architecture and the function *WithDefaultRetryableError()* is used to construct the terraform options with default retryable errors to handle the most common errors in terraform testing. This function takes the path of terraform directory and variable files used in it.

-- *terraform.InitAndApply()* function runs the terraform init and terraform apply command. 

-- *terraform.Destroy()* destroys the cloud architecture.

> <ins>Note</ins>: *defer* is used to run terraform destroy at the very end of execution. 

To run the script: 

*cd* into *test* folder and run the following command
```
$go test centralized_architecture_test.go
```
### 2. **<ins>For muliple az & multi instances</ins>**

Similar to Centralized architecture.
 
To run the script: 

*cd* into *test* folder and run the following command
```
$go test multi_instance_multi_az_test.go
```


### 3. **<ins>For single instance</ins>**
To run the script for single instance: 

*cd* into *test* folder and run the following command

```
$go test single_instance_test.go
```
