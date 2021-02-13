FROM alpine:latest

#add curl for better handling
RUN apk add --no-cache curl
RUN apk add linux-headers 
# Update & Install dependencies
RUN apk add --no-cache --update \
    git \
    bash \
    libffi-dev \
    openssl-dev \
    bzip2-dev \
    zlib-dev \
    readline-dev \
    sqlite-dev \
    build-base

# Set Python version
ARG PYTHON_VERSION='3.7.0'
RUN export PYTHON_VERSION
# Set pyenv home
ARG PYENV_HOME=/root/.pyenv
RUN export PYENV_HOME

# Install pyenv, then install python versions
RUN git clone --depth 1 https://github.com/pyenv/pyenv.git $PYENV_HOME && \
    rm -rfv $PYENV_HOME/.git

ENV PATH $PYENV_HOME/shims:$PYENV_HOME/bin:$PATH

RUN pyenv install $PYTHON_VERSION
RUN pyenv global $PYTHON_VERSION
RUN pip install --upgrade pip && pyenv rehash

# Clean
RUN rm -rf ~/.cache/pip

# Done python3.7 setup

## setup home folder
RUN mkdir -p /root/.config/N-P-M-GRAF

ENV N-P-M-GRAF_HOME=/root/.config/N-P-M-GRAF/
ARG N-P-M-GRAF_HOME=/root/.config/N-P-M-GRAF/
RUN export N-P-M-GRAF_HOME

## seting up influx connection
ENV INFLUX_USER=admin
ARG INFLUX_USER=admin

ENV INFLUX_PW=admin
ARG INFLUX_PW=admin

ENV INFLUX_DB=DB
ARG INFLUX_DB=DB

ENV INFLUX_HOST=192.168.0.11
ARG INFLUX_HOST=192.168.0.11

ENV INFLUX_PORT=192.168.0.11
ARG INFLUX_PORT=192.168.0.11



## Copy files
COPY Getipinfo.py $N-P-M-GRAF_HOME/Getipinfo.py
COPY shtail.sh $N-P-M-GRAF_HOME/shtail.sh

COPY start.sh /root/start.sh
RUN chmod +x  /root/start.sh

ENTRYPOINT ["/root/start.sh"]


