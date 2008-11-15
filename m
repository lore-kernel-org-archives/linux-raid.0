From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 01/11] async_tx: don't use src_list argument of
 async_xor() for dma addresses
Date: Sat, 15 Nov 2008 18:12:22 +1100
Message-ID: <1226733142.7178.162.camel@pasglop>
References: <1226589364-5619-1-git-send-email-yanok@emcraft.com>
	 <1226589364-5619-2-git-send-email-yanok@emcraft.com>
	 <e9c3a7c20811141642q7608e642sd14b3021223a2d3c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20811141642q7608e642sd14b3021223a2d3c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ilya Yanok <yanok@emcraft.com>, linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de
List-Id: linux-raid.ids

On Fri, 2008-11-14 at 17:42 -0700, Dan Williams wrote:
> I don't like the stack space implications of this change.  Especially
> for large arrays we will be carrying two 'src_cnt' size arrays on the
> stack, one from MD and one from async_tx.  However, I think the
> current scheme of overwriting input parameters is pretty ugly. 

Well, it's also broken :-) On a number of architectures, dma_addr_t can
be 64 bit while page * is 32 bit

>  So, I
> want to benchmark the performance implications of adding a GFP_NOIO
> allocation here, with the idea being that if the allocation fails we
> can still fallback to the synchronous code path.



