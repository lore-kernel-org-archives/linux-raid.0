From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Best Practice for Raid1 Root
Date: Thu, 15 Jan 2004 08:42:37 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0401150835500.15898@unicorn.drogon.net>
References: <4005D408.8060002@physics.ucsd.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4005D408.8060002@physics.ucsd.edu>
To: Terrence Martin <tmartin@physics.ucsd.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 14 Jan 2004, Terrence Martin wrote:

> The boot loader is grub and I want both /boot and / raided.
>
> In the event of a failure of hda I would like the system to switch to
> hdc. This works fine. However what I have had problems with is if the
> system reboots. If /dev/hda is unavailable I no longer have a disk with
> a boot sector set up correctly. Unless I have a floppy or CDROM with a
> boot loader the system will not come up.
>
> So my main question is what is the best practice to get a workable boot
> sector on /dev/hdc?

Use LILO.

Works just fine.

My standard layout on a 2-disk systems these days is usuely something like

  /		256MB
  swap		1GB (depends on system memory though)
  /usr		2GB
  /var		just under half of rest of disk
  /archive	rest of disk

I don't bother with a separate /boot partition. It's not needed in these
enlightened days of BIOSes that can boot from modern disks, and in
any-case a small / partition is inside the 1024 cylinder limit anyway.
Disks are cheap and I can keep an N-day archive on the same system (see
rsync documentation) which is normally re-mounted read only and then that
can be dumped to tape, etc.

I've deployed a lot of little servers and routers like this and I'm
pleased with their usbility.

The runes in a lilo.conf file are:

  boot=/dev/md0
  root=/dev/md0
  raid-extra-boot=/dev/hda,/dev/hdc

I've no idea how to integrate lilo into a modern RH distribution though. I
use Debian for all my stuff.

Gordon
