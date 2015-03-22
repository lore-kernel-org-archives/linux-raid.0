From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [Linux-nvdimm] [RFC PATCH 0/7] evacuate struct page from the
 block layer
Date: Sun, 22 Mar 2015 19:22:00 +0200
Message-ID: <550EFA38.8030706@plexistor.com>
References: <20150316201640.33102.33761.stgit@dwillia2-desk3.amr.corp.intel.com>	<20150318132650.3336261c58829f49a9af8675@linux-foundation.org>	<20150319134313.GF4003@linux.intel.com>	<550AF127.9010504@plexistor.com>	<20150319125917.6cc2bf02687aab542027d8ac@linux-foundation.org> <CAPcyv4j=M8V_36C-HhiJM7MHzNLFcpP=nec=LHnob5+qZ4xgYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4j=M8V_36C-HhiJM7MHzNLFcpP=nec=LHnob5+qZ4xgYw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <boaz@plexistor.com>, linux-arch@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, riel@redhat.com, linux-raid <linux-raid@vger.kernel.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Dave Hansen <dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Mel Gorman <mgorman@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-raid.ids

On 03/19/2015 10:59 PM, Dan Williams wrote:

> 
> At least for block-i/o it seems the only place we really need struct
> page infrastructure is for kmap().  Given we already need a kmap_pfn()
> solution for option 2 a "dynamic allocation" stop along that
> development path may just naturally fall out.

Really? what about networked block-io, RDMA, FcOE emulated targets,
mmaped pointers. virtual-machine bdev drivers

Block layer sits in the middle of the stack not at the low end as you
make it appear. There are lots of below the bio subsystems that tie into
a page struct, which will now stop to operate, unless you do:

pfn_to_page() which means a page-less pfn will now crash or will need
to be rejected so any where you have a
	if (page_less_pfn())
		... /* Fail or do some other code like copy */
	else
		page = pfn_to_page()

Is a double code path in the Kernel and is a nightmare to maintain.
(I'm here for you believe me ;-) )

Thanks
Boaz

