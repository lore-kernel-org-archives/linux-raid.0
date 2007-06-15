From: Neil Brown <neilb@suse.de>
Subject: Re: limits on raid
Date: Sat, 16 Jun 2007 08:21:26 +1000
Message-ID: <18035.4326.900551.657370@notabene.brown>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<20070615091318.GQ86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Chinner on Friday June 15
Sender: linux-raid-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 15, dgc@sgi.com wrote:
> On Fri, Jun 15, 2007 at 01:58:20PM +1000, Neil Brown wrote:
> > Certainly.  But the raid doesn't need to be tightly integrated
> > into the filesystem to achieve this.  The filesystem need only know
> > the geometry of the RAID and when it comes to write, it tries to write
> > full stripes at a time.
> 
> XFS already knows this (stripe unit, stripe width) and already
> does stripe unit sized and aligned allocation where it can.

What happens if the device gets restriped (e.g. add a drive to raid5)?
Is it possible to tell XFS about the new shape, or is it a mkfs only
thing?

I think it would be nice if the filesystem could query the device to
find out this geometry, and even that the device could tell the
filesystem that the geometry has changed.  But we don't have well
defined interfaces for that (yet).

> 
> > If that means writing some extra blocks full
> > of zeros, it can try to do that.  This would require a little bit
> > better communication between filesystem and raid, but not much.  If
> > anyone has a filesystem that they want to be able to talk to raid
> > better, they need only ask...
> 
> I'm interested in what you think is necessary here, Neil.

I see it more as "What does the filesystem think is necessary".
Some possibilities I see:
 - if the filesystem keeps checksums of some blocks, and finds that a
   block looks wrong, it might want to ask the RAID system "Do you
   have another copy of that I could try".
 - If the filesystem uses a journal, it might benefit from always
   doing strip-wide(*) writes.  With a journal, read speed is not a big
   issue, and padding is quite possible.  So the filesystem might want
   to find out the exact geometry so it can write a full strip each
   time, and it might want an interface so it can say "I am writing a
   full strip - don't start processing until I say 'go'".

> 
> But I think there's more to it than this - the filesystem only
> writes back what the generic writeback code passes it (i.e. a page
> at a time). XFs writes back extra adjacent pages in each I/O
> if they are in the same state, but it might take multiple
> I/Os to write out a full stripe units if we are doing things
> like writing across a hole.

I think the suggestion was that if the filesystem knows the contents
of other blocks in the stripe, then it might be more efficient to
write them out as well, even if they aren't dirty. e.g. if we know a
neighbouring block is unallocated, write zeros.  If we have a
neighbouring block in the page cache that is clean, write it out as
well as doing so will reduce the pre-reading required for a full
write.

> 
> Also, there is no guarantee that the first page the filesystem
> receives lies at the start of a stripe boundary, so that
> sort of information really needs to be propagated into
> the generic writeback code above the filesystem as well....
> 
> IOWs, the files can easily end I/Os on stripe boundaries
> but it is much harder to start them there because that is
> not in the control of the filesystem.

This of course depends on the layout used by the filesystem.
For a traditional layout where files are allocated to locations on
storage and stay there, you are absolutely correct.
For copy-on-write filesystems,  there is a lot more room to choose
size and alignment for all writes.  We seem to have a growth spurt in
this style of filesystem at the moment.  It will be interesting to see
if they can deliver equal performance (copy-on-write tends to risk
fragmented reads).   I suspect these new filesystems will have more
interest in closer integration with RAID.

NeilBrown

(*) A 'strip-wide' write is different from a 'stripe-wide' write.   It
is one block from each device, rather than one chunk.  These blocks
will likely not be consecutive in device-space, but writing them as a
group will be faster than writing a similar number of blocks that are
consecutive.  Laying out a journal so that consecutive blocks follow
strips might make writes faster.
