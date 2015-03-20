From: Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Fri, 20 Mar 2015 17:08:23 -0400
Message-ID: <550C8C47.5090002@redhat.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <20150318132650.3336261c58829f49a9af8675@linux-foundation.org> <20150319134313.GF4003@linux.intel.com> <550C490E.1080708@redhat.com> <20150320203136.GM4003@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150320203136.GM4003@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-raid.ids

On 03/20/2015 04:31 PM, Matthew Wilcox wrote:
> On Fri, Mar 20, 2015 at 12:21:34PM -0400, Rik van Riel wrote:
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
> 
> Ah!  I've looked at that a couple of times as well.  I asked our database
> performance team what impact freeing up the memmap would have on their
> performance.  They told me that doubling the amount of memory generally
> resulted in approximately a 40% performance improvement.  So freeing up
> 1.5% additional memory would result in about 0.6% performance improvement,
> which I thought was probably too small a return on investment to justify
> turning memmap into a two-level data structure.

Agreed, it should not be done for memory savings alone, but only
if it helps improve all kinds of other things.

>> This should work for both DRAM and persistent memory.
>>
>> I am still not convinced it is worthwhile to have struct pages
>> for persistent memory though, but I am willing to change my mind.
> 
> There's a lot of code out there that relies on struct page being PAGE_SIZE
> bytes.  I'm cool with replacing 'struct page' with 'struct superpage'
> [1] in the biovec and auditing all of the code which touches it ... but
> that's going to be a lot of code!  I'm not sure it's less code than
> going directly to 'just do I/O on PFNs'.

Totally agreed here. I see absolutely no advantage to teaching the
IO layer about a "struct superpage" when it could operate on PFNs
just as easily.

-- 
All rights reversed
