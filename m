From: Tom Oehser <tom@toms.net>
Subject: is automount affecting root device? huh?
Date: Thu, 1 Jul 2004 08:08:04 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407010801300.471@jupiter.toms.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi-

I have 2 raid-5 arrays, one is md software raid running on a Highpoint
1540, the other one is a Mylex Acceleraid-250 hardware scsi raid card.

Lilo is working fine to boot from the Mylex.  But, if I have the md on
the Highpoint autodetected, and if it doesn't have a /etc/fstab entry,
it seems to screw up the kernel's root device!?!

That is, if LILO has:

boot = /dev/rd/c0d0
disk = /dev/rd/c0d0
BIOS = 0x80
image = /2.6.7b
  label = 2.6.7b2
  append = "nmi_watchdog=2 reboot=cold parport=0x378,7"
  read-only
  root = /dev/rd/c0d0p1

and there is no:

# /dev/md1        /mnt/md1      ext3      defaults        0 0

line, it fails when it tries to mount the root filesystem.

BUT, if I add either:

 raid=noautomount

_or_

 the fstab line that mounts it on /mnt/md1

it seems to work fine...

Is the mount code ignoring the "root = /dev/rd/c0d0p1", seeing the
autodetected raid, and deciding to magically mount it as root...?

-Tom

