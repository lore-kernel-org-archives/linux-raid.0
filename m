From: Michal Soltys <soltys@ziu.info>
Subject: Re: Are there some alignment settings when creating filesystem on
 RAID5 array which can improve performance?
Date: Tue, 06 Jan 2009 02:13:18 +0100
Message-ID: <4962B02E.4070605@ziu.info>
References: <389deec70901041707l1613a8e8jb6a6a3fbba57ea91@mail.gmail.com>	 <A20315AE59B5C34585629E258D76A97C0337C80B@34093-C3-EVS3.exchange.rackspace.com> <389deec70901050344t3216690i9ecd1350bbf016b4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <389deec70901050344t3216690i9ecd1350bbf016b4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hank peng <pengxihan@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hank peng wrote:
> I am new to this area, so I'm not quite familiar with some words what
> you mentioned.
> The machine has a SATA controller (chip is Marvell 6081) attached on
> PCI-X bus. Five SATA II disks are attached to it.
> Each disk has 500G space.
> The following is my procedure:
> #mdadm -C /dev/md0 -l5 -n5 /dev/sd{a,b,c,d,e}
> After recovery is done, I do this:
> #pvcreate /dev/md0
> #vgcreate myvg /dev/md0
> #lvcreate -n mylv -L 1000G myvg
> #mkfs.xfs /dev/myvg/mylv  or  #mkfs.reiserfs /dev/myvg/mylv
> mount this file system and begin to use it.
> I mainly want to optimise its sequential write performace, IOPs is not
> my concern.

When you create PV, it consists of usually initial 192KiB area with 
metadata (it can be controlled by --metadatasize option of pvcreate). 
Then extents follow (4MiB by default). As far as alignment is 
considered, the best case scenario is when extents are aligned with 
raid's stripe. It's possible in your case, but not generally - as 
extents must be power of 2.

Try:

pvcreate --metadatasize 250K /dev/md0 (250K will be rounded up properly)

...and verify

pvs /dev/md0 -o+pe_start

...you should get 256.00K under 1st PE. 256K, as it's your stripe's size 
(md defaults to 64KiB chunk, and you haven't altered it).

Most filesystems allow setting stripe and chunk parameters - ext{2,3,4}, 
xfs - to name a few. They are used to e.g. setup their structures more 
optimally, and avoid read-modify-write if at all possible. I don't know 
if reiser has such settings, but xfs certailny does (look for su/sw 
options of mkfs.xfs).

Note, that when you create filesystems on logical volumes, they will not 
detect under-the-lvm raid structure - you have to set that manually. If 
extents are not aligned, then any settings related to stripe will be 
meaningless (as filesystem assumes it starts are stripe boundary 
itself). Chunk size will [/might] still be useful though.

Another easily forgotten parameter is LV's readahead. If not set 
explicitly, it will default to 256, which is quite small value. You can 
change it with blockdev or lvchange (permanently with the latter). RA 
set on md0 directly doesn't matter afaik, unless you also plan to setup 
filesystems directly on it.

Check out /sys/class/block/md0/md/stripe_cache_size (or /sys/block/.. if 
you use old sysfs layout) and increase it, if you have memory to spare.

Increasing RA and stripe_cache_size can provide very significant boost. 
Forgetting about the former is often a cause for complains about lvm 
performance (when compared to md used directly).

There's definitely more to it (like specific filesystem's creation and 
mount options, or more basically - filesystem choice). Best wait for 
David's input.

