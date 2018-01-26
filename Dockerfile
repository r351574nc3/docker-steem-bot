FROM alpine:latest

MAINTAINER Leo Przybylski <r351574nc3 at gmail.com>

ENV STEEM_NAME "NO_USER_SPECIFIED"
ENV STEEM_WIF  "NO_WIF_SPECIFIED"

RUN apk update \
    && apk add --no-progress --no-cache nodejs

ONBUILD COPY package*json .npmrc* /app/
ONBUILD RUN cd /app && npm install --production

# Now copy in the full code for the app
ONBUILD COPY . /app

# Set our workdirectory to the app and start with npm
WORKDIR /app
EXPOSE 3000

RUN adduser -D steembot steembot \
    && chown -R steembot /app

USER steembot

CMD ["npm", "start", "$STEEM_NAME", "$STEEM_WIF"]


