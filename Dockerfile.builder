# Update the VARIANT arg in devcontainer.json to pick an Alpine version: 3.10, 3.11, 3.12
ARG VARIANT=3.12
FROM alpine:${VARIANT}

MAINTAINER Leo Przybylski <r351574nc3 at gmail.com>

ENV STEEM_NAME "NO_USER_SPECIFIED"
ENV STEEM_WIF  "NO_WIF_SPECIFIED"

# This Dockerfile adds a non-root user with sudo access. Use the “remoteUser” property in
# devcontainer.json to use it. More info: https://aka.ms/vscode-remote/containers/non-root-user.
ARG USERNAME=steembot
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Options for common setup script
ARG INSTALL_ZSH="true"
ARG COMMON_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/master/script-library/common-alpine.sh"
ARG COMMON_SCRIPT_SHA="dev-mode"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
RUN apk update \
    && apk add --no-cache curl ca-certificates \
        nodejs \
        npm \
        python3 \
    && curl -sSL  ${COMMON_SCRIPT_SOURCE} -o /tmp/common-setup.sh \
    && if [ "$COMMON_SCRIPT_SHA" != "dev-mode" ]; then echo "$COMMON_SCRIPT_SHA */tmp/common-setup.sh" | sha256sum -c - ; fi \
    && /bin/ash /tmp/common-setup.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" \
    && rm /tmp/common-setup.sh \
    && npm install -g typescript @nestjs/cli

WORKDIR /app

ONBUILD COPY package*json .npmrc* /app/
ONBUILD RUN npm install
# Now copy in the full code for the app
ONBUILD COPY . /app
ONBUILD RUN cd /app && npm run build && npm install --production


# Set our workdirectory to the app and start with npm
EXPOSE 3000

ONBUILD RUN chown -R steembot /app

ONBUILD USER steembot

CMD ["npm", "start" ]
 