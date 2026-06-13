#!/bin/bash

# gcloud compute instances start ssh-tunnel

# IP=$(gcloud compute instances list --format="csv(name, networkInterfaces.accessConfigs[0].natIP)" | grep ssh-tunnel | cut -d ',' -f2)
#
# bore local --port 3000 --to $IP 22
