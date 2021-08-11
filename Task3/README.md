# Task 3 EXTRA  
**For Terraform Configuration Please Have a Look At variables.tf and main.tf**  


As seen in Terraform main.tf machine in the private subnet *Redhat Linux* Does not have direct access to the internet. the task is to download  
and install Nginx and serve our little html file to be seenable from public machine *Ubuntu Linux*. In order for that to be possible we need to  
make an SSH tunnel and a proxy which will allow YUM command to pass through. for that first we SSH from our Public machine to the 
Private one then we run the following command which opens the tunnel for port 1080 (note that if there are any questions have a look at  
main.tf)  

`ssh -i Frankfurt.pem -NTf -D 10.0.1.242:1080 ubuntu@10.0.0.110`  

After oppening the tunnel we have to edit `/etc/yum.conf` and type the following line at the last line  

![alt text](https://bucket-for-3-task-exadel.s3.eu-central-1.amazonaws.com/yum_conf.PNG)  

and this opens 1080 port for yum request to come through. and then we can run `sudo yum install nginx`!  

![alt text](https://bucket-for-3-task-exadel.s3.eu-central-1.amazonaws.com/nginx.PNG)  

edit `/usr/share/nginx/index.html` for nginx to serve our static web page!

![alt text](https://bucket-for-3-task-exadel.s3.eu-central-1.amazonaws.com/sudo_i.PNG)

than start nginx! exit to public machine and `curl -I 10.0.1.242` and the output is right!

![alt text](https://bucket-for-3-task-exadel.s3.eu-central-1.amazonaws.com/output.PNG)  

*also see the public server at* `http://3.121.230.144`
