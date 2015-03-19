From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [Linux-nvdimm] [RFC PATCH 0/7] evacuate struct page from the
 block layer
Date: Thu, 19 Mar 2015 13:59:27 -0700
Message-ID: <CAPcyv4j=M8V_36C-HhiJM7MHzNLFcpP=nec=LHnob5+qZ4xgYw@mail.gmail.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150318132650.3336261c58829f49a9af8675@linux-foundation.org>
	<20150319134313.GF4003@linux.intel.com>
	<550AF127.9010504@plexistor.com>
	<20150319125917.6cc2bf02687aab542027d8ac@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150319125917.6cc2bf02687aab542027d8ac@linux-foundation.org>
Sender: linux-arch-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <boaz@plexistor.com>, linux-arch@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, riel@redhat.com, linux-raid <linux-raid@vger.kernel.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Mel Gorman <mgorman@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Mar 19, 2015 at 12:59 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 19 Mar 2015 17:54:15 +0200 Boaz Harrosh <boaz@plexistor.com> wrote:
>
>> On 03/19/2015 03:43 PM, Matthew Wilcox wrote:
>> <>
>> >
>> > Dan missed "Support O_DIRECT to a mapped DAX file".  More generally, if we
>> > want to be able to do any kind of I/O directly to persistent memory,
>> > and I think we do, we need to do one of:
>> >
>> > 1. Construct struct pages for persistent memory
>> > 1a. Permanently
>> > 1b. While the pages are under I/O
>> > 2. Teach the I/O layers to deal in PFNs instead of struct pages
>> > 3. Replace struct page with some other structure that can represent both
>> >    DRAM and PMEM
>> >
>> > I'm personally a fan of #3, and I was looking at the scatterlist as
>> > my preferred data structure.  I now believe the scatterlist as it is
>> > currently defined isn't sufficient, so we probably end up needing a new
>> > data structure.  I think Dan's preferred method of replacing struct
>> > pages with PFNs is actually less instrusive, but doesn't give us as
>> > much advantage (an entirely new data structure would let us move to an
>> > extent based system at the same time, instead of sticking with an array
>> > of pages).  Clearly Boaz prefers 1a, which works well enough for the
>> > 8GB NV-DIMMs, but not well enough for the 400GB NV-DIMMs.
>> >
>> > What's your preference?  I guess option 0 is "force all I/O to go
>> > through the page cache and then get copied", but that feels like a nasty
>> > performance hit.
>>
>> Thanks Matthew, you have summarized it perfectly.
>>
>> I think #1b might have merit, as well.
>
> It would be interesting to see what a 1b implementation looks like and
> how it performs.  We already allocate a bunch of temporary things to
> support in-flight IO (bio, request) and allocating pageframes on the
> same basis seems a fairly logical fit.

At least for block-i/o it seems the only place we really need struct
page infrastructure is for kmap().  Given we already need a kmap_pfn()
solution for option 2 a "dynamic allocation" stop along that
development path may just naturally fall out.
