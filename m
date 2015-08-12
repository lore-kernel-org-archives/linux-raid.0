From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 7/9] raid5: don't allow resize/reshape with cache(log)
 support
Date: Wed, 12 Aug 2015 13:57:12 +1000
Message-ID: <20150812135712.7cb14036@noble>
References: <cover.1438215986.git.shli@fb.com>
	<7986246dabd1722b2ea9461da91651509049c2a6.1438215986.git.shli@fb.com>
	<20150805141351.126bb888@noble>
	<20150805214221.GB3197719@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150805214221.GB3197719@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, 5 Aug 2015 14:42:21 -0700 Shaohua Li <shli@fb.com> wrote:

> On Wed, Aug 05, 2015 at 02:13:51PM +1000, NeilBrown wrote:
> > On Wed, 29 Jul 2015 17:38:47 -0700 Shaohua Li <shli@fb.com> wrote:
> > 
> > > If cache(log) support is enabled, don't allow resize/reshape in current
> > > stage. In the future, we can flush all data from cache(log) to raid
> > > before resize/reshape and then allow resize/reshape.
> > 
> > Just to be on the safe side, you could probably add code to refuse to
> > start an array that is in the middle of a reshape and also have a log
> > configured.
> ok
>  
> > I think it makes sense to plan ahead a little and make sure we can
> > handle a cache on a reshaping array properly.
> > 
> > If the log metadata block includes a before/after flag for each stripe,
> > which recorded whether the stripe was "before" or "after"
> > reshape_position when it was written, then when recovering the log we
> > can check if the given addresses are still on that side.  If they are,
> > just recover using the appropriate geometry info from the superblock.
> > If not, then reshape has passed over that stripe and it must now be
> > fully up-to-date on the RAID so the data in the log can be discarded.
> > 
> > There may be some details I missed, but I think it is worth thinking
> > through properly.  I don't expect the code to handle this straight
> > away, but we need a clear plan to be sure there is sufficient
> > information stored in the log.
> 
> Just adding a flag is enough? Sounds there is no way to avoid the write
> hole issue if the array is reshapping. The data stored in log is valid,
> but if a reshape runs, we can't guarantee the parity is valid.

When a region of the array is reshaped, the current data is read (if
not already in the stripe cache), then written out to a location on disk
which is not currently in use, and then the superblock is updated to
record that the new area should be used and the old area is no longer
relevant.
So we have atomic updates from 'old' to 'new'.  There is no write-hole
issue for these writes.

So if a particular address in the array was in the 'old' section when
data was written to the log, and if on restart those addresses are in
the 'new' section, then we can be sure that the data, including parity,
was completely written to the new section - so the data in the log is
not needed.

So if we just add a before/after flag to entries in the log then we can
safe recovery around a reshape.
When reading the log on restart in some data is marked as being in the
'old' section but the address now maps to the 'new' section, then we
safely ignore that data.


Thanks,
NeilBrown
