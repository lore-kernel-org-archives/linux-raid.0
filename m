From: Paul Richter <iamcomcy@gmail.com>
Subject: Is this RAID recoverable???
Date: Tue, 3 Jan 2012 10:41:04 +0400
Message-ID: <CAHw_BJ3fGd2ZN5ORs4+DSxz57AhT6jq7oL+cs_4MaztZX0sgUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

I got 8Tb on the line here, and I need to know if I am wasting my time
now, or what the next step is to recovery ...

Background:
RAID 6, lost a controller card and two drives with it, didn't know.
Some files were added in degraded state.
Problem with MB, lost a 3rd drive.
No writes of course, not enough drives to assemble raid.

Researched the net as much as possible, added this to wiki page:
http://en.wikipedia.org/wiki/Mdadm#Recovering_from_a_loss_of_raid_superblock

So the above is exactly what I did to try and recover the raid.

Present:
Running in degraded state, trying to mount and then will add remaining disks.

clop Desktop # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath] [faulty]
md127 : active raid6 sdc1[0] sde1[3] sdf1[2] sdd1[1]
      7814037504 blocks super 1.2 level 6, 4096k chunk, algorithm 2
[6/4] [UUUU__]

md0 : active raid0 sdb1[0] sdj1[4] sdi1[3] sdh1[2] sdg1[1]
      312601600 blocks super 1.1 512k chunks

unused devices: <none>

clop Desktop # mdadm --detail /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Sun Jan  1 20:04:05 2012
     Raid Level : raid6
     Array Size : 7814037504 (7452.05 GiB 8001.57 GB)
  Used Dev Size : 1953509376 (1863.01 GiB 2000.39 GB)
   Raid Devices : 6
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Sun Jan  1 20:04:19 2012
          State : clean, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 4096K

           Name : clop:1  (local to host clop)
           UUID : 696be297:5056e6e5:86181fb8:7b323fd6
         Events : 2

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       8       81        2      active sync   /dev/sdf1
       3       8       65        3      active sync   /dev/sde1
       4       0        0        4      removed
       5       0        0        5      removed

This is what I get when I try and mount:

clop Desktop # mount /dev/md127 /media/
mount: wrong fs type, bad option, bad superblock on /dev/md127,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

clop Desktop # dmesg | tail
[   22.959022] ata11: EH complete
[   23.521403] ata12.00: configured for UDMA/133
[   23.521408] ata12: EH complete
[   23.573277] EXT4-fs (md0): re-mounted. Opts: commit=0
[   23.642304] EXT4-fs (sda1): re-mounted. Opts: commit=0
[   23.717975] EXT4-fs (sda2): re-mounted. Opts: commit=0
[   23.719060] EXT4-fs (sdl1): re-mounted. Opts: commit=0
[   31.945290] eth1: no IPv6 routers present
[  126.446097] libfcoe_device_notification: NETDEV_UNREGISTER lo
[  529.325204] EXT4-fs (md127): bad geometry: block count 1953512448
exceeds size of device (1953509376 blocks)


Have tried to get these numbers to change, nothing effects them.

Is this thing dead? Or what's my next step to recovery?

Many thanks!
