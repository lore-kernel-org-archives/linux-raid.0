From: Shaohua Li <shli@kernel.org>
Subject: Re: "creative" bio usage in the RAID code
Date: Mon, 14 Nov 2016 16:13:57 -0800
Message-ID: <20161115001357.sb5242j5t7bsurjd@kernel.org>
References: <20161110194636.GA32241@infradead.org>
 <20161111190223.4xrq3vvvvohzgs5e@kernel.org>
 <20161112174238.GA11518@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161112174238.GA11518@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On Sat, Nov 12, 2016 at 09:42:38AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 11, 2016 at 11:02:23AM -0800, Shaohua Li wrote:
> > > It's mostly about the RAID1 and RAID10 code which does a lot of funny
> > > things with the bi_iov_vec and bi_vcnt fields, which we'd prefer that
> > > drivers don't touch.  One example is the r1buf_pool_alloc code,
> > > which I think should simply use bio_clone for the MD_RECOVERY_REQUESTED
> > > case, which would also take care of r1buf_pool_free.  I'm not sure
> > > about all the others cases, as some bits don't fully make sense to me,
> > 
> > The problem is we use the iov_vec to track the pages allocated. We will read
> > data to the pages and write out later for resync. If we add new fields to track
> > the pages in r1bio, we could use standard API bio_kmalloc/bio_add_page and
> > avoid the tricky parts. This should work for both the resync and writebehind
> > cases.
> 
> I don't think we need to track the pages specificly - if we clone
> a bio we share the bio_vec, e.g. for the !MD_RECOVERY_REQUESTED
> we do one bio_kmalloc, then bio_alloc_pages then clone it for the
> others bios.  for MD_RECOVERY_REQUESTED we do a bio_kmalloc +
> bio_alloc_pages for each.

Sure, for r1buf_pool_alloc, what you suggested should work well. There are a
lot of other places we are using bi_vcnt/bi_io_vec. I'm not sure if it's easy
to replace them with bio iterator. But having a separate data structue to track
the memory we read/rewite/sync and so on definitively will make things easier.
I'm not saying to add the extra data structure in bio but instead in r1bio.

Thanks,
Shaohua
