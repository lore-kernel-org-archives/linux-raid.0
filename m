From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re: trouble creating array
Date: Sun, 25 Feb 2007 18:56:29 -0800 (PST)
Message-ID: <540638.44700.qm@web55810.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Do you have an active md array?
>
> mdadm -S /dev/md0

Nothing was showing up in /proc/mdstat, but when I try and stop md0, I get this

# mdadm -S /dev/md0
mdadm: stopped /dev/md0

> lsof | egrep '(sdb|sdc)'

I had tried that before, and nothing is showing. A reboot didn't help, but something is definately keeping it open. I tried an mkfs

]# mkfs.ext3  /dev/sdb1
mke2fs 1.39 (29-May-2006)
/dev/sdb1 is apparently in use by the system; will not make a filesystem here!


Any ideas how to find out what has it open? I can happily write all over the disk with dd... I can create and delete the partition, and it's all good... I will try deleting the sd{b,c}1 partitions, reboot, and see what happens.


Graham




----- Original Message ----
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: jahammonds prost <gmitch64@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Sunday, 25 February, 2007 5:35:33 PM
Subject: Re: trouble creating array


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


		
___________________________________________________________ 
To help you stay safe and secure online, we've developed the all new Yahoo! Security Centre. http://uk.security.yahoo.com
