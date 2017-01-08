FROM ubuntu:14.04

RUN apt-get update ; apt-get install -y openssh-server python python-pip ansible
#ADD ./start.sh /start.sh
RUN mkdir /var/run/sshd

ADD id_rsa.pub /tmp/id_rsa.pub
RUN mkdir -p /root/.ssh
RUN cat /tmp/id_rsa.pub >> /root/.ssh/authorized_keys && rm -f /tmp/id_rsa.pub
RUN chmod -R 700 /root/.ssh
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -ri 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sed -ri 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config

#RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

#RUN chmod 755 /start.sh
# EXPOSE 22
#RUN ./start.sh

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
