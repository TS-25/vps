# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Prevent apt-get from asking for user input
ENV DEBIAN_FRONTEND=noninteractive

# Update, install dependencies, and enable systemd
RUN apt-get update && \
    apt-get install -y \
    systemd \
    dbus \
    openssh-server \
    wget \
    curl \
    git \
    tmate && \
    rm -rf /var/lib/apt/lists/*

# Set up SSH for root login (as in your original file)
RUN mkdir -p /var/run/sshd && \
    echo 'root:password' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Enable the SSH service so systemd starts it on boot
RUN systemctl enable ssh

# Configure tmate (as in your original file)
RUN mkdir -p /root/.tmate
COPY tmate.conf /root/.tmate/

# Expose the SSH port
EXPOSE 22

# Tell Docker how to gracefully stop systemd
STOPSIGNAL SIGRTMIN+3

# Set the default command to start systemd
# This will be the main process (PID 1) in the container
CMD ["/sbin/init"]
