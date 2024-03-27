# Automated Ecommerce checkout process
This project can help you to deploy the infrastructure using AWS serverless architecture and other DevOps tools like terraform and jenkins.

Architecture:

![image](https://github.com/Srilatha-DevOps/Ecommerce/assets/134747767/715cd5fd-69be-43d9-8d3b-80579854e320)



Instructions to deploy the architecture:

* There are two basic groovy pipeines scripts are provided to be used. These can be customzied according to the need. The first pipeline will build the docker image and push it to the AWS ECR repository and pass the new docker image URI to the next pipeline. The second one will be able to run your terraform configuration to build the infrastructure.
* If you don't feel comfortabe in using the jenkins, the terraform can be initiated directly by changing directory into Terraform folder. 


* Terraform:
    * The folder named 'Terraform' has all the required configuration to build provided architecture. 
