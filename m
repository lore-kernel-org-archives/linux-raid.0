From: "bmoon" <bo@sosnetwork.net>
Subject: Could not have the right MD device name on /proc/partitions
Date: Thu, 19 Sep 2002 11:42:01 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00f001c2600c$3dd29480$6a01a8c0@bmoon>
References: <Pine.LNX.4.44.0209162301200.24650-100000@ddx.a2000.nu><001d01c25ef9$6bc25240$900d0d93@M02WS17219> <15752.23100.95651.59572@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

Hello,

I am having very strange and serious problem, which I could not
have the right MD device name from /proc/partitions.

I created md1,2,3,4 but it shows "md0" for all as you can see
from the following "cat /proc/partitions".

arm-raid# mdadm -C /dev/md1 -l1 -n2 /dev/hdb5 /dev/hdd5
mdadm: array /dev/md1 started.
arm-raid# mdadm -C /dev/md2 -l1 -n2 /dev/hdb6 /dev/hdd6
mdadm: array /dev/md2 started.
arm-raid#mdadm -C /dev/md3 -l1 -n2 /dev/hda5 /dev/hdc5
mdadm: array /dev/md3 started.
arm-raid#mdadm -C /dev/md4 -l1 -n2 /dev/hda6 /dev/hdc6
mdadm: array /dev/md4 started.

arm-raid#cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] 
read_ahead 1024 sectors
md4 : active raid1 hdc6[1] hda6[0]
      1024000 blocks [2/2] [UU]
      
md3 : active raid1 hdc5[1] hda5[0]
      1024000 blocks [2/2] [UU]
      
md2 : active raid1 hdd6[1] hdb6[0]
      1024000 blocks [2/2] [UU]
      
md1 : active raid1 hdd5[1] hdb5[0]
      1024000 blocks [2/2] [UU]
      
unused devices: <none>

arm-raid#cat /proc/partitions
major minor  #blocks  name

   9     1    1024000 md0
   9     2    1024000 md0
   9     3    1024000 md0
   9     4    1024000 md0
   3     0  120060864 hda
   3     1      16600 hda1

Any clues? suggestions?

Thanks in advance,

Bo
