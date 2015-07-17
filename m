From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V4 00/13] MD: a caching layer for raid5/6
Date: Fri, 17 Jul 2015 13:47:10 +1000
Message-ID: <20150717134710.43087b2b@noble>
References: <20150715004455.GA1024035@devbig257.prn2.facebook.com>
	<20150715121234.22803890@noble>
	<20150715031615.GA1292235@devbig257.prn2.facebook.com>
	<20150715140641.3c61cf78@noble>
	<20150715194927.GA3502691@devbig257.prn2.facebook.com>
	<20150716091653.7b970b32@noble>
	<20150716000739.GA4041321@devbig257.prn2.facebook.com>
	<20150716112217.3e2e685f@noble>
	<20150716041305.GA283306@devbig257.prn2.facebook.com>
	<20150716160711.08c37fc1@noble>
	<20150716174015.GA1992137@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150716174015.GA1992137@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, Kernel-team@fb.com
List-Id: linux-raid.ids

On Thu, 16 Jul 2015 10:40:17 -0700 Shaohua Li <shli@fb.com> wrote:

> On Thu, Jul 16, 2015 at 04:07:11PM +1000, NeilBrown wrote:
> > On Wed, 15 Jul 2015 21:13:06 -0700 Shaohua Li <shli@fb.com> wrote:
> > 

> > It's not a show-stopper.
> > However if you keep the backwards links, then the superblock is free to
> > point to any metadata block anywhere in the log.  That means we can let
> > the pointer in the superblock be updated lazily.  The cache module only
> > needs to force a superblock update if there hasn't been one for any
> > other reason.
> 
> superblock never need to be updated frequently. It's only updated when
> some space will be reused or to make recovery scan less. We don't need
> the backward link to achieve this. If you check my patch, superblock is
> updated very rarely.

OK.


> > I don't see that as a work-around.  But then I don't really trust
> > checksums and so would rather that we always write a metadata block
> > (with FUA or FLUSH) after writing data, and using that to know that the
> > data is safe.  If we did that, it would be natural to always have a
> > valid metadata block.
> 
> if you don't trust checksum, how can you make sure the metadata block is
> valid?

A checksum is useful when you have a block that you have good reason to
expect to be correct, and you want to double-check to guard against
error or corruption.
So if there is a pointer in the superblock that is supposed to always
point to a valid metadata block, then I strongly expect to find a
metadata block there.  If the magic number of checksum are wrong, then
that is very surprising.  Still worth checking because bugs happen at
all levels, but surprising.

If you have a pointer to something that may or may no be valid, then it
isn't particularly surprising if the checksum is wrong.  That is a very
different use case.

Famously reiserfs uses (or at least "used") checksums to identify
different sorts of blocks when performing an 'fsck'.  If you store the
image of a reiserfs filesystem in a file in reiserfs, then fsck could
get confused and think the data is metadata - the checksum matches.

That exact scenario would not apply to our log, but it still serves as
a warning not to put too much faith in checksums.  They can tell when
something if wrong, but not when it is right.

> 
> You object to add a superblock. Actually there is one with your
> proposal, the 'always valid metadata block' is acting as the role of
> superblock, since we must read metadata block to find log head. Creating
> a raid array will need create such block too. In other words, we need do
> everything a real superblock need to do with your proposal. So why don't
> we have an explict superblock instead of an implicit superblock?

I accept that a metadata block can be a de-facto superblock.
But why have two things when you can make do with one?

I'm a big fan of Occam's Razor:
   Entities must not be multiplied beyond necessity

NeilBrown
