From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Thu, 19 Mar 2015 15:31:16 -0400
Message-ID: <20150319193116.GH4003@linux.intel.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150318132650.3336261c58829f49a9af8675@linux-foundation.org>
 <20150319134313.GF4003@linux.intel.com>
 <20150319181725.GA17411@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150319181725.GA17411@infradead.org>
Sender: linux-arch-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, riel@redhat.com, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 19, 2015 at 11:17:25AM -0700, Christoph Hellwig wrote:
> On Thu, Mar 19, 2015 at 09:43:13AM -0400, Matthew Wilcox wrote:
> > 1. Construct struct pages for persistent memory
> > 1a. Permanently
> > 1b. While the pages are under I/O
> > 2. Teach the I/O layers to deal in PFNs instead of struct pages
> > 3. Replace struct page with some other structure that can represent both
> >    DRAM and PMEM
> 
> In addition to the options there's also a time line.  At least for the
> short term where we want to get something going 1a seems like the
> absolutely be option.  It works perfectly fine for the lots of small
(assuming "best option")
> capacity dram-like nvdimms, and it works funtionally fine for the
> special huge ones, although the resource use for it is highly annoying.
> If it turns out to be too annoying we can also offer a no I/O possible
> option for them in the short run.
> 
> In the long run option 2) sounds like a good plan to me, but not as a
> parallel I/O path, but as the main one.  Doing so will in fact give us
> options to experiment with 3).  Given that we're moving towards an
> increasinly huge page using world replacing the good old struct page
> with something extent-like and/or temporary might be needed for dram
> as well in the future.

Dan's patches don't actually make it a "parallel I/O path", that was
Boaz's mischaracterisation.  They move all scatterlists and bios over
to using PFNs, at least on architectures which have been converted.
Speaking of architectures not being converted, it is really past time for
architectures to be switched to supporting SG chaining.  It was introduced
in 2007, and not having it generically available causes problems for
the crypto layer, as well as making further enhancements more tricky.

Assuming 'select ARCH_HAS_SG_CHAIN' is sufficient to tell, the following
architectures do support it:

arm arm64 ia64 powerpc s390 sparc x86

which means the following architectures are 8 years delinquent in
adding support:

alpha arc avr32 blackfin c6x cris frv hexagon m32r m68k metag microblaze
mips mn10300 nios2 openrisc parisc score sh tile um unicore32 xtensa

Perhaps we could deliberately make asm-generic/scatterlist.h not build
for architectures that don't select it in order to make them convert ...
