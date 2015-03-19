From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Thu, 19 Mar 2015 11:17:25 -0700
Message-ID: <20150319181725.GA17411@infradead.org>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150318132650.3336261c58829f49a9af8675@linux-foundation.org>
 <20150319134313.GF4003@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150319134313.GF4003@linux.intel.com>
Sender: linux-arch-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, riel@redhat.com, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 19, 2015 at 09:43:13AM -0400, Matthew Wilcox wrote:
> Dan missed "Support O_DIRECT to a mapped DAX file".  More generally, if we
> want to be able to do any kind of I/O directly to persistent memory,
> and I think we do, we need to do one of:
> 
> 1. Construct struct pages for persistent memory
> 1a. Permanently
> 1b. While the pages are under I/O
> 2. Teach the I/O layers to deal in PFNs instead of struct pages
> 3. Replace struct page with some other structure that can represent both
>    DRAM and PMEM
> 
> I'm personally a fan of #3, and I was looking at the scatterlist as
> my preferred data structure.  I now believe the scatterlist as it is
> currently defined isn't sufficient, so we probably end up needing a new
> data structure.  I think Dan's preferred method of replacing struct
> pages with PFNs is actually less instrusive, but doesn't give us as
> much advantage (an entirely new data structure would let us move to an
> extent based system at the same time, instead of sticking with an array
> of pages).  Clearly Boaz prefers 1a, which works well enough for the
> 8GB NV-DIMMs, but not well enough for the 400GB NV-DIMMs.
> 
> What's your preference?  I guess option 0 is "force all I/O to go
> through the page cache and then get copied", but that feels like a nasty
> performance hit.

In addition to the options there's also a time line.  At least for the
short term where we want to get something going 1a seems like the
absolutely be option.  It works perfectly fine for the lots of small
capacity dram-like nvdimms, and it works funtionally fine for the
special huge ones, although the resource use for it is highly annoying.
If it turns out to be too annoying we can also offer a no I/O possible
option for them in the short run.

In the long run option 2) sounds like a good plan to me, but not as a
parallel I/O path, but as the main one.  Doing so will in fact give us
options to experiment with 3).  Given that we're moving towards an
increasinly huge page using world replacing the good old struct page
with something extent-like and/or temporary might be needed for dram
as well in the future.
