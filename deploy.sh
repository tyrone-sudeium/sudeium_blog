#!/bin/bash
bundle exec jekyll b && cd public && rsync -rtvz --delete --chmod=u=rwX,g=rX . aethe@rsync.keycdn.com:blgsud
