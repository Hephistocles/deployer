# deployer
A very simple tool which automates creation of nginx and upstart configuration files for serving apps.

I was fed up of writing and editing configurations files when deploying new apps. This repository contains my script, a sample configuration file and a sample app to deploy.

## Deployment guide

1. Build your app somewhere
(1b. [Optional] Ensure that your app launches on a port number provided as the PORT environment variable on launch)
2. Enter into the config file:
  a) `NAME`: the app's name
  b) `SLUG`: the app's slug ([A-Za-z0-9_-]+) - used for filenames etc
  c) `PORT`: the port the app will run on (passed as an environment variable to the app on launch)
  d) `COMD`: the command required to launch the app
  e) `DOMS`: The domain names you would like nginx to serve it under
  
  For example:

    NAME=My Application
    SLUG=my-app
    PORT=3000
    COMD=cd /home/christoph/dev/my-app; node app.js
    DOMS=myapp.clittle.com

(2b. [Optional] Add more applications, separated by a blank line. The end of the file must include a blank line, I think.)
    
3. Run `sudo add-site.sh`
