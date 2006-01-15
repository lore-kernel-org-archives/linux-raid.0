From: "Darwin O.V. Alonso" <dalonso@u.washington.edu>
Subject: raidtools mdadm conversion query
Date: Sun, 15 Jan 2006 12:40:18 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0601151237480.27906@homer22.u.washington.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I upgraded a system from FC2 to FC4,
The system had a working raidtools linear raid partition 
(md0 = sda1 and sdb1)
I now need to get the partition going using mdadm, while maintaining the data.

I used raidtabtomdadm.sh to create /etc/mdadm.conf
================================================================
DEVICE partitions
ARRAY /dev/md0 level=linear num-devices=2 UUID=ba95446a:6fe4d353:9ba80e0f:181c0117 auto=yes
================================================================
but I am unsure of the next step. I imagine I do somethink like:
  mdadm --assemble --verbose /dev/md0 --level=linear --raid-devices=2 /dev/sda1 /dev/sdb1
but I don't want to blunder ahead and wipe out the existing data.

Thanks,
Darwin



Current situation:
[root@a0 ~]# mdadm --examine /dev/md0
mdadm: /dev/md0 is too small for md


[root@a0 ~]# mdadm --examine /dev/sda1
/dev/sda1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : ba95446a:6fe4d353:9ba80e0f:181c0117
   Creation Time : Tue May 25 12:13:51 2004
      Raid Level : linear
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0

     Update Time : Tue May 25 12:13:51 2004
           State : active
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : 175f4ea3 - correct
          Events : 0.1

        Rounding : 32K

       Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1

