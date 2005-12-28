From: Sebastian Kuzminsky <seb@highlab.com>
Subject: Re: raid1: All my data completely vanished into the void
Date: Tue, 27 Dec 2005 22:59:54 -0700
Message-ID: <E1ErULq-0007Nu-5l@highlab.com>
References: <200512280030.51387.mlaks@verizon.net>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <200512280030.51387.mlaks@verizon.net> 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mitchell Laks <mlaks@verizon.net> wrote:
> What does doing
> 
> mdadm -Cv -n2 -l1 /dev/md0 /dev/sda /dev/sdb
> 
> do to the partition tables??? 
> (And why can I still access the data if I messed up the partitions??? very 
> odd).
> Can you point me at an explanation of the effects of what I did?

I'd expect that command to overwrite the partition table with the
MD metadata, or at least put the partition table at risk of being
overwritten later.

No problem, as long as you're aware of it.  That's how I usually set
my RAID disks up - no partition table, just use the whole disk raw.
LVM is a better solution to the partitioning problem.


-- 
Sebastian Kuzminsky
