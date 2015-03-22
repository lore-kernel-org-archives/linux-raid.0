From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Sun, 22 Mar 2015 10:22:03 -0700
Message-ID: <CAPcyv4ieZjj6senh26BANA4KT54AdrU+O=o8zCAk7W=vA+SjnQ@mail.gmail.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150318132650.3336261c58829f49a9af8675@linux-foundation.org>
	<20150319134313.GF4003@linux.intel.com>
	<550C490E.1080708@redhat.com>
	<20150320203136.GM4003@linux.intel.com>
	<550C8C47.5090002@redhat.com>
	<550EF6B2.70506@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <550EF6B2.70506@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Rik van Riel <riel@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid <linux-raid@vger.kernel.org>, Mel Gorman <mgorman@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-raid.ids

On Sun, Mar 22, 2015 at 10:06 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
> On 03/20/2015 11:08 PM, Rik van Riel wrote:
>> On 03/20/2015 04:31 PM, Matthew Wilcox wrote:
> <>
>>> There's a lot of code out there that relies on struct page being PAGE_SIZE
>>> bytes.  I'm cool with replacing 'struct page' with 'struct superpage'
>>> [1] in the biovec and auditing all of the code which touches it ... but
>>> that's going to be a lot of code!  I'm not sure it's less code than
>>> going directly to 'just do I/O on PFNs'.
>>
>> Totally agreed here. I see absolutely no advantage to teaching the
>> IO layer about a "struct superpage" when it could operate on PFNs
>> just as easily.
>>
>
> Or teaching 'struct page' to be variable length, This is already so at
> bio and sg level so you fixed nothing.
>
> Moving to pfn's only means that all this unnamed code above that
> "relies on struct page being PAGE_SIZE" is now not allowed to
> interfaced with bio and sg list. Which in current code and in Dan's patches
> means two tons of BUG_ONS and return -ENOTSUPP . For all these
> subsystems below the bio and sglist that operate on page_structs

I'm not convinced it will be that bad.  In hyperbolic terms,
continuing to overload struct page means we get to let floppy.c do i/o
from pmem, who needs that level of compatibility?

Similar to sg_chain support I think it's fine to let sub-systems /
archs add pmem i/o support over time.  It's a scaling problem our
development model is good at.
