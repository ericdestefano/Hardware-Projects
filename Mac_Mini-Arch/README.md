# Mac_Mini-Arch (i3)
"Change is the essential process of all existence." – Mr. Spock


### 1. Personal History

In 1987, a movie called *North Shore* hit theaters - a surfing drama that barely made a ripple at the box office, but found its way into my life when it landed on the paid cable movie channels later that year.

*North Shore* hit me as a kid because I didn’t see it as a coming-of-age surfing movie. I saw it as a story about starting over when you think you’ve already arrived. Rick - the protagonist-hero, not yet aware he’s been hero-quested - shows up with the latest gear and the confidence to match, only to find out none of it matters. He has to strip everything away, relearn from the roots, and earn his way back to the modern boards. That stuck with me. It taught me that if you really want to master something, you go back to the beginning, put yourself in the uncomfortable place where nothing is automatic, and grind until every part of it is yours.

Keeping that in mind, this time around I’m going for:  

1.  100% X11/XORG based - including the Display Manager, not just the Window Manager  
- For remote access with my preferred applications dwservice/dwagent and NoMachine, which mostly but not quite totally work  
2.  Run on my 2013 Mac Mini i7  
- Still a very powerful system  
3.  Use a tiling Window Manager that is mostly keyboard based  
- For the experience and knowledge expansion  
4.  Something I can build up, as opposed to tear down  
- This ruled out most distro remixes or those that rely heavily on add-ons for basics like power management  

In short, a basic, low-level system that delivers plenty of power with minimal overhead.


### 2. Setup

As I’ve observed over the years, with any system you usually have two choices - add or remove - to get it where you want it. I’m preferring the add approach with Arch Linux, which provides the bare minimum - a boot loader, kernel, a shell, and network stack - compared to my alternate choice - Debian - where I’d spend more time stripping out components I don’t need or that would get in the way.

Following the Arch Linux installation guide, I made the following decisions along its branching paths after pacstrapping the base system.

0. Partitioning - 1 GiB for /boot, 18 GiB for swap (hibernation support), and the rest to / using ext4. A separate SSD, installed with an aftermarket Mac Mini drive expansion bracket, is used for /home with XFS.  
1. Networking - I chose netctl, as I have come to appreciate its straightforward approach, similar to Debian’s /etc/network directory.  
2. Boot loader - grub2, for the moment. It works. I have a soft spot for rEFInd, but in the interest of finishing the install I went with grub2.

A couple of reboots later, and off we go...

#### 2.1 Power Management

Modern times with modern energy prices require power management - it simply isn’t optional anymore.  For what is essentially a glorified terminal at the moment, I enable hibernate with a 20-minute timeout. Swap is sized for hibernation — earlier I set 18 GiB so the full RAM image has room to land.  Why hibernate?  On the 2013 Mac mini, sleep mode typically draws around 0.8 to 1.4 W, while hibernation consumes just 0.2 to 0.4 W. That’s easily half (or less) the power draw, making hibernation the better choice for longer idle periods.

Edit `/etc/systemd/logind.conf` and uncomment the following two lines (and set my idle period):

```
IdleAction=hibernate
IdleActionSec=20min
```

Save, then restart `logind` with:

```
systemctl restart systemd-logind
```

#### 2.2 Netctl

For network management in Arch, I have always preferred Netctl as it’s the closest I can get to `/etc/network` in Debian - and I enjoy its simplicity without compromising customizability. It’s lightweight, predictable, and stays out of the way, making it ideal for my back-to-basics approach in this project. Once installed using Arch Linux’s documentation, I had my static IP configuration ready to go using the `ethernet-static` template in `/etc/netctl/examples`:

```
[root@mac-mini ~]# cat /etc/netctl/enp1s0f0-static

Description='enp1s0f0 static ethernet connection'
Interface=enp1s0f0
Connection=ethernet
IP=static
Address=('10.0.7.49/24')
#Routes=('192.168.0.0/24 via 192.168.1.2')
Gateway='10.0.7.1'
DNS=('8.8.8.8')

## For IPv6 autoconfiguration
#IP6=stateless

## For IPv6 static address configuration
#IP6=static
#Address6=('1234:5678:9abc:def::1/64' '1234:3456::123/96')
#Routes6=('abcd::1234')
#Gateway6='1234:0:123::abcd'

SkipNoCarrier=yes
```

Then I activated and started the profile:

```
netctl enable enp1s0f0-static
netctl start enp1s0f0-static
```

#### 2.3 Systemd-Resolved


#### 2.4 Xorg

