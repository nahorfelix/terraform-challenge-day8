#!/bin/bash

# Update system packages
yum update -y

# Install necessary packages
yum install -y httpd

# Create a simple HTML page with cluster information
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>${cluster_name} - Web Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f0f0f0; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .header { color: #333; border-bottom: 2px solid #007acc; padding-bottom: 10px; }
        .info { margin: 20px 0; }
        .status { color: #28a745; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="header">🚀 ${cluster_name}</h1>
        <div class="info">
            <p><strong>Status:</strong> <span class="status">✅ Running</span></p>
            <p><strong>Server Port:</strong> ${server_port}</p>
            <p><strong>Instance ID:</strong> <span id="instance-id">Loading...</span></p>
            <p><strong>Availability Zone:</strong> <span id="az">Loading...</span></p>
            <p><strong>Deployed:</strong> $(date)</p>
        </div>
        <p>This server is part of an Auto Scaling Group managed by Terraform modules.</p>
    </div>
    
    <script>
        // Fetch instance metadata
        fetch('http://169.254.169.254/latest/meta-data/instance-id')
            .then(response => response.text())
            .then(data => document.getElementById('instance-id').textContent = data)
            .catch(() => document.getElementById('instance-id').textContent = 'Not available');
            
        fetch('http://169.254.169.254/latest/meta-data/placement/availability-zone')
            .then(response => response.text())
            .then(data => document.getElementById('az').textContent = data)
            .catch(() => document.getElementById('az').textContent = 'Not available');
    </script>
</body>
</html>
EOF

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Configure Apache to listen on the specified port
sed -i "s/Listen 80/Listen ${server_port}/" /etc/httpd/conf/httpd.conf

# Restart Apache with new configuration
systemctl restart httpd

# Create a simple health check endpoint
echo "OK" > /var/www/html/health

# Set up log rotation for application logs
cat > /etc/logrotate.d/webapp << EOF
/var/log/httpd/*log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 apache apache
    postrotate
        systemctl reload httpd
    endscript
}
EOF