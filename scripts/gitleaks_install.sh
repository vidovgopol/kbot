#!/bin/sh

curl -o .git/hooks/pre-commit https://raw.githubusercontent.com/vidovgopol/kbot/master/scripts/pre-commit
chmod 755 .git/hooks/pre-commit
