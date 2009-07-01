From: Kris Hofmans <kris.hofmans@gmail.com>
Subject: Fwd: series of unfortunate events
Date: Wed, 1 Jul 2009 11:54:02 +0200
Message-ID: <632ddf2c0907010254p595921cdrade70d59a693546f@mail.gmail.com>
References: <632ddf2c0907010223x43742d68l99bfbdca73603cde@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <632ddf2c0907010223x43742d68l99bfbdca73603cde@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

It's a long story to tell, but I don't want to omit anything that
might be important as to the recovery strategy.

I had a 6 1TB disk raid 5 array. One disk started failing, I put the
failing one as faulty and added a replacement disk. The rebuild went
fine!

This is output from when it was doing the resync, which ended without issues.

bbox:/home/blacky# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[6] sda1[0] sdf1[5] sde1[4] sdc1[2] sdb1[1]

      4883799680 blocks level 5, 64k chunk, algorithm 2 [6/5] [UUU_UU]
      [>....................]  recovery =  0.4% (3996208/976759936)
finish=898.2min speed=18047K/sec

unused devices: <none>


bbox:/home/blacky# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90
  Creation Time : Sat Dec 13 08:30:08 2008
     Raid Level : raid5
     Array Size : 4883799680 (4657.55 GiB 5001.01 GB)
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)

   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Jun 28 23:25:48 2009
          State : clean, degraded, recovering
 Active Devices : 5

Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 0% complete

           UUID : 2ecd246f:8de14b9d:4d948b44:39f918b9 (local to host bbox)

         Events : 0.88

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1

       6       8       49        3      spare rebuilding   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1

Since I already had to buy a new disk I decided what the heck, lets
buy some extra disks to grow the array with 2 extra disks.

So on monday I started the grow operation adding the 2 disks at the
same time (not smart, I know that now) and saw in /proc/mdstat that it
was very slow (5MB/sec) so I checked dmesg and a disk was giving
errors. The grow operation was not completed for more than 0.5%

I saw it was on ata7 so I assumed it was /dev/sdh, and marked it as
faulty, hoping to speed up the resync. But then suddenly also /dev/sde
was marked as faulty, I guess that ata 7 was not /dev/sdh. The result
was that it could not do anything anymore!

After a reboot it did not recognire the md0 anymore.

All I want at this point is to have the array back like this:

sdd1[6] sda1[0] sdf1[5] sde1[4] sdc1[2] sdb1[1]

since that was a working configuration, I don't know if that is
possible since it was growing, disks put as faulty ... but in the end,
I don't think that much on the hd's moved around, or is that just
whishfull thinking on my part?

After reading things yesterday I performed an attempt to zero out all
the superblocks on those 6 disks. And then recreate the original
array, I am unsure if I do:

mdadm --create --verbose /dev/md0 --level=5 --raid-devices=6 /dev/sda1
/dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

This is the original command I used to create it, but I saw that sdd1
the replaced disk was [6] after the rebuild ...
so do I create it like this:

mdadm --create --verbose /dev/md0 --level=5 --raid-devices=6 /dev/sda1
/dev/sdb1 /dev/sdc1 /dev/sde1 /dev/sdf1 /dev/sdd1

?
I actually tried both, zero'ing out the superblocks in between, and
tried to do a mount -o ro /dev/md0 /mnt/storage
this only gives me an

unknown partition table

error ...
-----
The only thing I can think of now as a next step would be to
repartition /dev/md0 and HOPE that when I repartition the disk it will
be able to see my data again because it's missing the partition table.

But I would really like some professional opinions and advice before I
try to start writing to the array.

Any help will be immensely appreciated!

Kind regards,
Kris Hofmans
