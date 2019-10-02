### TASK

# 1

sudo yum install -y gcc gcc-c++ git httpd-tools 
# sudo  /etc/yum.repos.d/nginx.repo

cd /home/vagrant/
# NGINX
sudo usermod -aG wheel vagrant
sudo wget https://nginx.org/download/nginx-1.16.1.tar.gz
sudo tar xzf nginx-1.16.1.tar.gz
sudo rm nginx-1.16.1.tar.gz
#PCRE
sudo wget ftp://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz
sudo tar xzf pcre-8.43.tar.gz
sudo rm pcre-8.43.tar.gz

# OpenSSL
sudo wget https://www.openssl.org/source/openssl-1.0.2t.tar.gz
sudo tar xzf openssl-1.0.2t.tar.gz
sudo rm openssl-1.0.2t.tar.gz

# git
git clone https://github.com/vozlt/nginx-module-vts

cd /home/vagrant/nginx-1.16.1

# config
sudo ./configure --prefix=/home/vagrant/nginx \
--user=vagrant \
--group=vagrant \
--sbin-path=/home/vagrant/nginx/sbin/nginx \
--conf-path=/home/vagrant/nginx/conf/nginx.conf \
--http-log-path=/home/vagrant/nginx/logs/access.log \
--error-log-path=/home/vagrant/nginx/logs/error.log \
--pid-path=/home/vagrant/nginx/logs/nginx.pid \
--with-http_ssl_module \
--with-http_realip_module \
--without-http_gzip_module \
--with-pcre=/home/vagrant/pcre-8.43 \
--with-pcre-jit \
--with-openssl=/home/vagrant/openssl-1.0.2t \
--with-openssl-opt=no-nextprotoneg \
--add-module=/home/vagrant/nginx-module-vts \
--with-debug

sudo make
sudo make install

cd /home/vagrant/
sudo echo "[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
User=vagrant
Group=vagrant
PIDFile=/home/vagrant/nginx/logs/nginx.pid
ExecStartPre=/home/vagrant/nginx/sbin/nginx -t
ExecStart=/home/vagrant/nginx/sbin/nginx
ExecReload=/home/vagrant/nginx/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target" > nginx.service

sudo mv nginx.service /lib/systemd/system/

sudo chown -R vagrant:vagrant /home/vagrant/nginx
sudo chmod -R 755 /home/vagrant/nginx

sudo chown -R vagrant:vagrant /lib/systemd/system/nginx.service
sudo chmod -R 755 /lib/systemd/system/nginx.service


# 3
cd /vagrant
mkdir /home/vagrant/nginx/conf/vhosts
mv backend.conf /home/vagrant/nginx/conf/vhosts/
mv nginx.conf /home/vagrant/nginx/conf/ 
#rm -rf /home/vagrant/nginx/conf/html
#mkdir /home/vagrant/nginx/conf/html
tar xzf html.tar.gz -C /home/vagrant/nginx/ --overwrite
htpasswd -b -c /home/vagrant/nginx/conf/.htpasswd admin nginx

             

sudo systemctl daemon-reload
sudo systemctl enable nginx
sudo systemctl start nginx


