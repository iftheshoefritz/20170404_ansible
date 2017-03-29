# Intro to Ansible

# Presenter Notes

Giving Prodigy perspective on this tool, there's a lot more that we don't use, but I can only give some of the
possibilities, and I don't want to cover too much that's not immediately useful

Need to give some background, stick with me before I get to real code, hopefully explain why we need to be
able to do this stuff, and be able to transfer principles to whatever the next tool is.

---
# Doing stuff with code

  1. get new machine - Macbook from Rob
  2. get it ready for an app - install e.g. git, ruby, postgres, vim
  3. put your code on it - e.g. git clone
  4. so much winning

# Presenter Notes

We've all gone through this cycle, as you build more apps or use more computers (or servers) you go through it
more often. But we've all done it at least once. 

When I started working at prodigy I got a new laptop from Rob, then I installed stuff on it, then I got the
code, then I started to dev.  

---

## Web app deployment

  1. get servers
  2. install stuff
  3. Copy the code
  4. so much winning, now over the Internet

# Presenter Notes

Almost all of our apps are web applications accessed by users with their web browsers over the Internet.
So that means we have to have a server on the Internet.

We still have similar 4 steps - get a computer, install stuff, get the code, lots of winning

---

## Cloud deployment, e.g. AWS

  1. get instance on AWS EC2
  2. install stuff
  3. Copy the app
  4. so much winning, now in the cloud

# Presenter Notes

Now let's move to the cloud, say we want to work on AWS. When we want to deploy a new app, we start an EC2
instance, then some stuff needs to be installed on it, and then we move our code to the server.
  
---

## Cloud deployment with Prodigy's devops tools

  1. get instance on AWS EC2 (Terraform) 
  2. install stuff (Ansible + Docker)
  3. Copy the app (Also Docker?)
  4. so much winning, now automated

# Presenter Notes

Here we've substituted human stuff with tools to automate the process. Last week we used Terraform to start up
instances, this week we're looking at Ansible to install stuff in step 2. 

I'm being a bit hand wavy here and non-specific beyond step 2, there are some complications introduced by
Docker that can be a problem for the next week's speaker.

---

## Why automate?

  - humans make mistakes when they click
  - humans are inconsistent
  - humans don't naturally record what they did

---
# Finally some ansible

# Presenter Notes

show ansible project:

site.yaml calls add_user role with user_name variable

Document terraform setup in readme.md, make sure output.tf file is present, make them run terraform apply to create instance so that inventory.sh can get the variables

Run ansible and then login with user just created

---

# Presenter Notes

  - humans make mistakes when they click
  - humans are inconsistent... imagine if deploying one app required a user, 'deploy',
    another 'deploy_user': which one do I use for this app? Is it broken because it's broken or just
    because I used the wrong user?
  - humans don't make backups - when the server dies, the old code needs a similarly configured replacement. If a human did it, the only record of how the old server
    was configured WAS THE OLD SERVER THAT JUST DIED. Records are also important for version control.

... and the more times they have to do something in a row, the more bored lazy tired the humans get

---

# Why is Ansible a good choice for this?

## easy to read

## no agent on server

## idempotent

## declarative

---

# Declarative

    !ruby
    # telling you how to get the answer I want
    def odd_numbers(my_list)
      output = []
      for i in 0..my_list.length - 1
        output << my_list[i] if my_list[i] % 2 == 1
      end
      output
    end
    
    # declarative - telling you what I want
    def odd_numbers(my_list)
      my_list.select { |n| n.odd? }
    end

---

# Playbooks

##test
---

# Roles
---

# Templates
--- 

# Variables
---

# Dependencies
---

# Copying files

