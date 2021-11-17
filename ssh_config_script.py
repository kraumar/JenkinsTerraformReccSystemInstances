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
  User marek-ubu
  IdentityFile ~/.ssh/id_rsa"""

file.write(namenode + '\n')


for i in range(n_lines):
	datanode = """Host dnode""" + str(i + 1) +"""
  HostName """ + ips[i] + """
  User marek-ubu
  IdentityFile ~/.ssh/id_rsa"""
	file.write('\n' + datanode + '\n')

os.replace("./config.tmp","/home/marek-ubu/.ssh/config")
os.replace("./slave-public-ips","/home/marek-ubu/HadoopMaster/hadoop-2.10.1/etc/hadoop/slaves")
