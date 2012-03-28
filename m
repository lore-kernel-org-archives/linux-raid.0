From: "Paramasivam, Meenakshisundaram" <mparamas@iupui.edu>
Subject: mdadm raid6 recovery status
Date: Wed, 28 Mar 2012 02:22:33 +0000
Message-ID: <B2B36B3006DB4C47A56D6BA19443F5D12DCEB542@IU-MSSG-MBX110.ads.iu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi,

We have 8 disks (8x2TB=16TB) on an enclosure, with mdadm raid 6 serving ~12TB volume 
from a SATA JBOD through 2 e-SATA ports to host machine. We  used up 7 TB. One of e-SATA port 
connecting 4 drives did not respond on controller, possibly due heat issues from adjacent video card 
FX4800, or the controller momentarily went bad since we also had power glitches on multiple machines 
at the same time. This incident made mdadm to report the 4 drives  with "removed" status. After 
relocating the card inside the machine and rebooting, all of the drives physically came up fine. 
Now I was hoping to get 7 TB of data back, and I did:

#mdadm --assemble --scan
mdadm: /dev/md2 assembled from 4 drives - not enough to start the array.

Now I wanted to recover the data, so I did the following steps. I see 
only 2 TB of 7 TB now when I mount. I know that data is still on drives 
and I did not zero-superblock on any of the drives. How do I get data 
back, reliably and quickly? Using mdadm v3.1.2  on FC14. Any pointers/suggestions
 is very much appreciated. Thanks. 

#mdadm -v --assemble --force /dev/md2 /dev/sd{b,c,d,e,f,g,h,i}
mdadm: looking for devices for /dev/md2
mdadm: /dev/sdb is identified as a member of /dev/md2, slot 0.
mdadm: /dev/sdc is identified as a member of /dev/md2, slot 1.
mdadm: /dev/sdd is identified as a member of /dev/md2, slot 2.
mdadm: /dev/sde is identified as a member of /dev/md2, slot 3.
mdadm: /dev/sdf is identified as a member of /dev/md2, slot 4.
mdadm: /dev/sdg is identified as a member of /dev/md2, slot 5.
mdadm: /dev/sdh is identified as a member of /dev/md2, slot 6.
mdadm: /dev/sdi is identified as a member of /dev/md2, slot 7.
mdadm: forcing event count in /dev/sdh(6) from 220810 upto 220815
mdadm: forcing event count in /dev/sdf(4) from 220809 upto 220815
mdadm: forcing event count in /dev/sdi(7) from 220809 upto 220815
mdadm: clearing FAULTY flag for device 4 in /dev/md2 for /dev/sdf
mdadm: clearing FAULTY flag for device 6 in /dev/md2 for /dev/sdh
mdadm: clearing FAULTY flag for device 7 in /dev/md2 for /dev/sdi
mdadm: added /dev/sdc to /dev/md2 as 1
mdadm: added /dev/sdd to /dev/md2 as 2
mdadm: added /dev/sde to /dev/md2 as 3
mdadm: added /dev/sdf to /dev/md2 as 4
mdadm: added /dev/sdg to /dev/md2 as 5
mdadm: added /dev/sdh to /dev/md2 as 6
mdadm: added /dev/sdi to /dev/md2 as 7
mdadm: added /dev/sdb to /dev/md2 as 0
mdadm: /dev/md2 has been started with 7 drives (out of 8).

# mdadm -D /dev/md2
/dev/md2:
        Version : 0.90
  Creation Time : Fri Dec 16 17:56:14 2011
     Raid Level : raid6
     Array Size : 11721086976 (11178.10 GiB 12002.39 GB)
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
   Raid Devices : 8
  Total Devices : 7
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Mon Mar 26 13:53:25 2012
          State : clean, degraded

 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K
           UUID : 4fcdcafa:fea0c196:4d5dd1d0:da2b21e5
         Events : 0.220827

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3       8       64        3      active sync   /dev/sde
       4       8       80        4      active sync   /dev/sdf
       5       0        0        5      removed
       6       8      112        6      active sync   /dev/sdh
       7       8      128        7      active sync   /dev/sdi

# mdadm /dev/md2 -a /dev/sdg
mdadm: re-added /dev/sdg

This step took 24 hrs to rebuild
#mdadm --stop

#mdadm --assemble --scan
        where /etc/mdadm.conf has a line
            ARRAY /dev/md2 level=raid6 num-devices=8 \
                       devices=/dev/sdb,/dev/sdc,/dev/sdd,/dev/sde,/dev/sdf,/dev/sdg,/dev/sdh,/dev/sdi
            [yes no partitions, had been thsi way and has always worked]

#mount   /dev/md2   /myarray
mounts fine, however, I now see only 2TB instead of 7 TB for /myarray. I need to get all of the data back and I am stuck here.

Sundar







