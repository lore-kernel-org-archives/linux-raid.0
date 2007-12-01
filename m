From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Kernel 2.6.23.9 + mdadm 2.6.2-2 + Auto rebuild RAID1?
Date: Sat, 1 Dec 2007 06:19:14 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712010614070.25643@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: apiszcz@solarrain.com
List-Id: linux-raid.ids

Quick question,

Setup a new machine last night with two raptor 150 disks.  Setup RAID1 as 
I do everywhere else, 0.90.03 superblocks (in order to be compatible with 
LILO, if you use 1.x superblocks with LILO you can't boot), and then:

/dev/sda1+sdb1 <-> /dev/md0 <-> swap
/dev/sda2+sdb2 <-> /dev/md1 <-> /boot (ext3)
/dev/sda3+sdb3 <-> /dev/md2 <-> / (xfs)

All works fine, no issues...

Quick question though, I turned off the machine, disconnected /dev/sda 
from the machine, boot from /dev/sdb, no problems, shows as degraded 
RAID1.  Turn the machine off.  Re-attach the first drive.  When I boot my 
first partition either re-synced by itself or it was not degraded, was is 
this?

So two questions:

1) If it rebuilt by itself, how come it only rebuilt /dev/md0?
2) If it did not rebuild, is it because the kernel knows it does not need 
to re-calculate parity etc for swap?

I had to:

mdadm /dev/md1 -a /dev/sda2
and
mdadm /dev/md2 -a /dev/sda3

To rebuild the /boot and /, which worked fine, I am just curious though 
why it works like this, I figured it would be all or nothing.

More info:

Not using ANY initramfs/initrd images, everything is compiled into 1 
kernel image (makes things MUCH simpler and the expected device layout etc 
is always the same, unlike initrd/etc).

Justin.
