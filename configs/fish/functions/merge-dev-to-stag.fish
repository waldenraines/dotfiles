cd /home/walden/code/deploy-trefoil
git checkout dev
git fetch origin
git pull origin dev
git checkout stag
git merge -S dev --commit
