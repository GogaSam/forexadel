git clone https://github.com/GogaSam/forexadel.git
cd forexadel
git remote set-url origin https://github.com/GogaSam/forexadel.git
git status
git checkout -b master
mkdir Task1
cd Task1
touch README.md
cd ..
git add .
git commit -m "first commit"
git push origin master
git checkout -b dev
touch test.txt
echo "this is a test file" >> test.txt
git checkout -b GogaSam-new_feature
echo "create-readme" > README.md
git status
touch .gitignore
echo "./.*" > .gitignore
git add .
git commit -m "second push"
git checkout master
git push origin master
git checkout dev
git push --set-upstream origin dev
git checkout GogaSam-new_feature
git push --set-upstream origin GogaSam-new_feature
git checkout GogaSam-new_feature
echo "  Some changes" >> README.md
git add .
git commit -m "update README"
git log --oneline
git revert %COMMIT_ID
git log
git checkout master
git log > log.txt
git add .
git commit -m "third push"
git push origin --delete GogaSam-new_feature
git branch -D GogaSam-new_feature
git checkout dev
git pull origin
git add .
git commit -m "added git_commands.md"
git push origin dev
