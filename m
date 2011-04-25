From: Mark Knecht <markknecht@gmail.com>
Subject: High mismatch count on root device - how to best handle?
Date: Mon, 25 Apr 2011 15:32:59 -0700
Message-ID: <BANLkTikLN6P52tknwD0+D-+2iDUp3sF1fA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I did a drive check today, first time in months, and found I have a
high mismatch count on my RAID1 root device. What's the best way to
handle getting this cleaned up?

1) I'm running some smartctl tests as I write this.

2) Do I just do an

echo repair

to md126 or do I have to boot a rescue CD before I do that?

If you need more info please let me know.

Thanks,
Mark

c2stable ~ # cat /sys/block/md3/md/mismatch_cnt
0
c2stable ~ # cat /sys/block/md6/md/mismatch_cnt
0
c2stable ~ # cat /sys/block/md7/md/mismatch_cnt
0
c2stable ~ # cat /sys/block/md126/md/mismatch_cnt
222336
c2stable ~ # df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md126            51612920  26159408  22831712  54% /
udev                     10240       432      9808   5% /dev
/dev/md7             389183252 144979184 224434676  40% /VirtualMachines
shm                    6151452         0   6151452   0% /dev/shm
c2stable ~ # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md6 : active raid1 sdc6[2] sda6[0] sdb6[1]
      247416933 blocks super 1.1 [3/3] [UUU]

md7 : active raid6 sdc7[2] sda7[0] sdb7[1] sdd2[3] sde2[4]
      395387904 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]

md3 : active raid6 sdc3[2] sda3[0] sdb3[1] sdd3[3] sde3[4]
      157305168 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5] [UUUUU]

md126 : active raid1 sdc5[2] sda5[0] sdb5[1]
      52436032 blocks [3/3] [UUU]

unused devices: <none>
c2stable ~ #
