From: Thomas Grawert <thomasgrawert0282@gmail.com>
Subject: help requested for mdadm grow error
Date: Mon, 25 May 2020 19:25:53 +0200
Message-ID: <7d95da49-33d8-cd4d-fa3f-0f3d3074cb30@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

I´m pretty new here and already tried finding a solution with aunt 
google - without luck. So hopefully someone of you can help me:

I´m running a NAS with 4x 12TB WD120EFAX using mdadm Raid5 on the basis 
of Debian 10.

Because of capacity and speed I tried adding another WD120EFAX by simply
"mdadm --grow --raid-devices=5 /dev/md0 /dev/sd[a-e]1 
--backup-file=/tmp/bu.bak"

Everything worked... but during reshape, I had a power interruption. 
When power was back, I tried to restart NAS but the md disappeared.

Long story short... after asking aunt Google I managed to get the raid5 
up "active, not started":

root@nas:~# mdadm -D /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Sun May 17 00:23:42 2020
      Raid Level : raid5
   Used Dev Size : 18446744073709551615
    Raid Devices : 5
   Total Devices : 5
     Persistence : Superblock is persistent

     Update Time : Mon May 25 16:05:38 2020
           State : active, Not Started
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

   Delta Devices : 1, (4->5)

            Name : nas:0  (local to host nas)
            UUID : d7d800b3:d203ff93:9cc2149a:804a1b97
          Events : 38602

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       17        1      active sync   /dev/sdb1
        2       8       33        2      active sync   /dev/sdc1
        4       8       49        3      active sync   /dev/sdd1
        5       8       65        4      active sync   /dev/sde1


I already tried to repair the md0 using the mentioned way from 
https://serverfault.com/questions/776170/mdadm-grow-power-failure-dev-md2-no-longer-detected-raid5 
... however, the raid didn´t start.

Unfortunately the raid is not mountable (cannot read superblock), even 
readonly. So it´s impossible to run a backup of stored data, for now.

Any help is highly appreciated.

Greetings

Thomas
