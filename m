From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: mdadm and spare-group question
Date: Wed, 17 Mar 2004 13:20:48 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0403171254240.31494@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello

Looking at the spare-group and monitor option, how does mdadm take a
spare drive from one array to another and which drive is taken first
from the spare pool?

Taking my raid10 from the previous mail as an example, here the
mdadm.conf (without UUID to make it short):

DEVICE /dev/hda[2356] /dev/hde[2356]
DEVICE /dev/sd[abcdef]1
DEVICE /dev/md[234]

ARRAY /dev/md0 level=raid1 num-devices=2 devices=/dev/hda2,/dev/hde2
ARRAY /dev/md1 level=raid1 num-devices=2 devices=/dev/hda3,/dev/hde3
ARRAY /dev/md2 level=raid1 num-devices=2 devices=/dev/hda6,/dev/hda5,/dev/hde6,/dev/hde5,/dev/sdd1,/dev/sda1 spare-group=group1
ARRAY /dev/md3 level=raid1 num-devices=2 devices=/dev/sde1,/dev/sdb1 spare-group=group1
ARRAY /dev/md4 level=raid1 num-devices=2 devices=/dev/sdf1,/dev/sdc1 spare-group=group1
ARRAY /dev/md5 level=raid0 num-devices=3 devices=/dev/md2,/dev/md3,/dev/md4

And here the output of cat /proc/mdstat:

   Personalities : [raid0] [raid1] 
   md5 : active raid0 md2[0] md4[2] md3[1]
         215310528 blocks 64k chunks

   md1 : active raid1 hde3[1] hda3[0]
         4008128 blocks [2/2] [UU]

   md2 : active raid1 sda1[0] hde6[2] hda6[3] hde5[4] hda5[5] sdd1[1]
         71770240 blocks [2/2] [UU]

   md3 : active raid1 sdb1[0] sde1[1]
         71770240 blocks [2/2] [UU]

   md4 : active raid1 sdc1[0] sdf1[1]
         71770240 blocks [2/2] [UU]

   md0 : active raid1 hde2[1] hda2[0]
         33214272 blocks [2/2] [UU]

   unused devices: <none>

So spare group1 consists of /dev/hda6,/dev/hda5,/dev/hde6,/dev/hde5.
What I would like to achieve is that if one of my raid1's (md2,md3,md4)
from md5 fails, first /dev/hda5 gets put in, if another one fails /dev/hde5
gets put in, next /dev/hda6 and then /dev/hde6. Can this be done?

The reason why I want this ordering is to spread the load on the two
channels and second because hd[ae]5 will be slightly faster then
hd[ae]6.

Holger
