## Part 1 (Zabbix)  
first we install Zabbix on our servers type command - `sudo apt update && sudo apt upgrade` to update our dependencies (Ubuntu) then install zabbix using command -  `wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb` then dpkg it - `dpkg -i zabbix-release_5.0-1+focal_all.deb` and `sudo apt update && sudo apt upgrade` once more now we will install Zabbix server, frontend, agent, and database. `sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent mysql-server` check mysql, php and apache versions - `sudo mysql -V` & `sudo php --version` & `sudo apache2 -V` verify the versions. next we need to configure mysql.  

Start with `sudo mysql_secure_installation` It will ask to validate password component. for procution validate always. in this case I don't want to go with super complex password so I will type - n. next we will be asked to remove anonymous users Press y for that. then we will be asked to disable root login remotely. I will press N for that but in Production consider typing yes. then remove test database - Y. and also yes for reload table priviliges.  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part1.PNG)  

now we are going to create an initial database and a user. login in to the database `sudo mysql -u root -p` next Create a database and name it zabbix - `create database zabbix character set utf8 collate utf8_bin;`. Create a new user and name it zabbix. Also, pick a password for this user. We will need this password later on for Zabbix server config file. Type command - `create user zabbix@localhost identified by 'password';` Now grant permissions on zabbix database to user zabbix - `grant all privileges on zabbix.* to zabbix@localhost;` then `flush privileges;` and `quit;`  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part2.PNG)  

In the previous step, we created a new database and user. Now we will utilize that database and import initial schema and data to that database. Run the following command and provide the password for the database user zabbix. Be patient with this command it can take 5 to 30 seconds or more to finish - `sudo zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -u zabbix -p zabbix` (In this case password is - password) Login to database `sudo mysql -u root -p`, type `use zabbix;`, `show tables;` and once we verified we can `quit;`  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part3.PNG)  

This file has a lot of stuff we will update only one thing, however, this is the place where you tune up your Zabbix server. We will update the zabbix server password only. If you have used different zabbix database name, consider updating that as well -  `sudo nano /etc/zabbix/zabbix_server.conf` Let’s find the keyword DBPassword.Hit `Ctrl + W` on your keyboard, type DBPassword and then hit enter on your keyboard. You should see # DBPassword. You can use any password I will simply use password - password. so uncomment DBPassword and type as follows  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part4.PNG)  
__after updating use following keys on your keyboard to save the file CTRL + S, CRTL + X__  

Next we will configure PHP for Zabbix frontend. We will edit __/etc/zabbix/apache.conf__ file to update the timezone (`sudo nano  /etc/zabbix/apache.conf`). In my case it will be Etc/GMT-4 (Because of PHP syntax). I will type in version 7 php block. you can find your own timezone [here](https://www.php.net/manual/en/timezones.php)   

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part5.PNG)  
__after updating use following keys on your keyboard to save the file CTRL + S, CRTL + X__  

Alright, now it is the time to start Zabbix server and agent. type `sudo systemctl restart zabbix-server zabbix-agent apache2` in your terminal. Check if it is running - `sudo service zabbix-server status`. also let’s add Zabbix server and agent services to auto start at system boot - `sudo systemctl enable zabbix-server zabbix-agent apache2`.  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part6.PNG)  

All the hard work is done and now let’s finish it off through a web browser. type your machines Public IP address and /zabbix at the end for example __http://3.69.26.177/zabbix/__  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part7.PNG)  

Click next. look at the options and see if everything is like you set it up (especially timezone). Click on next step. Now here is important. check the name of the database and user, provide the password. Go to next step. and type the name you want zabbix to display. Go to next step and check if everything is right. You will be asked to provide username and password the username is __Admin__ (with capital A) and password is __zabbix__. and we will see our board  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part9.PNG)

after login we can go back to all dashboars, create new dashboard. I will name my dashboard dashboard-1 and save it. Then go to sharing options and give zabbix user groups permissions as follows  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part10.PNG)  
![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part29.PNG)

For active or passive checks I will configure one active check item for my zabbix agent. on the left sidebar go to Configurations -> Hosts and choose the Items under Items column.  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part11.PNG)  

choose Create Item in the right corner of the front end page. here is the active check of CPU with TCP, port key. and we can see trapper and poler with ps ax command.

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part12.PNG)  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part13.PNG)  

to add an agentles ICMP check we need to go Configuration on the left side of the page and Hosts. there we need to press create host.  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part14.PNG)  
and press templates on the tab above and add the following template  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part15.PNG)  

to ping another server from zabbix we need to ssh into the zabbix server. and edit the file `nano /etc/zabbix/zabbix_server.conf` and add the following line at the end of the file `StartPingers=10 FpingLocation=/usr/sbin/fping`. then go to zabbix front end and Configuration -> Hosts -> Create Host. and add the IP we want to ping. next press Templates and add the following template `Template Module ICMP Ping` and pres Add. the go to Monitoring -> Hosts -> latest data (Next to the name of the resource we created). press the resource name we created and at the drop down menu press ping. and we can see the output is right.

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part16.PNG)  

to create Alert go to Configuration -> Hosts. and create a trigger for any host (press trigger at the hosts bar, and at the right corner press create trigger) and create the following trigger for CPU Idle Time  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part17.PNG)  
Go to Maintence under Configuration bar and create new maintence period. for example:  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part18.PNG)  
![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part19.PNG)  
![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part20.PNG)  

## Part 2 (ELK)

I will be Running ELK with docker-compose (see the compose file in my repo). and also copy the __filebeat.yml__ for Kibana to recieve docker logs. for ELK to become online type `docker-compose up`. go to http://(IP):5601. the first thing you have to do is to configure the ElasticSearch indices that can be displayed in Kibana  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part21.PNG)  

You can use the pattern `filebeat-*` to include all the logs coming from FileBeat. You also need to define the field used as the log timestamp. You should use @timestamp as shown below.  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part22.PNG)  

we can now visualize the logs generated by FileBeat, ElasticSearch, Kibana and other containers in the Kibana interface.  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part23.PNG)  

for metrics to be shown from docker containers, go to Home -> add metric data -> docker metrics. and follow the guideline on your localhost. after that you will see the metrics overview something like this.  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part24.PNG)  

Let's create our own dashboard go to Dashboards -> create new dashboard. I will use visual interfaces of docker metrics. I already created it so i can not walk through the process of creation but it is fairly easy and user friendly. here is the end result.  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part25.PNG)  

## Part 3 (Grafana)

go to http://(IP):3000 and log in to grafana. go to Configuration -> Data Sources -> Add data source. and make configuration similar to this. then press save and test  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part26.PNG)  

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part27.PNG)   

![alt text](https://s3.eu-central-1.amazonaws.com/task7.boi.done.yea/Part28.PNG)  

thank yoou for your attention. have a nice day, or evening.
