#!/bin/sh
curl -X POST --data-urlencode 'payload={"attachments":[{"title":"ClamAV found the virus","title_link":"","channel":'$CHANNEL',"username":"clamav","text":"@here '$1' ('$POD_NAME')","color":"danger"}],"link_names":true,"prase":"full"}' $SLACK_WEBHOOK_URL
