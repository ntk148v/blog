---
title: "Blog Guideline"
date: 2019-08-22T14:40:59+07:00
comment: true
authors:
    - kiennt
showDate: true
tags: ["blog", "tech"]
---

In the beginning, I supposed that I'm the only one who write-up thing in this blog. But now thing was change, this blog might have multiple [bloggers](https://ntk148v.github.io/blog/authors/). So it needs a guideline to describe how to contribute.

![](https://sayingimages.com/wp-content/uploads/welcome-to-the-team-meme.jpg)

# 1. How to submit a new content

-   [Here](https://github.com/ntk148v/blog) is the source repo. Fork it & start writing.
-   Create a pull request to submit your content.
-   Make sure to create your author page.

# 2. Create an author page

-   Create a directory under [content/authors](https://github.com/ntk148v/blog/tree/master/content/authors), name it as your desire nickname. For example, your name is `amazingblogger`.

-   Directory structure.

```bash
~/Documents/blog master $? via ⬢ v8.10.0 took 6s tree content/authors    
content/authors
├── donghm
│   ├── avatar.jpg
│   └── index.md
├── _index.md
└── kiennt
    ├── avatar.jpg
    └── index.md
└── amazingblogger # Here
    ├── avatar.jpg
    └── index.md
```

-   Write about yourself in `index.md`.

```yaml
---
name: "Amazing Blogger"
contact:
    twitter: "@blogger"
    facebook: "blogger"
    github: "blogger"
    email: "blogger@gmail.com"
website: "https://blogger.io/"
---

Your amazing personal page here
```

-   Don't forget to place your avatar in directory. The picture format should be `jpg` or `png`, no name restriction.

# 3. Write a post

-   Very similar with author page, just place your post under [content/posts](https://github.com/ntk148v/blog/tree/master/content/posts).

```bash
$ hugo new content/posts/a-new-post.md -t sam
```

-   A sample post.

```yaml
---
title: "Blog Guideline"
date: 2019-08-22T14:40:59+07:00
comment: true
authors:
    - kiennt
showDate: true
tags: ["blog", "tech"]
---
```

-   Multiple authors feature is supported.
-   You can disable or enable comment section with `comment` option. You might want to take look at [how I create comment section](https://ntk148v.github.io/blog/posts/lets-comment/).
-   Don't forget to add a tag.

# 4. Create a photo/art gallery

Hmm, this is my secret corner, so... Might be in future?

# 5. Scripts

You can notice that some shell scripts are placed in repository. You can only use these if you're the repository collaborator. Just send me a request! :smile:

## 5.1. Lazy pull

Just a script to init and update submodule, do git pull (both master and gh-pages branchs).

## 5.2. Publish to github page

I deploy the blog from `gh-pages` branch. You can also tell Github pages to treat your `master` branch as the published site or point to a separate `gh-pages` branch. The latter approach is a bit more complex but has some advantages:

-   It keeps your source and generated website in different branches and therefore maintains version control history for both.
-   Unlike the preceding docs/ option, it uses the default public folder.

The [publish_to_ghpages.sh](https://github.com/ntk148v/blog/blob/master/publish_to_ghpages.sh) automates the set up steps.
