From: GrantC <grant_nospam@dodo.com.au>
Subject: Re: Still problems with USB
Date: Thu, 17 Feb 2005 10:43:31 +1100
Message-ID: <r4k7115c7r1l8ans7kf7a4cavjfld76v9r@4ax.com>
References: <1062276680@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: <1062276680@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: Clemens Eisserer <linuxhippy@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Clemens,

I've been working with software RAID0 a fair bit recently, so this 
is on topic for me.

On Wed, 16 Feb 2005 17:35:54 +0100, you wrote:

Firstly, what is it are you trying to gain by using RAID1?  

>However I now have another strage problem:
>1.) When booting up my USB hd is detected before raid is initialized.
>2.) The MD Driver tells me that it can only find /dev/sda1 of the array, although all partition-types are set correctly ("fd"). Please have a look at the dmesg-output I atached.
>3.) Mout tells me, that /dev/md0 is mounted on "/" - in /etc/fstab there is only written something like /      $LABEL (or something like that - I think it has something todo with grub, dont know if it was called LABEL).
>4.) If I write data to / only my internal harddisk (/dev/hda3) is involved, althought / is /dev/md0 (accoring to mount) and the raid-driver told me that only /dev/sda1 (usb) is used.
>5.) If I do hdparm -tT /dev/md0 only my usb-drive is benchmarked.
>6.) If I ask /proc/mdstat it also tells me that only /dev/sda1 is aktive.
>
>Does anybody have an idea whats going wrong. I am quite confused :-(

What you are doing is not making any sense at all, the machine needs 
to boot all by itself -- trying to run an OS with half of it hanging 
on a removable drive on USB transport strikes me as being a very bad 
idea.  

>I am more and more playing with the thought  that I just a small partition as root-partitions and symlink /usr and /opt to my raid. Would that make sence and would it hurt the performance much?

Makes no sense at all to me.  Using RAID1 hurts performance, write 
everything twice, and the read performance boost is not impressive, 
but my benchmarking was on a much slower system.

>Heres dmesg's output:

Please trim it next time!

>md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
. . .
>md: Autodetecting RAID arrays.
>md: could not bd_claim hda3.
>md: could not bd_claim sda1.
     ^^^^^^^^^^^^^^^^^^^^^^^^^-- I've not seen these before
"Use the source, Luke":

linux-2.6.10/drivers/md/md.c
/*
 * prevent the device from being mounted, repartitioned or
 * otherwise reused by a RAID array (or any other kernel
 * subsystem), by bd_claiming the device.
 */

I don't like grub either, it has done strange things to me, LILO is 
old and very reliable.  

>md: autorun ...
>md: considering sda1 ...
>md:  adding sda1 ...
>md: created md0
>md: bind<sda1>
>md: running: <sda1>
>md: raid1 personality registered as nr 3
>raid1: raid set md0 active with 1 out of 2 mirrors
>md: ... autorun DONE.

This is what I'd expect to see.  The RAID1 is broken.  What you 
are doing is technically broken IMHO, or simply not what I would 
consider doing.  Funny thing is I recently put a larger HDD into 
my laptop, and bought a USB adaptor for the old 6GB HDD -- but 
the thought of RAIDing a portable hard drive never occured to me.

Not trying to discourage you from playing though, as that is how 
to learn...

Cheers,
Grant.

