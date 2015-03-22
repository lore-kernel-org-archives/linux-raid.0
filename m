From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Sun, 22 Mar 2015 19:06:58 +0200
Message-ID: <550EF6B2.70506@plexistor.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <20150318132650.3336261c58829f49a9af8675@linux-foundation.org> <20150319134313.GF4003@linux.intel.com> <550C490E.1080708@redhat.com> <20150320203136.GM4003@linux.intel.com> <550C8C47.5090002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <550C8C47.5090002@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>, Matthew Wilcox <willy@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-raid.ids

On 03/20/2015 11:08 PM, Rik van Riel wrote:
> On 03/20/2015 04:31 PM, Matthew Wilcox wrote:
<>
>> There's a lot of code out there that relies on struct page being PAGE_SIZE
>> bytes.  I'm cool with replacing 'struct page' with 'struct superpage'
>> [1] in the biovec and auditing all of the code which touches it ... but
>> that's going to be a lot of code!  I'm not sure it's less code than
>> going directly to 'just do I/O on PFNs'.
> 
> Totally agreed here. I see absolutely no advantage to teaching the
> IO layer about a "struct superpage" when it could operate on PFNs
> just as easily.
> 

Or teaching 'struct page' to be variable length, This is already so at
bio and sg level so you fixed nothing.

Moving to pfn's only means that all this unnamed code above that
"relies on struct page being PAGE_SIZE" is now not allowed to
interfaced with bio and sg list. Which in current code and in Dan's patches
means two tons of BUG_ONS and return -ENOTSUPP . For all these
subsystems below the bio and sglist that operate on page_structs

Say the "relies on struct page being PAGE_SIZE" is such an hard
work, which is not at all at the bio and sg-list level, will
it not be worth while fixing this instead of alienating the all
Kernel from the IO subsystem.

But I believe it is the much much smaller change? Specially considering
Networking, RDMA shared memory ...

Cheers
Boaz
