# Update system
echo -e  "Updating your system"
sudo apt-get update && sudo apt-get upgrade -y
echo ""

# Check the installed packages
echo -e "Checking the installed packages"
dpkg --get-selections | grep -v deinstall
echo ""

# Check firewall server
echo -e "Checking for open ports"
sudo ufw enable
sudo ufw allow 22,80/tcp
sudo ufw verbose
echo ""

# Secure SSH
echo -e "Securing SSH"
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo systemctl restart sshd
echo

# Remove unnecessary services
echo -e "Removing unnecessary services"
echo "Removing unnecessary services..."
sudo apt-get purge rpcbind rpcbind-* -y
sudo apt-get purge nis -y
echo ""

# Remove unused package
echo -e "Removing unused package"
echo "Removing unused package..."
sudo apt-get autoremove -y
sudo apt-get autoclean -y
echo ""

# DNS Resolve
echo -e "Removing unused package"
sudo echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf
sudo echo "nameserver 8.8.4.4" | sudo tee -a/etc/resolv.conf
echo ""

# Configure webserver
echo -e "Configure webserver"
sudo chmod +x config-web-server.sh
sudo ./config-web-server.sh

# Manage password policies
echo -e "Managing password policies"
echo "Modifying the password policies..."
sudo sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t90/g' /etc/login.defs
sudo sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t7/g' /etc/login.defs
sudo sed -i 's/PASS_WARN_AGE\t7/PASS_WARN_AGE\t14/g' /etc/login.defs
echo ""