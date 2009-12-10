From: hank peng <pengxihan@gmail.com>
Subject: Is this a bitmap bug on RAID5?
Date: Thu, 10 Dec 2009 15:57:52 +0800
Message-ID: <389deec70912092357i2519c5basc376bd3565f53d7f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi, All:
Today, I encountered this problem and don't know whether it is a bug.
# uname -a
Linux Storage 2.6.31.6 #7 Thu Dec 10 15:24:00 CST 2009 ppc unknown
# mdadm -C /dev/md0 --bitmap=internal -l5 -n3 /dev/sd{b1,c1,d1}
mdadm: /dev/sdb1 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Thu Dec 10 15:45:48 2009
mdadm: /dev/sdc1 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Thu Dec 10 15:45:48 2009
mdadm: /dev/sdd1 appears to be part of a raid array:
    level=raid5 devices=3 ctime=Thu Dec 10 15:45:48 2009
Continue creating array? y
mdadm: array /dev/md0 started.
# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[3] sdc1[1] sdb1[0]
      5879552 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]
      [===>.................]  recovery = 15.7% (462848/2939776)
finish=2.0min speed=20125K/sec
      bitmap: 0/180 pages [0KB], 8KB chunk

unused devices: <none>

#dd if=/dev/zero of=/dev/md0 bs=1M count=1000

When dd is going on, I cat /proc/mdstat
# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[3] sdc1[1] sdb1[0]
      5879552 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]
      [========>............]  recovery = 44.1% (1297280/2939776)
finish=3.3min speed=8166K/sec
      bitmap: 6/180 pages [24KB], 8KB chunk

After dd completed, I cat /proc/mdstat:
# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[2] sdc1[1] sdb1[0]
      5879552 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 32/180 pages [128KB], 8KB chunk

unused devices: <none>

Some time later, I cat /proc/mdstat again:
# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[2] sdc1[1] sdb1[0]
      5879552 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 32/180 pages [128KB], 8KB chunk

unused devices: <none>

As you noticed, the value before slash in "bitmap: 32/180 pages "
never changed. I think it should be zero after date is written into
disk.




unused devices: <none>



-- 
The simplest is not all best but the best is surely the simplest!
