From: Dave Chinner <david@fromorbit.com>
Subject: Re: O_DIRECT to md raid 6 is slow
Date: Mon, 20 Aug 2012 15:19:51 +1000
Message-ID: <20120820051951.GC19235@dastard>
References: <502D6B0A.6090508@xs4all.net>
 <502DF357.8090205@hardwarefreak.com>
 <502E2817.8040306@xs4all.net>
 <502F237D.6060806@hardwarefreak.com>
 <502F698C.9010507@msgid.tls.msk.ru>
 <50305AB9.5080302@hardwarefreak.com>
 <5030F1C6.90205@hesbynett.no>
 <50317804.9010701@hardwarefreak.com>
 <20120820100134.22b2b056@notabene.brown>
 <5031C0A9.60803@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5031C0A9.60803@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: NeilBrown <neilb@suse.de>, David Brown <david.brown@hesbynett.no>, Michael Tokarev <mjt@tls.msk.ru>, Miquel van Smoorenburg <mikevs@xs4all.net>, Linux RAID <linux-raid@vger.kernel.org>, LKML@dastard
List-Id: linux-raid.ids

On Sun, Aug 19, 2012 at 11:44:25PM -0500, Stan Hoeppner wrote:
> I'm copying Dave C. as he apparently misunderstood the behavior of
> md/RAID6 as well.  My statement was based largely on Dave's information.
>  See [1] below.

Not sure what I'm supposed to have misunderstood...

> On 8/19/2012 7:01 PM, NeilBrown wrote:
> > On Sun, 19 Aug 2012 18:34:28 -0500 Stan Hoeppner <stan@hardwarefreak.com>
> > wrote:
> 
> > Since we are trying to set the record straight....
> 
> Thank you for finally jumping in Neil--had hoped to see your
> authoritative information sooner.
> 
> > md/RAID6 must read all data devices (i.e. not parity devices) which it is not
> > going to write to, in an RWM cycle (which the code actually calls RCW -
> > reconstruct-write).

That's a RMW cycle from an IO point of view. i.e. sycnhronous read
must take place before the data can be modified and written...

> > md/RAID5 uses an alternate mechanism when the number of data blocks that need
> > to be written is less than half the number of data blocks in a stripe.  In
> > this alternate mechansim (which the code calls RMW - read-modify-write),
> > md/RAID5 reads all the blocks that it is about to write to, plus the parity
> > block.  It then computes the new parity and writes it out along with the new
> > data.

And by the same definition, that's also a RMW cycle.

> >> [1}The only thing that's not clear at this point is if md/RAID6 also
> >> always writes back all chunks during RMW, or only the chunk that has
> >> changed.
> 
> > Do you seriously imagine anyone would write code to write out data which it
> > is known has not changed?  Sad. :-)

Two words: media scrubbing.

> On 6/25/2012 9:30 PM, Dave Chinner wrote:
> > IOWs, every time you do a small isolated write, the MD RAID volume
> > will do a RMW cycle, reading 11MB and writing 12MB of data to disk.

Oh, you're probably complaining about that write number.  All I was
trying to do was demonstrate what a worst case RMW cycle looks like.
So by the above, that occurs when you have a same isolated write to
each chunk of the stripe. A single write is read 11MB, write 1.5MB
(data + 2 parity). It doesn't really change the IO latency or load,
though, you've still got the same read-all, modify, write-multiple
IO pattern....

> > Given that most workloads are not doing lots and lots of large
> > sequential writes this is, IMO, a pretty bad default given typical
> > RAID5/6 volume configurations we see....

Either way, the point I was making in the original post stands -
RAID6 sucks balls for most workloads as they only do small writes in
comparison to the stripe width of the volume....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
