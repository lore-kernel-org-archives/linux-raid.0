From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: disaster. raid1 drive failure rsync=DELAYED why?? please help
Date: Sun, 13 Mar 2005 01:45:47 -0500
Message-ID: <200503130145.47467.mlaks@verizon.net>
References: <200503130123.40428.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-8-i
Content-Transfer-Encoding: 7bit
In-reply-to: <200503130123.40428.mlaks@verizon.net>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had some more bright ideas and here is what happened:

I am unable to even do ls on the directory mounted on this raid device.

So, I said, maybe the problem is that I need to run fsck.ext3 on the drive 
first. So I tried to umount it and i got the error message:

A1:~# umount /home/big0
umount: /home/big0: device is busy
umount: /home/big0: device is busy

So I said maybe the problem is the rsyncing. So maybe an idea is to fail the 
new added device /dev/hdi1  and then remove /dev/hdi1, move back to degraded 
mode. Do an umount of the drive, then do an fsck.ext3 on the drive and then I 
can do a reboot and then add the drive back in.

Hey why not?

Ok. So I tried: Here is the transcipt of the session:

A1:~# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 hdi1[2] hdg1[0]
      244195904 blocks [2/1] [U_]
        resync=DELAYED
md1 : active raid1 hdc1[1]
      244195904 blocks [2/1] [_U]

md2 : active raid1 hde1[1]
      244195904 blocks [2/1] [_U]

unused devices: <none>
A1:~# umount /home/big0
umount: /home/big0: device is busy
umount: /home/big0: device is busy
A1:~# whoami
root
A1:~# mdadm /dev/md0 -fail /dev/hdi1 --remove /dev/hdi1
mdadm: hot add failed for /dev/hdi1: Invalid argument

A1:~# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 hdi1[2] hdg1[0]
      244195904 blocks [2/1] [U_]
        resync=DELAYED
md1 : active raid1 hdc1[1]
      244195904 blocks [2/1] [_U]

md2 : active raid1 hde1[1]
      244195904 blocks [2/1] [_U]

unused devices: <none>
A1:~# mdadm --manage --set-faulty /dev/md0  /dev/hdi1
mdadm: set /dev/hdi1 faulty in /dev/md0
A1:~# mdadm --detail /dev/md0
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

    Update Time : Sun Mar 13 01:28:06 2005
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           UUID : 6b8b4567:327b23c6:643c9869:66334873
         Events : 0.343413

    Number   Major   Minor   RaidDevice State
       0      34        1        0      active sync   /dev/hdg1
       1       0        0        -      removed

       2      56        1        1      faulty   /dev/hdi1
A1:~# mdadm /dev/md0 -r /dev/hdi1
mdadm: hot remove failed for /dev/hdi1: Device or resource busy
A1:~# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 hdi1[2](F) hdg1[0]
      244195904 blocks [2/1] [U_]
        resync=DELAYED
md1 : active raid1 hdc1[1]
      244195904 blocks [2/1] [_U]

md2 : active raid1 hde1[1]
      244195904 blocks [2/1] [_U]

unused devices: <none>
A1:~# mdadm /dev/md0 -r /dev/hdi1
mdadm: hot remove failed for /dev/hdi1: Device or resource busy
A1:~#                                                                 

Any ideas on what I can do now?

thanks
Mitchell
