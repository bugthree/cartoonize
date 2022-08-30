# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.7-slim


# change sources.list
# Add custom china source，ADD可将本地文件添加到镜像中，类似于具有root权限的cp命令
RUN rm -rf /etc/apt/sources.list
COPY sources.list /etc/apt/ 

#RUN adduser -D myuser
# USER myuser
# WORKDIR /home/myuser
# Copy local code to the container image.
# 这里会将当前目录所有文件拷贝进去
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY tensorflow-2.1.0-cp37-cp37m-manylinux2010_x86_64.whl tensorflow-2.1.0-cp37-cp37m-manylinux2010_x86_64.whl
COPY . ./

# COPY tensorflow-2.1.0-cp37-cp37m-manylinux2010_x86_64.whl  /tmp

ENV GOOGLE_APPLICATION_CREDENTIALS "./token.json"

RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    ffmpeg

# Install production dependencies.
# 给pip 配置镜像
RUN pip config set global.index-url http://mirrors.aliyun.com/pypi/simple
RUN pip config set install.trusted-host mirrors.aliyun.com
# 更新pip    
RUN pip install --upgrade pip
# Install production dependencies.
# 因为下载tensorflow太慢了,所以采用了从宿主拷贝的方法
RUN pip install -r requirements_1.txt
RUN pip install tensorflow-2.1.0-cp37-cp37m-manylinux2010_x86_64.whl
RUN pip install -r requirements_2.txt

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
CMD exec gunicorn --bind 0.0.0.0:8080 --workers 1 --threads 8 --timeout 0 app:app

