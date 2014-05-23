From: Thilo Molitor <thilo@eightysoft.de>
Subject: md raid hanging in raid1 rebuild
Date: Fri, 23 May 2014 22:45:24 +0200
Message-ID: <2095141.tBaqcIgo3l@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all.

I have a strange issue when trying to rebuild my raid1 array.
One disk is operational and my laptop is running fine with the degraded raid1, 
but when I add a second disk, this disk wont get synced.

md0 is mounted ad /boot and running with /dev/sdb (my new SSD), /dev/sda is my 
HDD I want to add.
Below is some system info you might need.
Please help, this is making my raid unusable (eg there is no raid when you use 
just one single disk ;) )

Thilo Molitor



# cat /proc/mdstat 
Personalities : [raid1] 
md0 : active raid1 sdb2[2] sda2[0]
      204736 blocks [2/1] [U_]
      [>....................]  recovery =  0.0% (128/204736) finish=6394.0min 
speed=0K/sec

# mdadm -E /dev/sda2
/dev/sda2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 8024b3b6:76520e88:9d4deba6:47ca997f
  Creation Time : Wed Nov  6 01:55:24 2013
     Raid Level : raid1
  Used Dev Size : 204736 (199.97 MiB 209.65 MB)
     Array Size : 204736 (199.97 MiB 209.65 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Fri May 23 21:08:34 2014
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 2ab6fe80 - correct
         Events : 3009


      Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       0        0        1      faulty removed
   2     2       8       18        2      spare   /dev/sdb2


/dev/sdb2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 8024b3b6:76520e88:9d4deba6:47ca997f
  Creation Time : Wed Nov  6 01:55:24 2013
     Raid Level : raid1
  Used Dev Size : 204736 (199.97 MiB 209.65 MB)
     Array Size : 204736 (199.97 MiB 209.65 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Fri May 23 21:08:34 2014
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 2ab6fe8e - correct
         Events : 3009


      Number   Major   Minor   RaidDevice State
this     2       8       18        2      spare   /dev/sdb2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       0        0        1      faulty removed
   2     2       8       18        2      spare   /dev/sdb2


# ps -A -f | grep md0_resync
root       311     2  0 Mai19 ?        00:00:07 [md0_resync]
# cat /proc/311/stack
[<ffffffff81066a90>] process_timeout+0x0/0x10
[<ffffffff81068057>] msleep+0x27/0x30
[<ffffffffa01ec791>] md_do_sync+0x9b1/0xcd0 [md_mod]
[<ffffffff81093362>] load_balance+0x1c2/0x840
[<ffffffffa01e9637>] md_thread+0xf7/0x110 [md_mod]
[<ffffffffa01e9540>] md_thread+0x0/0x110 [md_mod]
[<ffffffff8107b8c1>] kthread+0xc1/0xe0
[<ffffffff8107b800>] kthread+0x0/0xe0
[<ffffffff814a944c>] ret_from_fork+0x7c/0xb0
[<ffffffff8107b800>] kthread+0x0/0xe0
[<ffffffffffffffff>] 0xffffffffffffffff


# uname -a
Linux laptop 3.13-1-amd64 #1 SMP Debian 3.13.10-1 (2014-04-15) x86_64 
GNU/Linux
