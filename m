From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 02/13] async_tx: don't use src_list argument of
	async_xor() for dma addresses
Date: Wed, 25 Mar 2009 10:11:04 -0700
Message-ID: <e9c3a7c20903251011w3f6b3f58u7c0352ae39bb1c7c@mail.gmail.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <20090318192026.20375.3053.stgit@dwillia2-linux.ch.intel.com>
	 <20090319201008.GC10491@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090319201008.GC10491@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com, Yuri Tikhonov <yur@emcraft.com>, Ilya Yanok <yanok@emcraft.com>
List-Id: linux-raid.ids

On Thu, Mar 19, 2009 at 1:10 PM, Andre Noll <maan@systemlinux.org> wrote:
> On 12:20, Dan Williams wrote:
>
>> Using src_list argument of async_xor() as a storage for dma addresses
>> implies sizeof(dma_addr_t) <= sizeof(struct page *) restriction which is
>> not always true (e.g. ppc440spe).
>
> This message does not tell what the patch is going to do about that.
> It would also be nice to mention (either in the log message or as a
> comment) why allocating the dma_src arrays on the stack is not going
> to be a problem.
>

True, and taking into account your other comment about the number of
parameters I think this is a good opportunity to solve this problem
rather than kick it down the road.  So I will prepare a rework to make
this memory caller provided.  This gives us the flexibility to use a
kmalloc'd buffer hanging off the stripe_head as Neil suggested in
another thread.

Regards,
Dan
