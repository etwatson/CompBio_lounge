#!/bin/bash

#Prepare Environment for Large MEmory Tasks

# Set the swappiness 
echo "Setting swappiness to 10..."
sudo sysctl vm.swappiness=20

# Drop caches
echo "Dropping caches..."
echo 3 | sudo tee /proc/sys/vm/drop_caches

# Stop non-essential services (replace 'service_name' with the actual service name)
echo "Stopping non-essential services..."
SERVICES=("bluetooth.service" "cups.service" "snap.cups.cups-browsed.service" "snap.cups.cupsd.service")

# Stop non-essential services
for service in "${SERVICES[@]}"
do
  echo "Stopping $service..."
  sudo systemctl stop "$service"
done

# Create a larger swap file if needed (e.g., 4GB swap file)
echo "Checking and creating swapfile..."
if [ ! -f /swapfile ]; then
    sudo fallocate -l 4G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
fi

# Print current memory and swap usage
echo "Current memory and swap usage:"
free -h

# Turn off all swap processes
sudo swapoff -a

# Wait for the swap data to move to RAM (optional, may require more sophisticated monitoring)
sleep 30

# Turn swap back on
sudo swapon -a

# Show the status of swap after re-enabling
swapon --show

# Confirm memory status
free -m
