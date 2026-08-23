# Understanding The Git Workflow: Working Directory, Staging, Commit and Push

Imagine working on a project for several weeks. You make hundreds of changes across dozens of files. Then your computer crashes. Which version of your project was working yesterday? What did you change? Which changes did your colleague make? And how do you combine everyone's work without overwriting each other's changes?

This is where Git comes in.

## What is Git?
Git is an open-source system that enables users to manage their projects, from a single file to large projects. Git is basically a version control system. It provides the necessary resource to help one manage files in the local machine, track the files that have been changed, attach a pointer which marks files which were changed, who did it, and when, and to make it redundant, these files can be pushed into a remote shareable project called repository in *Github*.

Git also has something very key that is called *branches*. A branch is basically an isolated area of your project where you can work on a copy of the main project without making changes to the main work. Once you are done working on your branch, Git makes it possible to merge all the changes to the main branch.

For this article, I will cover these concepts, guiding one on the step by step process of how to do all this. This article assumes that one has Git installed and configured, and has a Github account. We shall also assume that one has a text editor installed, or is conversant with commands in the terminal. We shall cover these concepts in another article.

## Creating a Project On Your Machine
To start, we need to create a folder where we shall be working on our project. On your machine, you can use the good old right click and select New Folder, or, if in terminal, use the command *mkdir <folder name>* as follows:
`mkdir new_project`
This creates a folder called new_project

We shall then open our folder in the terminal, so that we can do the following:
1. Initialize Git
2. Create a file
3. Stage it
4. Commit it
5. Link local repository to remote repository
6. Push to Github account

### Initializing Git
At this point, we have our folder. So to open it in terminal, we can open our favorite terminal, or simply open our folder in our text editor. Once this is done, we can now initialize Git using this command:
`git init`
This command simply initializes a local Git repository in your project folder. You can confirm this by confirming that we have a *.git* folder inside our main folder. During initialization, you will note that you will be in a default branch called *main* or *master*. To confirm this, simply run the command:
*git branch*

### Creating a File
In our terminal, we can be able to create a file using the command:
`touch <filename>`
This will create a file inside our main folder. For this case let's call our file *main.py* At this point, you can run certain commands like:
`git status`
which allows us to see files that we have not started to track, files we have modified, files we have staged, files we have modified after staging, and so on. Files that are not tracked means that they will not be pushed to Github once we get to that.

We can now write a simple sentence on our terminal using a command called *echo* as follows:
`echo "print('This is a new file')" > main.py`
The echo command prints text, but when used together with the greater than sign (*>*) and the file name, will write the text into the file specified. At this point, we are on our working directory. Git does not know what it needs to stage. So how do we stage files?

### Staging a File(s)
Staging a file basically tells Git that we want to commit our changes that we have made so far. Moreover, it will also stage any new, modified, or deleted paths too. We can do this by basically staging everything or staging a single file, or staging specific files.
To do so, we can do the following
```
git add . // Stages everything that is yet to be tracked.
git add <filename> // Stages a single file.
git add <filename_1> <filename_2> ... // Stages specific files.
```
At this point, we are in the staging area. We know what we want to commit/update in our remote repository. In the next stage, we will commit the staged files.

### Committing a File(s)
We now commit our changes so Git records a snapshot of what we have done. This is important, as git uses these commits to help the user go back to a certain point in your branch.
To create a commit, We use this command:
`git commit -m "Add main Python file"`
The commit message should be in double quotes. Once this is done, we need to to point our local folder to our remote repository. If not created, you will need to create a repository.

*Note*: At this stage of our workflow, we are now in the local repository. We have a full committed history of what we have done, but it is local. We are yet to update on our remote repository.

### Link Our Local Repository to Remote Repository
We will first create a repository on Github. To do this, simply navigate to your Github account on your browser and click *New Repository* button on your Repositories page. You will then provide a name for your repository, provide a description, and you can later have it as Private or Public of other users to access it. Once that is done, you can click the *Create repository* button. For this case, our repository is called *health_records_analysis*

This has now created our repository. This repository contains a link which we can share to other users, and this is the link that we need to link our local folder with the newly created repository. To do this, simply access it once you scroll down in the page you are in the simply copy the http link. This is what we shall use. The link usually looks like this *http://github.com/<github_username>/<repository_name>*

We will then go back to the terminal we were in and enter the following command
`git remote add origin <repository_link>`

Great! We can now conduct the final step, *pushing*

### Pushing Our Changes To Github
To push to Github, we only need a single command:
`git push -u origin main`

*git push* will send our local commit to the remote repository
*origin* basically is the name of our remote repository
*main* is the branch we are pushing to
*-u* will establish origin/main as the remote branch.

You can confirm this by going back to your Github account and refresh. You will see the file we just pushed, and the commit message. As you may have guessed, this is the remote repository. This is now where we have pushed our changes, and all this can be shared to relevant users.

## Closing
Learning Git is important as a person working with any kind of projects that require proper tracking, can be collaborative, and even makes your work neat. It is a skill that is important, and one that I, personally has had fun learning, and look forward to sharing my progress.