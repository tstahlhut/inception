# nginx

FROM	alpine:3.20


# 1. install nginx and openssl (to create self_signed ssl certificate for TLS)
#	Note: in Alpine no confirmation (-y) required
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
RUN		apk update && apk add nginx openssl \
		&& mkdir -p /etc/nginx/ssl \
		&& openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/my_cert.key \
		-out /etc/nginx/ssl/my_cert.crt \
		-subj "/C=DE/ST=Berlin/L=Berlin/O=42/OU=42/CN=$(DOMAIN_NAME)"

#COPY	./conf/nginx.conf /etc/nginx/nginx.conf
COPY	./conf/default.conf /etc/nginx/http.d/default.conf
#COPY	./conf/default /etc/nginx/sites-available/default

EXPOSE	443

#ensure that nginx is running in the foreground so that container stays alive as long as nginx runs
CMD 	["nginx", "-g", "daemon off;"]