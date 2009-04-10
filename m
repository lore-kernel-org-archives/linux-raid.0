From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Converting system to raid
Date: Fri, 10 Apr 2009 14:26:26 -0700
Message-ID: <00f301c9ba23$032025f0$0a00a8c0@vorg>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg> <49DF0D06.8030705@musmo.com> <20090410195303.GB21242@cthulhu.home.robinhill.me.uk> <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Strange:
-----------------
sudo mdadm -D /dev/md0
/dev/md0:
        Version : 00.90
  Creation Time : Fri Mar 27 16:49:37 2009
     Raid Level : raid1
     Array Size : 24418688 (23.29 GiB 25.00 GB)
  Used Dev Size : 24418688 (23.29 GiB 25.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Apr 10 12:58:59 2009
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 27ce9bd9:4ce6ceb2:670e265f:82e0c670 (local to host LLLx64-32)
         Events : 0.38

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
-----------------

Seems ok, but then:
-----------------
sudo mdadm -E /dev/md0
mdadm: No md superblock detected on /dev/md0.
-----------------
----- Original Message ----- 
From: "Robin Hill" <robin@robinhill.me.uk>
To: <linux-raid@vger.kernel.org>
Sent: Friday, April 10, 2009 1:59 PM
Subject: Re: Converting system to raid

> As for the other reply, the sata drives each have 3 primary partitions
> all set to type fd and formated with ext3. I was going to try ext4 for
> the main storage of the newer system but I found there is a problem
> with kernels .27 and newer on nforce2 and newer boards. some sort of
> problem with the bios and apci. How do I find out which superblocks
> version is used?
> 
Either "mdadm -D" on the array, or "mdadm -E" on one of the partitions
will show you the version.

Cheers,
    Robin
-- 
     ___        
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

