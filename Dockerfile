FROM kalilinux/kali-rolling

LABEL maintainer="noruleset"

# Environment Variables
ENV HOME /root
ENV DEBIAN_FRONTEND=noninteractive

# Working Directory
WORKDIR $HOME
RUN mkdir ${HOME}/tools && \
    mkdir ${HOME}/wordlists

# Install Essentials
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    tmux \
    gcc \
    iputils-ping\
    git \
    vim \
    wget \
    awscli \
    tzdata \
    curl \
    make \
    nmap \
    whois \
    python2 \
    python-pip-whl \
    python-setuptools \
    python3 \
    python3-pip \
    python3-setuptools \
    perl \
    nikto \
    dnsutils \
    net-tools \
    && ln -s /usr/bin/python2 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

# Install Dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # sqlmap
    sqlmap \
    # dnsenum
    cpanminus \
    # wfuzz
    python3-pycurl \
    # knock
    python3-dnspython \
    # massdns
    libldns-dev \
    # wpcscan
    libcurl4-openssl-dev \
    libxml2 \
    libxml2-dev \
    libxslt1-dev \
    ruby-dev \
    libgmp-dev \
    zlib1g-dev \
    # masscan
    libpcap-dev \
    # hydra
    hydra \
    # dnsrecon
    dnsrecon \
    && rm -rf /var/lib/apt/lists/*

# tzdata
RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# configure python(s)
RUN python3 -m pip install --upgrade setuptools

# Sublist3r
RUN cd ${HOME}/tools && \
    git clone https://github.com/aboul3la/Sublist3r.git && \
    cd Sublist3r/ && \
    pip install -r requirements.txt && \
    ln -s ${HOME}/tools/Sublist3r/sublist3r.py /usr/local/bin/sublist3r

# wfuzz
RUN pip install wfuzz

# seclists
RUN cd ${HOME}/wordlists && \
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git 

# knock
RUN cd ${HOME}/tools && \
    git clone https://github.com/guelfoweb/knock.git && \
    cd knock && \
    chmod +x setup.py && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install python3 -y && \
    python3 setup.py install

# massdns
RUN cd ${HOME}/tools && \
    git clone https://github.com/blechschmidt/massdns.git && \
    cd massdns/ && \
    make && \
    ln -sf ${HOME}/tools/massdns/bin/massdns /usr/local/bin/massdns

# wafw00f
RUN cd ${HOME}/tools && \
    git clone https://github.com/enablesecurity/wafw00f.git && \
    cd wafw00f && \
    chmod +x setup.py && \
    python setup.py install

# commix 
RUN cd ${HOME}/tools && \
    git clone https://github.com/commixproject/commix.git && \
    cd commix && \
    chmod +x commix.py && \
    ln -sf ${HOME}/tools/commix/commix.py /usr/local/bin/commix

# masscan
RUN cd ${HOME}/tools && \
    git clone https://github.com/robertdavidgraham/masscan.git && \
    cd masscan && \
    make && \
    ln -sf ${HOME}/tools/masscan/bin/masscan /usr/local/bin/masscan    

# teh_s3_bucketeers
RUN cd ${HOME}/tools && \
    git clone https://github.com/tomdev/teh_s3_bucketeers.git && \
    cd teh_s3_bucketeers && \
    chmod +x bucketeer.sh && \
    ln -sf ${HOME}/tools/teh_s3_bucketeers/bucketeer.sh /usr/local/bin/bucketeer

# XSStrike
RUN cd ${HOME}/tools && \
    git clone https://github.com/s0md3v/XSStrike.git && \
    cd XSStrike && \
    pip3 install -r requirements.txt && \
    chmod +x xsstrike.py && \
    ln -sf ${HOME}/tools/XSStrike/xsstrike.py /usr/local/bin/xsstrike

# CloudFlair
RUN cd ${HOME}/tools && \
    git clone https://github.com/christophetd/CloudFlair.git && \
    cd CloudFlair && \
    pip install -r requirements.txt && \
    chmod +x cloudflair.py && \
    ln -sf ${HOME}/tools/CloudFlair/cloudflair.py /usr/local/bin/cloudflair

# go
RUN cd /opt && \
    wget https://go.dev/dl/go1.17.6.linux-amd64.tar.gz && \
    tar -xvf go1.17.6.linux-amd64.tar.gz && \
    rm -rf /opt/go1.17.6.linux-amd64.tar.gz && \
    mv go /usr/local 
ENV GOROOT /usr/local/go
ENV GOPATH /root/go
ENV PATH ${GOPATH}/bin:${GOROOT}/bin:${PATH}

# gobuster
RUN cd ${HOME}/tools && \
    git clone https://github.com/OJ/gobuster.git && \
    cd gobuster && \
    go get && go install

# s3recon
RUN pip3 install --upgrade setuptools && \
    pip3 install pyyaml pymongo requests s3recon

# subfinder
RUN GO111MODULE=on go get -u -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder

# whatweb
RUN cd ${HOME}/tools && \
    git clone https://github.com/urbanadventurer/WhatWeb.git && \
    cd WhatWeb && \
    chmod +x whatweb && \
    ln -sf ${HOME}/tools/WhatWeb/whatweb /usr/local/bin/whatweb

# fierce
RUN python3 -m pip install fierce

# amass
RUN export GO111MODULE=on && \
    go get -v github.com/OWASP/Amass/v3/...

# S3Scanner
RUN cd ${HOME}/tools && \
    git clone https://github.com/sa7mon/S3Scanner.git && \
    cd S3Scanner && \
    pip3 install -r requirements.txt

# subjack
RUN go get github.com/haccer/subjack

# SubOver
RUN go get github.com/Ice3man543/SubOver

# Compress wordlist
RUN cd ${HOME}/wordlists && \
    tar czf SecList.tar.gz ${HOME}/wordlists/SecLists/ && \
    rm -rf SecLists

# ffuf
RUN go get -u github.com/ffuf/ffuf

# httprobe
RUN go get -u github.com/tomnomnom/httprobe

# assetfinder
RUN go get -u github.com/tomnomnom/assetfinder

# gron
RUN go get -u github.com/tomnomnom/gron

# meg
RUN go get -u github.com/tomnomnom/meg

# gf
RUN go get -u github.com/tomnomnom/gf

# anew
RUN go get -u github.com/tomnomnom/anew

# fff
RUN go get -u github.com/tomnomnom/fff

# gitGraber
RUN cd ${HOME}/tools && \
    git clone https://github.com/hisxo/gitGraber.git && \
    cd gitGraber && \
    ln -sf ${HOME}/tools/gitGraber/gitGraber.py /usr/local/bin/gitGraber

# waybackurls
RUN go get github.com/tomnomnom/waybackurls

# Katoolin
RUN cd ${HOME}/tools && \
    git clone https://github.com/LionSec/katoolin.git && \
    cd katoolin && \
    chmod +x katoolin.py

# Clean Go Cache
RUN go clean -cache && \
    go clean -testcache && \
    go clean -modcache