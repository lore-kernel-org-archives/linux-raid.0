From: Michal Soltys <nozo@ziu.info>
Subject: Re: RAID on partitions and partitions on RAID
Date: Sun, 29 Jul 2007 21:11:07 +0200
Message-ID: <46ACE64B.6030801@ziu.info>
References: <loom.20070727T225545-192@post.gmane.org> <46ABAC5A.2000103@ziu.info> <46ABB830.1000204@ziu.info> <loom.20070729T091941-198@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20070729T091941-198@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Cry Regarder <cry_regarder@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cry Regarder wrote:
> 
> Thanks!  A couple questions:
> 
> 1.  Are you sharing that spare with an other array?  If not, why not do a raid-6
> instead of a raid-5?
> 

No, the spare is not shared. Now that I think about it and you reminded 
about raid-6...

I can think of one small plus of my setup - that spare is not spinning
(it's stopped with sdparm -C stop). So the disk should be in almost unused
condition if the need for it arrives. Excluding vibrations from the rest of 
the disks, and barely active electronics.

> 2.  I noticed that you built your raid partitions on corresponding disk
> partitions.  Why do that instead of making one monolithic raid volume and then
> partitioning that into the desired pieces?
> 

few reasons:

1) I wanted /boot out of any raid
2) I wanted LVM for some of the partitions
3) I prefered regular mbr on the whole disks.
4) I wanted properly aligned XFS, so I can use its su/sw options

Alternatives:

- create separate md0 (for lvm) md1 (for xfs), but it seemed wrong when 
there is support for partitionable arrays
- or I could just put everything on lvm and don't bother with xfs alignment.

All things considered, it looked like a decent compromise. Of course, I'm 
open for suggestions.

> 
> 1.  Adjust the partition table on each of the component disks so that I can
> assemble the drives from /dev/sd?1 instead of /dev/sd?
> 

No can do here, afaik. When you assemble from /dev/sd? , there're no 
partitions to start with on those disks. Either way, I'm not aware of any 
tools allowing - shrink raid, shift it, create fitting mbr ...

> 2.  Adjust my /dev/md0 so that it is partitioned into /dev/md0_1 /dev/md0_2 or
> something of that ilk.
> 

No idea if you can easily switch from non-partitionable to partitionable raid.

