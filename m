From: David Greaves <david@dgreaves.com>
Subject: Raid 5 questions
Date: Thu, 03 Jun 2004 15:29:43 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40BF35D7.9050902@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I've perused the archives and read the docs but I'm not sure on this 
point :)

If I create an array with 3 250Gb disks and use the 'missing' option I 
should get a degraded raid5 array with 750Gb
Now, when another 250Gb disk arrives I want to add that as the missing 
disk - will that work?

Now, since I actually have the 3 disks and I'm waiting for the 4th, lets 
try it with 2 and add a third...

Clear out the superblocks so we're starting from scratch
cu:~# mdadm --stop /dev/md0
cu:~# mdadm --zero-superblock /dev/sda
cu:~# mdadm --zero-superblock /dev/sdb
cu:~# mdadm --zero-superblock /dev/sdc

Make the array.
cu:~# mdadm -v -C /dev/md0 --chunk=128 --level=5 --raid-devices=3 
/dev/sda /dev/sdb missing
mdadm: layout defaults to left-symmetric
mdadm: size set to 245117312K
mdadm: array /dev/md0 started.

What have we got?
cu:~# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Thu Jun  3 16:19:26 2004
     Raid Level : raid5
     Array Size : 490234624 (467.52 GiB 502.00 GB)
    Device Size : 245117312 (233.76 GiB 251.00 GB)
   Raid Devices : 3
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jun  3 16:19:26 2004
          State : clean, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       0        0       -1      removed
           UUID : 8acbe990:b31287f7:32888f7d:f0edcf0c
         Events : 0.3887

Thats 2x 251Gb giving a 502Gb array - good

Add this to the config
cu:~# echo 'DEVICE /dev/sd[abcd]' >/etc/mdadm/mdadm.conf
cu:~# mdadm --detail --scan >>/etc/mdadm/mdadm.conf
cu:~# cat /etc/mdadm/mdadm.conf
DEVICE /dev/sd[abcd]
ARRAY /dev/md0 level=raid5 num-devices=3 
UUID=8acbe990:b31287f7:32888f7d:f0edcf0c
   devices=/dev/sda,/dev/sdb

Now, the new disk arrives...
cu:~# mdadm  /dev/md0 -a /dev/sdc
mdadm: hot added /dev/sdc

So it should be working fine...
cu:~# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Thu Jun  3 16:19:26 2004
     Raid Level : raid5
     Array Size : 490234624 (467.52 GiB 502.00 GB)
    Device Size : 245117312 (233.76 GiB 251.00 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jun  3 16:23:21 2004
          State : clean, no-errors
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

 Rebuild Status : 0% complete

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       0        0       -1      removed
       3       8       32        2      spare   /dev/sdc
           UUID : 8acbe990:b31287f7:32888f7d:f0edcf0c
         Events : 0.3888


Nope it's a spare?
Help - how do I make my array resilient?


Environment:
Debian testing
Linux cu.dgreaves.com 2.6.6 #1 Thu Jun 3 14:12:01 BST 2004 i686 GNU/Linux
mdadm - v1.5.0 - 22 Jan 2004

Thanks

David
