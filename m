From: Mats Johnson <mats@jupp.se>
Subject: Please help with reconstruction of RAID 5
Date: Fri, 02 Dec 2005 13:47:04 +0100
Message-ID: <43904248.3090001@jupp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had a 4 device RAID 5 array consisting of the devices sda, sdb, sdc
and sdd.

Then the sda device failed. I had the (perhaps not so brilliant) idea
that it was probably just some glitch, and that it wasn't really broken,
so I removed it from the array, then added it back again.

As expected the resynchronisation started, however at 58% it got stuck
and nothing more happened. Anything I did after that that touched the
raid hung, so I restarted the machine.

When booting the broken sda device didn't respond and so there were
only three disc devices, now they were called sda (formerly sdb),
sdb (formerly sdc) and sdc (formerly sdd).

Now the raid wouldn't start, I think because it had the impression that
sdd was also missing. I ordered a replacement disc, thinking that this
would fix the confusion, when it was inserted as sda. After installing
this the devices are called sda, sdb, sdc and sdd again.

So the actual state of the discs are now that sda is new and has been
partitioned the same as the other ones. sdb, sdc and sdd I'm convinced
contain good raid 5 data, "mdadm -E" for all three says checksums are
correct, state is clean and "Events" are equal.

The table of raid devices is a bit messed up however, it shows sda, sdb
and sdc as "active sync", sdd as "spare" and another "device" as "faulty
removed".

So, I thought I'd tell mdadm to assemble the array from the three good
devices:
# mdadm --assemble /dev/md0 /dev/sdb /dev/sdc /dev/sdd
mdadm: /dev/md0 assembled from 2 drives and 1 spare - not enough to 
start the array.
...which didn't work, I assume because it thinks sdd is "spare". I
tried adding "--force" but that didn't change anything.

I'm using Debian, Sarge (kernel 2.6.8).
"mdadm --version" returns "mdadm - v1.9.0 - 04 February 2005"
On boot the md driver says:
    "md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27"
The disks are all Seagate Barracuda 7200.8 SATA NCQ - ST3300831AS.
They are all partitioned into a single partition.

Below is the output of "mdadm --examine /dev/sdd", the others are
exactly the same (except for the "this"-line and checksum values,
naturally).

/dev/sdd:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : b7ab9c13:23c0ec3b:ca61051c:b536662c
   Creation Time : Wed Apr 20 15:24:36 2005
      Raid Level : raid5
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0

     Update Time : Wed Apr 20 17:18:04 2005
           State : clean
  Active Devices : 3
Working Devices : 4
  Failed Devices : 1
   Spare Devices : 1
        Checksum : 9a747d6d - correct
          Events : 0.1851

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     4       8       48        4      spare   /dev/sdd

    0     0       8        0        0      active sync   /dev/sda
    1     1       8       16        1      active sync   /dev/sdb
    2     2       8       32        2      active sync   /dev/sdc
    3     3       0        0        3      faulty removed
    4     4       8       48        4      spare   /dev/sdd

