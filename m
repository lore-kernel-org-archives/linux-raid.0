From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Mon, 23 Mar 2015 12:30:17 -0700
Message-ID: <20150323193017.GA14179@infradead.org>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150318132650.3336261c58829f49a9af8675@linux-foundation.org>
 <20150319134313.GF4003@linux.intel.com>
 <550C490E.1080708@redhat.com>
 <550EE4FE.1070009@plexistor.com>
 <55102EEB.2090401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55102EEB.2090401@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>
Cc: Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-raid.ids

On Mon, Mar 23, 2015 at 11:19:07AM -0400, Rik van Riel wrote:
> There are two things going on here:
> 
> 1) You want to keep using struct page for now, while there are
>    subsystems that require it. This is perfectly legitimate.
> 
> 2) Matthew and Dan are changing over some subsystems to no longer
>    require struct page. This is perfectly legitimate.
> 
> I do not understand why either of you would have to object to what
> the other is doing. There is room to keep using struct page until
> the rest of the kernel no longer requires it.

*nod*

I'd really like to merge the struct page based pmem driver ASAP.  We can
then look into work that avoid the need for struct page, and I think Dan
is doing some good work in that direction.
