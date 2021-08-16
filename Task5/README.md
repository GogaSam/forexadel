## Task 5 (Main Task)

the first task says that we have to deploy 3 virtual machines in the cloud. we go to our AWS managment console(or any other cloud  
provider you use), select EC2 and spin up 3 amazon linux 2 servers.

![alt text](https://task5-new-bucket-lol.s3.eu-central-1.amazonaws.com/part1.PNG)

next we install ansible. I have already installed it you can install ansible using `sudo pip install ansible`, on Amazon Linux python  
is installed by default. we need to create a file called **ansible.cfg** for ansible to now where our remote servers are stored, we  
can specify this in command but it is better to set it up like this.  

![alt text](https://task5-new-bucket-lol.s3.eu-central-1.amazonaws.com/part2.PNG)

we need to execute ansible ping command to make sure that our workers are reachable from control plane. for that we need to setup  
hosts.txt  

![alt text](https://task5-new-bucket-lol.s3.eu-central-1.amazonaws.com/part3.PNG)  

and then we create **group_vars/workers** file where we specify credentials for our remote servers(user, and ssh key). for our servers  
to be reachable from control plane we need to specify which key we are using to reach it. and import the private key into our control  
plane for ansible to be possible to ssh into remote workers. see the file below

![alt text](https://task5-new-bucket-lol.s3.eu-central-1.amazonaws.com/part4.PNG)  

and now we can succesfully ping our machines with `ansible all -m ping`  

![alt text](https://task5-new-bucket-lol.s3.eu-central-1.amazonaws.com/part5.PNG)  

now we need to write a playbook (an instruction file for ansible) which will install docker on it.  
(for playbook please see **install_docker_playbook.yml** in my git folder Task5)  

![alt text](https://task5-new-bucket-lol.s3.eu-central-1.amazonaws.com/part6.PNG)

