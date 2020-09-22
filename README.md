# gitdork.sh
Get dorky and search GitHub for sensitive information with this simple shell script. Made by a Blue Teamer for Blue Teamers.

# Goal
As a Blue Teamer you can't protect what you don't know about. This script can help you gain awareness as to what sensitive information may be hiding in your GitHub repositories.

# How I Use This
I don't smash a bunch of keywords against GitHub or do any fancy password or api key detection with this script. I use this script to hunt around for sensitive information that I may not know exists so I can better protect that information. That's the reason there are so few keywords in dorks.txt. I prefer to check for a smaller subset of keywords, then investigate manually through the browser.

# Inspiration
There are some really great projects and scripts for finding sensitive information. However, for my script, these were the scripts/projtects I drew inspiration from:

- Jason Haddix's bash script that generates Github dork payloads
  - https://gist.github.com/jhaddix/1fb7ab2409ab579178d2a79959909b33

- Techquan's github-dorks python tool for automating github dorks
  - https://github.com/techgaun/github-dorks

- Majd Aldeen Atiyat's talk on Github Recon and Sensitive Data Exposure
  - https://www.youtube.com/watch?v=l0YsEk_59fQ

# Setup
1. Run `git clone https://github.com/techspence/gitdork.sh.git`
2. Review `dorks.txt` & modify as needed
3. run:  `gitdork.sh -u dorks.txt -u <github user>`  or  `gitdork.sh -u dorks.txt -o <github org>`

# TODO
- [ ] Add Slack alert
- [ ] Convert hard coded username/token to use environment variables
- [ ] Add -i (ignore) flag to allow ignoring a repository/list of repositories (txt file)

