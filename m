From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: disaster. raid1 drive failure rsync=DELAYED why?? please help
Date: Sun, 13 Mar 2005 01:23:40 -0500
Message-ID: <200503130123.40428.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi: some additional information

1) I tried to add the new spare device to /dev/md0 on friday afternoon.  It
still has not rebuilt. I am also unable to do "ls" of the directory of the 
drive.
2) I had another idea. Why not umount the drive and then run fsck.ext3 on the 
drive. Maybe it needs fsck? When I tried that I got the message:

A1:~# umount /home/big0
umount: /home/big0: device is busy
umount: /home/big0: device is busy

(/dev/md0 is mounted on /home/big0).

Here is the output from mdadm --detail.

Note: I accidentally renamed the drives in the original posting (sorry..). 
This is the 'rebuilt' setup. It has been 2 days of time for rebuilding with 
no change. What do I do to restart the rebuilding???

A1: mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Wed Jan 12 14:19:21 2005
     Raid Level : raid1
     Array Size : 244195904 (232.88 GiB 250.06 GB)
    Device Size : 244195904 (232.88 GiB 250.06 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Mar 11 11:40:23 2005
          State : clean, degraded
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

           UUID : 6b8b4567:327b23c6:643c9869:66334873
         Events : 0.343412

    Number   Major   Minor   RaidDevice State
       0      34        1        0      active sync   /dev/hdg1
       1       0        0        -      removed

       2      56        1        1      spare rebuilding   /dev/hdi1
A1:~# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 hdi1[2] hdg1[0]
      244195904 blocks [2/1] [U_]
        resync=DELAYED
md1 : active raid1 hdc1[1]
      244195904 blocks [2/1] [_U]

md2 : active raid1 hde1[1]
      244195904 blocks [2/1] [_U]

unused devices: 
