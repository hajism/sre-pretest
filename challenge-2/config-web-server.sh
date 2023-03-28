#!/bin/bash
conf_path="/etc/nginx/conf.d/$1.conf"

if [ -f "$conf_path" ]
then
    conf_text=`cat $conf_path`
    if [[ "$conf_text" == *"$2"* ]] || [[ "$conf_text" == *"localhost:$3"* ]]
    then
        echo "Proxy route or localhost port has been used, please manually reconfigure your Nginx configuration."
    else
        word="\n\n\tlocation \/$2\/ {\
\n\t\tproxy_pass http:\/\/localhost:$3\/;\
\n\t}"
        match="# Insert here"
        echo "$conf_text" | sed "s/$match/&$word/g" > "$conf_path"
    fi

    nginx -t
    systemctl reload nginx
else
    conf_text="server {
	listen       80;
	listen       [::]:80;
	server_name  $1;
	# Load configuration files for the default server block.
	include /etc/nginx/default.d/*.conf;
	
	# Insert here
	location /$2/ {
		proxy_pass http://localhost:$3/;
	}
	error_page 404 /404.html;
		location = /40x.html {
	}
	error_page 500 502 503 504 /50x.html;
		location = /50x.html {
	}
}"

    echo "$conf_text" > "$conf_path"

    chcon unconfined_u:object_r:httpd_config_t:s0 "$conf_path"
    chown root:root "$conf_path"

    nginx -t
    systemctl reload nginx
fi