From: Stephen Kent <smkent@smkent.net>
Subject: mdadm named array (metadata 1.2) and udev when assembling an array in initramfs
Date: Sat, 1 Nov 2014 11:53:56 -0700
Message-ID: <CAC45b7=-dZX-kxDZY3KBEPZhaTuUhTcqNjTL6y8X71q9oDjiwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have set up a machine to use an md array as the root device. I have
created the array with metadata type 1.2, name "root," on host
"optimus" (so the full metadata name is "optimus:root").

I'm using Gentoo Linux (kernel 3.16.5-gentoo), and previously I had no
initramfs so I wrote a short one to assemble the array. My initramfs
sets the hostname and runs "mdadm -As," which correctly auto-assembles
the root device array on /dev/md/root (even without an
/etc/mdadm.conf).

Once the initramfs script is finished, init starts which then starts
udev. Now, at this point the array is already assembled, but the
/dev/md/* name is lost (and so is /run/mdadm/map) since those files
were on the initramfs' tempfs root. udev creates a /dev/mdXXX node
(ex. /dev/md127) and then runs a rule to try to figure out the
/dev/md/* name, which should be /dev/md/root. The default udev rule
calls mdadm --detail --export /dev/md127, which should print
MD_DEVNAME=root for udev, but instead it prints
MD_DEVNAME=optimus:root, and the symlink in /dev/md gets created as
/dev/md/optimus:root.

I think this is a bug in mdadm, but I'm not sure how to dig into it. I
have made sure that my main OS init sets the hostname before starting
udev, and I have tried with and without "HOMEHOST optimus" in
/etc/mdadm.conf.

The workaround I am using right now is to define the array name
manually in /etc/mdadm.conf like this:

ARRAY /dev/md/root UUID=782a671c:e646f2d5:848baad0:5668ee84

This works by avoiding automatic name detection and using the defined
name (/dev/md/root), but it really seems that mdadm should know how to
determine MD_DEVNAME correctly for an already-started array if the
hostname (or homehost) is correctly set. Is this a bug in mdadm? If
so, is this the correct place to report it or is there a bug tracking
system I should use? I am using mdadm v3.3.1.

(Please cc me on replies as I am not currently subscribed to the
linux-raid list.)

Thanks,

Stephen
