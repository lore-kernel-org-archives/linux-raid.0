From: Tomka Gergely <tomka@avaxio.net>
Subject: spare group
Date: Mon, 11 Jun 2007 15:45:18 +0200
Message-ID: <466D51EE.7030509@avaxio.net>
Reply-To: tomka@avaxio.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Linux, Raid lista" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good day!

I have problems with spare-groups. The problem: spare groups dont work 
for me. How can i use ths function?

The test :

# mdadm26 -D /dev/md0
/dev/md0:
         Version : 01.02.03
   Creation Time : Mon Jun 11 15:25:23 2007
      Raid Level : raid5
      Array Size : 19534720 (18.63 GiB 20.00 GB)
   Used Dev Size : 19534720 (9.31 GiB 10.00 GB)
    Raid Devices : 3
   Total Devices : 3
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Mon Jun 11 16:05:21 2007
           State : clean, degraded
  Active Devices : 2
Working Devices : 2
  Failed Devices : 1
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            Name : ursula:T1  (local to host ursula)
            UUID : 3e420024:281f9bb1:fd9ef39b:c18153b1
          Events : 10

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        1       8       17        1      active sync   /dev/sdb1
        3       8       33        2      active sync   /dev/sdc1

        0       8        1        -      faulty spare   /dev/sda1

# mdadm26 -D /dev/md1
/dev/md1:
         Version : 01.02.03
   Creation Time : Mon Jun 11 15:35:40 2007
      Raid Level : raid5
      Array Size : 19534720 (18.63 GiB 20.00 GB)
   Used Dev Size : 19534720 (9.31 GiB 10.00 GB)
    Raid Devices : 3
   Total Devices : 4
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Mon Jun 11 15:38:23 2007
           State : clean
  Active Devices : 3
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

            Name : ursula:T2  (local to host ursula)
            UUID : fb8ece28:9a6a31f8:700f37f6:7ee91bcf
          Events : 6

     Number   Major   Minor   RaidDevice State
        0       8       49        0      active sync   /dev/sdd1
        1       8       65        1      active sync   /dev/sde1
        3       8       81        2      active sync   /dev/sdf1

        4       8       97        -      spare   /dev/sdg1

# cat /etc/mdadm/mdadm.conf
DEVICE /dev/sd[a-g]1

HOMEHOST ursula

ARRAY /dev/md1 level=raid5 devices=/dev/sd[defg]1 num-devices=3 
spares=1 spare-group=ubul name=ursula:T2 
UUID=fb8ece28:9a6a31f8:700f37f6:7ee91bcf
ARRAY /dev/md0 level=raid5 devices=/dev/sd[abc]1 num-devices=3 
spare-group=ubul name=ursula:T1 UUID=3e420024:281f9bb1:fd9ef39b:c18153b1

According to the source:

* If an array has active < raid && spare == 0 && spare_group !=NULL
* Look for another array with spare > 0 and active == raid and same 
spare_group
* if found, choose a device and hotremove/hotadd

This is not happening. What is my mistake?

tg

