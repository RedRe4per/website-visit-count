#基础阶段：构建 Python 应用程序
# syntax=docker/dockerfile:1.4     #指定 Dockerfile 使用的语法版本，这里是 Dockerfile 1.4 版本。
FROM python:3.10-alpine AS builder  
#使用 Python 3.10 的 Alpine 版本作为基础镜像。Alpine 是一个轻量级的 Linux 发行版，适合构建小型镜像。
#AS builder 表示这是一个构建阶段，命名为 builder。

WORKDIR /code 
#设置工作目录为 /code。所有后续的命令都将在这个目录下执行。

COPY requirements.txt /code  
#将本地的 requirements.txt 文件复制到镜像的 /code 目录中。
RUN  pip3 install -r requirements.txt   
#使用 pip3 安装 requirements.txt 中列出的 Python 依赖包。

COPY . /code
#将当前目录下的所有文件复制到镜像的 /code 目录中。

ENTRYPOINT ["python3"]
#设置容器启动时的默认可执行文件为 python3。
CMD ["app.py"]
#指定默认的参数为 app.py，这意味着容器启动时会运行 python3 app.py。


#下面是开发环境阶段
FROM builder as dev-envs
#从 builder 阶段继承，创建一个新的阶段，命名为 dev-envs。

RUN <<EOF
apk update
apk add git bash
EOF
#使用多行命令更新包管理器并安装 git 和 bash。
#apk update：更新 Alpine 包管理器的索引。
#apk add git bash：安装 git 和 bash。

RUN <<EOF
addgroup -S docker
adduser -S --shell /bin/bash --ingroup docker vscode
EOF
# install Docker tools (cli, buildx, compose)。这一行是William老师的注释.
#创建一个新的用户组和用户。
#addgroup -S docker：创建一个名为 docker 的系统组。
#adduser -S --shell /bin/bash --ingroup docker vscode：创建一个名为 vscode 的系统用户，属于 docker 组，并使用 /bin/bash 作为默认 shell。


COPY --from=gloursdocker/docker / /
#从另一个镜像 gloursdocker/docker 中复制文件到当前镜像的根目录。
#这通常用于复制 Docker 工具（如 Docker CLI、Buildx、Compose）到镜像中。
