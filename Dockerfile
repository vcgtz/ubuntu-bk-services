FROM ubuntu:22.04

# Set bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Env variables
ENV TIME_ZONE=America/Mexico_City

# Install Updates
RUN apt update && apt -y upgrade

# Install Dependencies
RUN ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo $TIME_ZONE > /etc/timezone
RUN apt -y install sudo python3 python3.10-venv python3-pip git curl libmagic1 libmagickwand-dev libnss3 libatk1.0-0 \
  libatk-bridge2.0-0 libdrm2 libxkbcommon-x11-0 libxcomposite-dev libxdamage1 libxrandr2 libgbm-dev libasound2 \
  chromium-browser

# Install Node 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt install -y nodejs

# Config user
RUN adduser --disabled-password --gecos '' automation
RUN adduser automation sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER automation
WORKDIR /home/automation

# Install Python dependencies
COPY requirements.txt /home/automation/requirements.txt
RUN pip install -r requirements.txt

ENTRYPOINT /bin/bash
