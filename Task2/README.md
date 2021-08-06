# Task II AWS  
**This is the Infrastructure we are going to build**
![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/infrastructure.png)

First thing we are going to do is to create a new VPC. I will create it in Frankfurt (eu-central-1) because it is closest hosted zone to me  

![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/vpc.PNG)  
  
Next step is to create Internet Gateway, and attach it to our VPC, This is needed for us to have connection to the internet

![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/InternetGateway.PNG)  
  
Next thing we are going to do is to create two public subnets and two private ones, one public and private in availability zone A 
and other one in B. This will be the environment where our Instances will be launched, the public subnets will also have the permission
to asign public IPv4 addresses and Private subnets will only have private ones  

![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/Subnet.PNG)  

now we need to modify Routing Table For our public subnets to grant them access to the internet! we will add new route 0.0.0.0/0 which  
will be pointed towards our Internet Gateway. We will talk about private subnets a bit later

![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/RTB.PNG)  

According to the fact that our private subnets don't have public IPs we will need to attach them to NAT Gateway because they will not be  
able to go through Internet Gateway without Public IP. So first thing we will do is to create two NAT Gateways one for Private Subnet A  
and another one For Private Subnet B. NAT Gateway also requires an elastic IP. then create a private Route Table which will be pointed  
towards our NAT Gateway.

![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/NATgateway.PNG)  

__Now to Test out our VPC we will launch two instances one will be auto scaled in public subnets A and B so if it goes  
down for some reason it will automatically scale back to one and one in private subnet and we will SSH from public  
instance to the private one and see if private instance has connection to the internet__  

First we will Create a launch Template for auto scaling with following user data, which will start Apache Web Server for us and serve  
following HTMl static web page

![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/Amazon_linux_templateuserdata.PNG)  

Next we create Auto Scale group with following network options  

![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/Autoscale_amazonlinux.PNG)  

And here we can see our Server running with all checks passed!  

![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/Amazon_linux-Success.PNG)  

Static Web Page is reachable as well!  

![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/Web_page_success.PNG)  

Now we Start ubuntu in Private Subnet B.  

![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/Ubuntu_Starting.png)  

Configure Security Group for only SSH For Us to SSH into it from our Public instance  

![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/Ubuntu_securitygroup.PNG)  

Now we SSH into our public Host and then to the Private one, and as we can see everything works perfectly!  

![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/key_import%2Bconnect_ubuntu.PNG)

Also we can Ping exadel.com From Ubuntu!  

![alt text](https://pictures-for-md-markdown-git.s3.eu-central-1.amazonaws.com/Ping_from_ubuntu.PNG)  

**Thank You For Your Attention!**
