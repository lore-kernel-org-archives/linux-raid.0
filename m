From: hansbkk@gmail.com
Subject: old filesystem label remaining after partition --add 'ed?
Date: Wed, 16 Feb 2011 12:44:46 +0700
Message-ID: <AANLkTikcYz+AYXQBm+BhcjM1SkvDnR=-x58jLbyGB+2d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I replaced a RAID6 member drive that hadn't been fully zero'd, had the
same partitioning layout as the previous one.

The target partition had previously had an ext3 filesystem on it for
temporary moving/copying files around, with an e2label on it.

I added the partition to the array with "mdadm /dev/md_raid6a --add
/sde4", and let it rebuild, all looks good both via -D and
/proc/mdstat

Later on, I noticed that that partition still has the e2label on it? I
know my RAID1's show the label same as if it's a regular partition,
but I've always got a "bad magic" message back from checking for a
label on a RAID5/6 array member partition.

I'm assuming this is just cosmetic, but it bothers my (probably OCD)
sense of order, so I thought I'd check in here.

I don't even know a command to remove an existing filesystem other
than zeroing out the MBR/partition table - and in this case I didn't
want to disturb data in the other partitions. I supposed I could have
formatted it as ntfs or something, but that doesn't seem right.

Any advice/comments welcome, especially if anyone thinks this isn't
just a cosmetic problem.
