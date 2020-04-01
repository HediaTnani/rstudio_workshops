# Deploying Content

As part of this class, you'll deploy an RMarkdown document and a Shiny app to
RStudio Connect. Before deploying, you'll have to fix them! They've got some essential parts missing.

After they're fixed, you'll deploy them to RStudio Connect.

## Add RStudio Connect as Deployment Location

Your RStudio Connect instance is on the same server as the RStudio Server Pro
instance at the `rsconnect` path. 

When you press the blue publish button, you'll be prompted to put in the URL of your RStudio Connect deployment.

## Getting your deployment URL
If you copy the URL from your
browser right now, you'll have something that looks like
```
http://ec2-18-222-240-93.us-east-2.compute.amazonaws.com/rstudio/s/7d2abcfc78a3182f0768a/
```

If you take the base URL `http://ec2...amazonaws.com` and replace everything
after (the part that starts with `/rstudio`) with `/rsconnect`, you'll be taken to your RStudio Connect instance.

Login with the same username and password you used to login to RStudio Server Pro. 
When prompted for an email, you can put in whatever you like (including a fake email).

## Deploy Shiny App

You can use push-button deployment to deploy the Shiny app, but you'll get an
error! Examine the shiny app code to find the `Sys.getenv` calls. You'll have to
provide these variables through the Environment Variables pane in RStudio Connect.

Hint: Find the username and password by checking in `~/rstudio_workshops/.Rprofile` file. 

## Deploy Rmd

You can deploy this right away to RStudio Connect with no errors because it makes
use of the DSNs present on RStudio Server and RStudio Connect. Since we're using a config file
to get the DSN here, you shouldn't face any errors, but gotta push that `config.yml` to the server
along with the RMD.

