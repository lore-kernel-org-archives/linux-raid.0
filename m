From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [Linux-nvdimm] [RFC PATCH 0/7] evacuate struct page from the
 block layer
Date: Thu, 19 Mar 2015 17:54:15 +0200
Message-ID: <550AF127.9010504@plexistor.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <20150318132650.3336261c58829f49a9af8675@linux-foundation.org> <20150319134313.GF4003@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150319134313.GF4003@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, axboe@kernel.dk, riel@redhat.com, hch@infradead.org, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On 03/19/2015 03:43 PM, Matthew Wilcox wrote:
<>
> 
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

Thanks Matthew, you have summarized it perfectly.

I think #1b might have merit, as well. I have a very surgical small
"hack" that we can do with allocating on demand pages before IO.
It involves adding a new MEMORY_MODEL policy that is derived from
SPARSEMEM but lets you allocate individual pages on demand. And a new
type of page say call it GP_emulated_page.
(Tell me if you find this interesting. It is 1/117 in size of both
 #2 or #3)

In anyway please reconsider a configurable #1a for people that do
not mind sacrificing 1.2% of their pmem for real pages.

Even at 6G page-structs with 400G pmem, people would love some of the stuff
this gives them today. just few examples: direct_access from within a VM to
an host defined pmem, is trivial with no extra code with my two simple #1a
patches. RDMA memory brick targets, network shared memory FS and so on, the
list will always be bigger then any of #1b #2 or #3. Yes for people that
want to sacrifice the extra cost.

In the Kernel it was always about choice and diversity. And what does it
costs us. Nothing. Two small simple patches and a Kconfig option.
Note that I made it in such a way that if pmem is configured without
use of pages, then the mm code is *not* configured-in automatically.
We can even add a runtime option that even if #1a is enabled, for certain
pmem device may not want pages allocated. And so choose at runtime rather
than compile time.

I think this will only farther our cause and let people advance with
their research and development with great new ideas about use of pmem.
Then once there is a great demand for #1a and those large 512G devices
come out, we can go the #1b or #3 route and save them the extra 1.2%
memory, but once they have the appetite for it. (And Andrews question
becomes clear)

Our two ways need not be "either-or". They can be "have both". I think
choice is a good thing for us here. Even with #3 available #1a still has
merit in some configurations and they can co exist perfectly.

Please think about it?

Thanks
Boaz

