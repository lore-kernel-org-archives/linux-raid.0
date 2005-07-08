From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: Degraded raid5 returns mdadm: /dev/hdc5 has no superblock - assembly aborted
Date: Fri, 08 Jul 2005 13:38:48 +1000
Message-ID: <874qb6m0fr.fsf@enki.rimspace.net>
References: <42CDE44C.9020804@phys.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8 Jul 2005, Melinda Taylor wrote:
> We have a computer based at the South Pole which has a degraded raid 5
> array across 4 disks. One of the 4 HDD's mechanically failed but we have 
> bought the majority of the system back online except for the raid5 
> array. I am pretty sure that data on the remaining 3 partitions that 
> made up the raid5 array is intact - just confused. The reason I know 
> this is that just before we took the system down, the raid5 array 
> (mounted as /home) was still readable and writable even though 
> /proc/mdstat said:

[...]

> /*[root@planet mdadm-1.12.0]# mdadm --assemble --force /dev/md2 
> /dev/hdd5 /dev/hda5 /dev/hdb5 /dev/hdc5
> mdadm: no RAID superblock on /dev/hdc5
> mdadm: /dev/hdc5 has no superblock - assembly aborted
>
> *//dev/hdc is the new disk I have just installed to replace the failed
> one (/dev/hda). I have parititioned it correctly and in fact one 
> partition on /dev/hdc1 is now happily part of another raid1 set on the 
> system so I know all is good with /dev/hdc

What you want to do is start the array as degraded, using *only* the
devices that were part of the disk set.  Substitute 'missing' for the
last device if needed but, IIRC, you should be able to say just:

] mdadm --assemble --force /dev/md2 /dev/hd[abd]5

Don't forget to fsck the filesystem thoroughly at this point. :)

Once the array is up and running, you *then* add the new disk to it by
saying:

] mdadm -a /dev/md2 /dev/hdc5

The array will then recover and, hopefully, life is good.

    Daniel
-- 
Anyone who goes to a psychiatrist ought to have his head examined.
        -- Samuel Goldwyn

