From: Phil Turmel <philip@turmel.org>
Subject: Re: Lost a mirror disk, md array wouldn't start, vg's are missing
Date: Fri, 12 Jan 2018 07:58:18 -0500
Message-ID: <52404a95-25bd-f389-d6f2-de949d168223@turmel.org>
References: <496wakgGB9904S08.1515652381@web08.cms.usa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496wakgGB9904S08.1515652381@web08.cms.usa.net>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Jason Herring <jaherring@usa.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Jason,

On 01/11/2018 01:33 AM, Jason Herring wrote:
> I have a crashed mirror array on Fedora 27. One disk is clicky-clicking, the
> the other seems fine but the array won't assemble.  The machine may have
> crashed during this time, causing the additional problems.  I can see the
> partition fine and the details about this disk but mdadm scanning didn't find
> it.

[trim /]

> # fdisk -l /dev/sds
> Disk /dev/sds: 1.4 TiB, 1500301909504 bytes, 2930277167 sectors
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disklabel type: dos
> Disk identifier: 0x39fa8c19
> 
> Device     Boot Start        End    Sectors  Size Id Type
> /dev/sds1           1 2930277168 2930277168  1.4T fd Linux raid autodetect

That's a "protective MBR" intended to keep old BIOSs from scrambling a
GPT setup.  But you don't have the GPT setup, so it's not meaningful.

Your utilities are old.  Modern fdisk would have reported the difference.

> # cat /proc/mdstat
> Personalities : [raid1] 
> md125 : active (auto-read-only) raid1 sds[0]
>   1465137424 blocks super 1.2 [2/1] [U_]
> 
> But it shows up with a name the same as another array (this server has several
> arrays):
> 
> # mdadm --examine --scan --verbose
> ARRAY /dev/md/2  level=raid1 metadata=1.2 num-devices=2
> UUID=2dae5fb0:bcce83e4:2855f921:1b3bb460 name=pangea:2
> devices=/dev/sdj7,/dev/sdg7
> ARRAY /dev/md/2  level=raid1 metadata=1.2 num-devices=2
> UUID=9746d015:9e39eeea:334aa92e:bfa480bb name=pangea:2
> devices=/dev/sds
> 
> Listing the devices, there are two entries for md/2, kind of, but mdadm can't
> differentiate them? Seems like a bug?

Not a bug.  Array metadata records the *preferred* name for an array,
and autoassembly will *try* to honor it, on a first-come, first-served
basis.  If blocked by another, mdadm will fall back on a munged name in
/dev/md/ and will take the next available /dev/mdNNN counting backwards
from 127.

> # ls -l /dev/md/ 
> lrwxrwxrwx. 1 root root 6 Jan 9 12:51 2 -> ../md2 
> lrwxrwxrwx. 1 root root 8 Jan 9 19:13 2_0 -> ../md125
> 
> Next, I see it's assembled, and the PV is visible:
> 
> # pvs
> /dev/md125               lvm2 ---    1.36t   1.36t

LVM doesn't care what the device names are at any point, as it looks at
the metadata, in much the same way as modern distros use UUID=.... in
fstab for filesystems.  However, it isn't valid, as it doesn't identify
the volume group it belongs to.

> Note, it finds it at /dev/md125, not /dev/md/2 or md/2_0. So, there is some
> confusion by mdadm.

Any confusion here is not by mdadm (-:

> There are no volume groups listed above, and lvs and the various tools to look
> at them find nothing.

This is concerning, and suggests that you weren't supposed to be
assembling whole disks.  (What was your setup before?)  Consider using
lsdrv[1] to document your working setup so you'll know what you're
supposed to have.

> Finally, I rant "testdisk" to see what's in there. Selecting /dev/md125 ->
> Intel partition table -> Analyse

Very few people partition their arrays -- that's what they use LVM for.

> I then hit "continue":

Uh oh.

> Disk /dev/md125 - 1500 GB / 1397 GiB - CHS 366284356 2 4
> 
>      Partition                  Start        End    Size in sectors
> 
>  1 * Linux                  256   0  1 366284031   1  4 2930270208
> 
> At this point I stop as I could start to do some real damage here and need
> some help as to how to proceed to get my volume group and logical volume
> back.. and save the filesystem.

You just did damage by creating a partition inside the array.
Hopefully, you really have your array in /dev/sds1.  You haven't shown
the output of mdadm --examine /dev/sds1.  Please do.

> Issues that need addressing:
> 
> 1) conflicting /dev/md### numbers 

No real conflict.

> 2) partition /dev/sds or /dev/sds1 

Missing info.

> 3) missing volume group and logical volume

Probably available after stopping /dev/md125 and assembling like so:

mdadm -A /dev/mdNNN /dev/sds1

where NNN is an unused device number.  You might need --force also.

Phil

[1] https://github.com/pturmel/lsdrv
