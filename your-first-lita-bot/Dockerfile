# load ubuntu 18 base image as a starting point
FROM ubuntu:bionic

# add base ruby dependencies and install ruby
RUN 	apt-get update && \
	apt-get install -y vim-tiny sudo && \
	apt-get install -y build-essential && \
	apt-get install -y ruby ruby-dev && \
	apt-get install -y redis-server && \
	ruby --version && \
	gem install bundler && \
	bundle --version

# add more ruby gem dependencies for compression, ssl, etc
RUN     sudo apt-get install -y patch zlib1g-dev liblzma-dev libssl-dev

# create a non-root user with sudo privileges to simulate end user experience
RUN     adduser litauser && \
	addgroup admin && \
	usermod -a -G admin litauser

# unset user password for passwordless sudo
RUN     passwd -dq litauser

# install the base lita gem
RUN 	gem install lita

# create a new lita bot, give it a plugin, and verify we can install
RUN     cd /home/litauser && \
	sudo -u litauser lita new && \
	cd /home/litauser/lita && \
        echo "gem 'lita-whats-brad-eating'" >> Gemfile && \
	sudo -u litauser bundle 

# configure litauser shell to autoload redis server and switch to the bot folder
RUN     sudo -u litauser echo "redis-server &" >> /home/litauser/.bashrc
RUN     sudo -u litauser echo "cd lita && ls" >> /home/litauser/.bashrc
