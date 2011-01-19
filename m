From: NeilBrown <neilb@suse.de>
Subject: Re: How to force rewrite of a smart detected bad block with raid5:
 checkarray?
Date: Thu, 20 Jan 2011 07:01:33 +1100
Message-ID: <20110120070133.47eccd10@notabene.brown>
References: <4D372F1C.7080703@clear.net.nz>
	<20110119184914.GA27358@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119184914.GA27358@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Richard Scobie <r.scobie@clear.net.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 19 Jan 2011 10:49:14 -0800 Marc MERLIN <marc@merlins.org> wrote:

> On Thu, Jan 20, 2011 at 07:36:12AM +1300, Richard Scobie wrote:
> > Marc Merlin wrote:
> > 
> > > Also, I didn't find anything about sync_action, check, and repair in
> > > the mdadm man page (a pointer to
> > > https://raid.wiki.kernel.org/index.php/RAID_Administration
> > > would me useful).
> > > Actually the above page still says that you can't check just a range
> > > of blocks.
> > 
> > > Is there more up to date documentation that I should be reading
> > > somewhere?
> > 
> > The kernel source, Documentation/md.txt.
> 
> Ah, yes of course. Didn't think about looking there, thanks.

"man md" is also an appropriate place to look.

> 
> Mmmh, so I was curious as to how repair, when reading all the blocks of a
> stripe with no read errors, and finding a parity mismatch, would know which
> block was corrupted and needs to be rewritten.

It doesn't repair the data - that would be impossible.  It repairs the
redundancy information which is all that raid really knows about.
i.e. if it finds an inconsistency it re-writes the parity block.

> Given that I don't see how it can figure that out, I'm not even sure when
> repair would be useful for raid5 when there are no underlying media errors
> returned (raid6 obviously has redundant info and it's possible there).

It isn't often useful.  But if you parity blocks are wrong somehow, then it
can be useful.  It will not recover data that you have already lost, but it
could make it less likely to lose more data.

md currently treats RAID6 just the same way as RAID5 - parity is re-written.
It is possible that more could be done, but it isn't completely clear that it
should - and it certainly isn't high on my priority list.

NeilBrown


> 
> Not that I need repair in my case (check indeed does the right thing), I'm
> just not sure when repair would be useful.
> 
> Anyway, thanks again for the pointer.
> 
> Cheers,
> Marc

