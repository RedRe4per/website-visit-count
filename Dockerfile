# syntax=docker/dockerfile:1.4     #指定 Dockerfile 使用的语法版本，这里是 Dockerfile 1.4 版本。
FROM python:3.10-alpine AS builder  
#使用 Python 3.10 的 Alpine 版本作为基础镜像。Alpine 是一个轻量级的 Linux 发行版，适合构建小型镜像。
#AS builder 表示这是一个构建阶段，命名为 builder。

WORKDIR /code 
#设置工作目录为 /code。所有后续的命令都将在这个目录下执行。

COPY requirements.txt /code  #将本地的 requirements.txt 文件复制到镜像的 /code 目录中。
RUN  pip3 install -r requirements.txt   #使用 pip3 安装 requirements.txt 中列出的 Python 依赖包。

COPY . /code

ENTRYPOINT ["python3"]
CMD ["app.py"]

FROM builder as dev-envs

RUN <<EOF
apk update
apk add git bash
EOF

RUN <<EOF
addgroup -S docker
adduser -S --shell /bin/bash --ingroup docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /
