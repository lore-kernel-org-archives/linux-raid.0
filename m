From: Paul Nowoczynski <pauln@psc.edu>
Subject: Re: Raid5 Construction Question
Date: Fri, 20 Aug 2004 00:53:18 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408192358240.21605@pscuxb.psc.edu>
References: <200408191730.i7JHUd313659@watkins-home.com> <4124E8F5.1010105@psc.edu>
 <16677.21008.119662.799869@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16677.21008.119662.799869@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,
Thanks for the info - I tried something along these lines
but didn't know how to set the faulty disk.  I didn't see it in
a man page though I should have caught it with raid\tab\tab :)

Ironically, the performance did end up hovering around 30MB/sec
for most of the rebuild.

Thanks.
Pul

On Fri, 20 Aug 2004, Neil Brown wrote:

> On Thursday August 19, pauln@psc.edu wrote:
> >
> > md0 : active raid5 sdh1[7] sdf1[6] sdg1[5] sde1[4] sdd1[3] sdc1[2]
> > sdb1[1] sda1[0]
> >       481949184 blocks level 5, 64k chunk, algorithm 2 [7/7] [UUUUUUU]
> >       [>....................]  resync =  2.4% (1936280/80324864)
> > finish=4261.4min speed=305K/sec
> >
> > In the docs I saw that "reconstruction" is possible with raidhotadd but
> > I didn't
> > see anything about initialization.   So am I "screwed" until the resync
> > is fixed?  I was depeding
> > on the disks to do some filesystem testing but maybe I'll have to wait a
> > few days..
>
> When resyncing an array, raid5 will read all the blocks in each
> stripe, check the parity, and if it is wrong, write out the new
> parity.
> For a mostly-correct array this just involves lots of sequential
> reads.  For a mostly incorrect array, this involves lots of
> read-seek-writes which is substantially slower.
>
> When reconstructing onto a spare, raid5 will read all the good drives
> and write to the spare.  This all IO is sequential, there are no
> seeks, and it is nice and fast.
>
> It is for this reason that 'mdadm' will normally create a raid5 array
> with one missing drive and one spare, which is then immediately
> reconstructed.
>
> mkraid, on the other hand, doesn't know about this, and just creates
> the array and the sync happens which, as you note, can be quite slow.
>
> So, you can either re-make the array with mdadm or, you can fail one
> drive, remove it and re-add it.
>
>    raidsetfaulty /dev/md0 /dev/sdh1
>    raidhotremove /dev/md0 /dev/sdh1
>    raidhotadd /dev/md0 /dev/sdh1
>
> In either case it should stop the resync and start reconstruction
<> which will be much faster.
>
> NeilBrown
>
