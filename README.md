# DeckShare - SteamOS Screenshot Sharing Service

Steam Screenshot sharing is a hassle, especially on the Steam Deck.

*DeckShare* is a simple bash service that monitors the users Steam directory for new screenshots and automatically posts them to Discord via the provided webhook.
(You must get your own [Discord webhook](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) url and provide it in the .env file)

The service monitors the directory and within 5 seconds of detected changes will post the images to discord and remember what file it posted last to ensure no duplicates.

<hr>

*Hey! I made it easier with a scary bash script! (You are more than welcome to analyze it yourself before running, it's good I promise)*

`curl -s https://raw.githubusercontent.com/SmugZombie/DeckShare/main/install.sh | sudo bash`

Otherwise read on...

<hr>

How to use:
Extract this git here:

/opt/DeckShare

Once unzipped, cd into the directory:

`cd /opt/DeckShare`

![image](https://github.com/SmugZombie/DeckShare/assets/11764327/af593bc5-24e3-430a-a841-980982b97821)

Create a .env file (copy sample.env to .env and fix the values)

<pre>
webhook_url=< your discord webhook url here >
thumbnails=<0|1>
</pre>
  
Copy the service file to the appropriate location in SteamOS:

`sudo cp deckshare.service /etc/systemd/system/`

Enable the service:

`sudo systemctl enable deckshare.service`

Start the service:

`sudo systemctl start deckshare.service`

Check the service status:

`sudo systemctl status deckshare.service`

![image](https://github.com/SmugZombie/DeckShare/assets/11764327/dc792fd7-8892-42db-a1ba-09d1b9bcef70)

Now you should be able to locate all new screenshots in your discord history and can share freely / download from here.

![image](https://github.com/SmugZombie/DeckShare/assets/11764327/00e0226f-86a0-46a8-ac1e-3fbe2b9dd814)


# Give Thanks

Like this plugin? [Buy me a beer!](https://www.paypal.com/paypalme/regli)
