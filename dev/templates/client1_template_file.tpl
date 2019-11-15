#!/bin/bash

export name="${name}"
export env="${env}"

# Install packages
yum install epel-release.noarch -y
yum install vim mc wget unzip -y

# Install NTP
yum -y install ntp
systemctl enable ntpd
systemctl enable ntpd.service

# Update the hosts file 
echo "ip-10-10-10-100.ec2.internal	10.10.10.100" >> /etc/hosts
echo "ip-10-10-20-100.ec2.internal  	10.10.20.100" >> /etc/hosts
echo "ip-10-10-21-100.ec2.internal  	10.10.21.100" >> /etc/hosts

# Disable SELinux
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

# Install Puppet Server
rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
yum install -y puppet-server
systemctl enable puppetmaster.service

# -- Change the Puppet config
cat << EOF > /etc/puppet/puppet.conf
[main]
    # The Puppet log directory.
    # The default value is '$vardir/log'.
    logdir = /var/log/puppet

    # Where Puppet PID files are kept.
    # The default value is '$vardir/run'.
    rundir = /var/run/puppet

    # Where SSL certificates are kept.
    # The default value is '$confdir/ssl'.
    ssldir = $vardir/ssl

    # Enable automatic confirmation of 
    # certificates from clients
    # autosign = true

    environment = ${env}
    runinterval = 60s

[agent]
    # The file in which puppetd stores a list of the classes
    # associated with the retrieved configuratiion.  Can be loaded in
    # the separate ``puppet`` executable using the ``--loadclasses``
    # option.
    # The default value is '$confdir/classes.txt'.
    classfile = $vardir/classes.txt

    # Where puppetd caches the local configuration.  An
    # extension indicating the cache format is added automatically.
    # The default value is '$confdir/localconfig'.
    localconfig = $vardir/localconfig

    server=ip-10-10-10-100.ec2.internal
    certname=ip-10-10-21-100.ec2.internal    
EOF

echo "import 'nodes/*.pp'" > /etc/puppet/manifests/site.pp
mkdir /etc/puppet/manifests/nodes

# -- Create an example of manifest
cat << EOF > /etc/puppet/manifests/nodes/files.pp 
file { "/tmp/hello-file":
    replace => "no",
    owner => "root",
    group => "wheel",
    ensure  => "present",
    content => "From Puppet\n",
    mode    => 644,
}
EOF

systemctl start puppet.service

# Reboot ec2 Instance
# reboot 
