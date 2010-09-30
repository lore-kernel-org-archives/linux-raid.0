From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: Accidental grow before add
Date: Thu, 30 Sep 2010 12:13:27 -0400
Message-ID: <AANLkTikDgY_icdc54FiaNVbAwGZ2CvOYtkVeKfTzYvtN@mail.gmail.com>
References: <AANLkTi=PydpqTR1x=KTfW16en3U3+KxoLV85iWpWtRC9@mail.gmail.com>
	<193703.58642.qm@web51305.mail.re2.yahoo.com>
	<AANLkTimWyuvf1_9H8QhLXQ5gYRya1ux6WFGS4EPWP5_U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimWyuvf1_9H8QhLXQ5gYRya1ux6WFGS4EPWP5_U@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In the spirit of providing full updates for interested parties/future Googlers:

> I'm thinking it's going through the original
> reshape I kicked off (transforming it from an intact 7 disk RAID 6 to
> a degraded 8 disk RAID 6) and then when it gets to the end it will run
> another reshape to pick up the new spare.

Well that "first" reshape finally finished and it looks like it
actually did switch over to bringing in the new spare at some point in
midstream. I only noticed it after the reshape completed, but here's
the window where it happened.


23:02 (New spare still unused):

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid6 sdk1[0] md3p1[8](S) sde1[6] sdf1[5] md1p1[4] sdl1[3] sdj1[1]
      7324227840 blocks super 1.2 level 6, 256k chunk, algorithm 2
[8/6] [UUUUUU__]
      [===============>.....]  reshape = 76.4% (1119168512/1464845568)
finish=654.5min speed=8801K/sec

md3 : active raid0 sdb1[0] sdh1[1]
      1465141760 blocks super 1.2 128k chunks

md1 : active raid0 sdi1[0] sdm1[1]
      1465141760 blocks super 1.2 128k chunks

unused devices: <none>


23:03 (Spare flag is gone, although it's not marked as "Up" yet further down):

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid6 sdk1[0] md3p1[8] sde1[6] sdf1[5] md1p1[4] sdl1[3] sdj1[1]
      8789073408 blocks super 1.2 level 6, 256k chunk, algorithm 2
[8/6] [UUUUUU__]
      [===============>.....]  recovery = 78.7%
(1152999432/1464845568) finish=161.1min speed=32245K/sec

md3 : active raid0 sdb1[0] sdh1[1]
      1465141760 blocks super 1.2 128k chunks

md1 : active raid0 sdi1[0] sdm1[1]
      1465141760 blocks super 1.2 128k chunks

unused devices: <none>



14:57 (It seemed to stall at the percent complete above for about 16 hours):

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid6 sdk1[0] md3p1[8] sde1[6] sdf1[5] md1p1[4] sdl1[3] sdj1[1]
      8789073408 blocks super 1.2 level 6, 256k chunk, algorithm 2
[8/6] [UUUUUU__]
      [===============>.....]  recovery = 79.1%
(1160057740/1464845568) finish=161.3min speed=31488K/sec

md3 : active raid0 sdb1[0] sdh1[1]
      1465141760 blocks super 1.2 128k chunks

md1 : active raid0 sdi1[0] sdm1[1]
      1465141760 blocks super 1.2 128k chunks

unused devices: <none>



15:01 (And the leap forward):

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid6 sdk1[0] md3p1[8] sde1[6] sdf1[5] md1p1[4] sdl1[3] sdj1[1]
      8789073408 blocks super 1.2 level 6, 256k chunk, algorithm 2
[8/6] [UUUUUU__]
      [==================>..]  recovery = 92.3%
(1352535224/1464845568) finish=58.9min speed=31729K/sec

md3 : active raid0 sdb1[0] sdh1[1]
      1465141760 blocks super 1.2 128k chunks

md1 : active raid0 sdi1[0] sdm1[1]
      1465141760 blocks super 1.2 128k chunks

unused devices: <none>



16:05 (Finishing clean, with only the drive that failed in mid-reshape
still missing):

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid6 sdk1[0] md3p1[8] sde1[6] sdf1[5] md1p1[4] sdl1[3] sdj1[1]
      8789073408 blocks super 1.2 level 6, 256k chunk, algorithm 2
[8/7] [UUUUUUU_]

md3 : active raid0 sdb1[0] sdh1[1]
      1465141760 blocks super 1.2 128k chunks

md1 : active raid0 sdi1[0] sdm1[1]
      1465141760 blocks super 1.2 128k chunks

unused devices: <none>


So it seemed to pause for about 16 hours to pull in the spare, but
that's 4-5 times faster than it would normally take to grow the array
onto a new one. I assume that's because I was already reshaping the
array to fit across 8 disks (they just weren't all there) so when it
saw the new one it only had to update the new disk. Hopefully it will
go that fast when I replace the other disk that died.

Everything seems to have worked out ok - I just did a forced fsck on
the filesystem and it didn't mention correcting anything. Mounted it
and everything seems to be intact. Hopefully this whole thread will be
useful for someone in a similar situation. Thanks to everyone for the
help.

Mike
