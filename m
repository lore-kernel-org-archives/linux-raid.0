From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re[2]: [PATCH 01/11] async_tx: don't use src_list argument of async_xor() for dma addresses
Date: Tue, 9 Dec 2008 03:41:36 +0300
Message-ID: <1195158776.20081209034136@emcraft.com>
References: <200812090055.26721.yur@emcraft.com> <e9c3a7c20812081631i1e0efff2j953b2e81f6dc6e0e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20812081631i1e0efff2j953b2e81f6dc6e0e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

On Tuesday, December 9, 2008 you wrote:

> On Mon, Dec 8, 2008 at 2:55 PM, Yuri Tikhonov <yur@emcraft.com> wrote:
>> Using src_list argument of async_xor() as a storage for dma addresses
>> implies sizeof(dma_addr_t) <= sizeof(struct page *) restriction which is
>> not always true (e.g. ppc440spe).
>>

> ppc440spe runs with CONFIG_PHYS_64BIT?

 Yep. It uses 36-bit addressing, so this CONFIG is turned on.

> If we do this then we need to also change md to limit the number of
> allowed disks based on the kernel stack size.  Because with 256 disks
> a 4K stack can be consumed by one call to async_pq ((256 sources in
> raid5.c + 256 sources async_pq.c) * 8 bytes per source on 64-bit).

 On ppc440spe we have 8KB stack, so the things are not worse than on 
32-bit archs with 4KB stack. Thus, I guess no changes to md are 
required because of this patch. Right?

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

