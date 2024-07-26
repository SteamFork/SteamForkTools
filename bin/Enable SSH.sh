#!/bin/sh
sudo steamos-readonly disable
sudo systemctl enable sshd
sudo systemctl start sshd
sudo steamos-readonly enable
