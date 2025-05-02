sudo amazon-linux-extras install epel -y ;
sudo yum install stress -y ;
stress --cpu 20 --vm 2 --timeout 10000s& ;