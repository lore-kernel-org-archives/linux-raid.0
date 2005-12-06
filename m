From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 resync question
Date: Wed, 7 Dec 2005 10:50:54 +1100
Message-ID: <17302.9182.322057.18613@cse.unsw.edu.au>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs>
	<17300.56329.638969.509384@cse.unsw.edu.au>
	<004201c5f9fe$50cc41a0$0400a8c0@dcccs>
	<17300.58327.193597.248431@cse.unsw.edu.au>
	<002b01c5fa53$cd3d3fa0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Tuesday December 6
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 6, djani22@dynamicweb.hu wrote:
> 
> > > I know, it is some chance to leave some incorrect parity information on
> the
> > > array, but may be corrected by next write.
> >
> > Or it may not be corrected by the next write.  The parity-update
> > algorithm assumes that the parity is correct.
> 
> Hmm.
> If it works with parity-update algorithm, instead of parity "rewrite
> algorithm", you have right.

It chooses read-modify-write(depending on old parity), or
reconstruct-write (not depending on old parity) depending on how much
pre-reading each option requires.


> But it works block-based, and if the entire block is written, the parity is
> turned to de correct, or not? :-)

Not.

> What is the block size?

PAGE_SIZE (4K)

> It isequal to chunk-size?

no.
> 
> > > What does this exactly?
> >
> > Divides the array into approximately 200,000 sections (all a power of
> > 2 in size) and keeps track (in a bitmap) of which sections might have
> > inconsistent parity.  if you crash, it only syncs sections recorded in
> > the bitmap.
> >
> > > Changes the existing array's structure?
> >
> > In a forwards/backwards compatible way (makes use of some otherwise
> > un-used space).
> 
> What unused space?
> In the raid superblock?

The raid superblock is 4k in size, placed at least 64k from the end of
the devices.  Thus there is always at least 60k of dead space.

> The end of the drives or the end of the array?

end of the drives.  bitmap is stored (similar to raid1) on all
drivers.

> It leaves the raid structure unchanged except the superblocks?

yes.

> 
> >
> > > To use some checkpoints in ext file or device to resync an array?
> > > And the better handling of half-synced array?
> >
> > I don't know what these mean.
> 
> (a little background:
> I have write a little stat program, using /sys/block/#/stat -files, to find
> performance bottlenecks.
> In the stat files i can see, if the device is reads or writes, and the
> needed times for these.)
> 
> One time while my array is really rebuild one disk (paralel normal
> workload), i see, the new drive in the array *only* writes.
> i means with "better handling of half-synced array" is this:
> If read request comes to the ?% synced array, and if the read is on the
> synced half, only need to read from *new* device, instead reading all other
> to calculate data from parity.
> 
> On a working system this can be a little speed up the rebuild process, and
> some offload the system.
> Or i'm on a wrong clue? :-)

Yes, it would probably be possible to get it to read from the
recovering drive once that section had been recovered.  I'll put it on
my todo list.

NeilBrown
