From: Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Mon, 23 Mar 2015 11:19:07 -0400
Message-ID: <55102EEB.2090401@redhat.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <20150318132650.3336261c58829f49a9af8675@linux-foundation.org> <20150319134313.GF4003@linux.intel.com> <550C490E.1080708@redhat.com> <550EE4FE.1070009@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <550EE4FE.1070009@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-raid.ids

On 03/22/2015 11:51 AM, Boaz Harrosh wrote:
> On 03/20/2015 06:21 PM, Rik van Riel wrote:
>> On 03/19/2015 09:43 AM, Matthew Wilcox wrote:
>>
>>> 1. Construct struct pages for persistent memory
>>> 1a. Permanently
>>> 1b. While the pages are under I/O
>>
>> Michael Tsirkin and I have been doing some thinking about what
>> it would take to allocate struct pages per 2MB area permanently,
>> and allocate additional struct pages for 4kB pages on demand,
>> when a 2MB area is broken up into 4kB pages.
>>
>> This should work for both DRAM and persistent memory.
> 
> My thoughts as well, this need *not* be a huge evasive change. Is however
> a careful surgery in very core code. And lots of sleepless scary nights
> and testing to make sure all the side effects are wrinkled out.

Even the above IS a huge invasive change, and I do not see it
as much better than the work Dan and Matthew are doing.

> If we want copy-less, we need a common memory descriptor career. Today this
> is page-struct. So for me your above statement means:
> 	"still not convinced I care about copy-less pmem"
> 
> Otherwise you either enhance what you have today or devise a new
> system, which means change the all Kernel.

We do not necessarily need a common descriptor, as much as
one that abstracts out what is happening. Something like a
struct bio could be a good I/O descriptor, and releasing the
backing memory after IO completion could be a function of the
bio freeing function itself.

> Lastly: Why does pmem need to wait out-of-tree. Even you say above that
> machines with lots of DRAM can enjoy the HUGE-to-4k split. So why
> not let pmem waist 4k pages like everyone else and fix it as above
> down the line, both for pmem and ram. And save both ways.
> Why do we need to first change the all Kernel, then have pmem. Why not
> use current infra structure, for good or for worth, and incrementally
> do better.

There are two things going on here:

1) You want to keep using struct page for now, while there are
   subsystems that require it. This is perfectly legitimate.

2) Matthew and Dan are changing over some subsystems to no longer
   require struct page. This is perfectly legitimate.

I do not understand why either of you would have to object to what
the other is doing. There is room to keep using struct page until
the rest of the kernel no longer requires it.

-- 
All rights reversed
