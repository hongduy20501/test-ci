#!/usr/bin/env bash
set -ex
while read -r line;
do
        if [ -z $(curl -v https://github.com/${line}.keys)]; then
                continue
        else
                curl -v https://github.com/${line}.keys | grep -oE "ssh-rsa [A-Za-z0-9/+=]+" | while read linekey; do
                  echo "${line}" "${linekey}" >> keys
                  done
        fi
done < usersname