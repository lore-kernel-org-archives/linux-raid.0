From: Spelic <spelic@shiftmail.org>
Subject: Re: inactive device
Date: Wed, 15 Dec 2010 19:05:05 +0100
Message-ID: <4D090351.4000105@shiftmail.org>
References: <C7BDC8B0-E26E-4E42-9D71-DF90C4A80784@me.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <C7BDC8B0-E26E-4E42-9D71-DF90C4A80784@me.com>
Sender: linux-raid-owner@vger.kernel.org
To: raincatsdogs@me.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/15/2010 02:20 PM, raincatsdogs@me.com wrote:
> My name is Paolo from Italy (bad english)
> I am not subscribed to the list
>
> I am using a Ubuntu 10.04 x64 desktop and try to create a raid1 with a couple of disk.
> After the removal of the super block from the 2 discs (--zero-superblock) I assembled the raid with the command
> "mdadm --create --auto=md -b internal --symlink=no -l raid1 -n2 --force /dev/md0 /dev/sdc /dev/sdd"
> My intention is not to partition the raid (md_d0p1, md_d0p2, etc..); does not create links to the disks in /etc, and finally have the bitmap in order to accelerate the reconstruction.
> After launching the command, the construction is done and the raid is completed. Format the new device /dev/md0 and everything works.
>
> After rebooting the operating system the problem start.
> 1.Mdstat reports:
> paolo@machiavelli:~$ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> md_d0 : inactive sdd[1](S)
>        312571136 blocks
>    

Are you running ubuntu?

I find the same problem in Ubuntu if /etc/mdadm/mdadm.conf cites MD 
arrays as /dev/md/somearrayname .

Only the short form /dev/mdX works. If you go into the file and change 
the names with the short form (then regenerate initramfs and reboot) it 
will probably work.
The longer form triggers some bug in I-don't-know-where in the boot 
sequence for which a preliminary device md_d'something gets created as 
soon as the first raid element is detected, and then the other drives 
(detected later) cannot form a nondegraded array anymore. This does not 
happen on all arrays but a few yes, like 3-4 drives in 8 raid1 (2 
elements) arrays.

I don't know if this is a "mdadm --incremental" bug (Ubuntu uses mdadm 
--incremental in udev for each drive discovered), an udev bug or 
udev-rules bug, a race condition or something else. Might also have 
something to do with the symlinks.
I'm not sure if mdadm --incremental is safe in a highly racy situation 
like when tens of drives and tens or hundreds of partitions are detected 
at the same time. Does it lock properly?

Also I don't understand why in Ubuntu when using the long names i see 4 
drives for each array:
/dev/md/arrayname
/dev/md/arrayname1
/dev/md/arrayname2
/dev/md/arrayname3
/dev/md/arrayname4
/dev/md/anotherarray
/dev/md/anotherarray1
/dev/md/anotherarray2
/dev/md/anotherarray3
/dev/md/anotherarray4
...

the first has MD major number, the others have 254, which I don't know 
what refers to. I don't know what they are, my raid arrays are not 
partitionable!


> 2.and in /etc I find the device md0 partitioned into 4: md_d0p1, md_d0p2,md_d0p3,md_d0p4
>    

This one I don't know

> I do not understand why then the device /dev/md0 became /dev/md_d0, despite the command --auto=md
> also do not understand why the device md_d0 is inactive and mdstat shows a (S) (I can not find documentation about this symbol)
>
> It seems that the options "--auto=md --symlink=no" wonts work!
> Or maybe the mdadm command syntax is wrong?
> Thanks
>    

