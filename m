From: Jacob Schmidt Madsen <jacob@mungo.dk>
Subject: Trouble when growing a raid5 array
Date: Thu, 30 Nov 2006 08:04:14 +0100
Message-ID: <200611300804.15031.jacob@mungo.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey

I bought 2 new disks to be included in a big raid5 array.

I executed:
# mdadm /dev/md5 -a /dev/sdh1
# mdadm /dev/md5 -a /dev/sdi1
# mdadm --grow /dev/md5 --raid-disks=8

After 12 hours it stalled:
# cat /proc/mdstat
md5 : active raid5 sdc1[6] sdb1[7] sdi1[3] sdh1[2] sdg1[1] sdf1[0] sde1[4] 
sdd1[5]
      1562842880 blocks super 0.91 level 5, 64k chunk, algorithm 2 [8/8] 
[UUUUUUUU]
      [===================>.]  reshape = 98.1% (306783360/312568576) 
finish=668.7min speed=144K/sec

Its been stuck at 306783360/312568576 for hours now.

When i check the kernel log it is full of "compute_blocknr: map not correct".

I guess something went really bad? If someone know what is going on or if 
someone know what i can do to fix this.
I would really be sad if all the data was gone.

Thanks!
