From: "David M. Strang" <dstrang@shellpower.net>
Subject: Failed Hard Disk... help!
Date: Fri, 9 Jun 2006 19:36:42 -0400
Message-ID: <002801c68c1d$905a6020$7e0c10ac@enterprise.local>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all...

I'm looking for a suggestion or two... I have a server running with 2 
Western Digital WD4000YR drives running a RAID1 mirror... the other day, I 
was lucky enough to have one of the drives fail. Being as they are new(er) 
drives, they are still under warrenty, and I'm looking to do an advanced 
replacement RMA to swap the drive and allow it to rebuild. The problem is... 
I don't have the serial numbers of the hard drives. No big deal... except, 
they are SATA drives, and I'm running 2.6.14.6.... honestly, with the main 
drive of the mirror failed, I'm afraid to upgrade. I'm also afraid to 
upgrade, because I'm still using mdadm v2.2 with v1.00.02 superblocks. I had 
a recent raid disaster here at home (see another thread, long story short - 
every reboot, the raid 5 rebuilds... during one of those rebuilds, a disk 
really failed. bye bye data) - during all my attempts to recover from it, I 
upgraded to a newer mdadm and kernel, and it refused to recognize my raid 
superblocks! I had to revert to mdadm 2.2, and the old kernel to see the 
superblocks again (still... 26 of 28, did me little good... and forcing 27 
of 28 with 1 missing using the partially rebuilt disk, I think did even less 
good).

What options do I have to retreive the serial number without driving out to 
the datacenter and looking at the drive? Do I need to be afraid of upgrading 
my kernel and mdadm and having my superblock go poof?

-(root@xenogenesis)-(/)- # mdadm --version
mdadm - v2.2 - 5 December 2005
-(root@xenogenesis)-(/)- # mdadm --detail /dev/md_d0
/dev/md_d0:
        Version : 01.00.02
  Creation Time : Thu Jan  5 19:49:04 2006
     Raid Level : raid1
     Array Size : 390711376 (372.61 GiB 400.09 GB)
    Device Size : 390711376 (372.61 GiB 400.09 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Jun  9 19:04:40 2006
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : CRUX x64
           UUID : c622e6f7:2765c0fb:7516cdf1:3ee5b706
         Events : 13085584

    Number   Major   Minor   RaidDevice State
   -1428255432       0        0    10922      removed
       1       8       16        1      active sync   /dev/sdb
-(root@xenogenesis)-(/)- # uname -ar
Linux xenogenesis 2.6.14.6 #1 SMP Wed Jan 25 20:07:07 EST 2006 x86_64 x86_64 
x86_64 GNU/Linux
-(root@xenogenesis)-(/)- #

Thanks,
David M. Strang 

