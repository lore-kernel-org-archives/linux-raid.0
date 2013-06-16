From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Please assist with missing RAID 5 array.
Date: Sun, 16 Jun 2013 22:17:04 +0100
Message-ID: <20926.11088.591519.854183@tree.ty.sabi.co.uk>
References: <E1156523F009E84DA3511789DCE62C8D018D8B76B3@EXCHANGE.paulalima.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1156523F009E84DA3511789DCE62C8D018D8B76B3@EXCHANGE.paulalima.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]
> DEVICE /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdb
> ARRAY /dev/md0 level=raid5 devices=/dev/sdb,/dev/sdc,/dev/sdd,/dev/sde,/dev/sdb

> ...Strangely /dev/sdb shows twice.
[ ... ]
> Jun 16 09:27:23 localhost kernel: md: bind<sdd>
> Jun 16 09:27:23 localhost kernel: md: bind<sdb>
> Jun 16 09:27:23 localhost kernel: md: bind<sdc>
> Jun 16 09:27:23 localhost kernel: md: bind<sde>
> Jun 16 09:27:23 localhost kernel: md: kicking non-fresh sdd from array!
> Jun 16 09:27:23 localhost kernel: md: unbind<sdd>
> Jun 16 09:27:23 localhost kernel: md: export_rdev(sdd)
[ ... ]
> Jun 16 09:27:23 localhost kernel: md/raid:md0: device sde operational as raid disk 3
> Jun 16 09:27:23 localhost kernel: md/raid:md0: device sdc operational as raid disk 1
> Jun 16 09:27:23 localhost kernel: md/raid:md0: allocated 4282kB
> Jun 16 09:27:23 localhost kernel: md/raid:md0: not enough operational devices (2/4 failed)
[ ... ]
> ... note that this time the drives were recognized as standard
> drives not md array components.
[ ... ]
> [root@localhost ~]# mdadm --examine /dev/sd[bcde]
> /dev/sdb:
>    MBR Magic : aa55
> Partition[0] :   2930277167 sectors at            1 (type ee)
[ ... ]

The above seems rather confused, and we hope that you have
backups.

There are many pages on the web on how to sort out "kicking
non-fresh" situations (note the big difference between RAID1 and
RAID5/RAID6), and indeed event counts are relevant.

It is strange that 'sd[bcde]' are bound, but 'sdb' is not listed
as being part of the RAID set.

But the strangest thing is that after you unplugged/plugged the
drives now 'sd[bcde]' seem to come up as GPT partitioned drives,
rather than MD members, at least according to 'mdadm --examine'.

You should check in which order which drives came up, because
the Linux kernel does not guarantee that drives will be assigned
minor numbers in any given order (that is 'sd[abcde]' could be
completely different drives every time you boot).

Looking at '/proc/partitions' and using 'disktype /dev/sd?' and
'blkid | sort -k 2,2' will help you figure out what's on your
disks, and where the RAID set members are. Since these are
identified by their MD metadata, in whichever order they are
listed does not matter.
