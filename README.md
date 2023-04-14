# Factorio watchdog for release changes

Build trigger for my version of the factorio image on new releases

## Enviroment variables

This Factorio Docker Watchdog must be configured via environment variables.
Below you find a list with all required and optional variables.

### Required

| Name | Purpose |
|-|-|
| `GIT_ORG` | The git organization on github containing the repository |
| `GIT_REPO` | The repository in the github org to commit the versions to |
| `GIT_BRANCH` | The branch in the github repository to commit the versions to |
| `GIT_SSHFILE` | The path the ssh identity file to communicate with GitHub |

### Optional

| Name | Purpose |
|-|-|
| `FORCE` | Force an image rebuild |
