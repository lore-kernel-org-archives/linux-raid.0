From: Trevor Cordes <trevor@tecnopolis.ca>
Subject: RAID 6 corruption : please help!
Date: Wed, 5 Oct 2005 10:26:38 -0500
Message-ID: <20051005152638.GA24382@pog.tecnopolis.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I'm in a dire situation.  I need some advice.  If you are knowledgable,
please help.  If you are knowledgable but busy, I can arrange to pay for
your help.

I was rebuilding my file server to switch some disks around and add new
ones.  I have a 2TB RAID6 array.  I was removing 2 components of the array
and adding 2 new ones.  I'm using FC3 2.6 kernel and mdadm for all 
operations.

I took out the 2 decommissioned drives and put in the 2 new ones.

I hotadded the 2 new ones like: mdadm -a /dev/md3 /dev/hd[qs]2 (mistake 
#1?)

md0-2 were still being rebuilt from other work I was doing (they are root, 
boot and swap) so mdstat showed md3 as being "delayed" for rebuild.  md3 
shares 2 disks with the RAID 1 root/boot/swap.

I mounted md3 rw and was able to access/write to it no problems (mistake 
#2?).

I had to reboot to change the NIC (it's a long story), and since md0 was 
still being rebuilt and md3 had NOT started rebuilding, I thought it would 
be ok (mistake #3?).

Rebooted and md0 started rebuilding again.  md3 still said it was waiting 
before rebuilding.

On boot up I got some very weird behaviour from md3.  Logs showed md3 was
operational with 9 of 10 disks (fd:1) including one of the new ones (q)
that had not been synched yet!  It also said hds2 was a spare, and it said
hdq2 was operational?!  I tried to mount ro and it failed with the usual
filesystem-corrupted errors you get when you're majorly screwed.

If I look at a hexdump of hdq2 and hds2 I can see that some data was 
written to these yet-to-be-rebuilt drives... probably in the places where 
I was writing when it was mounted rw?

The important thing in my mind is I know for sure that no rebuild was ever
started on md3, because md0 was always rebuilding.  I had mdadm --stop 
md3 before md0 ever finished and have not added it back in without 
restarting a rebuild on md0 again.

I'm trying to figure out what exactly occurred so I can try to undo it.  
I'm very good at data recovery and hex editors and such, having saved many 
a RAID5 dual-disk failure scenario, even with corrupted partition tables.  
I just can't understand what RAID6 was doing.

I know all the data is just sitting there, there's just some wackiness to 
the way it's been spread across the disks.

Please help!  Please email, I can provide a phone # if you think that will 
help you help me.  Thanks!
