From: Scott White <scott-raid@riskboys.com>
Subject: One disk busy in RAID5?
Date: Sat, 30 Jul 2005 16:21:47 +0100
Message-ID: <1122736907.2963.26.camel@lian.jtfltd.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm doing a big rsync to my 5 disk RAID 5 partition and am seeing an
uneven loading of my disks.  The files are almost all huge video files.
Has anyone got any idea what I could have done wrong?

md6 : active raid5 sdi1[4] sdh1[3] sdg1[2] sdf1[1] sde1[0]
      976783360 blocks level 5, 128k chunk, algorithm 2 [5/5] [UUUUU]

The filesystem is ext3 created with 
mkfs.ext3 -R stride=32 /dev/md6

Disks are all identical 250G Hitachi SATA on a Marvell 8 port PCI-X SATA
controller. 


"iostat -x 5" shows something like, (sorry about the wrap)

Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s
avgrq-sz avgqu-sz   await  svctm  %util
sde         36.80 291.20 10.60 143.00  380.80 3486.40   190.40  1743.20
25.18     1.76   11.37   0.86  13.14
sdf         30.20 293.80  4.60 147.60  280.00 3531.20   140.00  1765.60
25.04     1.82   11.95   0.88  13.40
sdg         43.20 316.40 10.40 117.20  432.00 3521.60   216.00  1760.80
30.98     2.75   20.47   1.35  17.22
sdh         47.60 286.60 10.40 146.80  464.00 3470.40   232.00  1735.20
25.03     2.51   15.96   1.05  16.50
sdi         43.20 344.00  8.40 88.40  412.80 3425.60   206.40  1712.80
39.65    34.86  391.68  10.33 100.04


So sdi is 100% utilized with await 10x the other disks and the other
disks are not busy.  When the array was building it was sdi that was
doing all the writes and the other 4 disks just doing reads but I
figured this was just the fastest way to build the array, now I wonder
if I have ended up with parity all on one disk like RAID4?  Or is one
disk bad and is there any way to find out?

Scott 


