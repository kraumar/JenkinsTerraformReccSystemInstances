import os
import shutil

os.mknod("./config.tmp")

file = open("/home/marek-ubu/Documents/IAC/slave-public-ips")

ips = []

for line in file:
	ips.append(line.strip())

n_lines = len(ips)

file = open("./config.tmp", "a")

namenode = """Host nnode
  HostName 89.64.44.23
  User hadoop
  IdentityFile ~/.ssh/id_rsa"""

file.write(namenode + '\n')


for i in range(n_lines):
	datanode = """Host dnode""" + str(i + 1) +"""
  HostName """ + ips[i] + """
  User hadoop
  IdentityFile ~/.ssh/id_rsa"""
	file.write('\n' + datanode + '\n')

os.replace("./onfig.tmp","/home/marek-ubu/.ssh/config")

