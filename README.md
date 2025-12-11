
<div align="center">
  <img alt="An icon representing a box with debian*s logo on top of it, and a Plus sign in the bottom right corner" src="data/icons/48.svg" />
  <h1>Unboxing</h1>
  <h3>Install debian packages</h3>

  <a href="https://elementary.io">
    <img src="https://ellie-commons.github.io/community-badge.svg" alt="Made for elementary OS">
  </a>
  
<span align="center"> <img class="center" src="https://github.com/teamcons/unboxing/blob/main/data/screenshots/welcome.png" alt="A welcome screen"></span>
</div>

<br/>

## 🦺 Installation

You can download and install Unboxing from various sources:

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg?new)](https://appcenter.elementary.io/io.github.teamcons.unboxing)

## Building, Testing, and Installation

You'll need the following dependencies:
* libflatpak-dev
* libgranite-7-dev
* libgtk-4-dev
* libxml2-dev
* meson
* valac

Run `meson build` to configure the build environment. Change to the build directory and run `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`, then execute with `io.github.teamcons.unboxing`

    ninja install
    io.github.teamcons.unboxing
