FROM ubuntu:18.04


# Add the "PHP 7" ppa
RUN apt-get update
RUN apt -y install software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update

# Install PHP-CLI 7, some PHP extentions and some useful Tools with APT
RUN  apt -y install php7.4
RUN apt-get install -y php7.4-{bcmath,bz2,intl,gd,mbstring,mysql,zip}

# install docker
RUN apt-get install --reinstall systemd -y
RUN sudo apt update
RUN  apt-get remove docker docker-engine docker.io
RUN apt install docker.io
RUN systemctl start docker
RUN systemctl enable docker
RUN  docker --version
#install docker-composer
RUN curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www/laravel
