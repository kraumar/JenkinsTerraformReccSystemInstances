import os

if os.path.exists("./config.tmp"):
	os.remove("./config.tmp")

file = open("./slave-public-dns")

dns = []

for line in file:
	dns.append(line.strip())

n_lines = len(dns)

file = open("./config.tmp", "a")

namenode = """Host nnode
  HostName ec2-52-28-240-160.eu-central-1.compute.amazonaws.com
  User hadoop
  IdentityFile ~/.ssh/id_rsa"""

file.write(namenode + '\n')


for i in range(n_lines):
	datanode = """Host dnode""" + str(i + 1) +"""
  HostName """ + dns[i] + """
  User hadoop
  IdentityFile ~/.ssh/id_rsa"""
	file.write('\n' + datanode + '\n')

os.replace("./config.tmp","/home/hadoop/.ssh/config")
os.replace("./slave-public-dns","/opt/hadoop/hadoop-2.7.0/etc/hadoop/slaves")
