From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: mbr-install for Raid 1
Date: Tue, 05 Oct 2004 13:08:19 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41626483.60505@tls.msk.ru>
References: <20041005093440.2b639e71@zrr.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041005093440.2b639e71@zrr.local>
To: "Zeno R.R. Davatz" <zdavatz@ywesee.com>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[I'm getting quite some questions similar to this
  one -- so instead of replying to every and each,
  I'm posting to linux-raid@, to be able to refer to
  this post in the future... ;)]

Zeno R.R. Davatz wrote:
> Hi!
> 
> I am just reading a post of yours regarding using 'install-mbr' for linux-raid.
> 
> Something I do not understand about the post:
> http://lists.debian.org/debian-testing/2004/04/msg00054.html
> 
> is following:
> "mark your boot raid partitions active...". What do you mean by that?

Set the partitions (single partition on every disk) where your root raid
device resides to be active with fdisk.

> Do you mean to mark all the first partitions of all the disks /dev/sd[abcd]1 as boot with fdisk?

Not necessary first ones, but it is simpler to have your root fs on
first partition.  Again, it is the root-raid partition that should
be active.

> In that case I would have to do install-mbr /dev/md0 --force

No, you would have to use boot=/dev/md0 in your lilo.conf,
and install-mbr /dev/sd[abcd]1.

> Is that correct?

Basically, the scenario is as follows.

Standard mbr (master boot record) from mbr package (note lilo also
have it, see lilo -M) is installed into standard place (where BIOS
will expect it to be) into all your disks once (don't forget to
install the same mbr when you plug new disk).  The mbr code (it
resides on the first sector of the disk) works by reading partition
table, finding partition marked as "active" (or "boot" -- the same
flag but different terminology), loading boot record from that
partition and executing it.  Mbr code is stable and you don't have
to change it -- the first sector of your disks will never change.
In contrast, you will do eg kernel upgrades and similar stuff,
for which lilo boot tables needs to be refreshed, and that should
be done on all disks (to be able to boot off any disk in case
first one fails).  For this to work, you set up lilo to write
it's boot record into the device where your root filesystem is --
it is raid1 array created off all active (boot) partitions of
all your disks.  Lilo writes boot record into the beginning of
md0, and raid code propagates that boot record into your disks,
all of them -- remember, md0 is composed of active partitions
on all your disks -- this is exactly the place where mbr code
will look for the bootloader.

So, you have the same mbr code on all your disks (installed
once when you configure each disk), and "second-stage" boot
record, installed by lilo into md0 and again propagated to
all disks (into active or boot partition of each), which will
be loaded by mbr -- this boot record will be updated -- on
all disks -- when you re-run lilo.  In case any disk fails,
you have the same boot code and sequence on every other disk,
so you could boot off any working, non-failed disk.

But be warned -- boot (active) partition on every disk should
be at the exactly same place, or else file offsets written by
lilo will be valid for one disk but not valid for other.

/mjt
