From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Wed, 18 Mar 2015 13:26:50 -0700
Message-ID: <20150318132650.3336261c58829f49a9af8675@linux-foundation.org>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, riel@redhat.com, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
List-Id: linux-raid.ids

On Mon, 16 Mar 2015 16:25:25 -0400 Dan Williams <dan.j.williams@intel.com> wrote:

> Avoid the impending disaster of requiring struct page coverage for what
> is expected to be ever increasing capacities of persistent memory.  In
> conversations with Rik van Riel, Mel Gorman, and Jens Axboe at the
> recently concluded Linux Storage Summit it became clear that struct page
> is not required in many places, it was simply convenient to re-use.
> 
> Introduce helpers and infrastructure to remove struct page usage where
> it is not necessary.  One use case for these changes is to implement a
> write-back-cache in persistent memory for software-RAID.  Another use
> case for the scatterlist changes is RDMA to a pfn-range.

Those use-cases sound very thin.  If that's all we have then I'd say
"find another way of implementing those things without creating
pageframes for persistent memory".

IOW, please tell us much much much more about the value of this change.
