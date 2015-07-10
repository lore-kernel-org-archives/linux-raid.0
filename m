From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH V4 00/13] MD: a caching layer for raid5/6
Date: Fri, 10 Jul 2015 10:48:45 -0700
Message-ID: <20150710174835.GA1837928@devbig257.prn2.facebook.com>
References: <cover.1435094582.git.shli@fb.com>
 <20150708115636.6c972269@noble>
 <20150708054344.GA2709238@devbig257.prn2.facebook.com>
 <20150710092119.297fd9e1@noble>
 <20150710040847.GA1408097@devbig257.prn2.facebook.com>
 <20150710143656.4ee7e647@noble>
 <20150710045225.GA1746743@devbig257.prn2.facebook.com>
 <20150710151044.396f9645@noble>
 <20150710051815.GA1902680@devbig257.prn2.facebook.com>
 <20150710164209.5928d762@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150710164209.5928d762@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, Kernel-team@fb.com
List-Id: linux-raid.ids

On Fri, Jul 10, 2015 at 04:42:09PM +1000, NeilBrown wrote:
> On Thu, 9 Jul 2015 22:18:15 -0700 Shaohua Li <shli@fb.com> wrote:
> 
> > On Fri, Jul 10, 2015 at 03:10:44PM +1000, NeilBrown wrote:
> > > On Thu, 9 Jul 2015 21:52:43 -0700 Shaohua Li <shli@fb.com> wrote:
> > > 
> > > > On Fri, Jul 10, 2015 at 02:36:56PM +1000, NeilBrown wrote:
> > > > > On Thu, 9 Jul 2015 21:08:49 -0700 Shaohua Li <shli@fb.com> wrote:
> > > > > 
> > > 
> > > > > There is also the issue of what action commits a previous transaction.
> > > > > I'm not sure what you had.  I'm suggesting that each metadata block
> > > > > commits previous transactions.  Is that a close-enough match to what
> > > > > you had?
> > > > 
> > > > What did you mean about a transaction? In my implementation, metadata
> > > > block and followed stripe data/parity consist of an io unit. io units can
> > > > be finished out of order. but if io unit has flush request (the data has
> > > > flush/flush bio or metadata is a flush block), the io unit can only
> > > > start after all previous io units and disk cache flush finish. Such io
> > > > unit is strictly ordered. The log patch describes this behavior. Does it
> > > > match?
> > > 
> > > Yes, a "transaction" is an "io unit".  The flushing is the same.
> > > I just couldn't remember how, when reading the log on restart, you
> > > determined if a given "io unit" was reliably consistent, or whether it
> > > should be ignored (having possibly only partially been written).
> > 
> > The metadata block has a checksum for data of the block. data/parity has
> > checksum stored in metadata block. This way we can know if metadata and
> > data is consistent.
> > 
> 
> OK .. though I'm not totally sold on the value of checksums.  When a
> checksum doesn't match, that means something.  When a checksum does
> match, it could just be a co-incidence.
> I'd rather have a process that made checksums unnecessary, and only use
> the checksums as a double-check.

We could do something like: write metadata/data, wait, write another
metadata. the second metadata indicates the first is in disk. But this
can impact performance very much. I think checksum should be fine. It
might be just a coninsidence, but the rate should extremely low. jbd2 is
using checksum too now.

Thanks,
Shaohua
