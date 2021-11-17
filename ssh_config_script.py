import os

if os.path.exists("./config.tmp"):
	os.remove("./config.tmp")

file = open("./slave-public-ips")

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

