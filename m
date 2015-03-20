From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Fri, 20 Mar 2015 16:31:36 -0400
Message-ID: <20150320203136.GM4003@linux.intel.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150318132650.3336261c58829f49a9af8675@linux-foundation.org>
 <20150319134313.GF4003@linux.intel.com>
 <550C490E.1080708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <550C490E.1080708@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-raid.ids

On Fri, Mar 20, 2015 at 12:21:34PM -0400, Rik van Riel wrote:
> On 03/19/2015 09:43 AM, Matthew Wilcox wrote:
> 
> > 1. Construct struct pages for persistent memory
> > 1a. Permanently
> > 1b. While the pages are under I/O
> 
> Michael Tsirkin and I have been doing some thinking about what
> it would take to allocate struct pages per 2MB area permanently,
> and allocate additional struct pages for 4kB pages on demand,
> when a 2MB area is broken up into 4kB pages.

Ah!  I've looked at that a couple of times as well.  I asked our database
performance team what impact freeing up the memmap would have on their
performance.  They told me that doubling the amount of memory generally
resulted in approximately a 40% performance improvement.  So freeing up
1.5% additional memory would result in about 0.6% performance improvement,
which I thought was probably too small a return on investment to justify
turning memmap into a two-level data structure.

Persistent memory might change that calculation somewhat ... but I'm
not convinced.  Certainly, if we already had the ability to allocate
'struct superpage', I wouldn't be pushing for page-less I/Os, I'd just
allocate these data structures for PM.  Even if they were 128 bytes in
size, that's only a 25MB overhead per 400GB NV-DIMM, which feels quite
reasonable to me.

> This should work for both DRAM and persistent memory.
> 
> I am still not convinced it is worthwhile to have struct pages
> for persistent memory though, but I am willing to change my mind.

There's a lot of code out there that relies on struct page being PAGE_SIZE
bytes.  I'm cool with replacing 'struct page' with 'struct superpage'
[1] in the biovec and auditing all of the code which touches it ... but
that's going to be a lot of code!  I'm not sure it's less code than
going directly to 'just do I/O on PFNs'.

[1] Please, somebody come up with a better name!
