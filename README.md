# Terraform Cloud Symlink Bug Demonstration

This repository is a demonstration of an apparent bug in Terraform Cloud, where once symlinks matching certain conditions are added to the repo, speculative plans started using the CLI will fail when trying to setup the initial filesystem state on the Terraform Cloud agent.
The speculative plans will fail with an error message containing the following:
```
failed unpacking configuration version: illegal slug error: invalid filename, traversal with ".." outside of current directory
```

Only speculative plans started from local CLI will be affected; regular plans and plan & apply runs will not be affected.

Removing the symlink from the repository's current branches will not resolve the issue, and workspaces created after the symlinks are all removed _and_ that use an entirely different path as their working directory will _still_ fail with the same error message.
As such, this bug effectively disables speculative plans for any & all workspaces that use the repository in question.

## Steps to Reproduce

Assuming that you already have a git repository hosted somewhere that Terraform Cloud can access it, and that you have that repo cloned locally, then you can reproduce this bug by following these steps:
  * create a subdirectory in the repository and add a terraform module within it;
  * commit the subdirectory to the repository and push the changes up to the remote;
  * create a Terraform Cloud workspace that uses this subdirectory of the repository as its working directory;
  * verify that plan-only and plan & apply runs in the workspace work as expected;
  * configure terraform's backend to use the Terraform Cloud workspace;
  * verify that speculative plan runs triggered using local Terraform CLI work as expected;
  * create a symlink within the subdirectory that resolves to a file within the git repository but outside of the subdirectory, e.g. to a file within the root directory of the repository.
  * commit the symlink to the repository and push the changes up to the remote.

After all the setup steps have been completed, you will observe the following:
  * speculative plans triggered using the local Terraform CLI will fail with the error message mentioned above;
  * regular plans and plan & apply runs will work as expected (regardless of whether they are triggered by a VCS event or manually via the UI).

These properties will hold true for all workspaces that use the repository in question, even if their working directory _never_ contained a symlink matching the conditions above.
Removing the symlinks from all of the repository's branches will not resolve the issue.

It's possible[^1] that using `git filter-branch` to completely remove the symlinks from all the commits in the repository's history (not just those pointed to by the branches) will resolve the issue, but this is untested.

[^1]: and in my opinion likely
