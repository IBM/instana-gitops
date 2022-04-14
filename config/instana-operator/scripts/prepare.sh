#/bin/bash

# create ns instana-operator to create other stuff: secret/kubeconfig
oc create ns instana-operator

# kubeconfig
oc create secret generic kubeconfig --from-file=credentials=$HOME/.kube/config -n instana-operator

# cert-manager
oc apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml

# --
export dist=$(cat /etc/os-release  | grep "^ID=" | cut -f2 -d= | tr -d '"')
which expect
if [ $? -ne 0 ] ; then
	if [ "$dist" = "rhel" ] ; then
		yum install -y expect
	elif [ "$dist" = "ubuntu" ] ; then
		apt install -y expect
	else
		echo "no expected linux, exit"
		exit 1
	fi
fi

if [ ! -x /usr/local/bin/mycertpem.sh ] ; then
cat << EOF > /usr/local/bin/mycertpem.sh
#!/usr/bin/expect -f

set timeout -1
set mypassword [lindex \$argv 0]
set base [lindex \$argv 1]

#------- key.pem
spawn openssl genrsa -aes128 -out key.pem 2048

expect "Enter pass phrase for key.pem:"
send -- "\$mypassword\r"

expect "Verifying - Enter pass phrase for key.pem:"
send -- "\$mypassword\r"


#------- cert.pem from key.pem
puts "\r\r"
spawn openssl req -new -x509 -key key.pem -out cert.pem -days 365

expect "Enter pass phrase for key.pem"
send -- "\$mypassword\r"

expect "Country Name (2 letter code)"
send -- "CN\r"

expect "State or Province Name (full name)"
send -- "BJ\r"

expect "Locality Name (eg, city) "
send -- "BJ\r"

expect "Organization Name (eg, company)"
send -- "IBM\r"

expect "Organizational Unit Name (eg, section)"
send -- "CDL\r"

expect "Common Name "
send -- "instana.\$base\r"

expect "Email Address"
send -- "\r"

expect eof
EOF

chmod +x /usr/local/bin/mycertpem.sh
fi

base=`oc get ingresses.config/cluster -o jsonpath={.spec.domain}`
if [ "$portalPassword" = "" ] ; then
	portalPassword="passw0rd"
fi
/usr/local/bin/mycertpem.sh $portalPassword  $base
cat key.pem cert.pem > sp.pem
oc create configmap instana-sppem -n default --from-file=sppem=sp.pem


