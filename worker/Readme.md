# Integritee dev docker image for worker

Usage:
```bash
$ git clone git@github.com:integritee-network/worker.git
$ cd worker
$ docker run --name integriteeworker -it -v $(pwd):/home/ubuntu/worker -e MYUID=$(id -u) -e MYGUID=$(id -g) integritee/integritee-dev:0.2 /bin/bash
```

Inside docker:

```bash
$ cd worker
$ make 
$ ctrl+d
```

Re-run to the saved session

```bash
$ docker start -a -i integriteeworker
```