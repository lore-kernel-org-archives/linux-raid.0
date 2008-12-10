From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Re[2]: [PATCH 01/11] async_tx: don't use src_list argument of async_xor() for dma addresses
Date: Tue, 9 Dec 2008 18:08:29 -0700
Message-ID: <e9c3a7c20812091708n5e5daf2ane9c7fb927782c771@mail.gmail.com>
References: <200812090055.26721.yur@emcraft.com>
	 <e9c3a7c20812081631i1e0efff2j953b2e81f6dc6e0e@mail.gmail.com>
	 <1195158776.20081209034136@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1195158776.20081209034136@emcraft.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Mon, Dec 8, 2008 at 5:41 PM, Yuri Tikhonov <yur@emcraft.com> wrote:
> On Tuesday, December 9, 2008 you wrote:
>
>> On Mon, Dec 8, 2008 at 2:55 PM, Yuri Tikhonov <yur@emcraft.com> wrote:
>>> Using src_list argument of async_xor() as a storage for dma addresses
>>> implies sizeof(dma_addr_t) <= sizeof(struct page *) restriction which is
>>> not always true (e.g. ppc440spe).
>>>
>
>> ppc440spe runs with CONFIG_PHYS_64BIT?
>
>  Yep. It uses 36-bit addressing, so this CONFIG is turned on.
>
>> If we do this then we need to also change md to limit the number of
>> allowed disks based on the kernel stack size.  Because with 256 disks
>> a 4K stack can be consumed by one call to async_pq ((256 sources in
>> raid5.c + 256 sources async_pq.c) * 8 bytes per source on 64-bit).
>
>  On ppc440spe we have 8KB stack, so the things are not worse than on
> 32-bit archs with 4KB stack. Thus, I guess no changes to md are
> required because of this patch. Right?

8K stacks do make this less of an issue *provided* handle_stripe()
remains only called from raid5d.  We used to share some stripe
handling work with the requester's process context where the stack is
much more crowded.  So, we would now be more strongly tied to the
raid5d-only approach... maybe that is not enough to deny this change.
Neil what do you think of the async_{xor,pq,etc} apis allocating
'src_cnt' sized arrays on the stack?

Thanks,
Dan
