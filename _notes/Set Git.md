---
title: How I Set Up the Git Repo for My Inflatable Project
category:
---
When I started using the [MeshFEM/Inflatables](https://github.com/jpanetta/Inflatables) simulator for my soft robotics research, I made the mistake of cloning the repository directly from the original author without first forking it on GitHub. That gave me a local copy to explore and run, but it also meant I couldn’t use Git to track my own versions or push experimental changes until I reconfigured the project.
This post walks through how I fixed that: first by customizing my terminal to show the active Git branch, then pointing the repository to my own fork, setting up Git authentication using a personal access token (PAT), and finally committing and pushing my changes.

## Step 1: I Updated `.bashrc` to Show the Git Branch in My Prompt

> [!info] **What is `.bashrc`?**
> The `.bashrc` file is a user-level configuration script executed whenever a new interactive Bash terminal session begins. It is typically used to customize the shell environment, define aliases, and adjust the command prompt.

I opened the `.bashrc` file using:

```bash
gedit ~/.bashrc
```

The following snippet is what I actually added to the file:

```bash
# Function to parse the current Git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Custom prompt showing user@host:path (branch)
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[31m\]$(parse_git_branch)\[\033[00m\]\$ '

```

After editing and saving the file, I applied the changes with:

```bash
source ~/.bashrc
```

Now, when I’m inside a Git repo, my terminal prompt looks like this:
```bash
`adru@ubuntu-inflatables:~/Inflatables (master)$`
```

## Step 2: Changed the Remote Repository 

To understand the state of the repository, I first reviewed its recent commit history:

```bash
git log
```

This showed the last few commits made by the original project maintainer 
Then I verified where my local Git repository was pointing:
```bash
git remote -v
```

As expected, it showed the `origin` was still set to the upstream repository:

```bash
origin  https://github.com/jpanetta/Inflatables.git (fetch) 
origin  https://github.com/jpanetta/Inflatables.git (push)
```
Since I had already forked the repository on GitHub, I updated the remote to point to my fork instead:
```bash
git remote set-url origin https://github.com/adrulpz/Inflatables.git
```

Then I verified that the change was successful:

```bash
git remote -v
```

The output confirmed that my local repo now pushes and pulls from my own fork:

```bash
origin  https://github.com/adrulpz/Inflatables.git (fetch) 
origin  https://github.com/adrulpz/Inflatables.git (push)
```

I staged all new and modified files:

```bash
git add --all
```

I confirmed that everything was staged and ready to commit:

```bash
git status
```

## Step 3: Authenticating with GitHub Using a Personal Access Token (PAT)

After updating the remote to my fork, I attempted to push my local changes to GitHub:

```bash
`git push origin master`
```
Git prompted me for authentication:
```bash
`Username for 'https://github.com': adrulpz Password for 'https://github.com':`
```

🛑 **Password Rejected**
GitHub has deprecated password-based authentication over HTTPS, so even though I entered my GitHub password, the push failed. Instead, GitHub now requires the use of **Personal Access Tokens (PATs)** for secure access.

To resolve this, I created a token via the GitHub web interface:
1. Go to [https://github.com/settings/tokens](https://github.com/settings/tokens)    
2. Click **"Generate new token (classic)"**    
3. Select the necessary scopes (at minimum, `repo`)    
4. Generate and copy it — it only shows **once**   
## Step 4: Add and Commit Changes

```bash 
git add --all 
git commit -m "first commit."
git push origin master
```

Let’s hope this is a good start toward improving my workflow and version control practices 😄

