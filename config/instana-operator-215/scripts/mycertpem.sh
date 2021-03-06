#!/usr/bin/expect -f

set timeout -1
set mypassword [lindex $argv 0]
set base [lindex $argv 1]

#------- key.pem
spawn openssl genrsa -aes128 -out key.pem 2048

expect "Enter pass phrase for key.pem:"
send -- "$mypassword\r"

expect "Verifying - Enter pass phrase for key.pem:"
send -- "$mypassword\r"


#------- cert.pem from key.pem
puts "\r\r"
spawn openssl req -new -x509 -key key.pem -out cert.pem -days 365

expect "Enter pass phrase for key.pem"
send -- "$mypassword\r"

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
send -- "instana.$base\r"

expect "Email Address"
send -- "\r"


expect eof
