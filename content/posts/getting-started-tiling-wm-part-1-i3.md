+++
title = "Getting Started with Tiling Window Manager [Part 1]: I3"
date = 2020-05-22T17:10:04+07:00
lastmod = 2020-05-22T17:10:04+07:00
tags = ["tiling-wm", "i3"]
categories = []
imgs = []
cover = ""  # image show on top
readingTime = true  # show reading time after article date
toc = true
comments = false
justify = false  # text-align: justify;
single = false  # display as a single page, hide navigation on bottom, like as about page.
license = ""  # CC License
draft = true
+++

> **Disclaimer**: I love customizing desktop. I make changes in my desktop everyday, make it look eye candy. My colleagues ask me how to make their desktop look like mine. But there are many steps and things to learn and follow, I know because I've gone throught it. Therefore I decide to write this getting-started guide to give people a shortest path to Fancy world.

## 1. Overview Window Manager

First of all, you have to know the basic concepts.

### 1.1. Desktop Environment vs. Window Manager

We'll begin by showing how the Linux graphical desktop is layered. There are basically 3 layers that can be included in the Linux desktop:

- **X Window**: All GUIs require an X Window System layer, which draws graphic elements on the display. Without the X server, neither a WM nor a DE could create images on a Linux display. X also creates a framework for moving windows and performing tasks using a mouse and keyboard.
- **Window manager**:
  - A WM controls the placement and appearance of screen elements. Popular WMs: i3, awesome, dwm...
  - Requires configuration to get what you want.
  - Tends to be flexible and highly customizable.
  - Customizes most aspects of a Linux experience.
  - For Nerd: not user-friendly out of the box, need to edit configuration files...
- **Desktop environment**:
  - A DE requires both X and a WM. It also adds the deeper and seemless integration with applications, panels, system menus, status applets, drag-and-drop functionality,... The most popular DEs: KDE Plasma, GNOME, Pantheon, Cinnamon,... Sounds familiar, right?
  - Excellent default configurations.
  - May not be particularly customizable.
  - Gret if you don't want to customize everything.

```
+-------------------------------------+
|                                     |
|                                     |
|         Desktop Environment         |
|                                     |
|                                     |
+-----------------+-------------------+
                  |
                  |
                  |
+-----------------v-------------------+
|                                     |
|                                     |
|           Window Manager            |
|                                     |
|                                     |
+-----------------+-------------------+
                  |
                  |
+-----------------v--------------------+
|                                      |
|                                      |
|                                      |
|             X Windows                |
|                                      |
|                                      |
+--------------------------------------+
```

### 1.2. Types of Window Manager

- **Stack window manager**:
  - A stack window manager renders the window one-by-one onto the screen at specific co-orinates. If one window's area overlaps another, then the window "on top" overwites part of the other's visible appearance. This results in the appearance familiar to many users in which windows act a little like pieces of paper on a desktop, which can be moved around and allowed to overlap.
  - Openbox, Fluxbox, Enlightenment...
- **Tiling window manager**:
  - A window manager with an organization of the screen into mutually non-overlapping frames (hence the name tiling), as opposed to the traditional approach of coordinate-based stacking of objects (windows) that tries to emulate the desk paradigm.
  - Awesome,**i3** (here we go), dwm, bspwm...
- **Compositing window manager**:
  - A compositing window manager may appear to the user similar to a stacking window manager. However, the individual windows are first renders in individual buffers, and then theirs images are composited onto the screen buffer; this two-step process means that visual effects (such as shadows, translucency) can be applied.
  - Mutter (GNOME), Xfwm (XFCE), Compiz (Unity), KWin (KDE)

## 2. Overview I3

## 3. I3 Basic Use & Configuration

## 4. References

1. https://www.lifewire.com/window-manager-vs-the-desktop-environment-in-linux-4588338
2. https://en.wikipedia.org/wiki/X_window_manager
