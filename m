From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH 01/11] async_tx: don't use src_list argument of async_xor() for dma addresses
Date: Fri, 14 Nov 2008 17:42:27 -0700
Message-ID: <e9c3a7c20811141642q7608e642sd14b3021223a2d3c@mail.gmail.com>
References: <1226589364-5619-1-git-send-email-yanok@emcraft.com>
	 <1226589364-5619-2-git-send-email-yanok@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1226589364-5619-2-git-send-email-yanok@emcraft.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ilya Yanok <yanok@emcraft.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, yur@emcraft.com, wd@denx.de, dzu@denx.de
List-Id: linux-raid.ids

On Thu, Nov 13, 2008 at 8:15 AM, Ilya Yanok <yanok@emcraft.com> wrote:
> Using src_list argument of async_xor() as a storage for dma addresses
> implies sizeof(dma_addr_t) <= sizeof(struct page *) restriction which is
> not always true.
>
> Signed-off-by: Ilya Yanok <yanok@emcraft.com>
> ---

I don't like the stack space implications of this change.  Especially
for large arrays we will be carrying two 'src_cnt' size arrays on the
stack, one from MD and one from async_tx.  However, I think the
current scheme of overwriting input parameters is pretty ugly.  So, I
want to benchmark the performance implications of adding a GFP_NOIO
allocation here, with the idea being that if the allocation fails we
can still fallback to the synchronous code path.

--
Dan
