# nginx

FROM	alpine:3.20

COPY	./conf/default /etc/nginx/nginx.conf

# 1. install nginx and openssl (to create self_signed ssl certificate for TLS)
# 2. create dir to store self-signed ssl certificate (-p if it does not already exist)
# 3. create self-signed ssl certificate
#	req = create certificate request (CSR)
#	-x509 = flag to generate self-signed certificate instead of CSR
#	-nodes = "do DES" = do not encrypt private key; easier in automated systems
#	-days 365 = 365 days validity
#	-newkey rsa:2048 = new RSA private key with length of 2048 bits
#	-keyout = specifies output file for private key
#	-out = specifies output file for certificate itself
#	-subj "" = sets metadata, e.g. C = country, L = city, O = organization, CN = usually domain name
# do all in one RUN command to speed things up (otherwise we will have several layers)
RUN		sudo apk update -y && sudo apk add nginx openssl -y
		&& mkdir -p /etc/nginx/ssl 
		&& openssl req 

EXPOSE	443