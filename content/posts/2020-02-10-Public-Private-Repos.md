---
draft: false
title: "Private mirror of public repos on Github"
author: "Tarek Allam Jr"
date: 2020-02-10
category: tutorials
tags: [reproducibility, programming]
<!-- cover: img/posts/2020-02-10-Scala-Packaging/docker-and-scala.png -->
---

<!--more-->

# Public and Private Repo's on Github

How to have an open public repository as well as a mirrored private repository on Github

These steps were inspired from this guide of '[Mirroring a
repository'](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/duplicating-a-repository#mirroring-a-repository) on Github documentation

1. Create a bare clone of the repository.

```bash
14:05:04 ✔ ~/Github/origin  :: git clone --bare git@github.com:tallamjr/public.git private
Cloning into bare repository 'private'...
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 5 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (5/5), 5.47 KiB | 5.47 MiB/s, done.
```

2. Mirror-push to the new repository.

```bash
14:05:45 ✔ ~/Github/origin  :: cd private/
14:05:48 ✔ ~/Github/origin/private (BARE:master) :: git push --mirror git@github.com:tallamjr/private.git
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 4 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (5/5), 5.47 KiB | 5.47 MiB/s, done.
Total 5 (delta 0), reused 5 (delta 0)
To github.com:tallamjr/private.git
 * [new branch]      master -> master
```

3. Remove the temporary local repository you created in step 1.

```bash
14:06:13 ✔ ~/Github/origin/private (BARE:master) :: cd ../
14:06:24 ✔ ~/Github/origin  :: rm -rf private/
```

4. Clone newly created 'private' mirrored repository

```bash
14:06:30 ✔ ~/Github/origin  :: git clone git@github.com:tallamjr/private.git
Cloning into 'private'...
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (4/4), done.
Receiving objects: 100% (5/5), 5.47 KiB | 5.47 MiB/s, done.
remote: Total 5 (delta 0), reused 5 (delta 0), pack-reused 0
14:07:04 ✔ ~/Github/origin  :: cd private/
14:07:06 ✔ ~/Github/origin/private (master) :: git remote -v
origin  git@github.com:tallamjr/private.git (fetch)
origin  git@github.com:tallamjr/private.git (push)
```

5. Allow private repository to 'see' public repository by adding public repository to remote upstream

```bash
14:08:04 ✘ ~/Github/origin/private (master) :: git remote add upstream git@github.com:tallamjr/public.git
14:09:22 ✔ ~/Github/origin/private (master) :: git remote -v
origin  git@github.com:tallamjr/private.git (fetch)
origin  git@github.com:tallamjr/private.git (push)
upstream        git@github.com:tallamjr/public.git (fetch)
upstream        git@github.com:tallamjr/public.git (push)
```

*NOTE* Completing steps 1..5 should give you everything you need. Steps 6..10 go further with some
sanity checks to ensure everything has indeed worked, having said that, step 9 is recommended.

6. Clone public repository alongside private to test set-up by editing the public README.md (OPTIONAL)

```bash
14:10:25 ✔ ~/Github/origin/private (master) :: cd ../
14:10:41 ✔ ~/Github/origin  :: git clone git@github.com:tallamjr/public.git
Cloning into 'public'...
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 5 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (5/5), 5.47 KiB | 5.47 MiB/s, done.
14:10:50 ✔ ~/Github/origin  :: cd public/
14:10:52 ✔ ~/Github/origin/public (master) :: vim README.md
14:18:15 ✔ ~/Github/origin/public (master) :: git status
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
```

7. Add, commit and push recent changes to the public README.md (OPTIONAL)

```bash
14:19:13 ✔ ~/Github/origin/public (master) :: git add README.md
14:19:42 ✔ ~/Github/origin/public (master) :: git commit
[master 881d666] Updating README with instructions
 1 file changed, 82 insertions(+), 1 deletion(-)
 rewrite README.md (100%)
14:20:36 ✔ ~/Github/origin/public (master) :: git status
On branch master
Your branch is ahead of 'origin/master' by 1 commit.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean
14:20:37 ✔ ~/Github/origin/public (master) :: git push
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 4 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 1.04 KiB | 1.04 MiB/s, done.
Total 3 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To github.com:tallamjr/public.git
   ba0bb9d..881d666  master -> master
```

8. Go into the private repository and check 'status' (OPTIONAL). Notice with `git log` we only see a
   single commit from when the private repository was instantiated.

```bash
14:22:41 ✔ ~/Github/origin/public (master) :: cd ../private/
14:22:45 ✔ ~/Github/origin/private (master) :: git status
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
14:22:51 ✔ ~/Github/origin/private (master) :: git log
commit ba0bb9d112de731e246741436f7b4160419b9c4a (HEAD -> master, origin/master, origin/HEAD)
Author: Tarek <tallamjr@users.noreply.github.com>
Date:   Tue Feb 25 14:03:20 2020 +0000

    Initial commit
14:22:54 ✔ ~/Github/origin/private (master) ::
```

9. Bring in changes made from public repository into private repository i.e. sync private with the
   public repository (RECOMMENDED)

*NOTE* `git update` is an alias for:

```bash
git pull --rebase upstream master --ff-only && git fetch --all
```

```bash
14:24:00 ✔ ~/Github/origin/private (master) :: git update
remote: Enumerating objects: 8, done.
remote: Counting objects: 100% (8/8), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 6 (delta 3), reused 5 (delta 2), pack-reused 0
Unpacking objects: 100% (6/6), 1.87 KiB | 319.00 KiB/s, done.
From github.com:tallamjr/public
 * branch            master     -> FETCH_HEAD
 * [new branch]      master     -> upstream/master
Updating ba0bb9d..372ebcf
Fast-forward
 README.md | 118 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 117 insertions(+), 1 deletion(-)
Current branch master is up to date.
Fetching origin
Fetching upstream
14:24:08 ✔ ~/Github/origin/private (master) :: git log
commit 372ebcf4d7aa0377d085bd47c0ccf478201851ef (HEAD -> master, upstream/master)
Author: Tarek Allam <t.allam.jr@gmail.com>
Date:   Tue Feb 25 14:21:54 2020 +0000

    [FIXUP]

    Adding further instructions
            modified:   README.md

commit 881d666d86b912e4e687069bf422f4b31dcd9965
Author: Tarek Allam <t.allam.jr@gmail.com>
Date:   Tue Feb 25 14:19:44 2020 +0000

    Updating README with instructions

    How to mirror a public repo, privately

            modified:   README.md

commit ba0bb9d112de731e246741436f7b4160419b9c4a (origin/master, origin/HEAD)
Author: Tarek <tallamjr@users.noreply.github.com>
Date:   Tue Feb 25 14:03:20 2020 +0000

    Initial commit
14:24:12 ✔ ~/Github/origin/private (master) :: git push
Enumerating objects: 8, done.
Counting objects: 100% (8/8), done.
Delta compression using up to 4 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (6/6), 1.72 KiB | 440.00 KiB/s, done.
Total 6 (delta 3), reused 0 (delta 0)
remote: Resolving deltas: 100% (3/3), completed with 1 local object.
To github.com:tallamjr/private.git
   ba0bb9d..372ebcf  master -> master
```

Above we can see that we now have the 'extra' commits that were made in the public repository now in
the private repository too.

10. This point is more a discussion about issues and branching models (OPTIONAL)

It is best practise to relate all branches to a
specific issue, i.e. `issue/3/some-issue` and also with features,
`features/45/some-awesome-feature` which can further evolves into
`feature/45/issue/51/an-issue-with-awesome-feature`

When one has the set up described above, you would mostly likely have issues that are specific
for the public and potentially issues that are specific for the private (usually it would be
the case when _forking_, the created issue branch will _always_ relate to the upstream version as
this is the 'main' repository. However, in the case with public and private, there may be a case
where issues in the private repository are indeed 'private' and would be best kept 'in-house'.
For this situation, one can have a system like so:

public -->

```bash
- issue/<number>/short-token-description
- feature/<number>/short-token-description
- feature/<number>/issue/<number>/short-token-description
```

private -->

```bash
- pv/issue/<number>/short-token-description
- pv/feature/<number>/short-token-description
- pv/feature/<number>/issue/<number>/short-token-description
```

* Finally we can rebase a commit on the public repository and ensure this is reflected in the
    private repository. Again, this is just a system sanity check.


```bash
14:50:51 ✔ ~/Github/origin/public (master) :: git rebase -i HEAD~3
```

```bash
pick 881d666 Updating README with instructions
f 372ebcf [FIXUP]
pick 848079d Update with final set of instructions

# Rebase ba0bb9d..848079d onto ba0bb9d (3 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup <commit> = like "squash", but discard this commit's log message
# x, exec <command> = run command (the rest of the line) using shell
# b, break = stop here (continue rebase later with 'git rebase --continue')
# d, drop <commit> = remove commit
# l, label <label> = label current HEAD with a name
# t, reset <label> = reset HEAD to a label
# m, merge [-C <commit> | -c <commit>] <label> [# <oneline>]
# .       create a merge commit using the original merge commit's
# .       message (or the oneline, if no original merge commit was
# .       specified). Use -c <commit> to reword the commit message.
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out

```

```bash
Successfully rebased and updated refs/heads/master.
14:50:59 ✔ ~/Github/origin/public (master) :: git log --oneline
d1293c2 (HEAD -> master) Update with final set of instructions
b727c18 Updating README with instructions
ba0bb9d Initial commit
14:51:03 ✔ ~/Github/origin/public (master) :: git push -f
Enumerating objects: 8, done.
Counting objects: 100% (8/8), done.
Delta compression using up to 4 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (6/6), 3.33 KiB | 3.33 MiB/s, done.
Total 6 (delta 3), reused 0 (delta 0)
remote: Resolving deltas: 100% (3/3), completed with 1 local object.
To github.com:tallamjr/public.git
 + 848079d...d1293c2 master -> master (forced update)
14:51:12 ✔ ~/Github/origin/public (master) :: cd ../private/
14:51:15 ✔ ~/Github/origin/private (master) :: git update
remote: Enumerating objects: 8, done.
remote: Counting objects: 100% (8/8), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 6 (delta 3), reused 6 (delta 3), pack-reused 0
Unpacking objects: 100% (6/6), 3.31 KiB | 483.00 KiB/s, done.
From github.com:tallamjr/public
 * branch            master     -> FETCH_HEAD
 + 848079d...d1293c2 master     -> upstream/master  (forced update)
First, rewinding head to replay your work on top of it...
Fetching origin
Fetching upstream
14:51:21 ✔ ~/Github/origin/private (master) :: git log --oneline
d1293c2 (HEAD -> master, upstream/master) Update with final set of instructions
b727c18 Updating README with instructions
ba0bb9d Initial commit
14:51:23 ✔ ~/Github/origin/private (master) :: git push -f
Enumerating objects: 8, done.
Counting objects: 100% (8/8), done.
Delta compression using up to 4 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (6/6), 3.33 KiB | 1.11 MiB/s, done.
Total 6 (delta 3), reused 0 (delta 0)
remote: Resolving deltas: 100% (3/3), completed with 1 local object.
To github.com:tallamjr/private.git
 + 848079d...d1293c2 master -> master (forced update)
14:51:30 ✔ ~/Github/origin/private (master) ::
```
