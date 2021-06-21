#!/bin/bash

echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export PATH=$HOME/go/bin:$PATH" >> ~/.bashrc

GO111MODULE=on $HOME/go/bin/go get golang.org/x/tools/gopls@latest