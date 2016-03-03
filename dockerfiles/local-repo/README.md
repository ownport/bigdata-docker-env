# Local repositories

## External repositories

- Alpine linux
- Apache 
- Cloudera 
- Hortonworks 

## Components

- runit
- darkhttpd
- privoxy
- rsync

## Settings

```sh
$ HTTP_PROXY=http://local_repo:8118/
```

## How it'working

The scripts for updating files are located in the directory: /data/mirrors/scripts

- alpine/
- apache/

The mirrored files are located in the directory: /var/www/

- alpine-repo/
- apache-repo/

## Tasks

### TODO


### Done 

- [x] logging for privoxy server
- [x] logging for runit service
- [x] use common log for services via stdout

