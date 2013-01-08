git st & wait
git co master & wait
echo 'push to master'
git push h & wait
git co worker & wait
git merge master & wait
echo 'push to workers'
git push hw0 worker:master & git push hw1 worker:master & git push hw2 worker:master & wait
exit