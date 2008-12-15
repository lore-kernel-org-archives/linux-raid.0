From: Neil Brown <neilb@suse.de>
Subject: Re: Awful Raid10,f2 performance
Date: Tue, 16 Dec 2008 08:38:31 +1100
Message-ID: <18758.52823.375213.963854@notabene.brown>
References: <cccedfc60806020711o39ccd321h5e410c963d8bf3b1@mail.gmail.com>
	<48440953.3040004@wpkg.org>
	<cccedfc60806020809t73794ce6w539c6b0d247a264f@mail.gmail.com>
	<cccedfc60812150533p31974f4bye490958dbc974212@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Monday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
> A follow-up to an earlier post about weird slowness with RAID10,f2 and
> 3 drives. This morning's "check" operation is proceeding very slowly,
> for some reason.
> 
> dstat is showing 14-15MB/s worth of read I/O (0 or negligible write
> I/O) on each of the 3 drives which comprise the raid10,f2.
> 
> According to /proc/mdstat this is the current rate:
> 
>       [================>....]  check = 82.9% (381575040/460057152)
> finish=60.6min speed=21554K/sec
> 
> The sync_speed_min is 40000, sync_speed_max is 200000, and there is no
> other I/O on the system to speak of.
> 
> blockdev shows:
> 
> blockdev --getra /dev/sdb /dev/sdc /dev/sde
> 256
> 256
> 256
> 
> I just now tried setting it to 64K (65536) on each device and that did
> not seem to make much difference.
> 
> As you may recall from earlier posts, these drives are easily capable
> of twice or even three times this rate or more even at the inner
> tracks (70-80MB/s each on the outer tracks, 35-40MB/s on the inner
> tracks).
> 
> What might be going on here?

If you think about exactly which blocks of which drives md will have
to read, and in which order, you will see that each drive is seeking
half the size of the disk very often.  Exactly how often would depend
on chunk size and the depth of the queue in the elevator, but it would
probably read several hundred K from early in the disk, then several
hundred from half-way in, then back to start etc.  This would be
expected to be slow.

NeilBrown
