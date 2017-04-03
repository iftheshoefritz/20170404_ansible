Example project for Fritz's Ansible talk at Prodigy Finance on 04/04/2017.

Before the talk you need to:

### Clone the source to your local machine

```
git clone git@github.com:iftheshoefritz/20170404_ansible.git
```

### Create the machine

Since Ansible is a tool for configuring machines, we need a machine to configure. Terraform does this for us.

#### Set up AWS key and configure Terraform to use it.
Terraform needs the right access to AWS in order to create instances.

Get an AWS key + secret for your IAM user. Copy these into `example/terraform/terraform.tfvars`:

```
# don't commit to git - linked to your IAM user
aws_access_key = "YOUR_ACCESS_KEY_HERE"
aws_secret_key = "YOUR_SECRET_HERE"
```

#### Create a public/private key pair to install on the new machine
We have to be able to log into the machine, so Terraform has to copy a public key to the machine.

Create a key pair under the Network and Security section of the EC2 console, name it something specific to you, e.g. `alice_key`. The console will make you download a `.pem` private key file. Copy this into your `~/.ssh/` directory and run `chmod 400 ~/.ssh/alice_key.pem`.

Terraform will tell EC2 to install the public key for this `.pem` on your instance, but you need to tell it the right key name. Edit `example/terraform/terraform.tfvars` again and add this line:

```
aws_demo_instance_public_key = "alice_key"
```

#### Run Terraform

```
cd example/terraform
terraform apply
```

You should see something like the following at the end of the output (but expect the IP to change):

```
Outputs:

host_ips = {
  demo = 52.59.190.244
}
host_tags = {
  demo = map[Groups:demo Name:demo]
}
```

Now you are ready for the talk :).
