From: Stef Telford <stef@chronozon.artofdns.com>
Subject: Re: mdadm and raid5 hot-rebuild problem on 2.5.67
Date: Wed, 16 Apr 2003 02:13:09 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1050545634.13739.14.camel@testlin.hades>
References: <1050536716.13739.6.camel@testlin.hades>
	 <16028.46697.488363.56989@notabene.cse.unsw.edu.au>
	 <1050544298.13739.9.camel@testlin.hades>
	 <16028.47242.348607.436021@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16028.47242.348607.436021@notabene.cse.unsw.edu.au>
Date: 16 Apr 2003 22:13:54 -0400
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> raidstart!  Horrible tool.  Throw it away.
> 

consider it gone :)

> You will need
>    mdadm --assemble --force ....
> to start this array as it seems to have suffered an unclean shutdown
> while degraded.
> 

hrm, seems to not want to 'fly' to be honest...


[root@survivor stef]# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Fri Dec 20 14:45:52 2002
     Raid Level : raid5
    Device Size : 58633216 (55.92 GiB 60.04 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Apr 15 17:45:24 2003
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0      33        6        0      active sync  
/dev/ide/host2/bus0/target0/lun0/part6
       1      34        1        1      active sync  
/dev/ide/host2/bus1/target0/lun0/part1
       2       0        0       -1      removed
       3      57        1        3      active sync  
/dev/ide/host4/bus1/target0/lun0/part1
           UUID : 5bced80a:8f74bfa6:3e658b6a:46a5055d
         Events : 0.1895
[root@survivor stef]# mdadm --assemble --force /dev/md0
mdadm: device /dev/md0 already active - cannot assemble it
[root@survivor stef]# mdadm --manage /dev/md0 -a
/dev/ide/host4/bus0/target0/lun0/part2
mdadm: added /dev/ide/host4/bus0/target0/lun0/part2
[root@survivor stef]# mdadm --assemble --force /dev/md0
mdadm: device /dev/md0 already active - cannot assemble it
[root@survivor stef]# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Fri Dec 20 14:45:52 2002
     Raid Level : raid5
    Device Size : 58633216 (55.92 GiB 60.04 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Apr 15 17:45:24 2003
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0      56        2        0       
/dev/ide/host4/bus0/target0/lun0/part2
       1      34        1        1      active sync  
/dev/ide/host2/bus1/target0/lun0/part1
       2       0        0       -1      removed
       3      57        1        3      active sync  
/dev/ide/host4/bus1/target0/lun0/part1
           UUID : 5bced80a:8f74bfa6:3e658b6a:46a5055d
         Events : 0.1895

surely, when i -a a drive into the array, it should
'fit into' the removed slot on item '2', or does it
do that already and i am reading the output wrong :\

> > is there anything else you need or would like ?
> 
> Well, an answer to my original question would be nice:-)  You should
> have kernel logs of the time when you got "device busy" from "mdadm -a". 
> 

ah this being the rub, there isnt any oops or anything
like that in the kernel log when i get the device busy,
not even a 'device currently locked' or 'missing device'
from what i can see. sorry :\

> regards 
> Stef Telford <stef@chronozon.artofdns.com>

