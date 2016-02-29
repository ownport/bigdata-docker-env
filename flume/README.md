# Apache Flume

## Flume package structure

- conf/
- lib

## Docker container file structure

- bin/: scripts
- conf/: configuration files
- lib/: custom Flume libs and deps  
- logs/: log files


## How to use

```sh 
docker run -ti --rm --name "flume-agent" ownport/flume:1.5.0-jdk18 /bin/sh
```

## Scripts

### run.sh 

usage:

```sh
$ ./run.sh 
```