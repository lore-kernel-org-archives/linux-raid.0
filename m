From: Hank Barta <hbarta@gmail.com>
Subject: raid startup on a live CD?
Date: Mon, 14 Nov 2011 22:56:40 -0600
Message-ID: <CABTDG88XS6HeGbhj1=iApvsFfifbdjLrO-eoJ4TxNcEcNoyRQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi folks,
On occasion I boot a live CD and need to have the md RAID devices
running. Ordinarily (with Ubuntu live CDs) I find that I need to
install the mdadm package after booting the live CD. At that point my
recollection is that the RAID devices get started by the scripts that
perform the installation (and probably run the startup scripts that
are in /etc/init.d/...)

Earlier today I did this with a distro that is derived from Debian and
under development. I was happy to see that 'mdadm' was already
installed. (I had asked for this in fact.) But then I started
encountering difficulties. The /proc/mdstat file existed but listed no
RAID personalities and none of my devices were started. I tried 'mdadm
--assemble -scan' which reported no errors but did not improve the
situation. I manually loaded the raid0 and raid1 modules (which caused
the personalities to be listed in /prod/mdstat) and pulled in other
raid related kernel modules. However 'mdadm --assemble -scan' still
did not start my devices. I thrashed around a bit before finding a
command that probed drives and listed the md devices and their UUIDs.
I was then able to start them using 'mdadm --assemble /dev/md<n>
--uuid <UUID>' individually for the RAID devices I wanted to start.

I'd like to report back to the person working on this distro the
difficulties I had with the RAID and beyond that, I'd like to provide
the information that they need to set up RAID so it just works (like
on a normal boot) if possible and desirable.

First... Are there reasons that other live CDs I've used have not set
up RAID? Live CDs by their nature are somewhat lightweight so if
adding mdadm uses significant resources perhaps it is best left as a
manual operation.

Is there something I overlooked in getting it started in this
particular situation?

Where should I be looking for documentation that would help
configuring RAID on a Live CD? I did some searching and the most
promising thing I found was
https://raid.wiki.kernel.org/articles/r/a/i/RAID_Boot_bac9.html which
directs me to a text file in the kernel source tree.
(http://lxr.linux.no/#linux+v3.1.1/Documentation/filesystems/ramfs-rootfs-initramfs.txt)
And that points to other documentation. I'd appreciate pointers to
documentation that is particularly relevant to md RAID form a live CD.

many thanks,
hank

--
'03 BMW F650CS - hers
'98 Dakar K12RS - "BABY K" grew up.
'93 R100R w/ Velorex 700 (MBD starts...)
'95 Miata - "OUR LC"
polish visor: apply squashed bugs, rinse, repeat
Beautiful Sunny Winfield, Illinois
