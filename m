From: Michal Soltys <nozo@ziu.info>
Subject: Re: RAID on partitions and partitions on RAID
Date: Sat, 28 Jul 2007 22:51:38 +0200
Message-ID: <46ABAC5A.2000103@ziu.info>
References: <loom.20070727T225545-192@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20070727T225545-192@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Cry Regarder <cry_regarder@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cry Regarder wrote:

> 
> Partitions on RAID:
> 
> Back to when I constructed the array, I placed an ext3 partition directly on
> /dev/md0.  Since construction, I have expanded the array by two disks, but have
> not at this time resized the ext3 partition.  
> 
> What I would like to do is put a swap partition and XFS partition into that 1TB
> free space.  However, I have no idea how to go about doing that.  If I had
> originally used LVM, it would be easy, but I had read about some performance
> hits re ext3 on lvm on raid so I decided to be "simple".  Any advice?
> 

When I was doing recently some tests, I haven't noticed any significant 
performance differences if lvm2 is between filesystem and raid, or not. Note 
  though, that my tests weren't too extensive (yet). Also, I use large lv 
extents  - 512MiB.

Either way, you can use partitionable raid arrays. Today I've set following 
config on one of the new machines: raid 5 from 4x500GB disks + one hot 
spare. Each disk is partitioned in the same way - 64mb boot partition 
identical on each disk, and each disk is bootable (sdX1), swap (sdX2), 
partitionable (sdX3). sd[abcde]3 raid has GPT partition - 1st one is used by 
LVM2 for the usual stuff (root,usr,var,home.. "just" 24GB assigned here), 
the 2nd one is big XFS for my space-hungry users. The XFS partition is 
carefully aligned to be always on the stride boundary, up to 9 disks (as I 
plan do add new disks and grow that XFS later, while having its su/sw 
properly set).

You will of course need initramfs to boot from something like that. 
Depending on your distro (and how much can you dig into its config files), 
YMMV. (small remark - udev and mdadm, depending on their rules, might get in 
one others way - check / adjust both of them carefully).


