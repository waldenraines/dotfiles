cd /home/walden/code/deploy-trefoil
git checkout master
git fetch origin
git pull origin master
git checkout dev
git merge -S master --commit
