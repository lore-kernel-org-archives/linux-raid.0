From: "Daniel J. Priem" <daniel@flexserv.de>
Subject: raid from2.6 kernel not recognized under 2.4
Date: Sun, 23 Jul 2006 10:57:49 +0200
Message-ID: <878xmkd7g2.fsf@xserver.flexserv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello i created a raid0 wich works nice under 2.6 but under 2.4 i dont
get it running.
Please CC me i am not subscribed to this list

Regards Daniel

below the output one from 2.4 other from 2.6

daniel@prehension:~$ cat /etc/mdadm/mdadm.conf
DEVICE /dev/hd*[0-9] /dev/sd*[0-9]
ARRAY /dev/md0 level=raid0 num-devices=2
UUID=a2f1ee4c:42b18d34:1571b1f2:b800e11f
   devices=/dev/sdb1,/dev/sda4
daniel@prehension:~$
daniel@prehension:~$ sudo /etc/init.d/mdadm-raid start
Starting raid devices: mdadm: failed to add /dev/sda4 to /dev/md0:
Invalid argument
mdadm: failed to add /dev/sdb1 to /dev/md0: Invalid argument
mdadm: /dev/md0 assembled from 0 drives - not enough to start the array.
done.
daniel@prehension:~$daniel@prehension:~$ sudo mdadm -A /dev/md0
--uuid=a2f1ee4c:42b18d34:1571b1f2:b800e11f /dev/sdb1 /dev/sda4
mdadm: failed to add /dev/sda4 to /dev/md0: Invalid argument
mdadm: failed to add /dev/sdb1 to /dev/md0: Invalid argument
mdadm: /dev/md0 assembled from 0 drives - not enough to start the array.
daniel@prehension:~$ sudo mdadm -A /dev/md2
mdadm: failed to add /dev/sda4 to /dev/md2: Invalid argument
mdadm: failed to add /dev/sdb1 to /dev/md2: Invalid argument
mdadm: /dev/md2 assembled from 0 drives - not enough to start the array.
daniel@prehension:~$ sudo mdadm -A /dev/md0  --scan
--uuid=a2f1ee4c:42b18d34:1571b1f2:b800e11f /dev/sdb1 /dev/sda4
mdadm: failed to add /dev/sda4 to /dev/md0: Invalid argument
mdadm: failed to add /dev/sdb1 to /dev/md0: Invalid argument
mdadm: /dev/md0 assembled from 0 drives - not enough to start the array.
mdadm: /dev/sdb1 not identified in config file.
mdadm: /dev/sda4 not identified in config file.
daniel@prehension:~$ sudo mdadm -A /dev/md0  --scan /dev/sdb1 /dev/sda4
mdadm: failed to add /dev/sda4 to /dev/md0: Invalid argument
mdadm: failed to add /dev/sdb1 to /dev/md0: Invalid argument
mdadm: /dev/md0 assembled from 0 drives - not enough to start the array.
mdadm: /dev/sdb1 not identified in config file.
mdadm: /dev/sda4 not identified in config file.
daniel@prehension:~$ sudo mdadm -A /dev/md0  --scan /dev/sdb1 /dev/sda4
-c /etc/mdadm/mdadm.conf
mdadm: failed to add /dev/sda4 to /dev/md0: Invalid argument
mdadm: failed to add /dev/sdb1 to /dev/md0: Invalid argument
mdadm: /dev/md0 assembled from 0 drives - not enough to start the array.
mdadm: /dev/sdb1 not identified in config file.
mdadm: /dev/sda4 not identified in config file.

daniel@prehension:~$ sudo mdadm -E /dev/sdb1 und mdadm -E /dev/sda4
#
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : a2f1ee4c:42b18d34:1571b1f2:b800e11f
  Creation Time : Fri Jul 14 20:36:55 2006
     Raid Level : raid0
    Device Size : 13528064 (12.90 GiB 13.85 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Update Time : Fri Jul 14 20:36:56 2006
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 7958 - expected e68092d7
         Events : 0.1
     Chunk Size : 64K
      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        4        1      active sync   /dev/sda4
mdadm: cannot open und: No such file or directory
mdadm: cannot find device size for und: No such file or directory
mdadm: cannot open mdadm: No such file or directory
mdadm: cannot find device size for mdadm: No such file or directory
/dev/sda4:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : a2f1ee4c:42b18d34:1571b1f2:b800e11f
  Creation Time : Fri Jul 14 20:36:55 2006
     Raid Level : raid0
    Device Size : 13528064 (12.90 GiB 13.85 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Update Time : Fri Jul 14 20:36:56 2006
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 794d - expected e68092cc
         Events : 0.1
     Chunk Size : 64K
      Number   Major   Minor   RaidDevice State
this     1       8        4        1      active sync   /dev/sda4
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        4        1      active sync   /dev/sda4
daniel@prehension:~$ sudo mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Fri Jul 14 20:36:55 2006
     Raid Level : raid0
     Array Size : 31212096 (29.77 GiB 31.96 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent
    Update Time : Fri Jul 14 20:36:56 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
     Chunk Size : 64K
           UUID : a2f1ee4c:42b18d34:1571b1f2:b800e11f
         Events : 0.1
    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8        4        1      active sync   /dev/sda4
daniel@prehension:~$


