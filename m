From: Christoph Hellwig <hch@infradead.org>
Subject: Re: "creative" bio usage in the RAID code
Date: Sat, 12 Nov 2016 09:42:38 -0800
Message-ID: <20161112174238.GA11518@infradead.org>
References: <20161110194636.GA32241@infradead.org>
 <20161111190223.4xrq3vvvvohzgs5e@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161111190223.4xrq3vvvvohzgs5e@kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On Fri, Nov 11, 2016 at 11:02:23AM -0800, Shaohua Li wrote:
> > It's mostly about the RAID1 and RAID10 code which does a lot of funny
> > things with the bi_iov_vec and bi_vcnt fields, which we'd prefer that
> > drivers don't touch.  One example is the r1buf_pool_alloc code,
> > which I think should simply use bio_clone for the MD_RECOVERY_REQUESTED
> > case, which would also take care of r1buf_pool_free.  I'm not sure
> > about all the others cases, as some bits don't fully make sense to me,
> 
> The problem is we use the iov_vec to track the pages allocated. We will read
> data to the pages and write out later for resync. If we add new fields to track
> the pages in r1bio, we could use standard API bio_kmalloc/bio_add_page and
> avoid the tricky parts. This should work for both the resync and writebehind
> cases.

I don't think we need to track the pages specificly - if we clone
a bio we share the bio_vec, e.g. for the !MD_RECOVERY_REQUESTED
we do one bio_kmalloc, then bio_alloc_pages then clone it for the
others bios.  for MD_RECOVERY_REQUESTED we do a bio_kmalloc +
bio_alloc_pages for each.

While we're at it - I find the way MD_RECOVERY_REQUESTED is used highly
confusing, and I'm not 100% sure it's correct.  After all we check it
in r1buf_pool_alloc, which is a mempool alloc callback, so we rely
on these callbacks being done after the flag has been raise / cleared,
which makes me bit suspicious, and also question why we even need the
mempool.

> 
> > e.g. why we're trying to do single page I/O out of a bigger bio.
> 
> what's this one?

fix_sync_read_error
