#! /bin/bash
md_url="http://metadata.google.internal/computeMetadata/v1/instance"
project=`curl -s http://metadata.google.internal/computeMetadata/v1/project/project-id -H "Metadata-Flavor: Google"`
hostname=`curl -s ${md_url}/hostame -H "Metadata-Flavor: Google"`
machine=`curl -s ${md_url}/machine-type -H "Metadata-Flavor: Google"`
sa=`curl -s ${md_url}/service-accounts -H "Metadata-Flavor: Google"`
zone=`curl -s ${md_url}/zone -H "Metadata-Flavor: Google")`
tags=`curl -s ${md_url}/tags -H "Metadata-Flavor: Google")`
apt-get update
apt-get install -y nginx
cat <<EOF > /var/www/html/index.html
<html>
<head>
<style>
.preformatted {
    font-family: monospace;
    white-space: pre;
}
</style>
<title>${project} - ${hostname}</title>
</head>
<body>
<h1>${project} - ${hostname}</h1>
<div class="preformatted">
Hostname:         ${hostname}
Project:          ${project}
Zone:             ${zone}
Tags:             ${tags}
Machine Type:     ${machine}
Service Accounts: ${sa}
</div>
</body></html>
EOF