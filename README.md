# Deploying

First, build:

    bundle exec rake generate

Then deploy:

    cd public && rsync -avz --chmod=u=rwX,g=rX . aethe@rsync.keycdn.com:zones/blgsud
