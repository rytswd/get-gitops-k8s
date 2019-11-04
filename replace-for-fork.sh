#!/usr/bin/env bash

__b__=$(tput bold)
__bg__=$(tput bold)$(tput setaf 2)
__by__=$(tput bold)$(tput setaf 3)
__cl__=$(tput sgr0)

echo "${__bg__}Replace all repository reference of 'rytswd/get-declarative-k8s'${__cl__}"
echo
read -r -p "Enter your GitHub username for your forked repository: " username
read -r -p "Enter the name of forked repository (defaults to 'get-declarative-k8s'): " reponame
[[ -z $reponame ]] && reponame='get-declarative-k8s' # Fall back to 'get-declarative-k8s'

echo
read -r -p "About to replace '${__b__}rytswd/get-declarative-k8s${__cl__}' with '${__by__}${username}/${reponame}${__cl__}', are you sure to proceed? [y/N] " response
case "$response" in
[yY][eE][sS] | [yY]) ;;
*)
    exit
    ;;
esac

find . -type f -name '*.yaml' -print0 |
    xargs -0 -n 1 perl -pi -e "s/rytswd\/get-declarative-k8s/${username}\/${reponame}/g"

echo
echo "Replace complete"
