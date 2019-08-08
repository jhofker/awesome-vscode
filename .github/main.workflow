workflow "Deploy Extension" {
  on = "push"
  resolves = ["Publish"]
}

# Install npm dependencies
# Note: --unsafe-perm is used as GitHub Actions does not run `npm run post-install` without it for some reason.
action "npm install" {
  uses = "actions/npm@33871a7"
  args = ["install", "--unsafe-perm"]
}

# Check for master branch
action "Master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
  needs = ["npm install"]
}

# publish extension
action "Publish" {
  uses = "lannonbr/vsce-action@master"
  args = "publish -p $VSCE_TOKEN"
  needs = ["Master"]
  secrets = ["VSCE_TOKEN"]
}
