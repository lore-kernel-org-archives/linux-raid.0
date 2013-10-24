From: <yuji_touya@yokogawa-digital.com>
Subject: Help raid10 recovery from 2 disks removed
Date: Thu, 24 Oct 2013 05:10:59 +0000
Message-ID: <1F36A02C60ACD1478457DCD917DA0FA8034656@ZEX001-0M9030.jp.ykgw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: ja-JP
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Unfortunately my raid10 array (2TB x 4 disks, total 4TB) stopped working and
mdadm command reports State "removed" and "faulty removed" disks are there.
Could someone advise me how to recover the raid10 array?

I read this page and jumped into here.
https://raid.wiki.kernel.org/index.php/RAID_Recovery

Your help is appreciated,
Yuji

raid10 created as:
#  mdadm --create --verbose --assume-clean /dev/md0 --level=10 --raid-devices=4 --chunk=1024 --layout=n2 /dev/sd[bcde]

/dev/md0 is formatted by xfs.

*** when working well: ***
# cat /proc/mdstat
Personalities : [raid10]
md0 : active raid10 sdb[0] sde[3] sdd[2] sdc[1]
      3907028992 blocks 1024K chunks 2 near-copies [4/4] [UUUU]

unused devices: <none>

**** now broken: ****
# cat /proc/mdstat
Personalities : [raid10]
md0 : inactive sdd[2] sde[3]
      3907028992 blocks

unused devices: <none>


# mdadm --examine /dev/sd[bcde]
/dev/sdb:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 5911f80e:dfc48edd:c6cdfb15:1768b409
  Creation Time : Mon May  7 17:00:11 2012
     Raid Level : raid10
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 3907028992 (3726.03 GiB 4000.80 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Oct 23 10:56:11 2013
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : d6c88478 - correct
         Events : 34220

         Layout : near=2
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     0       8       16        0      active sync   /dev/sdb

   0     0       8       16        0      active sync   /dev/sdb
   1     1       0        0        1      faulty removed
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
/dev/sdc:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 5911f80e:dfc48edd:c6cdfb15:1768b409
  Creation Time : Mon May  7 17:00:11 2012
     Raid Level : raid10
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 3907028992 (3726.03 GiB 4000.80 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon Jun  3 09:32:45 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d60c30db - correct
         Events : 8

         Layout : near=2
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     1       8       32        1      active sync   /dev/sdc

   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
/dev/sdd:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 5911f80e:dfc48edd:c6cdfb15:1768b409
  Creation Time : Mon May  7 17:00:11 2012
     Raid Level : raid10
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 3907028992 (3726.03 GiB 4000.80 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Oct 23 18:25:25 2013
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : d6c8edf7 - correct
         Events : 34224

         Layout : near=2
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     2       8       48        2      active sync   /dev/sdd

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
/dev/sde:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 5911f80e:dfc48edd:c6cdfb15:1768b409
  Creation Time : Mon May  7 17:00:11 2012
     Raid Level : raid10
  Used Dev Size : 1953514496 (1863.02 GiB 2000.40 GB)
     Array Size : 3907028992 (3726.03 GiB 4000.80 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Oct 23 18:25:25 2013
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : d6c8ee09 - correct
         Events : 34224

         Layout : near=2
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     3       8       64        3      active sync   /dev/sde

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde



# mdadm --examine /dev/sd[b-z] | egrep 'Event|/dev/sd'
/dev/sdb:
         Events : 34220
this     0       8       16        0      active sync   /dev/sdb
   0     0       8       16        0      active sync   /dev/sdb
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
/dev/sdc:
         Events : 8
this     1       8       32        1      active sync   /dev/sdc
   0     0       8       16        0      active sync   /dev/sdb
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
/dev/sdd:
         Events : 34224
this     2       8       48        2      active sync   /dev/sdd
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde
/dev/sde:
         Events : 34224
this     3       8       64        3      active sync   /dev/sde
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       64        3      active sync   /dev/sde

-----
CONFIDENTIAL: This e-mail may contain information that is confidential or otherwise protected from disclosure and intended only for the party to whom it is addressed. If you are not the intended recipient, please notify the sender by return and delete this e-mail. You are hereby formally advised that any unauthorized use, disclosure or copying of this email is strictly prohibited and may be unlawful.
