yum update -y

yum install epel-release -y
yum install centos-release-gluster -y
yum install glusterfs-server -y

systemctl start glusterd

firewall-cmd --zone=internal --add-service=glusterfs --permanent
firewall-cmd --zone=internal --add-source=192.168.0.1/32 --permanent
firewall-cmd --zone=internal --add-source=192.168.0.2/32 --permanent
firewall-cmd --zone=internal --add-source=192.168.0.3/32 --permanent
firewall-cmd --zone=internal --add-source=192.168.0.4/32 --permanent

firewall-cmd - reload
systemctl enable firewalld glusterd