From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: suns raid-z / zfs
Date: Mon, 18 Feb 2008 21:45:29 +0100
Message-ID: <20080218204529.GA17984@rap.rap.dk>
References: <20080217160403.GA15710@rap.rap.dk> <18361.1168.473685.214133@notabene.brown> <20080218053319.GA18863@rap.rap.dk> <18361.25379.998485.63488@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18361.25379.998485.63488@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 18, 2008 at 09:51:15PM +1100, Neil Brown wrote:
> On Monday February 18, keld@dkuug.dk wrote:
> > On Mon, Feb 18, 2008 at 03:07:44PM +1100, Neil Brown wrote:
> > > On Sunday February 17, keld@dkuug.dk wrote:
> > > > Hi
> > > > 
> > > 
> > > > It seems like a good way to avoid the performance problems of raid-5
> > > > /raid-6
> > > 
> > > I think there are better ways.
> > 
> > Interesting! What do you have in mind?
> 
> A "Log Structured Filesystem" always does large contiguous writes.
> Aligning these to the raid5 stripes wouldn't be too hard and then you
> would never have to do any pre-reading.
> 
> > 
> > and what are the problems with zfs?
> 
> Recovery after a failed drive would not be an easy operation, and I
> cannot imagine it being even close to the raw speed of the device.

I thought this was a problem with most raid types, while
reconstructioning, performance is quite slow. And as there has been some
damage, this is expected. And there probebly is no much ado about it.

Or is there? Are there any RAID types that performs reasonably well
given that one disk is under repair? The performance could be cruical
for some applications. 

One could think of clever arrangements so that say two disks could go
down and the rest of the array with 10-20 drives could still function
reasonably well, even under the reconstruction. As far as I can tell
from the code, the reconstruction itself is not impeding normal
performance much, as normal operation bars reconstuction operations.

Hmm, my understanding would then be, for both random reads and writes
that performance in typical raids would only be reduced by the IO bandwidth
of the failing disks.

For sequential R/W performance for raid10,f would
be hurt, downgrading its performance to random IO for the drives involved.

Raid5/6 would be hurt much for reading, as all drives need to be read for giving
correct information during reconstruction.


So it looks like, if your performance is important under a
reconstruction, then you should avoid raid5/6 and use the mirrored raid
types. Given you have a big operation, with a load balance of a lot of
random reading and writing, it does not matter much which mirrored
raid type you would choose, as they all perform about equal for random
IO, even when reconstructing. Is that correct advice?

> > 
> > > > 
> > > > But does it stripe? One could think that rewriting stripes
> > > > other places would damage the striping effects.
> > > 
> > > I'm not sure what you mean exactly.  But I suspect your concerns here
> > > are unjustified.
> > 
> > More precisely. I understand that zfs always write the data anew.
> > That would mean at other blocks on the partitions, for the logical blocks
> > of the file in question. So the blocks on the partitions will not be
> > adjacant. And striping will not be possible, generally.
> 
> The important part of striping is that a write is spread out over
> multiple devices, isn't it.
> 
> If ZFS can choose where to put each block that it writes, it can
> easily choose to write a series of blocks to a collection of different
> devices, thus getting the major benefit of striping.

I see 2 major benefits of striping: one is that many drives are involved 
and the other is that the stripes are  allocated adjacant, so that io
on one drive can just proceed to the next physical blocks when one
stripe has been processed. Dependent on the size of the IO operations
involved, first one or more disks in a stripe is processed, and then the
following stripes are processed. ZFS misses the second part of the
optimization, In think.

Best regards
Keld
