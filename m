From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Sun, 22 Mar 2015 18:46:15 +0200
Message-ID: <550EF1D7.8040708@plexistor.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <20150318132650.3336261c58829f49a9af8675@linux-foundation.org> <20150319134313.GF4003@linux.intel.com> <20150319181725.GA17411@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150319181725.GA17411@infradead.org>
Sender: linux-arch-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <willy@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, riel@redhat.com, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On 03/19/2015 08:17 PM, Christoph Hellwig wrote:
<>
> 
> In addition to the options there's also a time line.  At least for the
> short term where we want to get something going 1a seems like the
> absolutely be option.  It works perfectly fine for the lots of small
> capacity dram-like nvdimms, and it works funtionally fine for the
> special huge ones, although the resource use for it is highly annoying.
> If it turns out to be too annoying we can also offer a no I/O possible
> option for them in the short run.
> 

Finally some voice in the dessert.

> In the long run option 2) sounds like a good plan to me, but not as a
> parallel I/O path, but as the main one.  Doing so will in fact give us
> options to experiment with 3).  Given that we're moving towards an
> increasinly huge page using world replacing the good old struct page
> with something extent-like and/or temporary might be needed for dram
> as well in the future.

Why ? why not just make page mean page_size(page) and mostly even that
is not needed.

Any changes to bio will only solve bio. And will push the problem to
the next subsystem.

Fix the PAGE_SIZE problem and you fixed it for all subsystems, not only
bio. And I believe it is the smaller change by far.

Because in most places PAGE_SIZE just means MIN_PAGE_SIZE when we try
calculate some array sizes for storage of a given "io-length", this
is surly 4k, but then when the actual run time is preformed we usually
have a length specifier like bv_len. (And the few places that do not are
easy to fix I believe)

Thanks
Boaz
