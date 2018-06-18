A Docker container with very basic provisioning of Ruby + Rails + Nginx + MySql

# Usage
## OSX / Ubuntu:
`docker run -it --rm --name ror -p 80:80 --mount type=bind,source=$(PWD),target=/var/www/html/ kmrd/ror`

## Windows:
`docker run -it --rm --name ror -p 80:80 --mount type=bind,source="%cd%",target=/var/www/html/ kmrd/ror`

## Deployment
Typically to start, use:
`bundle install`
`rake db:create`
`rake db:seed`
`rails start -b 0.0.0.0`
