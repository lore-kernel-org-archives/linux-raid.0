From: George Duffield <forumscollective@gmail.com>
Subject: Understanding raid array status: Active vs Clean
Date: Mon, 26 May 2014 22:08:40 +0200
Message-ID: <CAG__1a4MRV6gJL38XLAurtoSiD3rLBTmWpcS5HYvPpSfPR88UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently created a raid 5 array under Arch Linux running on a HP
Microserver using pretty much the same topography as I do under Ubuntu
Server.  The creation process went fine and the array is accessible,
however, from the outset it's only ever reported status as Active
rather than Clean.

After creating the array, watch -d cat /proc/mdstat returned:

Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sda1[0] sdc1[2] sde1[5] sdb1[1] sdd1[3]
      11720536064 blocks super 1.2 level 5, 512k chunk, algorithm 2
[5/5] [UUUUU]
      bitmap: 2/22 pages [8KB], 65536KB chunk

unused devices: <none>

which to me pretty much looks like the array sync completed successfully.

I then updated the config file, assembled the array and formatted it using:
mdadm --detail --scan >> /etc/mdadm.conf
mdadm --assemble --scan
mkfs.ext4 -v -L offsitestorage -b 4096 -E stride=128,stripe-width=512 /dev/md0

mdadm --detail /dev/md0 returns:

/dev/md0:
        Version : 1.2
  Creation Time : Thu Apr 17 01:13:52 2014
     Raid Level : raid5
     Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
  Used Dev Size : 2930134016 (2794.39 GiB 3000.46 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Apr 17 18:55:01 2014
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : audioliboffsite:0  (local to host audioliboffsite)
           UUID : aba348c6:8dc7b4a7:4e282ab5:40431aff
         Events : 11306

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       5       8       65        4      active sync   /dev/sde1

So, I'm now left wondering why the state of the array isn't "clean"?
Is it normal for arrays to show a state of "active" instead of clean
under Arch - is it simply a matter of Arch is packaged with a more
recent version of mdadm than Ubuntu Server?

Thx
