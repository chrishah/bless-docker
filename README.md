# bless-docker
Debian 8.1 with bless v1.02 installed

Docker context for [BLESS image](https://hub.docker.com/r/chrishah/bless/)

The Docker image is a self-contained Linux environment (Debian 8.1) set up to run the BLESS error correction tool for Illumina data.

I am in no way involved in the development of the BLESS software - this is just the Docker context to build an image for it.

For more information on BLESS see the [BLESS paper](http://bioinformatics.oxfordjournals.org/content/30/10/1354.long) or the [BLESS wiki](http://sourceforge.net/p/bless-ec/wiki/Home/).


The following command will enter a container within which you can run BLESS. The directory `/home/working` in the container (do not change) will be mounted to your present working directory `$(pwd)` on your local computer (change the latter directory if you wish). If the BLESS docker image `chrishah/bless` is not yet present on your computer the command will automatically fetch it from [Docker Hub](https://hub.docker.com/) (takes a minute at first execution, then it will remain in memory until you remove it).

```
docker run --rm -it -v $(pwd):/home/working chrishah/bless:v1.02 /bin/bash
```

Exit the container by typing 'exit'.

The BLESS images can also be used as executable, like so:
```
#Display the usage information of BLESS
docker run --rm -v $(pwd):/home/working chrishah/bless bless

#Example run
docker run --rm -i -t -v $(pwd):/home/working chrishah/bless bless -read in.fastq -prefix directory/prefix -kmerlength 31
```

You may want to create an alias for the above docker container, e.g by typing:
```
alias bless_docker="docker run --rm -i -t -v $(pwd):/home/working chrishah/bless:v1.02 bless"
```

or add the above code to your `~/.bashrc` and source by `. ~/.bashrc` to create a permanent alias.

Then you can simply run BLESS on your local computer:
```
#Display the usage information of BLESS
bless_docker

#Example run
bless_docker -read in.fastq -prefix directory/prefix -kmerlength 31
```

_NOTE:_ Any file that should be processed with BLESS needs to be physically present in your working directory (or whichever local directory you decide to mount your docker container to) or subdirectories within it. Symbolic links to files in parent directories of the mount point do not work.


