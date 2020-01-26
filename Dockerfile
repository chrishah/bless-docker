# Using the Debian image
FROM debian:8.1

MAINTAINER Christoph Hahn <christoph.hahn@uni-graz.at>

# Make sure apt is up to date
RUN apt-get -y update --fix-missing && \
	apt-get install -y wget build-essential mpich libmpich-dev

#add user (not really necessary)
RUN adduser --disabled-password --gecos '' blessuser

RUN mkdir /home/blessuser/src
#fetching & making bless - changes to the code have the effect that bless searches for the kmc and pigz binaries in a standard PATH #
#rather than in a certain place relative to the bless executable
RUN mkdir /home/blessuser/src/bless
WORKDIR /home/blessuser/src/bless
RUN wget http://sourceforge.net/projects/bless-ec/files/bless.v1p02.tgz && \
	tar xvfz bless.v1p02.tgz && \
	cd v1p02 && \
	sed -i 's/kmc_binary = .*/kmc_binary = KMC_BINARY;/' parse_args.cpp && \
	sed -i 's/pigz_binary = .*/pigz_binary = PIGZ_BINARY;/' parse_args.cpp && \
	make

#add binaries to /bin
USER root
RUN cp /home/blessuser/src/bless/v1p02/bless /home/blessuser/src/bless/v1p02/kmc/bin/kmc /home/blessuser/src/bless/v1p02/pigz/pigz-2.3.3/pigz /bin

#RUN chmod -R +r v1p02/
#RUN mv /home/blessuser/src//bless/v1p02/* /bin/

ADD bin/bless_iterate_over_ks.sh /bin 
RUN chmod +x /bin/bless_iterate_over_ks.sh

# I was trying to fix certain problems for this image with a helper script, but this is not necessary anymore after having made the changes to the cpp files above
#ADD docker_helper.sh /home/blessuser/src/bless/v1p02/
#RUN echo "export PATH=${PATH}:/home/blessuser/src/bless/v1p02" >> ~/.bashrc && \
#	echo "alias bless='/home/blessuser/src/bless/v1p02/bless'" >> ~/.bash_aliases && \
#	echo "source ~/.bash_aliases" >> ~/.bashrc && \
#	chmod +x /home/blessuser/src/bless/v1p02/docker_helper.sh

#ENTRYPOINT ["/src/bless/v1p02/docker_helper.sh"]

WORKDIR /home/blessuser
USER blessuser

