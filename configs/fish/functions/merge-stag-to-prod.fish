cd /home/walden/code/deploy-trefoil
git checkout stag
git fetch origin
git pull origin stag
git checkout prod
git merge -S stag --commit
