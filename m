From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: trouble creating array
Date: Sun, 25 Feb 2007 17:35:33 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702251734510.31647@p34.internal.lan>
References: <727816.19226.qm@web55809.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <727816.19226.qm@web55809.mail.re3.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: jahammonds prost <gmitch64@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 25 Feb 2007, jahammonds prost wrote:

> Just built a new FC6 machine, with 5x 320Gb drives and 1x 300Gb drive. Made a 300Gb partition on all the drives /dev/hd{c,d,e} and /dev/sd{a,b,c}... Trying to create an array gave me an error, since it thought there was already an array on some of the disks (and there was an old one).
>
> I decided to clear off the superblock on the drives with mdadm --zero-superblock on all the drives. It worked fine on all drives, except for /dev/sd{b,c)1, which returns an error "mdadm: Couldn't open /dev/sdb1 for write - not zeroing". There doesn't seem to be a problem with the drive, as I've run a non destructive badblocks on it, and also done a dd if=/dev/zero of=/dev/sdb1 on it, and Ive written out 300Gb onto the partition.
>
> When I try and create an array using these 2 partitions, I get an error
>
> mdadm: Cannot open /dev/sdb1: Device or resource busy
> mdadm: Cannot open /dev/sdc1: Device or resource busy
>
> and it aborts. I've double checked that the drives aren't mounted anywhere. There's nothing in /var/log/messages either...
>
> Any suggestions where to check next?
>
>
>
> Graham
>
>
>
> ___________________________________________________________
> To help you stay safe and secure online, we've developed the all new Yahoo! Security Centre. http://uk.security.yahoo.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Do you have an active md array?

mdadm -S /dev/md0
mdadm -S /dev/md1
mdadm -S /dev/md2

.. etc

lsof | egrep '(sdb|sdc)'

Something thinks its in use, that is why you cannot format it/make it part 
of a new array, a reboot would also fix the problem.

Justin.
