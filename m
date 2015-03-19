From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Thu, 19 Mar 2015 09:43:13 -0400
Message-ID: <20150319134313.GF4003@linux.intel.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150318132650.3336261c58829f49a9af8675@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150318132650.3336261c58829f49a9af8675@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, riel@redhat.com, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 18, 2015 at 01:26:50PM -0700, Andrew Morton wrote:
> On Mon, 16 Mar 2015 16:25:25 -0400 Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > Avoid the impending disaster of requiring struct page coverage for what
> > is expected to be ever increasing capacities of persistent memory.  In
> > conversations with Rik van Riel, Mel Gorman, and Jens Axboe at the
> > recently concluded Linux Storage Summit it became clear that struct page
> > is not required in many places, it was simply convenient to re-use.
> > 
> > Introduce helpers and infrastructure to remove struct page usage where
> > it is not necessary.  One use case for these changes is to implement a
> > write-back-cache in persistent memory for software-RAID.  Another use
> > case for the scatterlist changes is RDMA to a pfn-range.
> 
> Those use-cases sound very thin.  If that's all we have then I'd say
> "find another way of implementing those things without creating
> pageframes for persistent memory".
> 
> IOW, please tell us much much much more about the value of this change.

Dan missed "Support O_DIRECT to a mapped DAX file".  More generally, if we
want to be able to do any kind of I/O directly to persistent memory,
and I think we do, we need to do one of:

1. Construct struct pages for persistent memory
1a. Permanently
1b. While the pages are under I/O
2. Teach the I/O layers to deal in PFNs instead of struct pages
3. Replace struct page with some other structure that can represent both
   DRAM and PMEM

I'm personally a fan of #3, and I was looking at the scatterlist as
my preferred data structure.  I now believe the scatterlist as it is
currently defined isn't sufficient, so we probably end up needing a new
data structure.  I think Dan's preferred method of replacing struct
pages with PFNs is actually less instrusive, but doesn't give us as
much advantage (an entirely new data structure would let us move to an
extent based system at the same time, instead of sticking with an array
of pages).  Clearly Boaz prefers 1a, which works well enough for the
8GB NV-DIMMs, but not well enough for the 400GB NV-DIMMs.

What's your preference?  I guess option 0 is "force all I/O to go
through the page cache and then get copied", but that feels like a nasty
performance hit.
