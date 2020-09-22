#!/bin/bash

ORANGE='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
DORKFILE=dorks.txt

# TODO: convert this to use env variables
USERNAME=''
TOKEN=''

echo -e "${GREEN}"
echo -e "       G I T D O R K . S H        "
echo
echo -e "                  .----.          "
echo -e "      .---------. | == |          "
echo -e "      |.-\"\"\"\"\"-.| |----|     "
echo -e "      ||[0]^[0]|| | == |          "
echo -e "      ||   j   || |----|          "
echo -e "      || \___/ || |----|          "
echo -e "      |'-.....-'| |::::|          "
echo -e "      \`\"\")---(\"\"\` |___.|    "
echo -e "     /:::::::::::\                "
echo -e "    /:::=======:::\               "
echo -e "    ---------------               "
echo -e "${NC}"
echo "Usage:"
echo "gitdork.sh -d <dorkfile> -u <username>"
echo "gitdork.sh -d <dorkfile> -o <org name>"
echo
echo

# TODO: Add -i (ignore) flag to allow ignoring a repository/list of repositories (txt file)
while getopts ":d:o:u:" flag; do
  case ${flag} in
    d ) DORKS=${OPTARG};;
    o ) org=${OPTARG};;
    u ) user=${OPTARG};;
   \? ) echo "Invalid option: -$OPTARG" 1>&2
	exit 1;;
  esac
done


function reqsRemaining {
  curl -s -H "Accept: application/vnd.github.v3+json" -u $USERNAME:$TOKEN https://api.github.com/rate_limit | jq '.[].search.remaining // empty'
}

# Authenticated: 30 requests per minute
# Unauthenticated: 10 requets per minute
function searchGithub {
  if reqsRemaining -gt 0 >/dev/null; then
    curl -s -u $USERNAME:$TOKEN https://api.github.com/search/code?q=$1%3A$2+$3 -o results.json
    sleep 3
  fi
}

function displayResults {
  totalCount=$(cat $3 | jq '.total_count')
  repoCount=$(cat $3 | jq '.' | jq '.items[].repository.name' | sed 's/"//g' | sort -u | wc -l)
  # repos=$(cat $3 | jq '.' | jq '.items[].repository.name' | sort -u | sed '$!s/$/,/;s/"//g')
  # files=$(cat $3 | jq '.' | jq '.items[].name')
  output=$(cat $3 | jq -c '.items[] | {Repository: .repository.name, File: .name}' | sort -d)
  displayDork=$(echo "$1:$2 $dork")

  if [[ "$totalCount" -gt 0 ]]; then
    echo -e "${ORANGE}Dork:${NC} $displayDork"
    echo -e "${ORANGE}Total Results:${NC} $totalCount"
    echo -e "${ORANGE}Unique Respositories:${NC} $repoCount"
    echo -e "${ORANGE}Source(s):${NC}"
    echo $output | jq -c '.' | sed 's/:/: /g;s/{//g;s/}//g;s/"//g;s/,/ -- /g'
    echo
  fi

}

if [[ -z "$USERNAME" || -z "$TOKEN" ]]; then
  echo -e "${RED}[ERROR] Make sure you add your username and Github access token to the file${NC}"
exit 1
fi

if [[ -z $DORKS ]]; then
  echo -e "${RED}[ERROR] No dork file supplied. Make sure you added -d <dorkfile>${NC}"
exit 1
fi

while read -r DORKS; do
  dork=$(echo "$DORKS")
  # I don't want to search when both $org and $user are defined
  if [[ ! -z $org && ! -z $user ]]; then
    echo "[!] Try searching by either: -u (user) or -o (org) but not both"
    exit 1
  fi

  # If we search by user
  if [[ -z $org && ! -z $user ]]; then
    searchGithub 'user' $user $dork
    displayResults 'user' $user results.json
  fi

  # If we search by org
  if [[ ! -z $org && -z $user ]]; then
    searchGithub 'org' $org $dork
    displayResults 'org' $org results.json
  fi
done<"${DORKS}"

# delete results before running again
if [[ -f results.json ]]; then
  rm results.json
fi

