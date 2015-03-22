From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Sun, 22 Mar 2015 18:24:50 +0200
Message-ID: <550EECD2.4000604@plexistor.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <20150318132650.3336261c58829f49a9af8675@linux-foundation.org> <20150319134313.GF4003@linux.intel.com> <550C490E.1080708@redhat.com> <20150320203136.GM4003@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150320203136.GM4003@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-raid.ids

On 03/20/2015 10:31 PM, Matthew Wilcox wrote:
<>
> 
> There's a lot of code out there that relies on struct page being PAGE_SIZE
> bytes.  

Not so much really. Not at the lower end of the stack. You can actually feed
a 
	vp = kmalloc(64K);
	bv_page = virt_to_page(vp)
	bv_len = 64k

And feed that to an hard drive. It works.

The only last stronghold of PAGE_SIZE is at the page-cache and page-fault
granularity where the minimum is the better. But it should not be hard
to clean up the lower end of the stack. Even introduce a:
	page_size(page)

You will find that every subsystem that can work with a sub-page size
similar to above bv_len. Will also work well with bigger than PAGE_SIZE
bv_len equivalent.

Only the BUG_ONs need to convert to page_size(page) instead of PAGE_SIZE

> I'm cool with replacing 'struct page' with 'struct superpage'
> [1] in the biovec and auditing all of the code which touches it ... but
> that's going to be a lot of code!  I'm not sure it's less code than
> going directly to 'just do I/O on PFNs'.
> 

struct page already knows how to be a super-page. with the THP mechanics.
All a page_size(page) needs is a call to its section, we do not need any
added storage at page-struct. (And we can cache this as a flag we actually
already have a flag)

It looks like you are very trigger happy to change
	"biovec and auditing all of the code which touches it"

I believe long long term your #1b is the correct "full audit" path:

	Page Is the virtual-2-page-2-physical descriptor + state.
	It is variable size
 
> [1] Please, somebody come up with a better name!

sure struct page *page.

The one to kill is PAGE_SIZE. In most current code it can just be MIN_PAGE_SIZE
and CACHE_PAGE_SIZE == MIN_PAGE_SIZE. Only novelty is enhance of the split_huge_page
in the case of "page-fault-granularity".

Thanks
Boaz

