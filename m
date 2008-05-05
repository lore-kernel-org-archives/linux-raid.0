From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: Resize / file system and create /home in existing raid 1
Date: Mon, 5 May 2008 22:53:48 +0100
Message-ID: <18463.33260.564139.783585@tree.ty.sabi.co.uk>
References: <5a3dd2390805051335s7b163505w5d94206dcb56b8a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5a3dd2390805051335s7b163505w5d94206dcb56b8a4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... reshaping from ... ]

> - / is in a Raid 1 array (/dev/md0) consisting of two
>   partitions - sda1 and sdb1 (ca. 148 GB);
> - swap in Raid 0 (/dev/md1) - sda2 and sdb2 of ca. 1 GB each
>   giving me 2 GB in total:

[ ... to ... ]

> - resize the partition containing the / file system to 27 GB
>   keeping it in RAID 1 (/dev/md0);
> - create a new partition of 120GB to mount /home, also in RAID
>   1 (/dev/md2);
> - change swap from a RAID 0 to a RAID 1, resizing it to 2GB
>   (/dev/md1).

Separating '/' and '/home' is a good idea. RAID swap, either
RAID0 or RAID1, is usually pointless. RAID1 swap is only useful
if you have really demanding availability requirements.

> Can this be done without reinstalling everything from scratch?

You have two mirrored disks so it is trivial.

Break the mirroring, repartition 'sdb' say into 'sdb[123]',
'mkfs' the 'sdb[13]' partitions, 'mkswap' the 'sdb2' partition,
copy stuff from 'sda1' to 'sdb1' and 'sdb3', reboot from 'sdb1'
without any RAID, repartition 'sda' in the same way as 'sdb',
then recreate new RAID mirrors ('md0' as 'sda1' and 'sdb1'
etc.). You can do much the same from a live CD eliminating the
obvious steps.

Resizing is dangerous, shrinking is very dangerous, and most
filesystems don't support shrinking anyhow.

> Output of /proc/mdstat: [ ... ]

Why so much pointless stuff...
