From: =?ISO-8859-15?Q?Karsten_R=F6mke?= <k.roemke@gmx.de>
Subject: misunderstanding of spare and raid devices?
Date: Thu, 30 Jun 2011 12:51:37 +0200
Message-ID: <4E0C5539.4030000@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I'm searching some hours / minutes to create a raid5 device with 4 disks and 1 spare:
I tried first with the opensuse tool but no success as I want, so I tried mdadm

Try:
  mdadm --create /dev/md0 --level=5 --raid-devices=4 --spare-devices=1 /dev/sda3 /dev/sdb2 /dev/sdc5 /dev/sdd5 /dev/sde5

leads to
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active (auto-read-only) raid5 sdd5[5](S) sde5[4](S) sdc5[2] sdb2[1] sda3[0]
       13759296 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]

2 spares - I don't understand that.


kspace9:~ # mdadm --create /dev/md0 --level=5 --raid-devices=4 /dev/sda3 /dev/sdb2 /dev/sdc5 /dev/sdd5
leads to
md0 : active (auto-read-only) raid5 sdd5[4](S) sdc5[2] sdb2[1] sda3[0]
       13759296 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]

1 spare - but why - I expect 4 active disks and 1 spare

kspace9:~ # mdadm --create /dev/md0 --level=5 --raid-devices=5 /dev/sda3 /dev/sdb2 /dev/sdc5 /dev/sdd5 /dev/sde5
leads to
md0 : active (auto-read-only) raid5 sde5[5](S) sdd5[3] sdc5[2] sdb2[1] sda3[0]
       18345728 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]

That's what I want, but I reached it more or less by random.
Where is my "think-error" (in german).

I use
kspace9:~ # mdadm --version
mdadm - v3.0.3 - 22nd October 2009

Any hints would be nice
karsten
