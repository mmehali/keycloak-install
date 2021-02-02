 CentOS
echo "-------------------------------------------"
echo "  Install the extra packages repository    "
echo "-------------------------------------------"
sudo yum install -y epel-release

echo "-------------------------------------------"
echo " Update the repositories                   "
echo "-------------------------------------------"
sudo yum -y update

echo "-------------------------------------------"
echo " install Nginx                             "
echo "-------------------------------------------"
sudo yum -y install nginx

# CentOS users can find their host configuration files under
# /etc/nginx/conf.d/ in which any .conf type virtual host 
# file gets loaded.
#Check that you find at least the default configuration 
# and then restart nginx.

sudo cp /vagrant/Install/nginx/load-balancer.conf /etc/nginx/conf.d/load-balancer.conf

echo "--------------------------------------------"
echo " restart nginx                              "
echo "--------------------------------------------"
systemctl start nginx.service
systemctl enable nginx.service


# Test that the server replies to HTTP requests. Open the load 
# balancer server’s public IP address in your web browser. 
# When you see the default welcoming page for nginx the 
# installation was successful.

# If you have trouble loading the page, check that a firewall 
# is not blocking your connection. For example on CentOS 7 the 
# default firewall rules do not allow HTTP traffic, enable it 
# with the commands below.
echo "--------------------------------------------"
echo " Activer le trafic HHTP sur le firewall     "
echo "--------------------------------------------"
sudo firewall-cmd  --permanent --add-service=http
sudo firewall-cmd --reload


# disable the default server configuration you earlier tested 
# CentOS hosts don’t use the same linking. Instead, simply rename 
# the default.conf in the conf.d/ directory to something that 
# doesn’t end with .conf, for example:

sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.disabled

#Then use the following to restart nginx.
sudo systemctl restart nginx




