From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Problem re-shaping RAID6
Date: Sun, 13 Jun 2010 15:15:08 -0400
Message-ID: <AANLkTikv3JPbto1F2YYmRx0HNP7cgFh3gj6dHekCt1SE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I had problems reshaping my RAID6 down 1 disk today and found a
problem in Grow.c:

diff -udpr mdadm-3.1.2/Grow.c mdadm-3.1.2-critical-section/Grow.c
--- mdadm-3.1.2/Grow.c  2010-03-09 23:31:39.000000000 -0500
+++ mdadm-3.1.2-critical-section/Grow.c 2010-06-13 14:57:44.000000000 -0400
@@ -497,7 +497,7 @@ int Grow_reshape(char *devname, int fd,
        int rv = 0;
        struct supertype *st;

-       int nchunk, ochunk;
+       unsigned long nchunk, ochunk;
        int nlayout, olayout;
        int ndisks, odisks;
        int ndata, odata;


After changing this I was able to re-shape the array, it seems it was
overflowing and I had a message saying:
root@billsshack:~/mdadm-3.1.2/ > ./mdadm --grow /dev/md0
--raid-devices=6 --backup-file=/mnt/data1/md-raid6-grow-backup.bak
mdadm: Need to backup 4503599627350016K of critical section..
mdadm: /dev/md0: Something wrong - reshape aborted

Now it works:
root@billsshack:~/mdadm-3.1.2/ > ./mdadm --grow /dev/md0
--raid-devices=6 --backup-file=/mnt/data1/md-raid6-grow-backup.bak
mdadm: Need to backup 20480K of critical section..
root@billsshack:~/mdadm-3.1.2/ > cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
[faulty] [linear]
md0 : active raid6 dm-6[0] dm-8[5] dm-5[4] dm-3[3] dm-4[2] dm-7[1]
      7814041600 blocks super 0.91 level 6, 1024k chunk, algorithm 2
[6/5] [UUUUUU]
      [>....................]  reshape =  0.0% (33792/1953510400)
finish=1926.0min speed=16896K/sec


Here's a nice output of GDB:
      Breakpoint 1, Grow_reshape (devname=0x7fffffffe390 "/dev/md0",
fd=5, quiet=0,
          backup_file=0x7fffffffe3b8
"/mnt/data1/md-raid6-grow-backup.bak", size=1953510400, level=65534,
          layout_str=0x0, chunksize=0, raid_disks=6) at Grow.c:939
      939                     blocks = ochunk/512 * nchunk/512 * odata
* ndata / a;
      (gdb) p ochunk/512
      $9 = 2048
      (gdb) p ochunk/512 * nchunk/512
      $10 = -4194304
      (gdb) p nchunk
      $11 = 1048576
      (gdb) p ochunk
      $12 = 1048576
      (gdb) p ochunk/512
      $13 = 2048
      (gdb) p nchunk/512
      $14 = 2048
      (gdb) p 2048*2048
      $15 = 4194304
      (gdb) p 2048*2048*odata
      $16 = 20971520
      (gdb) p 2048*2048*odata*ndata
      $17 = 83886080
      (gdb) p 2048*2048*odata*ndata/a
      $18 = 40960
      (gdb) p ochunk/512 * nchunk/512 * odata * ndata / a
      $19 = 9007199254700032
      (gdb) p ochunk/512 * nchunk/512
      $20 = -4194304
      (gdb)
