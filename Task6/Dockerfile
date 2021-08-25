# For this image to be useable. Please make sure to bind mount /var/run/docker.sock
# Edit the permissions of /var/run/docker.sock so the user of this container can use it
# Make sure to have empty .ssh/authorized_keys file for SSH authentication

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - &&\
    apt-key fingerprint 0EBFCD88 &&\
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) stable" &&\
    apt-get update && apt-get install -y docker-ce-cli &&\
    apt-get update &&\
    apt-get -qy full-upgrade &&\
    apt-get install -qy git &&\
    apt-get install -qy openssh-server &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd &&\
    apt-get install -qy openjdk-8-jdk &&\
    apt-get install -qy maven &&\
    apt-get -qy autoremove &&\
    adduser --quiet jenkins &&\
    echo "jenkins:jenkins" | chpasswd &&\
    mkdir /home/jenkins/.m2

COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
