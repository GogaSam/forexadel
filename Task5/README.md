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

## Task 5 (Extra part Task)  

For extra one we ave to write a playbook which installs docker and docker-compose (I used docker-compose) and run it with ansible, and  
also 2 containers must run on remote servers one will be wordpress and another one mySQL db container here is the compose file.  
_for playbook see ubuntu.yml in my git repo_
  
![alt text](https://task5-new-bucket-lol.s3.eu-central-1.amazonaws.com/part7.PNG)

![alt text](https://task5-new-bucket-lol.s3.eu-central-1.amazonaws.com/part9.PNG)

extra part 2 says that we have to encrypt our credentials. in my instance it is .envwordpress and .envmysql which are used in docker-  
compose we encrypt them using `ansible-vault encrypt` command.  

![alt text](https://task5-new-bucket-lol.s3.eu-central-1.amazonaws.com/part8.PNG)

part 3 extra: we need to make a dynamic inventory in ansible. for example if we have auto scaling group and our servers are being scaled  
often It would be hard for us to keep track of all servers, in ansible. here comes the dynamic inventory which will automatically add  
or delete servers in our dynamic inventory. __https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ec2_inventory.html  
I recommend having a look at documentation__. we need to install aws ec2 plugin with ansible galaxy (ansible-galaxy collection install  
amazon.aws) install pip __https://pip.pypa.io/en/stable/installation/__ or any other version you need to use. after dealing with pip  
install __boto3__ with `pip install boto3`, install botocore (if not installed automatically) create AWS IAM Role or User. I will go with  
creating Role for EC2 isntance  

![alt text](https://task5-new-bucket-lol.s3.eu-central-1.amazonaws.com/part10.PNG)  

attach IAM Role to EC2 control plane  

![alt text](https://task5-new-bucket-lol.s3.eu-central-1.amazonaws.com/part11.PNG)  

next we will SSH in to our control plane and create __aws_ec2.yml__ the file can be very complex but for the example i will just use  
this config. and it will display all instances in Frankfurt AWS Region.  

![alt text](https://task5-new-bucket-lol.s3.eu-central-1.amazonaws.com/part12.PNG)

Thank you for your attention have a nice day
_for public server view 18.157.181.212:8000 & 18.193.48.166:8000_
