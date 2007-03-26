From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: [PATCH 2.6.21-rc4 01/15] dmaengine: add base support for the async_tx api
Date: Mon, 26 Mar 2007 09:48:06 -0700
Message-ID: <e9c3a7c20703260948r46044a2esa38c933495a0008f@mail.gmail.com>
References: <20070323064856.15570.45052.stgit@dwillia2-linux.ch.intel.com>
	 <20070323065142.15570.98231.stgit@dwillia2-linux.ch.intel.com>
	 <200703231718.01770.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200703231718.01770.yur@emcraft.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/23/07, Yuri Tikhonov <yur@emcraft.com> wrote:
>  Hi Dan,
>
>  Functions dma_async_memcpy_buf_to_buf(), dma_async_memcpy_buf_to_pg() and
> dma_async_memcpy_pg_to_pg() are practically identical. Maybe it makes sense
> to extract the common part into a separate inline function? Somehow like
> this:
>
ok, I'll pull this in.

Thanks,
Dan
