#!/bin/bash

# remember that Amazon Linux uses yum as its package manager, not apt

# Sleep to allow the instance to settle
sleep 30

# Update the system
sudo yum update -y

# Install tree, jq, and nginx
echo "Installing tree, jq, and nginx"
sudo yum install tree jq nginx -y

# Enable nginx to start on boot
sudo systemctl enable nginx

# Create a simple HTML page
sudo cat << EOF > /tmp/index.html
<html>
    <head>
        <title>Example html...</title>
    </head>
    <body>
        <h1 style="text-align: center;">Supa great app...</h1>
        <p style="text-align: center;">
        <img src="https://images.unsplash.com/photo-1508830524289-0adcbe822b40?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80" alt="School App">
        </p>
        <p style="text-align: center;">
        Photo by <a href="https://unsplash.com/@altumcode?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">AltumCode</a> on <a href="https://unsplash.com/s/photos/courses?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
        </p>
        <h2 style="text-align: center;">This message confirms that your App is working with an NGINX web server. Great work!</h2>
    </body>
</html>
EOF

# Move the HTML file to the nginx web directory
sudo mv /tmp/index.html /usr/share/nginx/html/index.html

# Start the nginx service
sudo systemctl start nginx

# Reload nginx to apply any configuration changes
sudo systemctl reload nginx