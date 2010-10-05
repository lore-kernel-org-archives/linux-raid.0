From: Neil Brown <neilb@suse.de>
Subject: Re: Accidental grow before add
Date: Tue, 5 Oct 2010 17:24:25 +1100
Message-ID: <20101005172425.4e6a6711@notabene>
References: <AANLkTi=PydpqTR1x=KTfW16en3U3+KxoLV85iWpWtRC9@mail.gmail.com>
	<193703.58642.qm@web51305.mail.re2.yahoo.com>
	<AANLkTimWyuvf1_9H8QhLXQ5gYRya1ux6WFGS4EPWP5_U@mail.gmail.com>
	<AANLkTikDgY_icdc54FiaNVbAwGZ2CvOYtkVeKfTzYvtN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikDgY_icdc54FiaNVbAwGZ2CvOYtkVeKfTzYvtN@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: Jon@ehardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 30 Sep 2010 12:13:27 -0400
Mike Hartman <mike@hartmanipulation.com> wrote:

> In the spirit of providing full updates for interested parties/future Googlers:
> 
> > I'm thinking it's going through the original
> > reshape I kicked off (transforming it from an intact 7 disk RAID 6 to
> > a degraded 8 disk RAID 6) and then when it gets to the end it will run
> > another reshape to pick up the new spare.
> 
> Well that "first" reshape finally finished and it looks like it
> actually did switch over to bringing in the new spare at some point in
> midstream. I only noticed it after the reshape completed, but here's
> the window where it happened.
> 
> 
> 23:02 (New spare still unused):
> 
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active raid6 sdk1[0] md3p1[8](S) sde1[6] sdf1[5] md1p1[4] sdl1[3] sdj1[1]
>       7324227840 blocks super 1.2 level 6, 256k chunk, algorithm 2
> [8/6] [UUUUUU__]
>       [===============>.....]  reshape = 76.4% (1119168512/1464845568)
> finish=654.5min speed=8801K/sec
> 
> md3 : active raid0 sdb1[0] sdh1[1]
>       1465141760 blocks super 1.2 128k chunks
> 
> md1 : active raid0 sdi1[0] sdm1[1]
>       1465141760 blocks super 1.2 128k chunks
> 
> unused devices: <none>
> 
> 
> 23:03 (Spare flag is gone, although it's not marked as "Up" yet further down):
> 
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active raid6 sdk1[0] md3p1[8] sde1[6] sdf1[5] md1p1[4] sdl1[3] sdj1[1]
>       8789073408 blocks super 1.2 level 6, 256k chunk, algorithm 2
> [8/6] [UUUUUU__]
>       [===============>.....]  recovery = 78.7%
> (1152999432/1464845568) finish=161.1min speed=32245K/sec
> 
> md3 : active raid0 sdb1[0] sdh1[1]
>       1465141760 blocks super 1.2 128k chunks
> 
> md1 : active raid0 sdi1[0] sdm1[1]
>       1465141760 blocks super 1.2 128k chunks
> 
> unused devices: <none>

This is really strange.  I cannot reproduce any behaviour like this.
What kernel are you using?

What should happen is that the reshape will continue to the end, and then a
recovery will start from the beginning of the array, incorporating the new
device.  This is what happens in my tests.

At about 84% the reshape should start going a lot faster as it no longer
needs to read data - it just writes zeros.  But there is nothing interesting
that can happen around 77%.





> 
> 
> 
> 14:57 (It seemed to stall at the percent complete above for about 16 hours):

This is also extremely odd.  I think you are saying that the 'speed' stayed
at a fairly normal level, but the 'recovery =' percent didn't change.
Looking at the code - that cannot happen!

Maybe there is a perfectly reasonable explanation - possibly dependant on the
particular kernel you are using - but I cannot see it.

I would certainly recommend a 'check' and a 'fsck' (if you haven't already).

NeilBrown




> 
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active raid6 sdk1[0] md3p1[8] sde1[6] sdf1[5] md1p1[4] sdl1[3] sdj1[1]
>       8789073408 blocks super 1.2 level 6, 256k chunk, algorithm 2
> [8/6] [UUUUUU__]
>       [===============>.....]  recovery = 79.1%
> (1160057740/1464845568) finish=161.3min speed=31488K/sec
> 
> md3 : active raid0 sdb1[0] sdh1[1]
>       1465141760 blocks super 1.2 128k chunks
> 
> md1 : active raid0 sdi1[0] sdm1[1]
>       1465141760 blocks super 1.2 128k chunks
> 
> unused devices: <none>
> 
> 
> 
> 15:01 (And the leap forward):
> 
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active raid6 sdk1[0] md3p1[8] sde1[6] sdf1[5] md1p1[4] sdl1[3] sdj1[1]
>       8789073408 blocks super 1.2 level 6, 256k chunk, algorithm 2
> [8/6] [UUUUUU__]
>       [==================>..]  recovery = 92.3%
> (1352535224/1464845568) finish=58.9min speed=31729K/sec
> 
> md3 : active raid0 sdb1[0] sdh1[1]
>       1465141760 blocks super 1.2 128k chunks
> 
> md1 : active raid0 sdi1[0] sdm1[1]
>       1465141760 blocks super 1.2 128k chunks
> 
> unused devices: <none>
> 
> 
> 
> 16:05 (Finishing clean, with only the drive that failed in mid-reshape
> still missing):
> 
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active raid6 sdk1[0] md3p1[8] sde1[6] sdf1[5] md1p1[4] sdl1[3] sdj1[1]
>       8789073408 blocks super 1.2 level 6, 256k chunk, algorithm 2
> [8/7] [UUUUUUU_]
> 
> md3 : active raid0 sdb1[0] sdh1[1]
>       1465141760 blocks super 1.2 128k chunks
> 
> md1 : active raid0 sdi1[0] sdm1[1]
>       1465141760 blocks super 1.2 128k chunks
> 
> unused devices: <none>
> 
> 
> So it seemed to pause for about 16 hours to pull in the spare, but
> that's 4-5 times faster than it would normally take to grow the array
> onto a new one. I assume that's because I was already reshaping the
> array to fit across 8 disks (they just weren't all there) so when it
> saw the new one it only had to update the new disk. Hopefully it will
> go that fast when I replace the other disk that died.
> 
> Everything seems to have worked out ok - I just did a forced fsck on
> the filesystem and it didn't mention correcting anything. Mounted it
> and everything seems to be intact. Hopefully this whole thread will be
> useful for someone in a similar situation. Thanks to everyone for the
> help.
> 
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

