From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID1 + rsync (2)
Date: Fri, 13 Aug 2004 11:32:02 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0408131052450.480@lion.drogon.net>
References: <1092387262.3113.10.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1092387262.3113.10.camel@localhost>
To: Ninti Systems <office@ninti.com.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 13 Aug 2004, Ninti Systems wrote:

> Sory about having to re-post, but that last email wasn't too well laid out ...
>
> I'm looking at a method of creating maximum redundancy using software
> RAID with four equal disks. I know that the most common advice is to do
> RAID 5 if there are four disks and redundancy is required.

So why not use RAID5 ?

> Still, redundancy really is more important to me than performance
> (within reason of course). I know that a four disk RAID1 array
> (including swap) built out of primary and secondary masters/slaves would
> not perform well.

It's not neccessarily performance thats the issue here - I've had personal
experience of a drive failing in a master/slave cable set and its failure
preventing access to the other drive on the same cable. Fortunately for
me, it wasn't part of a RAID set, so I didn't lose the data (on the good
drive), but if it had been, the I might have lost the lot...

A Promise card has 2 ports, so for 4 drives, one drive on each of the
motherboard ports and one on each of the Promise cards will work well.
Cabling is a hassle though - you'll have 4 flat cables to deal with inside
the case, but it's not an insurmountable problem.

As for performance, RAID1 won't give you much more than the speed of a
single drive and it's half the write speed, and for reading, RAID5 might
have an advantage, depending on your data. I've never seen RAID5 slower
than a single drive though. If you really want performance, you'll need to
go to a RAID1+0 combination and have the hardware to match.

> So I'm wondering if anyone has any comments on the following scenario,
> or has tried it. Let's assume partitioning is /boot, swap and /(root):
>
> 1. Put /boot on a four disk RAID1 array across all disks (dev/md0).
> 2. Put swap on a two disk RAID1 array (primary and secondary masters)
> (/dev/md1).
> 3. Put /(root) on a two disk RAID1 array (primary and secondary masters)
> (/dev/md2).
>
> So I end up with something like this (all RAID autodetect type):
>
> /dev/md0 - /dev/hda1, /dev/hdb1, /dev/hdc1, /dev/hdd1
> /dev/md2 - /dev/hda2, /dev/hdc2
> /dev/md2 - /dev/hda3, /dev/hdc3
>
> /dev/md0 - /boot
> /dev/md2 - swap
> /dev/md2 - /
>
> 4. Configure the remaining /dev/hdb2 and /dev/hdd2 partitions as normal swap
> partitions.

You've just lot the point of having RAID here - your machine will crash if
one of these swap partitions develops a bad sector.

> 5. Configure and format the remaining /dev/hdb3 and /dev/hdd3 partitions as
> normal ext2 partitions.
> 6. Run rsync daily to mirror /(root) on /dev/md2 to both /dev/hdb3 and
> /dev/hdd3.

Again, it'll have problems if one of the non-RAIDed partitions develops a
fault.

> I'm hoping that this would create something like a four disk RAID1 array
> with the performance of a two disk RAID1 array, and that in theory up to
> 3 of 4 disks could fail but a usable system would still be bootable
> (even if it may be the case that the system may only be as up to date as
> the last rsync process). I realise that depending on which disk(s)
> failed, I may have to fiddle lilo and/or fstab to boot a running system.
>
> Does this idea have wheels, or am I overlooking some fatal flaw?

It's not neccessarily fatal, as your important data is on a RAID
partition, but you can make life a lot easier for yourself...

Heres a scenario that I use myself. Firstly I'm not a fan of a separate
/boot partition - thats all to do with me being a boring old fart and new
hardware not needing it... So..

If you partition all 4 disks identically it'll save you headaches later
when you need to replace one.

So I'd do it like this:

6 partitions: The first used as root, 2nd as swap, 3rd as /usr, 4th as
/var 5th as your data and 6th as the backup for the data. You can combine
root and /var and even /usr if you like to make it simpler. There are pros
and cons for each way. (as well as holy wars)

Combine the root partitions together with RAID1 and 2 hot-spares. All
others in RAID5. (including swap, yes, I know, not efficient, but if you
are swapping heavilly you are runing sub-optimally in the first place -
buy more memory!)

You can still do the daily backup via rsync from one RAID5 to another.

Here is a live example of one of my servers: (This has 4 x 150GB SCSI
drives in a Dell rack-mount box)

gordonh @ pixel: df -h -t ext3
Filesystem            Size  Used Avail Use% Mounted on
/dev/md0              235M   38M  185M  17% /
/dev/md2              2.8G  2.4G  268M  91% /usr
/dev/md3              5.6G  726M  4.6G  14% /var
/dev/md4              195G  164G   21G  89% /mounts/local0
/dev/md5              196G  165G   22G  89% /mounts/local0.yesterday

gordonh @ pixel: cat /proc/swaps
Filename                        Type            Size    Used    Priority
/dev/md1                        partition       2097136 60888   -1

Heres another with IDE drives and a promise card:

gordonh @ blue: df -h -t ext3
Filesystem            Size  Used Avail Use% Mounted on
/dev/md0              235M   33M  191M  15% /
/dev/md2              5.6G  994M  4.3G  19% /usr
/dev/md3              1.4G  178M  1.1G  14% /var
/dev/md4              165G  125G   32G  80% /mounts/jdrive
/dev/md6              165G  125G   32G  80% /mounts/jdrive.yesterday

An extract from /proc/mdstat:
md6 : active raid5 hdi7[3] hde7[1] hdc7[2] hda7[0]
      176080128 blocks level 5, 64k chunk, algorithm 0 [4/4] [UUUU]

(There is no md5 in this system - I made a typo when I created it and
never bothered to fix it as it wasn't that important)

Gordon
