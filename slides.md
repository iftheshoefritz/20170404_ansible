# Intro to Ansible

# Presenter Notes

Non-dev friendly talk

Giving Prodigy perspective on this tool, there's a lot more that we don't use, but I can only give some of the
possibilities, and I don't want to cover too much that's not immediately useful

Need to give some background, stick with me before I get to real code, hopefully explain why we need to be
able to do this stuff, and be able to transfer principles to whatever the next tool is.

---
# Coding on your own machine

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

We still have similar 4 steps - get a computer, install stuff, get the code, lots of winning. They look a bit
different, e.g. the machine you need comes from a hosting provider

---

## Cloud deployment, e.g. AWS

  1. get instance on AWS EC2
  2. install stuff
  3. Copy the code
  4. so much winning, now in the cloud

# Presenter Notes

Now let's move to the cloud, say we want to work on AWS. When we want to deploy a new app, we start an EC2
instance, then some stuff needs to be installed on it, and then we move our code to the server.
  
---

## Automated cloud deployment

  1. get instance on AWS EC2 (Terraform) 
  2. install stuff (Ansible + Docker)
  3. Copy the code (Docker + ?)
  4. so much winning, now automated

# Presenter Notes

Here we've substituted human stuff with tools to automate the process. Last week we used Terraform to start up
instances, this week we're looking at Ansible to install stuff in step 2. 

---

## Why automate?

  - humans make mistakes when they click
  - humans are inconsistent
  - humans don't naturally record what they did

# Presenter Notes

  - humans make mistakes when they click
  - humans are inconsistent... imagine if deploying one app required a user, 'deploy',
    another 'deploy_user': which one do I use for this app? Is it broken because it's broken or just
    because I used the wrong user?
  - humans don't make backups - when the server dies, the old code needs a similarly configured replacement. If a human did it, the only record of how the old server
    was configured WAS THE OLD SERVER THAT JUST DIED. Records are also important for version control.

... and the more times they have to do something in a row, the more bored lazy tired the humans get

---
# Finally some ansible

    !yaml
    #example/ansible/roles/python/tasks/main.yml
    - name: update apt-get
      raw: sudo apt-get -y update

    - name: install python2
      raw: sudo apt-get -y install python python-pip python-setuptools

# Presenter Notes

This is a role. Role is an abstraction for a set of configuration steps that Ansible will take. You could
think about it as, "machines will play this role".

In this case the role is just running some bash commands to install Python 2. Most of Ansible's cool stuff won't workif there is no Python on the machine. But once we have it we can write stuff in a much nicer way than bash.

---
# Some more ansible

    !yaml
    #example/ansible/demo.yml
    - hosts: demo
      remote_user: ubuntu
      become: true
      gather_facts: no
      roles:
        - { role: python }

# Presenter Notes

This is a playbook. You can think of a playbook as a collection of roles. In this case we're just running the role we just created. At the top of the file we're saying run this against the demo instance we got Terraform to create.

TODO:
  create branch with complete version, then remove role and demo.yml

---
# Run Ansible

    !bash
    > ansible-playbook demo.yml --private-key ~/.ssh/alice_key.pem

(point to `.pem` file you created when setting up)

---
# Run Ansible

    !bash
    > ansible-playbook demo.yml --private-key ~/.ssh/fritz_ec2_dev.pem

    PLAY [demo] ********************************************************************

    TASK [python : update apt-get] *************************************************
    changed: [54.93.229.175]

    TASK [python : install python2] ************************************************
    changed: [54.93.229.175]

    PLAY RECAP *********************************************************************
    54.93.229.175              : ok=2    changed=2    unreachable=0    failed=0

Check that python did actually install using: `ssh -i ~/.ssh/alice_key.pem ubuntu@54.93.229.175`

---
# Add another user

Copy YOUR public key (e.g. `~/.ssh/id_rsa.pub`) to `example/ansible/keys/deploy.pub` (or symlink)

Add to `demo.yml`:

    !yaml
    - { role: user, tags: user, name: deploy, comment: "Deploy User"  }

Now run `ansible-playbook ....` and try SSH to deploy@...

# Presenter notes

We're going to use a role that I wrote, then I'm going to explain it to you. Add this stuff into demo.yml.
Run ansible and then login with user just created.

---
# User role

`example/ansible/roles/user/tasks/main.yml`

# Presenter notes

This addition controls the user role. Let's look at that.

Note the use of Ansible variable syntax. 

1. use the built in user module to create a user. We've added variables to this role, so it can be 
used in multiple contexts.
2. create .ssh directory for the new user
3. add the key file in the local keys/ directory to the authorized keys for the user

In general using the built in user modules will be more portable than writing raw bash.

We can also use a role more than once. Add a user named now app.

SSH to deploy user again and check out ~/.ssh/authorized_keys

---

# What are Ansible's strengths

### no agent on server

### easy to read

### good abstractions (e.g. roles, modules)

Allows you to script configuration that is:
- portable
- idempotent
- declarative

# Presenter Notes

Portable:
Actually wrote the user role originally for a CentOS box, no changes to code for this Ubuntu EC2 instance.
Also switched between vagrant and EC2 easily. 

Idempotent:
Run as many times as you want with the same result. So if you admin multiple machines, and you add some new ones, when you run your playbook against all of them, it doesn't matter which ones you ran the playbook on already and which ones are new.

Declarative: 
see next slide

---

# Bonus CS: Imperative vs. Declarative

    !ruby
    # imperative - telling you how to get the answer I want
    def odd_numbers(my_list)
      output = []
      for i in 0..my_list.length - 1
        output << my_list[i] if my_list[i] % 2 == 1
      end
      output
    end

---

# Bonus CS: Imperative vs. Declarative

    # declarative - telling you what I want
    def odd_numbers(my_list)
      my_list.select { |n| n.odd? }
    end

# Presenter Notes

Most people prefer declarative code because:

- often more readable
- details that you don't care about are hidden and can change without affecting this code

SQL is a great example of declarative language, you just say "select id from books" - you know very little about how books are stored. The storage engine can change without you querying, the query optimiser can decide whether to use an index or not.

Just be aware that sometimes you really do care about exactly how things are done.

---

# Declarative / Portable / Idempotent Ansible

    - name: Enable unicorn-myapp
      service:  name=unicorn-myapp
                state=started
Or: `/etc/init.d/unicorn-myapp start`

# Presenter Notes

- The bash command is not portable - different nix flavours start services differently. 
- It is not idempotent, if you run it while the service is running, it will give you an error.
- there is an argument to be had about declarative ... you have to know about `etc/init.d`

---

# What other kinds of configuration can Ansible do:

- nginx
- git
- postgres
- firewalls
- stop / start services
- anything bash can do

# Presenter Notes

We can do a bunch of other stuff. 

---

# Ansible at Prodigy

- install python
- install docker
- install docker-compose
- install docker-py

---
# Other Ansible tricks

- Templates
- Inventory
- Copying files
- Vault

---

# Do not forget to:

`terraform destroy`
