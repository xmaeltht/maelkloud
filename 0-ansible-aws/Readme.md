># ansible Tutorials for Beginner

**Note** ´´´ This code is set to run in us-east-2
Therefore, if you want to run this in different
region make sure to get the appropriate 
Ami_id as well as update all others parameters.
´´´

>## Prerequisite

Make sure these tools are installed and configure according to your OS system.

* Terraform 
* Ansible 
* awscli (install and configure)

>### step 1

After clone the repo run 

* `cd maelkloud` 

>### step 2
To provision your infrastructure using terraform this command:

* `cd 0-ansible-aws; terra.sh`

>### step 3
To cleanup your infrastructure

* `terraform destroy -auto-approve`
