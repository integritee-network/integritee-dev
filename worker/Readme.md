# Integritee dev docker image for worker

Usage:
```bash
$ git clone git@github.com:integritee-network/worker.git
$ cd worker
$ docker run --name integritee-dev-worker -it -v $(pwd):/home/ubuntu/worker -e MYUID=$(id -u) -e MYGUID=$(id -g) integritee/integritee-dev:0.2.1 /bin/bash
```

Inside docker:

```bash
$ cd worker
$ make 
$ exit
```

To continue your saved session:

```bash
$ docker start -a -i integritee-dev-worker
```

Should you want to test against a node inside the docker, you can use (check the relative directory) :
```
docker run --name integritee-dev-worker-and-node -it -v $(pwd):/home/ubuntu/worker -v $(pwd)/../integritee-node:/home/ubuntu/integritee-node -e MYUID=$(id -u) -e MYGUID=$(id -g) integritee/integritee-dev:0.2.1 /bin/bash
```
