From: "jdd@dodin.org" <jdd@dodin.org>
Subject: fixing raid1
Date: Mon, 1 May 2017 18:34:14 +0200
Message-ID: <c416bcba-7a5d-a409-42ca-2eb82eca32b7@dodin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm new to this mailing list, so forgive me if I break some etiquette

I have an academic problem. I mean that the target computer in not in 
production and do not hold any essential data. I try to learn some 
aspects of linux raid.

I have built a three disks raid1 on openSUSE 42.2. so far so good, all 
worked perfectly

but later on I had no more use of the machine with as much disks, and 
wanted to reclaim one disk. This one was in a esata dock.

At the moment I didn't found a way to make this cleanly (I found it it 
too late in the linux raid wiki 
https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm#Removing_a_disk_from_an_array)

so, I stopped the computer and removed the dock.

The computer rebooted perfectly, but in slightly degraded mode (see below)

I don't find a way to tell the system that it have to forget the third 
disk. May be it's not necessary.

Do you have a clue?

thanks
jdd

# mdadm --detail /dev/md127
/dev/md127:
         Version : 1.0
   Creation Time : Wed Dec 21 22:43:31 2016
      Raid Level : raid1
      Array Size : 976758592 (931.51 GiB 1000.20 GB)
   Used Dev Size : 976758592 (931.51 GiB 1000.20 GB)
    Raid Devices : 3
   Total Devices : 2
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Mon May  1 15:29:48 2017
           State : clean, degraded
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : any:jdd-raid
            UUID : 4d57c009:5d7fc724:07376d9a:8ecb39a2
          Events : 9592

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       17        1      active sync   /dev/sdb1
        -       0        0        2      removed
