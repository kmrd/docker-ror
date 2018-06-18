A Docker container with very basic provisioning of Ruby + Rails + Nginx + MySql

# Usage
## OSX / Ubuntu:
`docker run -it --rm --name ror -p 80:80 --mount type=bind,source=$(PWD),target=/var/www/html/ kmrd/ror`

## Windows:
`docker run -it --rm --name ror -p 80:80 --mount type=bind,source="%cd%",target=/var/www/html/ kmrd/ror`
