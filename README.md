# SatellaOS

A Debian-based Linux distribution focused on modern design, low resource usage, and user freedom.

---

## 🚀 Why SatellaOS?

### 🏗️ Foundation

SatellaOS is built on top of a clean Debian Netinst installation. Its goal is to provide the reliability of Debian while remaining as lightweight and efficient as possible.

### 📦 Package Count

A minimal installation comes with approximately **900 DPKG packages**.

The final package count may increase depending on the components and applications selected during installation.

### 🎨 User Interface

Unlike many XFCE-based distributions, SatellaOS aims to push XFCE beyond its traditional appearance by providing a modern desktop experience while maintaining low CPU and memory usage.

### 🧹 Minimal Bloatware

SatellaOS is designed to include as little unnecessary software as possible.

Users are not forced to use a specific:

* Web browser
* Media player
* Text viewer
* Office suite

The choice belongs to the user.

### 🛠️ SatellaOS Ecosystem

SatellaOS includes its own growing ecosystem of tools.

The goal is to solve common user problems through simple and practical utilities.

For example:

* The graphical Deb Packaging Tool allows anyone to create their own `.deb` packages without manually writing package structures.
* Additional tools are continuously being developed and added to the ecosystem.

### 🌳 Tree Installer System

Unlike traditional Linux distributions, SatellaOS does not distribute ISO images.

Instead, it uses a **setup.sh** installation system.

This approach:

* Uses an existing Debian Netinst installation as its foundation.
* Downloads the latest packages directly from the internet.
* Eliminates the need for maintaining custom ISO images.
* Allows development efforts to focus on usability and features rather than ISO compilation.

The installation process is inspired by the idea of a tree growing from its roots, which is why it is called the **Tree Installer System**.

### ☁️ Cloud Release Model

SatellaOS tools are designed around an internet-connected workflow.

Instead of relying on outdated local scripts, the latest versions are downloaded when needed.

Benefits include:

* Faster bug fixes
* Faster feature deployment
* Always up-to-date tools

---

## ⚠️ Warnings

### 📱 Touchscreen Support

SatellaOS is not currently designed with touchscreen devices in mind.

Since touchscreen hardware is not available for testing, some functionality may not behave as expected.

### 🎮 Gaming

Linux gaming has improved significantly thanks to Proton and related technologies.

However:

* Some games may experience reduced performance.
* Some games may fail to launch.
* Hardware compatibility may vary.

Your experience will depend on your hardware, drivers, and the games you play.

### 🎨 Adobe Software Users

SatellaOS is a Linux distribution.

Most Adobe applications such as Photoshop, Premiere Pro, Illustrator, After Effects, and Lightroom are not officially available for Linux.

While some users attempt to run Adobe software through compatibility layers, functionality and stability are not guaranteed.

If you rely heavily on Adobe products, SatellaOS may not be the right operating system for your workflow.

Open-source Linux alternatives include:

* GIMP (Photoshop alternative)
* Krita (Digital painting and illustration)
* Inkscape (Illustrator alternative)
* Kdenlive (Video editing)
* Blender (3D creation and animation)
* Darktable (Lightroom alternative)

We recommend testing these alternatives before fully migrating from Windows.

## 🧪 Test System

SatellaOS has been tested on the following hardware:

**CPU:** Intel Pentium B970 (2 Cores / 2 Threads, 2.3 GHz)

**GPU:** NVIDIA GeForce GT 630M

* The proprietary NVIDIA 390.xx driver is no longer suitable for modern Linux kernels.
* Nouveau was used during testing.

**Memory:** 4 GB DDR3L 1333 MHz (2×2 GB)

**Storage:** 2012-era laptop hard drive

* Only 20 GB of disk space was allocated for the installation.

This hardware is considered extremely old by modern standards.

If SatellaOS performs acceptably on this system, newer hardware should provide a significantly better experience.

---

## 🖼️ Screenshots

<table>
<tr>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/screenshots/grub.png" width="220"/><br/><sub>GRUB</sub></td>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/screenshots/lightdm-gtk-greeter.png" width="220"/><br/><sub>LightDM GTK Greeter</sub></td>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/screenshots/main-screen.png" width="220"/><br/><sub>Main Screen</sub></td>
</tr>
<tr>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/screenshots/whisker-menu.png" width="220"/><br/><sub>Whisker Menu</sub></td>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/screenshots/htop.png" width="220"/><br/><sub>Htop</sub></td>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/screenshots/fastfetch.png" width="220"/><sub>Fastfetch</sub></td>
</tr>
</table>


---

### 📚 GitHub Guide

If you experience problems while uploading projects to GitHub, configuring Git, or pushing commits, please refer to the following guide:

**https://github.com/satellaos-official/satellaos-install-tool-cr/blob/main/git-user-manual/README.md**

The guide includes step-by-step instructions for repository creation, authentication, branch management, and common troubleshooting procedures.

---

## 📥 Installation

> ⚠️ Before starting, make sure you have a working Debian Netinst installation.

<table>
<tr>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/installing-steps/step1.png" width="220"/><br/><sub>Step 1</sub></td>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/installing-steps/step2.png" width="220"/><br/><sub>Step 2</sub></td>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/installing-steps/step3.png" width="220"/><br/><sub>Step 3</sub></td>
</tr>
<tr>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/installing-steps/step4.png" width="220"/><br/><sub>Step 4</sub></td>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/installing-steps/step5.png" width="220"/><br/><sub>Step 5</sub></td>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/installing-steps/step6.png" width="220"/><br/><sub>Step 6</sub></td>
</tr>
<tr>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/installing-steps/step7.png" width="220"/><br/><sub>Step 7</sub></td>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/installing-steps/step8.png" width="220"/><br/><sub>Step 8</sub></td>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/installing-steps/step9.png" width="220"/><br/><sub>Step 9</sub></td>
</tr>
<tr>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/installing-steps/step10.png" width="220"/><br/><sub>Step 10</sub></td>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/installing-steps/step11.png" width="220"/><br/><sub>Step 11</sub></td>
  <td align="center"><img src="https://raw.githubusercontent.com/satellaos-official/satellaos-install-tool-cr/main/main-repo-pictures/installing-steps/step12.png" width="220"/><br/><sub>Step 12</sub></td>
</tr>
</table>

---

# 👤 Project Status

SatellaOS is currently developed and maintained by a single developer.

While development may progress at a different pace compared to larger projects, this allows the project to remain focused on its core goals:

## ❤️ Philosophy

SatellaOS is not about providing the largest number of features.

Its goal is to give users as much control over their system as possible.

The core principles of the project are:

* Lightweight Design
* User Freedom
* Simplicity
* Modern Appearance

SatellaOS aims to stay out of the user's way and let them build the system they want.

# 📜 License

This project is licensed under the **MIT License**.

You are free to use, modify, distribute, and redistribute the software, provided that the original copyright notice and license text are included.

For more information, see the `LICENSE` file included in this repository.