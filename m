From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Tue, 24 Mar 2015 11:41:37 +0200
Message-ID: <55113151.7090304@plexistor.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <20150318132650.3336261c58829f49a9af8675@linux-foundation.org> <20150319134313.GF4003@linux.intel.com> <550C490E.1080708@redhat.com> <550EE4FE.1070009@plexistor.com> <55102EEB.2090401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55102EEB.2090401@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>, Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-raid.ids

On 03/23/2015 05:19 PM, Rik van Riel wrote:
>>> Michael Tsirkin and I have been doing some thinking about what
>>> it would take to allocate struct pages per 2MB area permanently,
>>> and allocate additional struct pages for 4kB pages on demand,
>>> when a 2MB area is broken up into 4kB pages.
>>
>> My thoughts as well, this need *not* be a huge evasive change. Is however
>> a careful surgery in very core code. And lots of sleepless scary nights
>> and testing to make sure all the side effects are wrinkled out.
> 
> Even the above IS a huge invasive change, and I do not see it
> as much better than the work Dan and Matthew are doing.
> 

You lost me again. Sorry for my slowness. The code I envision is not
invasive at all. Nothing is touched at all, except a few core places
at the page level.

The contract with Kernel stays the same:
	page_to_pfn, pfn_to_page, page_address (which is kmap_atomic in 64bit)
	virt_to_page, page_get/put and so on...

So none of the Kernel code need change at all. You were saying that we
might have a 2M page and on demand we can allocate a 4k page shove it down the
stack, which does not change at all, and once back from io, the 4k pages can be
freed and recycled for reuse with other IO. This is what I thought you said.

This is doable, and not that much work and for the life of me I do not see any
"invasive". (Yes a few core headers that make everything compile ;-))

That said I do not even think we need that (2M split to 4k on demand) we can even
do better and make sure 2M pages just work as is. It is very possible today
(Tested) to push a 2M page into a bio and write to a bdev. Yes lots of side
code will break, but the core path is clean. Let us fix that then.

(Need I send code to show you how a 2M page is written with a single
 bvec?)

>> If we want copy-less, we need a common memory descriptor career. Today this
>> is page-struct. So for me your above statement means:
>> 	"still not convinced I care about copy-less pmem"
>>
>> Otherwise you either enhance what you have today or devise a new
>> system, which means change the all Kernel.
> 
> We do not necessarily need a common descriptor, as much as
> one that abstracts out what is happening. Something like a
> struct bio could be a good I/O descriptor, and releasing the
> backing memory after IO completion could be a function of the
> bio freeing function itself.
> 

Lost me again sorry. What backing memory. struct bio is already
an I/O descriptor which gets freed after use. How is that relevant
to pfn vs page ?

>> Lastly: Why does pmem need to wait out-of-tree. Even you say above that
>> machines with lots of DRAM can enjoy the HUGE-to-4k split. So why
>> not let pmem waist 4k pages like everyone else and fix it as above
>> down the line, both for pmem and ram. And save both ways.
>> Why do we need to first change the all Kernel, then have pmem. Why not
>> use current infra structure, for good or for worth, and incrementally
>> do better.
> 
> There are two things going on here:
> 
> 1) You want to keep using struct page for now, while there are
>    subsystems that require it. This is perfectly legitimate.
> 
> 2) Matthew and Dan are changing over some subsystems to no longer
>    require struct page. This is perfectly legitimate.
> 

How is this legitimate when you need to Interface the [1] subsystems
under the [2] subsystem? A subsystem that expects pages is now not
usable by [2].

Today *All* the Kernel subsystems are [1] Period. How does it become
legitimate to now start *two* competing, do the same differently, abstraction,
in our kernel. We have two much diversity not to little.

> I do not understand why either of you would have to object to what
> the other is doing. There is room to keep using struct page until
> the rest of the kernel no longer requires it.
> 

So this is your vision "until the rest of the kernel no longer requires
pages" Really? Sigh, coming from other Kernels I thought pages were
a breeze of fresh air. I thought it was very clever. And BTW good luck
with that.

BTW: you have not solved the basic problem yet. for one pfn_kmap() given a
pfn what is its virtual address. would you like to loop through the
Kernel's range tables to look for the registered ioremap ? its a long
annoying loop. The page was invented exactly for this reason, to go through
the section object. And actually it is not that easy because if it is an ioremap
pointer it is in one list and if a page it is another way, and on top of
all this, it is ARCH dependent. And you are trashing highmem, because the
state and locks of that are at the page level. Not that I care about highmem
but I hate double coding. For god sake what do you guys have with poor old
pages, they were invented to exacly do this, abstract away management of a single
pfn-to-virt.
All I see is complains about page being 4K well it need not be. page can be any
size, and hell it can be variable size. (And no we do not need to add an extra size
member, all we need is the one bit)

Cheers
Boaz
