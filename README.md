
## Project structure
Python/Flask application using a Redis database

Project structure:

```
.
├── Dockerfile
├── README.md
├── app.py
├── compose.yaml
└── requirements.txt
```

[_compose.yaml_](compose.yaml)

```
services:
   redis: 
     image: redislabs/redismod
     ports:
       - '6379:6379' 
   web:
        build: .
        ports:
            - "8000:8000"
        volumes:
            - .:/code
        depends_on:
            - redis
```



## Deploy application

### Use with Docker CLI

For redis service:

```bash
docker run -d -p 6379:6379 --name=redis redislabs/redismod
```

For web service, you first need to build the image:

```bash
docker build --target builder -t web .
```
Check docker image built just now
```bash
docker images
docker image inspect web
```
Then you can run the container:

```bash
docker run -d -p 8000:8000 -v $(pwd):/code --name=web --link redis:redismod web
```

### Deploy with docker compose

```
$ docker compose up -d
[+] Running 24/24
 ⠿ redis Pulled   
 ...                                                                                                                                                                                                                                                                                                                                                                                                             
   ⠿ 565225d89260 Pull complete                                                                                                                                                                                                      
[+] Building 12.7s (10/10) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                                                                                                  ...
[+] Running 3/3
 ⠿ Network flask-redis_default    Created                                                                                                                                                                                             
 ⠿ Container flask-redis-redis-1  Started                                                                                                                                                                                             
 ⠿ Container flask-redis-web-1    Started
```


#### Expected result

Listing containers must show one container running and the port mapping as below:
```

$ docker compose ps
NAME                  COMMAND                  SERVICE             STATUS              PORTS
flask-redis-redis-1   "redis-server --load…"   redis               running             0.0.0.0:6379->6379/tcp
flask-redis-web-1     "/bin/sh -c 'python …"   web                 running             0.0.0.0:8000->8000/tcp
```

After the application starts, navigate to `http://localhost:8000` in your web browser or run:
```
$ curl localhost:8000
This webpage has been viewed 2 time(s)
```



Stop and remove the containers
```
$ docker compose down
```


### Use with Docker Development Environments

You can open this sample in the Dev Environments feature of Docker Desktop version 4.12 or later.

[Open in Docker Dev Environments <img src="open_in_new.svg" alt="Open in Docker Dev Environments" align="top"/>](https://open.docker.com/dashboard/dev-envs?url=https://github.com/AutomationLover/website-visit-count/tree/main)
