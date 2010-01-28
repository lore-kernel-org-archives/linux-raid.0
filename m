From: Yuehai Xu <yuehaixu@gmail.com>
Subject: The huge different performance of sequential read between RAID0 and
	RAID5
Date: Wed, 27 Jan 2010 22:16:12 -0500
Message-ID: <100eff551001271916y116de081la77982f4b5a03c73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: yhxu@wayne.edu
List-Id: linux-raid.ids

Hi,

When I use IOZONE to test sequential read performance, I notice the
result between RAID0 and RAID5 is totally different.

Below is the message from cat /proc/mdstat:
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sdh1[7] sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
      631353600 blocks level 5, 64k chunk, algorithm 2 [7/6] [UUUUUU_]
      [======>..............]  recovery = 30.6% (32202272/105225600)
finish=14.7min speed=82429K/sec

unused devices: <none>

The first question is that why the recovery is done after every time I
setup RAID5? I use such command to setup RAID5:
mdadm --create /dev/md0 --level=5 --raid-devices=7 /dev/sdb1 /dev/sdc1
/dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1

Anyway, after the recovery, I start to test. I divide 10 partitions in
RAID5 and RAID0, the mount info is:
/dev/md0p5             38G  817M   35G   3% /mnt/md0p5
/dev/md0p6             38G  817M   35G   3% /mnt/md0p6
/dev/md0p7             38G  817M   35G   3% /mnt/md0p7
/dev/md0p8             38G  817M   35G   3% /mnt/md0p8
/dev/md0p9             38G  817M   35G   3% /mnt/md0p9
/dev/md0p10            38G  817M   35G   3% /mnt/md0p10
/dev/md0p11            38G  817M   35G   3% /mnt/md0p11
/dev/md0p12            38G  817M   35G   3% /mnt/md0p12
/dev/md0p13            38G  817M   35G   3% /mnt/md0p13
/dev/md0p14            38G  817M   35G   3% /mnt/md0p14

Then I start IOZONE which starts 10 processes to do the sequential
read(iozone -i 1). Each process read 640M file on each partition. The
throughput of RAID0 is about 180M/s, while the throughput of RAID5 is
just 43M/s. Why the performance between RAID0 and RAID5 is so
different?

Yuehai
