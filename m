From: Shaohua Li <shli@kernel.org>
Subject: Re: "creative" bio usage in the RAID code
Date: Fri, 11 Nov 2016 11:02:23 -0800
Message-ID: <20161111190223.4xrq3vvvvohzgs5e@kernel.org>
References: <20161110194636.GA32241@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161110194636.GA32241@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On Thu, Nov 10, 2016 at 11:46:36AM -0800, Christoph Hellwig wrote:
> Hi Shaohua,
> 
> one of the major issues with Ming Lei's multipage biovec works
> is that we can't easily enabled the MD RAID code for it.  I had
> a quick chat on that with Chris and Jens and they suggested talking
> to you about it.
> 
> It's mostly about the RAID1 and RAID10 code which does a lot of funny
> things with the bi_iov_vec and bi_vcnt fields, which we'd prefer that
> drivers don't touch.  One example is the r1buf_pool_alloc code,
> which I think should simply use bio_clone for the MD_RECOVERY_REQUESTED
> case, which would also take care of r1buf_pool_free.  I'm not sure
> about all the others cases, as some bits don't fully make sense to me,

The problem is we use the iov_vec to track the pages allocated. We will read
data to the pages and write out later for resync. If we add new fields to track
the pages in r1bio, we could use standard API bio_kmalloc/bio_add_page and
avoid the tricky parts. This should work for both the resync and writebehind
cases.

> e.g. why we're trying to do single page I/O out of a bigger bio.

what's this one?

> Maybe you have some better ideas what's going on there?
> 
> Another not quite as urgent issue is how the RAID5 code abuses
> ->bi_phys_segments as and outstanding I/O counter, and I have no
> really good answer to that either.

I don't have good idea for this one either if we don't want to allocate extra
memory. The good side is we never dispatch the original bio to under layer
disks.

Thanks,
Shaohua
