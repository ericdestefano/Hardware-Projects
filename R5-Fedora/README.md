# R5-Fedora (Plamsa)

### 0- Preface: The H97 Chipset Showstopper

“That’s not supposed to happen.”

R5 was happily running a now-forgotten Linux distribution, and I proceeded to do what I always do when I’m done for the moment—put the system into S4 (Hibernate Mode). I swiveled my chair, was halfway out of it, when I heard the *voooom* of my system’s fans kick in.

I figured I must have bumped the mouse or something to that effect. Hibernated the system again—five seconds later: *voooom*.

A day or two later, I rebooted back into Windows… for about six months.

R5 is a happy little server, built around 2020 using a combination of new and used parts housed in a Fractal R5 Tower Case. The idea was to build something with one foot in the past—à la PCI 32-bit—and one foot in the future: PCI-E / M.2. It’s played multiple roles around the house until I decided to move back to PC gaming from console after a seven-year absence.

It’s done its job well, handling modern AAA games with its Intel 4th Gen i7-4770, 32 GB of RAM, and AMD RX 590 GPU with ease—even on High or Ultra settings. But not being one to leave well enough alone, the project still felt incomplete.

It was time to return to Linux.

The issue came down to R5’s motherboard chipset that was to power its Haswell CPU—the H97—well documented here:

https://bugzilla.kernel.org/show_bug.cgi?id=66171  
https://bbs.archlinux.org/viewtopic.php?id=303546

After trying everything, including recompiling DSDT ACPI settings, I tracked the spurious wake-up event to my PCI-E WiFi adapter that had… a USB 2.0 header connector.

Device removed.  
S3–S5 power states restored.  
It was time to go.


### 1- Personal History

Going back to Red Hat Linux 5.2, I have found over the decades that a good benchmark for how well you’re doing in a non-Windows environment is measured by how often you reboot into Windows.

Back in 1997—this was quite often.  
The feature set in Windows 95 and Windows NT 4.0 Workstation was too powerful, and too exciting, to ignore.

I’m always reminded of what Gordon Letwin wrote in his now-famous Usenet post, *“What’s Happening to OS/2?”*  
It was written shortly after Windows 95 shipped.  
The relevant part for our purposes here is that he accurately pointed out:

> “I bought a Tektronics 222 scope. It has an RS232 port on  
> it to upload and download waveforms. It came with a floppy disk with  
> driver software on it. For which processor and OS was the software written?  
> And what was the disk format? Guess.”

On the Linux front, this left a would-be enthusiast with two options:  
reboot often,  
or build your desktop carefully—choosing parts known to work with open drivers.  
Graphics chipset. Network chipset. SCSI/IDE controller. Sound card. The works.

Doubly so when choosing a laptop—  
especially as we rapidly approached the new millennium.  
Proprietary chipsets were showing up—sometimes as the next generation of notebook tech,  
sometimes just to shave costs.  
Either way, if you wanted sound or native Ethernet support,  
it was going to take a while.

Returning to our late ‘90s dilemma, success meant getting XFree86 running.  
Your modem modeming.  
Your sound card making sound.

In the early 2000s, this would morph into getting 2D acceleration,  
DRI, and hardware decoding working for DVD playback.  
And 3D support—for the small handful of AAA games that had native Linux binaries.  
All while still keeping mental track of how many times that day you rebooted into Windows.

Later that decade, support expanded.  
Wi-Fi chipsets. Broader 3D graphics compatibility.  
By 2010, it had become quite common to run Linux full-time as your daily desktop—  
so long as you didn’t have an iPod or… play PC games.

Gaming was the biggest showstopper for running Linux full-time—  
either due to the lack of native binaries, the dominance of DirectX, or some combination of both.

If you wanted to PC game, you were running Windows.  
And as a result, always had a partition or drive ready to boot when the urge arose.

Eventually, Valve made a move that changed the trajectory.  
Instead of chasing native Linux versions of Windows games,  
they introduced Proton—  
a compatibility layer, built on Vulkan, that translated Windows API calls—DirectX included—on the fly.

Now, with a small translation tax in the form of lost FPS,  
rebooting into Windows is no longer required to enjoy your favorite (non–CoD multiplayer) titles.

### 2 – Moving In

Having done a proof of concept, and having the proof of concept proven - it was time to start moving in and making the platform feel like home. This comes down to the following:

- **Auto login**: I like the system to be ready for use at boot, or resume (S3, S4, S5)—as much as I adore SDDM.
- **Power Savings**: Hibernate the computer after 30 minutes.
- **Wake on LAN**: Energy is expensive. Using Homebridge, most of my devices remain in a hibernate (S4) or soft shutdown state (S5) until needed.
- **Hypervisors**: VMware Workstation Pro, VirtualBox, QEMU, and TAP Adapters set up for my various virtual projects.
- **GUI Customization**: We all have our desktop look and feel preferences—whether it's a simple wallpaper or full window customizing.
- **Remote Access**: A luxury at best, and an absolute at worst. Sometimes I just need to confirm something from work—"is x.y.z really borked?" Sitting in my hotel room with all its hotelness, it’s my link to home and feeling like I am at home.

---

#### Auto login

As I noted above, I like to have my workstation (at home) auto login and be ready for use from cold boot, or from resume. As I am using the KDE/Plasma variant, my focus would be with SDDM—which is a fairly straightforward process in the file:

`/etc/sddm.conf.d/kde_settings.conf` – I have attached this file to the project repo here.

---

#### Power Savings

Due to auto login being enabled, I don’t need to configure both logind and KDE/Plasma for idle system hibernation. I also have idle/user lock disabled in the KDE/Plasma GUI—so aside from just logging me in, logind is never really present/active. As a result, I just have hibernation enabled after 30 minutes of idle activity in the GUI.

Please note: To hibernate up to 32GB of RAM, I have a 34GiB (gibibyte) SWAP partition—for the entire memory contents, plus a little extra.

*Note: I have "require password" disabled for locking. So when the system goes into hibernate mode, the screen blanks, reappears briefly, and then successfully suspends. This is due to the system checking with SDDM, which isn’t needed, as there is no requirement to use SDDM for a lock. This is normal behavior.*

---

#### Wake On LAN

WOL is disabled by default in Network Manager within Fedora, and I use it for the aforementioned reasons above… well, rely on it.

**Step 1**: Get it running manually to test:
```bash
ethtool -s enp5s0 wol g
```

**Step 2**: Hardcode those settings in Network Manager using `nmcli`. While I love editing files by hand, the recommended way is `nmcli`:

```bash
nmcli con show
```

```text
NAME                  UUID                                  TYPE       DEVICE
Wired connection 2    47cbe899-b00f-3b7f-933f-f4f1341fcd90  ethernet   enp5s0
lo                    13adbbad-5304-41ce-b0b1-8cc72ee1e4f5  loopback   lo
Wired connection 1    793ec897-d22b-388a-8a85-1cf63cf73f6a  ethernet   --
```

```bash
nmcli c modify "Wired connection 2" 802-3-ethernet.wake-on-lan magic
```

Reboot and verify:
```bash
ethtool enp5s0
```

Look for:
```text
...
Wake-on: g
...
```

*Good to go.*

---

#### Hypervisors

An essential part of my setup for experimentation, separation of services, and when I need a workhorse I’d like to keep separate from the rest of my universe—i.e., my Windows Development system with all my tools, preferences, and workflows I’d rather not recreate when I feel like OS hopping.

---

**VMware Workstation Pro**

This went surprisingly well. I’ve had issues in the past with compiling the kernel modules due to Fedora’s bleeding edge, but with Fedora Workstation 41—it just worked.

1. Download the latest build of VMware Workstation Pro  
2. `dnf group install "Development Tools"`  
3. `chmod +x` the `.bundle` file, and execute it  
4. Launch VMware Workstation Pro, let it build its kernel modules  
5. Done.

---

**VirtualBox**

…continues to be my go-to for most legacy operating systems. Getting it going in Fedora was simple:

```bash
rpm -i VirtualBox-7.1-7.1.6_167084_fedora40-1.x86_64.rpm
```

```text
warning: VirtualBox-7.1...rpm: Header V3 RSA/SHA256 Signature, key ID 2980aecf: NOKEY
Creating group 'vboxusers'. VM users must be members of that group!
```

```bash
usermod -aG vboxusers eric
```

**Author’s Note:** In Linux, VirtualBox has a slight advantage over the Windows variant—it can directly access a VMware Workstation network interface. In Windows, I have to bridge between VirtualBox and the host OS to do the same. So, yeah—nice to have direct NAT access.

---

**QEMU**

In Fedora, QEMU setup is straightforward:

```bash
dnf install qemu
```

You’re off.

---

#### GUI Customization

As the GUI became part of everyday life around 1984, personalization followed close behind—backgrounds, mouse pointers, screen savers, then title bars, and beyond. For Windows users, it might’ve been taskbar placement—top, bottom, left, right.

In Linux, it begins with your choice of window manager… then customizing the hell out of it. Something the Linux community’s been full throttle on since the late '90s.

For this build, we already know I’ve thrown in with KDE/Plasma. So the only question is: what did I end up choosing this time?

*Author’s note: While this was a lot of fun to write, this part is mostly for my own reference. For when I inevitably distro, WM, or OS hop again.*

- **Global Theme**: Black Glass (not really in use)
- **Colors**: Sweet (a good compromise over pure black)
- **Application Style**: Breeze, though Fusion is tempting
- **Plasma Style**: Glassy, with Oxygen2 making a strong case
- **Window Decorations**: CommonalitySol/Commonality, in honor of our gone-but-not-forgotten CDE
- **Icons**: candy-icons — these scratched the QNAP aesthetic itch that nearly made me buy one
- **Cursors**: candy-icons, again—very classic
- **Splash Screen**: Commonality, another CDE tribute
- **Login Screen (SDDM)**: CommonalitySol, to keep me from browsing eBay for SPARC workstations

*Should nostalgia strike, I may just dig up some Windows 95 Plus Pack system sounds.*

---

#### Remote Access

We’ve all been there—best-laid plans, etc.

In 2002 I found myself on a plane, flying to Texas. On my lap was a shiny new PowerBook running at 887 MHz. The plan: have a PowerPC Linux distribution up and running, with XFree86 operational. Sadly, because the screen resolution and horizontal/vertical timing was so different than anything else that had been released before, it just wasn’t meant to be in that moment.

In the present day, I find myself wanting a remote desktop solution while on bleeding edge Fedora running Wayland. Like my flight in 2002—which, I’ll digress for a moment, led to some fun adventures with Open Firmware—it’s not meant to be… yet.

And maybe, if it had worked, I wouldn’t be here—following this new thread.

The problem was simple, but firm: there’s still no real Remote Desktop solution for Fedora when running KDE/Plasma under Wayland.

That left me with two options: switch to something else, like Gnome.  
I am not religious about platforms. Give me an UltraSPARC running FreeBSD and I will still have fun.  
But this was meant to be a Plasma platform—and a Plasma platform it shall remain.

Or… go back to X11/Xorg—which I equally had no desire to do.  
This particular project is meant to be bleeding edge, and if bleeding edge right now is Wayland all the way, then get by in it we shall.  
That doesn’t mean we can’t have a little fun along the way, and rejoice later when we have something… anything for our remote viewing needs.

---

In the remote access department we have the following:

- **VPN** – Tailscale, my new favorite VPN for us CGNAT folks. It works out of the box, and their instructions for installing on Fedora are quick and plain.
- **SSH** – I really have no issue going back to using `ssh -L xxxx:127.0.0.1:xxxx` to get to any services I’m running that have an interface bound to a socket. Likewise, no problem doing remote X when I want to load a graphical application.
- **Syncthing** – This slight bump in the road got me motivated to start living with—rather than just examining—Syncthing, and I’m very happy with it.  
  Why do I need a remote desktop when my project folders are already synced to my laptop?

### Wrap-Up

In the end, this doesn’t feel like one of those “Hey, I switched to Fedora” moments—followed by a hail to Gentoo or Mint or Arch a month later.

Part of the exploration is always about trying things on. Seeing what fits. What doesn’t.

And for the last two weeks, this platform hasn’t just worked.  
It’s felt like home.





