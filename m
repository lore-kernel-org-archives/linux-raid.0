From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH 01/11] async_tx: don't use src_list argument of async_xor() for dma addresses
Date: Mon, 8 Dec 2008 17:31:13 -0700
Message-ID: <e9c3a7c20812081631i1e0efff2j953b2e81f6dc6e0e@mail.gmail.com>
References: <200812090055.26721.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200812090055.26721.yur@emcraft.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

On Mon, Dec 8, 2008 at 2:55 PM, Yuri Tikhonov <yur@emcraft.com> wrote:
> Using src_list argument of async_xor() as a storage for dma addresses
> implies sizeof(dma_addr_t) <= sizeof(struct page *) restriction which is
> not always true (e.g. ppc440spe).
>

ppc440spe runs with CONFIG_PHYS_64BIT?

If we do this then we need to also change md to limit the number of
allowed disks based on the kernel stack size.  Because with 256 disks
a 4K stack can be consumed by one call to async_pq ((256 sources in
raid5.c + 256 sources async_pq.c) * 8 bytes per source on 64-bit).

Regards,
Dan
