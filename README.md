# docker-steem-bot
Base docker image for building steem bots


## Usage

It's intended that you would use this to create a new bot following the convention laid out by this `Dockerfile`

### Implement App

Create a nodejs app in the `app/` directory that can be executed via `npm start`. This is really up to you. Examples will be provided.

### Create Dockerfile

To use this base create a `Dockerfile` with

```
FROM r351574nc3/steem-bot-base:latest
```

### Build

You're done at this point. If you have a running application in `app/`, and you created a Dockerfile you can now build your bot! 
> **Note** you only have to do this once. It's not necessary each time you want to run your bot.

`docker build -t your-rep/your-bot-name:latest .`

### Go

Now that the image is built, we can run it. 

`docker run --rm -d your-rpo/your-bot-name:latest`

That's it. It's running in daemon mode. If you want to be sure that it's running:

`docker ps` 

will show the docker containers you have running. 