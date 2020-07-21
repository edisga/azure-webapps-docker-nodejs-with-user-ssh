FROM node:12-buster-slim
WORKDIR /code
ADD package.json /code/
RUN npm install
ADD . /code/

# ssh
ENV SSH_PASSWD "root:Docker!"
RUN apt-get update \
        && apt-get install -y sudo openssh-server \
	&& echo "$SSH_PASSWD" | chpasswd 

COPY sshd_config /etc/ssh/
COPY entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh && chmod a+w /etc/ssh/sshd_config

RUN groupadd -r demo && useradd -m -g demo demo \
   && echo "demo   ALL=(ALL:ALL) NOPASSWD: /usr/sbin/service ssh start,/usr/sbin/service ssh stop, /usr/sbin/service ssh status, /etc/init.d/ssh start, /etc/init.d/ssh stop, /etc/init.d/ssh status" >> /etc/sudoers\
   && chown -R demo:demo /code/

USER demo

ENV SSH_PORT 2222
EXPOSE 3000 2222

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
