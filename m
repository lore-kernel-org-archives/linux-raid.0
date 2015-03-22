From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Sun, 22 Mar 2015 17:51:26 +0200
Message-ID: <550EE4FE.1070009@plexistor.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <20150318132650.3336261c58829f49a9af8675@linux-foundation.org> <20150319134313.GF4003@linux.intel.com> <550C490E.1080708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <550C490E.1080708@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-raid.ids

On 03/20/2015 06:21 PM, Rik van Riel wrote:
> On 03/19/2015 09:43 AM, Matthew Wilcox wrote:
> 
>> 1. Construct struct pages for persistent memory
>> 1a. Permanently
>> 1b. While the pages are under I/O
> 
> Michael Tsirkin and I have been doing some thinking about what
> it would take to allocate struct pages per 2MB area permanently,
> and allocate additional struct pages for 4kB pages on demand,
> when a 2MB area is broken up into 4kB pages.
> 
> This should work for both DRAM and persistent memory.
> 

My thoughts as well, this need *not* be a huge evasive change. Is however
a careful surgery in very core code. And lots of sleepless scary nights
and testing to make sure all the side effects are wrinkled out.

BTW: Basic core block code may very well work with:
	bv_page, bv_len > PAGE_SIZE bv_offset > PAGE_SIZE.

  Meaning bv_page-pfn is contiguous in physical space (and virtual
  of course). So much so that there are already rumors that this suppose
  to be supported, and there are already out-of-tree drivers that use
  this today by kmalloc a page-order and feeding BIOs with bv_len=64K

  But going out of block-layer and say to networking say via iscsi and
  this breaks pretty fast. Lets fix that then lets introduce a:
	page_size(page)
  page already knows its size (ie belonging to a 2M THP)

> I am still not convinced it is worthwhile to have struct pages
> for persistent memory though, but I am willing to change my mind.
> 

If we want copy-less, we need a common memory descriptor career. Today this
is page-struct. So for me your above statement means:
	"still not convinced I care about copy-less pmem"

Otherwise you either enhance what you have today or devise a new
system, which means change the all Kernel.

Lastly: Why does pmem need to wait out-of-tree. Even you say above that
machines with lots of DRAM can enjoy the HUGE-to-4k split. So why
not let pmem waist 4k pages like everyone else and fix it as above
down the line, both for pmem and ram. And save both ways.
Why do we need to first change the all Kernel, then have pmem. Why not
use current infra structure, for good or for worth, and incrementally
do better.

May I call you on the phone to try and work things out. I believe the
huge page thing + 4k on demand is not a very big change, as long as
	struct page *page is left as is, everywhere.

But may *now* carry a different physical/virtual contiguous payload
bigger then 4k. Is not the PAGE_SIZE the real bug? lets fix that problem.

Thanks
Boaz
