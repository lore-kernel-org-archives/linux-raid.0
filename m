From: Nicolas Jungers <nicolas@jungers.net>
Subject: trouble repairing raid10
Date: Wed, 02 Jun 2010 18:25:58 +0200
Message-ID: <4C068616.3070703@jungers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've a 4 HD raid10 with to failed drive.  Any attempt I made to add 2 
replacement disks fail consistently.

mdadm -Af /dev/md1 /dev/sdm2 /dev/sdp2   /dev/sdb2  /dev/sdd2
mdadm: failed to add /dev/sdd2 to /dev/md1: Device or resource busy
mdadm: /dev/md1 assembled from 2 drives and 1 spare - not enough to 
start the array.

or

root@disk:~# mdadm -AR /dev/md1 /dev/sdm2 /dev/sdp2
mdadm: failed to RUN_ARRAY /dev/md1: Input/output error
mdadm: Not enough devices to start the array.
root@disk:~# mdadm --add /dev/md1 /dev/sdb2
mdadm: add new device failed for /dev/sdb2 as 4: Invalid argument


The array is in near mode and I lost disk 0 and 1.  Does it mean that my 
data are toasted?



mdadm --examine /dev/sdm2
/dev/sdm2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : d90ad6fe:1355134f:f83ffadc:a4fe7859
            Name : m1:1
   Creation Time : Thu Apr  1 21:28:58 2010
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 3907026909 (1863.02 GiB 2000.40 GB)
      Array Size : 7814049792 (3726.03 GiB 4000.79 GB)
   Used Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : e217355e:632ac2f0:8120e55e:3878bd88

     Update Time : Wed Jun  2 12:31:39 2010
        Checksum : feef2809 - correct
          Events : 1377156

          Layout : near=2, far=1
      Chunk Size : 1024K

     Array Slot : 3 (failed, failed, 2, 3)
    Array State : __uU 2 failed
