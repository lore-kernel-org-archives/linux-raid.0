From: Cry Regarder <cry_regarder@yahoo.com>
Subject: Re: RAID on partitions and partitions on RAID
Date: Sun, 29 Jul 2007 07:26:14 +0000 (UTC)
Message-ID: <loom.20070729T091941-198@post.gmane.org>
References: <loom.20070727T225545-192@post.gmane.org> <46ABAC5A.2000103@ziu.info> <46ABB830.1000204@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michal Soltys <nozo <at> ziu.info> writes:

> 
> Michal Soltys wrote:
> >>
> > one hot spare. Each disk is partitioned in the same way - 64mb boot 
> > partition identical on each disk, and each disk is bootable (sdX1), swap 
> > (sdX2), partitionable (sdX3). sd[abcde]3 raid has GPT partition - 1st 
> > one is used by LVM2 for the usual stuff (root,usr,var,home.. "just" 24GB 
> 

Thanks!  A couple questions:

1.  Are you sharing that spare with an other array?  If not, why not do a raid-6
instead of a raid-5?

2.  I noticed that you built your raid partitions on corresponding disk
partitions.  Why do that instead of making one monolithic raid volume and then
partitioning that into the desired pieces?

Since I already built my array, I don't want to dump, rebuild, and restore at
this time.  What I'd like to do is do two small (I don't know if they are small
actually) to my system:

1.  Adjust the partition table on each of the component disks so that I can
assemble the drives from /dev/sd?1 instead of /dev/sd?

2.  Adjust my /dev/md0 so that it is partitioned into /dev/md0_1 /dev/md0_2 or
something of that ilk.

I see now that I could have built it that way from the start, but is it too late
to convert?

Thanks!

Cry

