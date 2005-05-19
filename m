From: Andre Noll <noll@mathematik.tu-darmstadt.de>
Subject: Re: Problems setting up RAID1
Date: Thu, 19 May 2005 03:55:23 -0000
Message-ID: <slrnd8o3hb.na8.noll@p133.mathematik.tu-darmstadt.de>
References: <d6danj$nmr$1@sea.gmane.org> <slrnd8n1vj.na8.noll@p133.mathematik.tu-darmstadt.de> <slrnd8n1vj.na8.noll@p133.mathematik.tu-darmstadt.de> <d6g8np$vr9$1@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 18 May 2005 16:32:54 -0400 you wrote in local.lists.linux-raid:

>> Did you try root=/dev/md7 in your lilo.conf (or at the lilo prompt)?
>> 
> Fedora core 3 used GRUB as the boot loader (part of my problem may be 
> that all of the how-to's that I have found still deal with lilo).  The
> only options for a boot loader with Fedora core 3 are 'GRUB' and not to
> install a boot loader.  Any tips on using GRUB with RAID

Nope, I've never used grub. Be aware that strange things may happen if
the boot loader tells the kernel to use /dev/sda7 or /dev/sdb7 instead
of /dev/md7 as the root device. However, this is only a problem with
linux 2.4, see the thread on raid1-diseaster on reboot.

