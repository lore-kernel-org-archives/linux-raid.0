From: Aymeric <mulx@aplu.fr>
Subject: mdadm RAID1 with 3 disks active on 2 disks configuration
Date: Sun, 23 Feb 2020 18:38:56 +0100
Message-ID: <4cf4cbe7-989e-d7ec-cad9-cfde022bd4bf@aplu.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've a system with a RAID1 using two disks (sda + sdb) + 1 spare (sdc).

For some stupid reason (cable) the spare (sdc) became active and sda was
out the array.

I then added back sda to the RAID1 but now I've RAID1 with three active
disks and zero spare.
I don't understand why the spare device didn't switch back as spare
after sda have been rebuild.

I used the following command to add sda to the RAID1:
# mdadm  /dev/md0 --add /dev/sda3


What did I do wrong here? And how to fix it? Do I have to set sdc to
faulty and add it back?

Thanks!

Here are the RAID1 status:

# cat /proc/mdstat
Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid1 sda3[2] sdc3[3](W)(R) sdb3[0]
      976015360 blocks super 1.2 [2/3] [UU]
      bitmap: 1/8 pages [4KB], 65536KB chunk

# mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Wed Sep  5 09:45:55 2018
        Raid Level : raid1
        Array Size : 976015360 (930.80 GiB 999.44 GB)
     Used Dev Size : 976015360 (930.80 GiB 999.44 GB)
      Raid Devices : 2
     Total Devices : 3
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Sun Feb 23 18:28:45 2020
             State : clean
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : bitmap

              Name : sharon:2
              UUID : 98299cb7:9cbe61e9:c8374bcb:3c72d5ca
            Events : 704774

    Number   Major   Minor   RaidDevice State
       0       8       19        0      active sync   /dev/sdb3
       2       8        3        1      active sync   /dev/sda3
       3       8       35        1      active sync writemostly   /dev/sdc3


-- 
Aymeric
