From: Max Amanshauser <linux-raid@lambdalifting.org>
Subject: Raid 5 assembly
Date: Wed, 11 Feb 2009 13:40:02 +0100
Message-ID: <DC1C3104-7467-4DC8-92F3-C25967C3692C@lambdalifting.org>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

After drive failure I used to have a degraded raid-5 array on  
sd[cde]1. When resyncing, after adding a new spare drive, another  
drive failed. I hastily dd_rescue'd it to the intended spare. A mere  
80 kB were unreadable. Now I'd like to start the resulting mess, but I  
think the device I copied to, sdd1, is only recognised as a spare:

$ mdadm -A /dev/md0 /dev/sd[cde]1
mdadm: /dev/md0 assembled from 2 drives and 1 spare - not enough to  
start the array.

$ mdadm -A /dev/md0 --force /dev/sd[cde]1
mdadm: /dev/md0 assembled from 2 drives and 1 spare - not enough to  
start the array.


How can I fix it all up so that it starts again?



/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 460f8b36:b1603b5b:e990ddad:ef078ba9
            Name : purgatory:0
   Creation Time : Tue Jun 10 18:01:20 2008
      Raid Level : raid5
    Raid Devices : 4

   Used Dev Size : 1953519730 (931.51 GiB 1000.20 GB)
      Array Size : 5860558848 (2794.53 GiB 3000.61 GB)
       Used Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 1e86a7cb:dd1f6f2a:86c4ed3d:5f26f4b3

     Update Time : Wed Feb  4 11:53:32 2009
        Checksum : cf1e6f58 - correct
          Events : 38348

          Layout : left-symmetric
      Chunk Size : 64K

     Array Slot : 1 (0, 1, failed, failed, failed)
    Array State : uU__ 3 failed
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 460f8b36:b1603b5b:e990ddad:ef078ba9
            Name : purgatory:0
   Creation Time : Tue Jun 10 18:01:20 2008
      Raid Level : raid5
    Raid Devices : 4

   Used Dev Size : 1953519730 (931.51 GiB 1000.20 GB)
      Array Size : 5860558848 (2794.53 GiB 3000.61 GB)
       Used Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 123f6486:a905181a:006d7805:c9c44694

     Update Time : Wed Feb  4 11:53:32 2009
        Checksum : 216154fa - correct
          Events : 38342

          Layout : left-symmetric
      Chunk Size : 64K

     Array Slot : 4 (0, 1, failed, failed)
    Array State : uu__ 2 failed
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 460f8b36:b1603b5b:e990ddad:ef078ba9
            Name : purgatory:0
   Creation Time : Tue Jun 10 18:01:20 2008
      Raid Level : raid5
    Raid Devices : 4

   Used Dev Size : 1953519730 (931.51 GiB 1000.20 GB)
      Array Size : 5860558848 (2794.53 GiB 3000.61 GB)
       Used Size : 1953519616 (931.51 GiB 1000.20 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 3e165b62:0e929fe2:91ef7462:14f4deec

     Update Time : Wed Feb  4 11:53:32 2009
        Checksum : 7b746a69 - correct
          Events : 38348

          Layout : left-symmetric
      Chunk Size : 64K

     Array Slot : 0 (0, 1, failed, failed, failed)
    Array State : Uu__ 3 failed


-- 
Thanks,
Max.

