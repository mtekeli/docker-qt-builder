workflow "New workflow" {
  on = "push"
  resolves = ["GitHub Action for Google Cloud SDK auth"]
}

action "GitHub Action for Google Cloud SDK auth" {
  uses = "actions/gcloud/auth@ba93088eb19c4a04638102a838312bb32de0b052"
}
