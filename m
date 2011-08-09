From: Sebastian Muniz <sjmuniz@gmail.com>
Subject: Undestanding /proc/mdstat with raid10
Date: Tue, 09 Aug 2011 04:14:05 -0300
Message-ID: <4E40DE3D.2020005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I have searched a lot trying to answer this.
I have a raid10 array on an openfiler box.
Personalities : [raid10]
md0 : active raid10 sde1[3] sdd1[2] sdc1[1] sdb1[0]
       181760 blocks super 1.2 64K chunks 2 near-copies [4/4] [UUUU]

unused devices: <none>
Actually this is a Virtualbox machine with the same disk setup. I made 6 
x 100 Mbytes disks for the test.

How can I tell which disks are mirrored?

My goal is to free the two mirror disks from md0, add two more free 
disks, create a new md1 raid5 array, and move the contents from md0 to md1

Thanks in advance.
Sebastian

PS: in case it is relevant, i am adding the detailed md0 output.

[root@of ~]# mdadm --misc --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Tue Aug  9 03:01:14 2011
      Raid Level : raid10
      Array Size : 181760 (177.53 MiB 186.12 MB)
   Used Dev Size : 90880 (88.76 MiB 93.06 MB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

     Update Time : Tue Aug  9 03:20:06 2011
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : near=2
      Chunk Size : 64K

            Name : of:0  (local to host of)
            UUID : 63b2145a:49030744:41b8f5b4:cb11bc1d
          Events : 19

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        1       8       33        1      active sync   /dev/sdc1
        2       8       49        2      active sync   /dev/sdd1
        3       8       65        3      active sync   /dev/sde1
