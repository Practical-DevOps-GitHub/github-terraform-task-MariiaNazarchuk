# Define provider for GitHub
provider "github" {
  token = var.PAT
}

# Define variables
variable "PAT" {
  description = "GitHub personal access token"
}

# Add softservedata as a collaborator
resource "github_repository_collaborator" "softservedata" {
  repository = "github-terraform-task-MariiaNazarchuk"
  username   = "softservedata"
  permission = "push" # or whatever permission level you prefer
}

# Create develop branch as default
resource "github_branch" "develop" {
  repository = "github-terraform-task-MariiaNazarchuk"
  branch     = "develop"
  default    = true
}

# Protect main and develop branches
resource "github_branch_protection" "main" {
  repository        = "github-terraform-task-MariiaNazarchuk"
  branch            = "main"
  enforce_admins    = true
  require_pull_request_reviews {
    dismiss_stale_reviews         = true
    require_code_owner_reviews    = true
    required_approving_review_count = 1
  }
}

resource "github_branch_protection" "develop" {
  repository        = "github-terraform-task-MariiaNazarchuk"
  branch            = "develop"
  enforce_admins    = true
  require_pull_request_reviews {
    dismiss_stale_reviews         = true
    required_approving_review_count = 2
  }
}
# Create CODEOWNERS file
resource "github_repository_file" "codeowners_file" {
  repository = "github-terraform-task-MariiaNazarchuk"
  file_path  = ".github/CODEOWNERS"
  content    = <<-EOT
    # Automatically generated CODEOWNERS file
    * @softservedata
  EOT
}

# Add pull request template
resource "github_repository_file" "pull_request_template" {
  repository = "github-terraform-task-MariiaNazarchuk"
  file_path  = ".github/pull_request_template.md"
  content    = <<-EOT
    # Pull Request

    ## Describe your changes

    ## Issue ticket number and link

    ## Checklist before requesting a review
    - [ ] I have performed a self-review of my code
    - [ ] If it is a core feature, I have added thorough tests
    - [ ] Do we need to implement analytics?
    - [ ] Will this be part of a product update? If yes, please write one phrase about this update
  EOT
}

# Add deploy key
resource "github_repository_deploy_key" "deploy_key" {
  repository      = "github-terraform-task-MariiaNazarchuk"
  title           = "DEPLOY_KEY"
  key             = var.deploy_key
  read_only       = false
}
