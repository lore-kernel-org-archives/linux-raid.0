From: Michael Tokarev <mjt@tls.msk.ru>
Subject: read errors (in superblock?) aren't fixed by md?
Date: Fri, 12 Nov 2010 16:56:55 +0300
Message-ID: <4CDD47A7.9010501@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I noticed a few read errors in dmesg, on drives
which are parts of a raid10 array:

sd 0:0:13:0: [sdf] Unhandled sense code
sd 0:0:13:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:13:0: [sdf] Sense Key : Medium Error [current]
Info fld=0x880c1d9
sd 0:0:13:0: [sdf] Add. Sense: Unrecovered read error - recommend rewrite the data
sd 0:0:13:0: [sdf] CDB: Read(10): 28 00 08 80 c0 bf 00 01 80 00
end_request: I/O error, dev sdf, sector 142655961

sd 0:0:11:0: [sdd] Unhandled sense code
sd 0:0:11:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:11:0: [sdd] Sense Key : Medium Error [current]
Info fld=0x880c3e5
sd 0:0:11:0: [sdd] Add. Sense: Unrecovered read error - recommend rewrite the data
sd 0:0:11:0: [sdd] CDB: Read(10): 28 00 08 80 c2 3f 00 02 00 00
end_request: I/O error, dev sdd, sector 142656485

Both sdf and sdd are parts of the same (raid10) array,
and this array is the only usage for these drives (i.e.,
there's nothing else reading them).  Both the mentioned
locations are near the end of the only partition on
these drives:

# partition table of /dev/sdf
unit: sectors
/dev/sdf1 : start=       63, size=142657137, Id=83

(the same partition table is on /dev/sdd too).

Sector 142657200 is the start of the next (non-existing)
partition, so the last sector of the first partition is
142657199.

Now, we've read errors on sectors 142655961 (sdf)
and 142656485 (sdd), which are 1239 and 715 sectors
before the end of the partition, respectively.

The array is this:

# mdadm -E /dev/sdf1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 1c49b395:293761c8:4113d295:43412a46
  Creation Time : Sun Jun 27 04:37:12 2010
     Raid Level : raid10
  Used Dev Size : 71328256 (68.02 GiB 73.04 GB)
     Array Size : 499297792 (476.17 GiB 511.28 GB)
   Raid Devices : 14
  Total Devices : 14
Preferred Minor : 11

    Update Time : Fri Nov 12 16:55:06 2010
          State : clean
Internal Bitmap : present
 Active Devices : 14
Working Devices : 14
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 104a3529 - correct
         Events : 16790

         Layout : near=2, far=1
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this    10       8       81       10      active sync   /dev/sdf1
   0     0       8        1        0      active sync   /dev/sda1
   1     1       8      113        1      active sync   /dev/sdh1
   2     2       8       17        2      active sync   /dev/sdb1
   3     3       8      129        3      active sync   /dev/sdi1
   4     4       8       33        4      active sync   /dev/sdc1
   5     5       8      145        5      active sync   /dev/sdj1
   6     6       8       49        6      active sync   /dev/sdd1
   7     7       8      161        7      active sync   /dev/sdk1
   8     8       8       65        8      active sync   /dev/sde1
   9     9       8      177        9      active sync   /dev/sdl1
  10    10       8       81       10      active sync   /dev/sdf1
  11    11       8      193       11      active sync   /dev/sdm1
  12    12       8       97       12      active sync   /dev/sdg1
  13    13       8      209       13      active sync   /dev/sdn1


What's wrong with these read errors?  I just verified -
the error persists, i.e. reading the mentioned sectors
using dd produces the same errors again, so there were
no re-writes there.

Can md handle this situation gracefully?

Thanks!

/mjt
