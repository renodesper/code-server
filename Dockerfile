# Start from the code-server Debian base image
FROM codercom/code-server:3.10.2

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json
COPY deploy-container/keybindings.json .local/share/code-server/User/keybindings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
RUN code-server --install-extension golang.go

# Install go
RUN curl -O https://dl.google.com/go/go1.16.5.linux-amd64.tar.gz && \
    tar xvf go1.16.5.linux-amd64.tar.gz && \
    rm -f go1.16.5.linux-amd64.tar.gz
COPY deploy-container/golang.sh /usr/bin/deploy-container-golang.sh
RUN /usr/bin/deploy-container-golang.sh

# Copy files:
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
