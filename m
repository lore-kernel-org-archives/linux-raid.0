From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [RFC PATCH 0/7] evacuate struct page from the block layer
Date: Fri, 20 Mar 2015 21:17:54 +0000
Message-ID: <550C8E82.2020309@youngman.org.uk>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com> <20150318132650.3336261c58829f49a9af8675@linux-foundation.org> <20150319134313.GF4003@linux.intel.com> <550C490E.1080708@redhat.com> <20150320203136.GM4003@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150320203136.GM4003@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, axboe@kernel.dk, linux-nvdimm@ml01.01.org, Dave Hansen <dave.hansen@linux.intel.com>, linux-raid@vger.kernel.org, mgorman@suse.de, hch@infradead.org, linux-fsdevel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-raid.ids

On 20/03/15 20:31, Matthew Wilcox wrote:
> Ah!  I've looked at that a couple of times as well.  I asked our database
> performance team what impact freeing up the memmap would have on their
> performance.  They told me that doubling the amount of memory generally
> resulted in approximately a 40% performance improvement.  So freeing up
> 1.5% additional memory would result in about 0.6% performance improvement,
> which I thought was probably too small a return on investment to justify
> turning memmap into a two-level data structure.

Don't get me started on databases! This is very much a relational
problem, other databases don't suffer like this.

(imho relational theory is totally inappropriate for an engineering
problem, like designing a database engine ...)

Cheers,
Wol
