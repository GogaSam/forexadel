## Part 1  
firts part was to install docker (extra - to do it with script) what we can do is to create an EC2 instance on AWS (or any cloud provider you  
use) and type the following script in user data of the instance. note that user data is a text bar where you can store your SH scripts for EC2  
to run on startup. the following script installs docker and docker-compose. 

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/part1.PNG)

## Part 2 
we have to run a hello world container which is very easy to do we just type `docker run hello-world` and docker works fine. 

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/part2.PNG)

the extra part is to make an image with html page which says Goga Samunashvili Sandbox 2021! for that we can make our Dockerfile which  
will do that for us!  

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/part3.PNG)

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/part4.PNG)

## Part 3

the parts 3.1 and 3.1.1 where done already by creating the dockerfile, so going to task 3.2 which is to add an environment variable, to our  
dockerfile, and specify it in index.html. every time we restart the container with `docker run --env DEVOPS=...` command must give us  
new value if we specify it in `--env`. for that to be possible we need to change our dockerfile. we cannot execute echo and apache  
commands in dockerfile. we must specify them in **script.sh**, because when we build our image **the ENV value is already stored in the built  
image** and it is impossible to change it, so last 2 commands must run everytime we restart container. see the configuration below

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/solution3.1.PNG)  

*script.sh here*

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/Capture.PNG)

and if we run container with another `--env DEVOPS=...` flag, the ENV will change!  

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/done1.PNG)  

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/done2.PNG)

## Part 4

Now we must push our cute little image to the Dockerhub for other people to see! so first I tag my image as a name of my docker repo   
(gogasamu111/exadelweb23) after that we docker login and type our credentials. and last but not least we push it with docker push command!

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/part7.PNG)

the part 4.1 basically says that we must create a pipeline which will build our image and send it to dockerhub. for that we must push our  
image to Github repo, and write the following github acctions pipeline. which will build our image and push it to dockerhub automatically.  

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/part8.PNG)  

## Part 5

the last part says that we must have docker-compose file with 3 images and 8 contaners (one image should run 5 nodes) so here is the  
compose file we are going to use. and we are going to run command `docker-compose up --scale apache=5 -d` which will run 5 apache  
containers.

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/part9.PNG)

take a look at database env_file, it is not included in github repo, there are variables - POSTGRES_PASSWORD,USER and DB. also take   
a look at init.sql which creates a new user for our DB for security purposes.  

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/part11.PNG)  

we can go to port 8080 to see jenkins and it works properly!  

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/part10.PNG)  

and lastly lets take a look at our containers!  

![alt text](https://task-4-exadel-yeah.s3.eu-central-1.amazonaws.com/part12.PNG)  

**Thank you for your Attention! have a nice day**

(*you can see public web container at* `http://3.127.244.106`)
