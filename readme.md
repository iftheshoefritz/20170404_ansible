Example project for Fritz's Ansible talk on 04/04/2017.

Before the talk you need to:

1. Clone the source `git clone git@github.com:iftheshoefritz/20170404_ansible.git` to your local machine
2. Get an AWS key + secret for your IAM user. Copy these into `example/terraform/terraform.tfvars`:

    ```
    # don't commit to git - linked your IAM user
    aws_access_key = "YOUR_ACCESS_KEY_HERE"
    aws_secret_key = "YOUR_SECRET_HERE"
    ```

3. Since Ansible is a tool for configuring machines, we need a machine to configure. Run Terraform to set up an EC2 instance:

```
cd example/terraform
terraform apply
```
    
