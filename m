From: hank peng <pengxihan@gmail.com>
Subject: Recovery didn't continue recovery after reboot
Date: Wed, 25 Nov 2009 12:14:19 +0800
Message-ID: <389deec70911242014r1a2f5c27k65a30f2d627b17c3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I created a RAID5 array which consisted of 3 disks.
#mdadm -C /dev/md0 --metadata=1.1 --bitmap=internal -l5 -n3 /dev/sd{a,b,c}
Before initial recovery was done, I reboot my system. After system is
on, initial recovery didn't continue.
#cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath]
md0 : active raid5 sda[0] sdc[3] sdb[1]
      976772864 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3] [UUU]

I removed '--bitmap' option and retest again, there was no problem and
recovery continued.

Is there something wrong? Any help will be appreciated!

-- 
The simplest is not all best but the best is surely the simplest!
