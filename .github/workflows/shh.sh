#!/usr/bin/env bash
set -ex
server=$1
	ssh "${server}" cat /etc/passwd | grep "/bin/bash" |cut -d: -f1 >> user.pass
	echo "${server}"
while read -r user; do             
	echo "${user}"
   	ssh "${server}" sudo cat ~"${user}"/.ssh/authorized_keys < /dev/null | grep -oE "ssh-rsa [A-Za-z0-9/+=]+" >> keys.list
done < user.pass

 while read -r linekey; do
                a=$(echo "${linekey}" | md5sum | grep -oE "[A-Fa-f0-9]+")
                flag=0
        while read -r line; do
                b=$(echo "${line}" | cut -d' ' -f1)
                c=$(echo -n "${line}" | grep -oE "ssh-rsa [A-Za-z0-9/+=]+")
                d=$(echo "${c}" | md5sum | grep -oE "[A-Fa-f0-9]+")

                if [[ ${a} == ${d} ]]; then
                        flag=1
                        echo "user: ${b}" >> login.list
                        break
                fi
        done < keys
                if [ ${flag} == 0 ]; then
                        echo "key: ${linekey:0:50}...${linekey:(-30)}" >> nologin.list
                fi
done < keys.list

echo "user co the login :"
cat -n login.list
echo "-------------------------------"
echo "key khong thuoc user nao :"
cat -n nologin.list
