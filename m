From: "Christian Kivalo" <valo@valo.at>
Subject: RE: Best Practice for Raid1 Root
Date: Thu, 15 Jan 2004 01:06:44 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NMEHJKFGFEGJPIPOLFFECEMHDEAA.valo@valo.at>
References: <4005D408.8060002@physics.ucsd.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4005D408.8060002@physics.ucsd.edu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Hi,
>
[snip]
> The boot loader is grub and I want both /boot and / raided.
>
> In the event of a failure of hda I would like the system to switch to
> hdc. This works fine. However what I have had problems with is if the
> system reboots. If /dev/hda is unavailable I no longer have a
> disk with
> a boot sector set up correctly. Unless I have a floppy or
> CDROM with a
> boot loader the system will not come up.
>
> So my main question is what is the best practice to get a
> workable boot
> sector on /dev/hdc? How are other people making sure that
> their system
> remains bootable after a disk failure of the boot disk? Is it even
> possible with software raid and PC BIOS? Also when you
> replace /dev/hda
> how are you getting a valid boot sector on that disk?
>
> I have found grub to often be problematic so that even when I
> move the
> good drive to be hda grub does not like to install itself correctly.
>
> I am sure I am approaching this incorrect in some way, I am just not
> sure what is the right way.
>
> Terrence Martin
> UCSD Physics

hi!

one possible solution would be to use lilo. lilo is capable of booting
from md raid1 arrays. look at lilo.conf(5) manpage for 'raid-extra-boot'
in 'GLOBAL OPTIONS'. i use it on most of my maschines. AFAIK grub is not
able to boot from /dev/mdX.

hth
christian

