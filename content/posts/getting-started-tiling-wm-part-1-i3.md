+++
title = "Getting Started with Tiling WM [Part 1] - I3"
date = 2020-05-22T17:10:04+07:00
tags = ["tiling-wm", "linux", "tech", "i3"]
readingTime = true  # show reading time after article date
comments = true
draft = false
+++

{{< hint info >}}
**Disclaimer**

I love customizing desktop. I make changes in my desktop everyday, make it look eye candy. My colleagues ask me how to make their desktop look like mine. But there are many steps and things to learn and follow, I know because I've gone throught it. Therefore I decide to write this getting-started guide to give people a shortest path to Fancy world.
{{< /hint >}}

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

{{<mermaid>}}
graph TD;
A[Desktop Environment] --> B[Window Manager];
B --> C[X Windows];
{{</mermaid>}}

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

- [i3wm](https://i3wm.org) is a tiling window manager designed for [X11](https://en.wikipedia.org/wiki/X_Window_System).
- It supports tiling, stacking, and tabbing layouts, which it handles dynamically.
- Configuration is achieved via plain text file.
- Keyboard navigation: Hall full control with keyboard navigation.
- Minimalistic: no window decorations or nonsense icons floating around. But you can fully customize it.
- Window management: is left to the user. Windows are held inside containers, which can be split veritically or horizontally. They can also optionally be resized. There are also options for stacking the windows, as well as tabbing them.
- Floating pop-up windows.
- Want more, check [this](https://i3wm.org/docs/userguide.html).

## 3. Minimal Ubuntu I3 setup

### 3.1. Ubuntu Server

- Download the [installer](https://ubuntu.com/download/server) and install Ubuntu server by walking through installer. If you're completely new to it, you can follow [official documentation](https://ubuntu.com/server/docs/installation).
- The version `20.04.2`.

### 3.2. Desktop

- We'll need a display server so let's install X Window System ([Xorg](https://wiki.archlinux.org/index.php/Xorg))

```bash
sudo apt install xinit
# The configuration files are stored in /etc/X11/xinit
# You can override it by creating and modifying ~/.xinitrc
```

### 3.3. Terminal emulator

- We need to install a terminal emulator to use a terminal in a GUI environment.
- My choice is [tilix](https://github.com/gnunn1/tilix).

```bash
sudo apt install tilix
```

### 3.4. Tiling Window Manager - I3

- You can install i3 from [Ubuntu repository](https://packages.ubuntu.com/search?keywords=i3).

```bash
sudo apt install i3
```

- Or build from source, I have a personal fork - [Rounded i3-gaps](https://github.com/ntk148v/i3).

```bash
# Dependencies
sudo apt install git libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
    libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
    libstartup-notification0-dev libxcb-randr0-dev \
    libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
    libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
    autoconf libxcb-xrm0 libxcb-xrm-dev automake \
    ninja-build meson libxcb-shape0-dev build-essential -y
    git clone https://github.com/ntk148v/i3.git
cd i3/
# Compile
mkdir -p build && cd build
meson ..
ninja
sudo ninja install
```

- Start `X`. A prompt will be shown to create a config file, just use the default key.

```bash
startx
```

## 4. References

1. https://www.lifewire.com/window-manager-vs-the-desktop-environment-in-linux-4588338
2. https://en.wikipedia.org/wiki/X_window_manager
3. https://i3wm.org/docs
