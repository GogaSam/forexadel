# Task 6(Main Part)  
## Part 1  
The First part says that we have to install jenkins and run it in docker container for that I will use a compose file, which will build and run a  
jenkins container.  

![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part1.PNG)  

after writing docker-compose up and opening my browser I can login into my Jenkins dashboard!  

![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part2.PNG)  
__if you want more stable setup for docker I would recommend following this installations guideline.__  
_https://www.jenkins.io/doc/book/installing/docker/#downloading-and-running-jenkins-in-docker_
## Part 2  

part 2 is to Install necessary plugins I choosed to install the recommended pluggins but I will update them throughout the Task  

## Part 3  

We need to add docker agents for our jenkins master I will have two ubuntu servers with same configuration. ssh in to servers and add the  
following line in __/lib/systemd/system/docker.service__  

![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part3.PNG)  
_don't forget to comment out ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock_  

reload docker daemon (`sudo systemctl daemon-reload`) and restart the docker service (`sudo service docker restart`) check if docker  
is running succesfully (`sudo service docker status`) curl the localhost or public IP of the server on port 4243/version  
(`curl 3.69.148.165:4243/version`) the output should be something like this  
![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part4.PNG)  
if you followed and everything works that means that we succesfully applied docker api on port 4243 and now we can integrate it with  
jenkins! on master node of jenkins go to plugins and install docker plugin  

![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part5.PNG)  

after installing go to Manage Jenkins -> Manage Nodes and Clouds -> Configure Clouds -> Add a new cloud. and the Docker option will pop up 
and press Docker. click on Docker Cloud Details configure your Docker Host URI and type `tcp://(your server's Public IP):4243`  
and click test connection. it should show you the version of the API and docker host.  

![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part6.PNG)  

then click Docker Agent Templates -> Add Docker Template. Add Label, for example docker-agent-1. Under Docker images  
type the image you want to use (Jenkins and java must beinstalled on the image you will use) I will be using  
gogasamu111/jenkins-docker-test image for this setup. because it already has everything i need. for this image set up  
/home/jenkins as root directory under root directory tab. under connect method choose connect with ssh. Select  
connect with SSh and under SSH key select Use configured ssh credentials and add credentials (For this  
image password is jenkins and username is jenkins) for host key verificication select Non verifying Verification Strategy.  

![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/Screenshot+2021-08-24+213346.png)  

save the configuration and you are good to go! I will complete the exact same process on another ec2 instance.  

__Docker Node #1__
![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part7.1.PNG)  
__Docker Node #2__
![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part7.2.PNG)  
## Part 4  

we need to install Plugin called Build timestamp which will show our current time (Georgia/Tbilisi) Which is GMT+4. after intsalling the  
Pluggin we go to configure system and choose the following options  

![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/Part8.PNG)  

Create a Freestyle project. Which will show the current date as a result of execution. we create the job (New Item -> Freestyle Project)  
then under label expressions choose the docker agent label.  

![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/Part9.PNG)  
__the name was changed from slave to agent__

select execute shell and type the following command  

![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/Part10.PNG)  
![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part11.PNG)

## Part 5 

Next we create Task-5 pipeline. and make agent-2 do the task. but untill executing the docker ps -a there are some things to do.  
first we go to Manage Jenkins ->  Manage Nodes and Clouds -> Configure Clouds and edit docker agent template and add the following  
line in container settings tab  -> Mounts -> `type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,` this will  
bind mount docker agents local docker engine to the docker engine in docker agents container. SSH into docker agent and execute  
command `sudo chmod 777 /var/run/docker.sock` to not get permission errors in the pipeline. go to pipeline in jenkins and add the  
following command in script.  

![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part12.PNG)  
![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part13.PNG)  

## Part 6  

go to pipeline config and Run the following jenkinsfile in pipeline which will build our dockerfile from git repository. note  
that if you have private repository you should use git plugin

![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part14.PNG)
![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part15.PNG)  

## Part 7  

first we go to Manage Jenkins -> Manage Credentials. then add a global credential in Secret text format. provide the password - QWERTY!  
there then use the pipeline as followed. add environment block and password variable there and provide the ID you gave to the Credential.  

![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part16.PNG)  
and as you can see the password is encrypted.
![alt text](https://s3.eu-central-1.amazonaws.com/tas6.completed.forever/part17.PNG)  

__thank you for your attention :) have a nice day__
