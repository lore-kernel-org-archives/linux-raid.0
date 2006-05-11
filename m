From: Guido Moonen <guido.moonen@axon.tv>
Subject: RAID5 - 4 disk reboot trouble.
Date: Thu, 11 May 2006 13:46:25 +0200
Message-ID: <44632411.7020102@axon.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm running a raid5 system, and when I reboot my raid seems to be 
failing. (One disk is set to spare and other disk seems to be oke in the 
detials page but we get a INPUT/OUTPUT error when trying to mount it)

We cannot seem te find the problem in this setup.

If you need more info please contact me using guido.moonen@axon.tv

Specs of the system:
- Kernel 2.6.15.6 (with unionfs patch, Marvell driver, vweb (internal 
pci card) driver, libata, ibm kernel debugger)
- 4x 250 Gb sata harddrive (which will be used for raid)
- mdadm version v2.4.1 - 4 April 2006
- mke2fs version 1.37

Steps to get our problem.
1. Create the raid system
"mdadm --create -n 4 -l 5 -x 0 /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 
/dev/sdd1"
2. Format the system to use ext3
"mke2fs -j /dev/md0"
3. Reboot (The hard way, turning off power)
4. Reassemble the raid array
"mdadm --assemble --run --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 
/dev/sdd1"
5. Repeat 3 and 4 until system does not correctly mount the raid anymore.
Then it reports:
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 4.
mdadm: added /dev/sdb1 to /dev/md0 as 1
mdadm: added /dev/sdc1 to /dev/md0 as 2
mdadm: no uptodate device for slot 3 of /dev/md0
mdadm: added /dev/sdd1 to /dev/md0 as 4
mdadm: added /dev/sda1 to /dev/md0 as 0
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error

The line mdadm: no uptodate device for slot 3 of /dev/md0 is what I see 
every boot, even it is runs correctly.


The raid system is used to write a constant mpeg stream (512kbit/s) and 
we have a database active (postgres) on the raid. other than that there 
is no read activity on the raid system.

** mdadm --detail /dev/md0 after step 2 **
/dev/md0:
        Version : 00.90.03
  Creation Time : Thu May 11 11:29:40 2006
     Raid Level : raid5
     Array Size : 732419136 (698.49 GiB 750.00 GB)
    Device Size : 244139712 (232.83 GiB 250.00 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu May 11 11:35:08 2006
          State : clean, degraded, recovering
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 2% complete

           UUID : 4d66978f:eab0d6ef:39e6cf38:7a7191ba
         Events : 0.3

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       4       8       49        3      spare rebuilding   /dev/sdd1

** mdadm --detail /dev/md0 after step 5 **
/dev/md0:
        Version : 00.90.03
  Creation Time : Thu May 11 11:29:40 2006
     Raid Level : raid5
    Device Size : 244139712 (232.83 GiB 250.00 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu May 11 11:43:07 2006
          State : active, degraded
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 4d66978f:eab0d6ef:39e6cf38:7a7191ba
         Events : 0.204

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       0        0        3      removed

       4       8       49        -      spare   /dev/sdd1

