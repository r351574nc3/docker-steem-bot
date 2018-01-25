FROM alpine:latest

MAINTAINER Leo Przybylski <r351574nc3 at gmail.com>

RUN apk update \
    apk add nodejs nodejs-npm

ONBUILD COPY package*json .npmrc* /app/
ONBUILD RUN cd /app && npm install --production

# Now copy in the full code for the app
ONBUILD COPY . /app

# Set our workdirectory to the app and start with npm
WORKDIR /app
CMD ["npm", "start"]


