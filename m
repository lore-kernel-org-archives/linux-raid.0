From: Ninti Systems <office@ninti.com.au>
Subject: RAID1 + rsync (2)
Date: 13 Aug 2004 18:24:22 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1092387262.3113.10.camel@localhost>
Reply-To: office@ninti.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sory about having to re-post, but that last email wasn't too well laid out ...

I'm looking at a method of creating maximum redundancy using software
RAID with four equal disks. I know that the most common advice is to do
RAID 5 if there are four disks and redundancy is required.

Still, redundancy really is more important to me than performance
(within reason of course). I know that a four disk RAID1 array
(including swap) built out of primary and secondary masters/slaves would
not perform well.

So I'm wondering if anyone has any comments on the following scenario,
or has tried it. Let's assume partitioning is /boot, swap and /(root):

1. Put /boot on a four disk RAID1 array across all disks (dev/md0).
2. Put swap on a two disk RAID1 array (primary and secondary masters)
(/dev/md1).
3. Put /(root) on a two disk RAID1 array (primary and secondary masters)
(/dev/md2).

So I end up with something like this (all RAID autodetect type):

/dev/md0 - /dev/hda1, /dev/hdb1, /dev/hdc1, /dev/hdd1
/dev/md2 - /dev/hda2, /dev/hdc2			
/dev/md2 - /dev/hda3, /dev/hdc3	

/dev/md0 - /boot
/dev/md2 - swap	
/dev/md2 - /
	


4. Configure the remaining /dev/hdb2 and /dev/hdd2 partitions as normal swap
partitions.
5. Configure and format the remaining /dev/hdb3 and /dev/hdd3 partitions as
normal ext2 partitions.
6. Run rsync daily to mirror /(root) on /dev/md2 to both /dev/hdb3 and
/dev/hdd3.

I'm hoping that this would create something like a four disk RAID1 array
with the performance of a two disk RAID1 array, and that in theory up to
3 of 4 disks could fail but a usable system would still be bootable
(even if it may be the case that the system may only be as up to date as
the last rsync process). I realise that depending on which disk(s)
failed, I may have to fiddle lilo and/or fstab to boot a running system.

Does this idea have wheels, or am I overlooking some fatal flaw?

Thanks
Mick


-- 
--------------------------------------
Ninti Systems: Smart IT Solutions
Michael Hall
Mobile: 0429 095 392
Ph/Fax: 08 8953 1442       
Email:  office at ninti dot com dot au
Web:    http://ninti.com.au
--------------------------------------
