From: Christian <cjs703@gmail.com>
Subject: Re: RAID6 array won't start
Date: Fri, 11 Feb 2011 18:37:06 -0500
Message-ID: <AANLkTikrnrerHoYKS6dQ5fK6eqUY7vO1ntOAWYgBJN0j@mail.gmail.com>
References: <AANLkTimLfJHc2waPkvjUXn=mewc37qkCd-r0GG4k=e-D@mail.gmail.com>
	<AANLkTi=dtMbuszU3x_hGduN-y5ATbgD0tgby_2mj4YsH@mail.gmail.com>
	<20110212074904.41e113ed@notabene.brown>
	<AANLkTikmCmutS_96PNYR0RKAv07cG5Vje0kyzzQ7U9rd@mail.gmail.com>
	<20110212083224.6b1c2cee@notabene.brown>
	<AANLkTi=Y7zf9v6dobfWj-z97FSfkVk2FpWT9Yi4MMKMr@mail.gmail.com>
	<AANLkTi=em0Wkj48SOECZqSuyJ01AwDnDdE76aQPzWiTp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=em0Wkj48SOECZqSuyJ01AwDnDdE76aQPzWiTp@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok problem solved!! The array and data are back!! With the help of
some of the guys on #linux-raid on freenode I went ahead and ran
--create on the array.  If anyone else happens to have the same issue
here is what I did.

First I backed up all the examine info by doing:
# mdadm -E /dev/sd[efgklmqrst]1 > examineinfo

And then I backed up the superblocks at the end of the disk by first
running fdisk to get the size, and then using dd
# fdisk /dev/sdt
   Device Boot      Start         End      Blocks   Id  System
/dev/sdt1            2048  3907029167  1953513560   fd  Linux raid autodetect

Took the total block numbers and then just skipped to the end by
dropping a 0 in the thousands column.  It's not exactly the superblock
but should be enough to have a backup in case things get really nasty
later.

# for i in sdm sdt sdr sds sdq sdk sdf sdg sdl sde; do dd if=/dev/$i
of=$i.tail skip=1953510560 bs=1k; done

And then I issued the create command, making sure it matched the info
from examine, and the drives letters were in order sequentially from 0
to 9, leaving out the two disks that dropped originally that were
marked with lower event counts.

# mdadm --create --metadata=0.90 --assume-clean --verbose --level=6
--raid-devices=10 --chunk=64 /dev/md1 missing /dev/sdt1 /dev/sdr1
missing /dev/sdq1 /dev/sdk1 /dev/sdf1 /dev/sdg1 /dev/sdl1 /dev/sde1

After executing this I have:
# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : active raid6 sde1[9] sdl1[8] sdg1[7] sdf1[6] sdk1[5] sdq1[4]
sdr1[2] sdt1[1]
      15628107776 blocks level 6, 64k chunk, algorithm 2 [10/8] [_UU_UUUUUU]

When attempting to mount the ext4 fs it initially failed, didn't
recognize the fs at all, but after:

# fsck /dev/md1

It fixed up the journal, etc and I'm now able to mount the file system
with all the data in tact!

I'm not completely out of the woods yet since I have to re-add 2
disks, but as of now everything looks great.
