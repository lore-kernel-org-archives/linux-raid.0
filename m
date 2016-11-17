From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 1/4] md: add block tracing for bio_remapping
Date: Thu, 17 Nov 2016 10:04:23 -0800
Message-ID: <20161117180423.tzmeqpgklihgh7vp@kernel.org>
References: <147910131504.27168.6566119701315109161.stgit@noble>
 <147910142095.27168.11356591734977480053.stgit@noble>
 <20161116192922.ylqx32zocag4xp4b@kernel.org>
 <87twb6hdqq.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87twb6hdqq.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 17, 2016 at 04:33:33PM +1100, Neil Brown wrote:
> On Thu, Nov 17 2016, Shaohua Li wrote:
> 
> > On Mon, Nov 14, 2016 at 04:30:21PM +1100, Neil Brown wrote:
> >> The block tracing infrastructure (accessed with blktrace/blkparse)
> >> supports the tracing of mapping bios from one device to another.
> >> This is currently used when a bio in a partition is mapped to the
> >> whole device, when bios are mapped by dm, and for mapping in md/raid5.
> >> Other md personalities do not include this tracing yet, so add it.
> >> 
> >> When a read-error is detected we redirect the request to a different device.
> >> This could justifiably be seen as a new mapping for the originial bio,
> >> or a secondary mapping for the bio that errors.  This patch uses
> >> the second option.
> >> 
> >> When md is used under dm-raid, the mappings are not traced as we do
> >> not have access to the block device number of the parent.
> >
> > Looks the the original sector (the last parameter of trace_block_bio_remap)
> > isn't correct.
> > - in linear/raid0, bio_split already updated bio->bi_iter.bi_sector
> 
> Oh yes, of course.  in the common case 'split == bio' so when
> split->bi_iter.bi_sector  is adjusted, bio->.... is as well.
> I'll fix that, and also add calls to trace_block_split() as appropriate.
> 
> 
> > - in raid1/raid10, r1_bio->sector is updated before the bio is sent.
> 
> Here I really think my code is correct.  r1_bio->sector is always the
> address in the array of the request.  It is only set once for each
> r1_bio, and that is before the call to trace_block_io_remap().

Oh, you are right, sorry. I think moving the trace_remap right before we add
the bio to plug or pending list is better. It will make the code simpler. The
timing of the trace doesn't matter.

Thanks,
Shaohua
