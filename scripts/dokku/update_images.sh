#!/bin/bash
set -ex

# TODO: how to handle if services uses custom image (e.g. postgis)?

# https://stackoverflow.com/a/33511811/4028896
# https://stackoverflow.com/a/51628017/4028896

update_service() {
    SERVICE=$1
    SERVICE_VERSION=$2

    IMAGE=$SERVICE:$SERVICE_VERSION
    out=$(docker pull $IMAGE)

    if [[ $out != *"up to date"* ]]; then
        # put all
        for app in $(dokku --quiet apps:list); do
            dokku maintenance:on $app
        done

        digest=$(docker inspect --format='{{index .RepoDigests 0}}' $IMAGE)
        # take last 10 chars as ID
        short_digest=${digest: -10}

        newtag="$IMAGE-$short_digest"
        docker tag $IMAGE $newtag

        # upgrade every service
        for service_name in $(dokku --quiet $SERVICE:list); do
            dokku $SERVICE:upgrade $service_name -I "$SERVICE_VERSION-$short_digest"
        done

        # enable all apps
        for app in $(dokku --quiet apps:list); do
            dokku maintenance:off $app
        done

        # delete old images
        docker image prune -f
    fi
}

update_service postgres 11
update_service redis 5
