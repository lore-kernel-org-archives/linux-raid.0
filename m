From: Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Fri, 20 Mar 2015 12:21:34 -0400
Message-ID: <550C490E.1080708@redhat.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <20150318132650.3336261c58829f49a9af8675@linux-foundation.org> <20150319134313.GF4003@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150319134313.GF4003@linux.intel.com>
Sender: linux-arch-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-raid.ids

On 03/19/2015 09:43 AM, Matthew Wilcox wrote:

> 1. Construct struct pages for persistent memory
> 1a. Permanently
> 1b. While the pages are under I/O

Michael Tsirkin and I have been doing some thinking about what
it would take to allocate struct pages per 2MB area permanently,
and allocate additional struct pages for 4kB pages on demand,
when a 2MB area is broken up into 4kB pages.

This should work for both DRAM and persistent memory.

I am still not convinced it is worthwhile to have struct pages
for persistent memory though, but I am willing to change my mind.

-- 
All rights reversed
