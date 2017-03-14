From: Alfred Matthews <asm13243546@gmail.com>
Subject: Re: on assembly and recovery of a hardware RAID
Date: Tue, 14 Mar 2017 13:27:14 -0400
Message-ID: <CAAZLhTcEhn2GezDSDJHOLv2VNSynzT-he0FRrVNbz1xtakLsMQ@mail.gmail.com>
References: <CAAZLhTdaVM4fagN5=bqWpPx-DjyU6UZ69bJFf51FWMX7oeyJNw@mail.gmail.com>
 <87tw6weubu.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87tw6weubu.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Does
>   dmraid -b /dev/sda /dev/sdb /dev/sdc
> tell you anything useful?
>

# dmraid -b /dev/sdb /dev/sdc
/dev/sdc:   5860533168 total, "WD-WCAWZ2927144"
/dev/sdb:   5860533168 total, "WD-WCAWZ2939730"

>
> You will probably want a command like:
>
>  mdadm --build /dev/md0 -l0 -n2 --chunk=SOMETHING /dev/sdXX /dev/sdYY
>
> where SOMETHING is the chunk size. e.g. 64K or 512K or something.
> Doing this is non-destructive so you can try several different times,
> using "mdadm --stop /dev/md0" to reset before trying again.
>

# mdadm --build /dev/md0 -l0 -n2 --chunk=512K /dev/sdb1 /dev/sdc1
mdadm: array /dev/md0 built and started.

> After building the array, try "cfdisk /dev/md0" or maybe "fdisk
> /dev/md0" to look at the partition table.
>

#fdisk /dev/md0

Command (m for help): p
Disk /dev/md0: 400 MiB, 419430400 bytes, 819200 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 524288 bytes / 1048576 bytes
Disklabel type: dos
Disk identifier: 0x00000000

> What filesystem(s) did you have on the device?

In fact, I'm insufficiently familiar with fsck to know why it's
reporting fsck-fat, except to suppose that that's the bootsector
format. The data partitions themselves are Apple RAID and presumed HFS
something.

Maybe "fsck -n /dev/md0p1"
> might tell you if the filesystem looks OK.
>

# fsck -n /dev/md0
fsck from util-linux 2.28.2
fsck.fat 4.0 (2016-05-06)
FATs differ - using first FAT.
Cluster 126974 out of range (43014379 > 403267). Setting to EOF.
Cluster 126975 out of range (2114643 > 403267). Setting to EOF.
Cluster 126976 out of range (3419700 > 403267). Setting to EOF.
Cluster 126977 out of range (2097410 > 403267). Setting to EOF.
Cluster 126980 out of range (1048608 > 403267). Setting to EOF.
Cluster 126982 out of range (409600 > 403267). Setting to EOF.
Cluster 126990 out of range (19464192 > 403267). Setting to EOF.
Cluster 126991 out of range (91280919 > 403267). Setting to EOF.
Cluster 126992 out of range (2115910 > 403267). Setting to EOF.
Cluster 126993 out of range (2105376 > 403267). Setting to EOF.
Cluster 126994 out of range (21372960 > 403267). Setting to EOF.
Cluster 126995 out of range (3289940 > 403267). Setting to EOF.
Cluster 126996 out of range (33169440 > 403267). Setting to EOF.
Cluster 126997 out of range (214994624 > 403267). Setting to EOF.
Cluster 126998 out of range (251362304 > 403267). Setting to EOF.
Cluster 127000 out of range (164004702 > 403267). Setting to EOF.
Cluster 127001 out of range (201328571 > 403267). Setting to EOF.
Cluster 127002 out of range (79725740 > 403267). Setting to EOF.
Cluster 127003 out of range (219067398 > 403267). Setting to EOF.
Cluster 127004 out of range (16116496 > 403267). Setting to EOF.
Cluster 127005 out of range (219598308 > 403267). Setting to EOF.
Cluster 127006 out of range (235539737 > 403267). Setting to EOF.
Cluster 127007 out of range (53309039 > 403267). Setting to EOF.
Cluster 127008 out of range (91517817 > 403267). Setting to EOF.
Cluster 127009 out of range (157556845 > 403267). Setting to EOF.
Cluster 127010 out of range (168651635 > 403267). Setting to EOF.
Cluster 127011 out of range (56980048 > 403267). Setting to EOF.
Cluster 127012 out of range (241246323 > 403267). Setting to EOF.
Cluster 127013 out of range (90906745 > 403267). Setting to EOF.
Cluster 127014 out of range (259268729 > 403267). Setting to EOF.
Cluster 127015 out of range (40202784 > 403267). Setting to EOF.
Cluster 127016 out of range (225734511 > 403267). Setting to EOF.
Cluster 127101 out of range (173342720 > 403267). Setting to EOF.
Cluster 127102 out of range (23155282 > 403267). Setting to EOF.
Cluster 127223 out of range (21066354 > 403267). Setting to EOF.
Cluster 127229 out of range (173342720 > 403267). Setting to EOF.
Cluster 127742 out of range (43014379 > 403267). Setting to EOF.
Cluster 127743 out of range (2114643 > 403267). Setting to EOF.
Cluster 127744 out of range (3419700 > 403267). Setting to EOF.
Cluster 127745 out of range (2097410 > 403267). Setting to EOF.
Cluster 127748 out of range (1048608 > 403267). Setting to EOF.
Cluster 127750 out of range (409600 > 403267). Setting to EOF.
Cluster 127758 out of range (19464192 > 403267). Setting to EOF.
Cluster 127759 out of range (91280919 > 403267). Setting to EOF.
Cluster 127760 out of range (2115910 > 403267). Setting to EOF.
Cluster 127761 out of range (2105376 > 403267). Setting to EOF.
Cluster 127762 out of range (21372960 > 403267). Setting to EOF.
Cluster 127763 out of range (3289940 > 403267). Setting to EOF.
Cluster 127764 out of range (33169440 > 403267). Setting to EOF.
Cluster 127765 out of range (214994624 > 403267). Setting to EOF.
Cluster 127766 out of range (251362304 > 403267). Setting to EOF.
Cluster 127768 out of range (164004702 > 403267). Setting to EOF.
Cluster 127769 out of range (201328571 > 403267). Setting to EOF.
Cluster 127770 out of range (79725740 > 403267). Setting to EOF.
Cluster 127771 out of range (219067398 > 403267). Setting to EOF.
Cluster 127772 out of range (16116496 > 403267). Setting to EOF.
Cluster 127773 out of range (219598308 > 403267). Setting to EOF.
Cluster 127774 out of range (235539737 > 403267). Setting to EOF.
Cluster 127775 out of range (53309039 > 403267). Setting to EOF.
Cluster 127776 out of range (91517817 > 403267). Setting to EOF.
Cluster 127777 out of range (157556845 > 403267). Setting to EOF.
Cluster 127778 out of range (168651635 > 403267). Setting to EOF.
Cluster 127779 out of range (56980048 > 403267). Setting to EOF.
Cluster 127780 out of range (241246323 > 403267). Setting to EOF.
Cluster 127781 out of range (90906745 > 403267). Setting to EOF.
Cluster 127782 out of range (259268729 > 403267). Setting to EOF.
Cluster 127783 out of range (40202784 > 403267). Setting to EOF.
Cluster 127784 out of range (225734511 > 403267). Setting to EOF.
Cluster 127869 out of range (173342720 > 403267). Setting to EOF.
Cluster 127870 out of range (23155282 > 403267). Setting to EOF.
Cluster 127991 out of range (21066354 > 403267). Setting to EOF.
Cluster 127997 out of range (173342720 > 403267). Setting to EOF.
Cluster 131070 out of range (268435440 > 403267). Setting to EOF.
Reclaimed 93 unused clusters (47616 bytes).
Leaving filesystem unchanged.
/dev/md0: 0 files, 1/403266 clusters

Thanks for your comments so far.

Al.

> NeilBrown
