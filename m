From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [Linux-nvdimm] [RFC PATCH 0/7] evacuate struct page from the
 block layer
Date: Sun, 22 Mar 2015 12:30:34 +0200
Message-ID: <550E99CA.5090004@plexistor.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>	<20150318132650.3336261c58829f49a9af8675@linux-foundation.org>	<20150319134313.GF4003@linux.intel.com>	<550AF127.9010504@plexistor.com> <20150319125917.6cc2bf02687aab542027d8ac@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150319125917.6cc2bf02687aab542027d8ac@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-arch@vger.kernel.org, axboe@kernel.dk, riel@redhat.com, hch@infradead.org, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On 03/19/2015 09:59 PM, Andrew Morton wrote:
> On Thu, 19 Mar 2015 17:54:15 +0200 Boaz Harrosh <boaz@plexistor.com> wrote:
> 
>> On 03/19/2015 03:43 PM, Matthew Wilcox wrote:
>> <>
>>>
>>> Dan missed "Support O_DIRECT to a mapped DAX file".  More generally, if we
>>> want to be able to do any kind of I/O directly to persistent memory,
>>> and I think we do, we need to do one of:
>>>
>>> 1. Construct struct pages for persistent memory
>>> 1a. Permanently
>>> 1b. While the pages are under I/O
>>> 2. Teach the I/O layers to deal in PFNs instead of struct pages
>>> 3. Replace struct page with some other structure that can represent both
>>>    DRAM and PMEM
>>>
>>> I'm personally a fan of #3, and I was looking at the scatterlist as
>>> my preferred data structure.  I now believe the scatterlist as it is
>>> currently defined isn't sufficient, so we probably end up needing a new
>>> data structure.  I think Dan's preferred method of replacing struct
>>> pages with PFNs is actually less instrusive, but doesn't give us as
>>> much advantage (an entirely new data structure would let us move to an
>>> extent based system at the same time, instead of sticking with an array
>>> of pages).  Clearly Boaz prefers 1a, which works well enough for the
>>> 8GB NV-DIMMs, but not well enough for the 400GB NV-DIMMs.
>>>
>>> What's your preference?  I guess option 0 is "force all I/O to go
>>> through the page cache and then get copied", but that feels like a nasty
>>> performance hit.
>>
>> Thanks Matthew, you have summarized it perfectly.
>>
>> I think #1b might have merit, as well.
> 
> It would be interesting to see what a 1b implementation looks like and
> how it performs.  We already allocate a bunch of temporary things to
> support in-flight IO (bio, request) and allocating pageframes on the
> same basis seems a fairly logical fit.

There is a couple of ways we can do this, they are all kind of 
"hacks" to me, along the line of how transparent huge pages is an
hack, a very nice one at that, and every one that knows me knows
I love hacks, be so it is never the less.

So it is all about designating the page to mean something else
at a set of a flag.

And actually the transparent-huge-pages is the core of this.
because there is already a switch on core page operations when
it is present. (for example get/put_page )

And because we do not want to allocate pages inline, as part of a
section, we also need a bit of a memory_model.h new define.
(May this can avoided I need to stare harder on this)

> 
> It is all a bit of a stopgap, designed to shoehorn
> direct-io-to-dax-mapped-memory into the existing world.  Longer term
> I'd expect us to move to something more powerful, but it's unclear what
> that will be at this time, so a stopgap isn't too bad?
> 

I'd bet real huge-pages is the long term. The one stop gap for
huge-pages is that no one wants to dirty a full 2M for two changed
bytes. 4k is kind of the IO performance granularity we all calculate
for. This can be solved in couple of ways, all very invasive to lots
of Kernel areas. 

Lots of times the problem is "where do you start?"

> 
> This is all contingent upon the prevalence of machines which have vast
> amounts of nv memory and relatively small amounts of regular memory. 
> How confident are we that this really is the future?
> 

One thing you guys are ignoring is that the 1.5% "waste" can come
from nv-memory. If real ram is scarce and nv-ram is hips cheep,
just allocate the pages from nvram then.

Do not forget that very soon after the availability of real
nvram, I mean not the backed up one, but the real like mram
or reram. Lots of machines will be 100% nv-ram + sram caches.
This is nothing to do with storage speed, it is to do with
power consumption. The machine shuts-off and picks up exactly
where it was. (Even at power on they consume much less, no refreshes)
In those machine a partition of storage say, the swap partition, will
be the volatile memory section of the machine, zeroed out on boot and
used as RAM.

So this future above does not exist. Pages can just be allocated
from the cheapest memory you have and be done with it.

(BTW all this can already be done now, I have demonstrated it
 in the lab, a reserved NvDIMM memory region is memory_hot_plugged
 and is there after used as regular RAM)

Thanks
Boaz
