From: GrantC <grant_nospam@dodo.com.au>
Subject: Re: Autodetection using RAID1 on externa USB2-HDs
Date: Wed, 16 Feb 2005 18:20:57 +1100
Message-ID: <rms5115dginq7etbe2sdhdlnfpgohningh@4ax.com>
References: <1061567322@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: <1061567322@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: Clemens Eisserer <linuxhippy@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Feb 2005 07:54:26 +0100, you wrote:

>Hello!
>
>I am trying to use my external USB2.0 hd for  raid1 in my laptop, however autodetection does not work and I do not really know - but I have at least a theory.
>
>What i did till now:
>1.) set the partition-type of both partitiuons from 83 (Linux) to fd (Linux Raid Autodetection)
>2.) mdadm --create /dev/md0 --level=raid1 --reaid-devices=2 /dev/hda2 /dev/sda1
>
>This works great on creation, I can watch with /proc/mdstat the syncing process, but if I reboot the autodetection does not work. I can see that linux-raid discovers an raid (on /dev/hda2) but something returns "-22" (have forgotten what exactly) - it seems that my usb-disc (/dev/sda1) is simply not known at raid-discovery-time.
>Some seconds later I can see that the kernel disvcovers my usb-drive - so I think my theory could be right?
>
>Is there a way to tell the kernel after boot where to find raid-arrays and howto handle them. Is that maybe possible with only a /boot partition and the reast on a mirrored "/" (root) partition.
>
>Please help, I don't know any further :(

If you really want to do this, I'd suggest stopping the RAID1 
prior to shutdown, and then starting the RAID1 from rc.local, 
then your RAID1 wil be recognised and resynced.

Consider what will happen when you turn on laptop without 
USB RAID1 partner HD plugged in?

If you are trying for easy way to backup data, I would suggest 
rsync.

Cheers,
Grant.

