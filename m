From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Net DMA crash when using the mv_xor driver
Date: Tue, 3 Mar 2009 00:13:08 -0700
Message-ID: <e9c3a7c20903022313w477c7af8g2ea2599cb82af3d5@mail.gmail.com>
References: <c70ff3ad0903020827s421a52bak964df6dd013722f6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c70ff3ad0903020827s421a52bak964df6dd013722f6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: saeed bishara <saeed.bishara@gmail.com>
Cc: linux-raid@vger.kernel.org, Lennert Buytenhek <buytenh@wantstofly.org>, Nicolas Pitre <nico@cam.org>
List-Id: linux-raid.ids

On Mon, Mar 2, 2009 at 9:27 AM, saeed bishara <saeed.bishara@gmail.com>=
 wrote:
> Hi Dan,
> =A0 =A0The log below show a kernel crash when using the mv_xor dma en=
gine
> and enabling the NET_DMA, the test that I run is iperf as server.
> after doing some experiences, I found that the reason is because this
> engine doesn't support requests less than 16 bytes, the driver return=
s
> NULL when the request len is too short.
> is this the right thing do when the prepare function needs to reject =
a request?

Yes, this is the right thing to do, but this particular backtrace is
something different.  In this case we are hitting the valid checks in
dma_cache_maint.  I suspect it is failing the dma_map_single call as
it is unlikely we have a bad struct page here, but your function
offsets do not correlate with my local build so it is hard to tell.
This leaves a skb buffer that does not pass the virt_addr_valid
checks?  That seems unlikely as well since, as far as I understand,
skb->data is always kmalloc'd?  Can you determine what the failing
address is and where it came from?

NET_DMA=3Dn is the default on ARM for a reason.  The large overhead of
get_user_pages makes NET_DMA a losing proposition versus cpu-copy.  A
cache coherent architecture is a minimum requirement to see a
performance or cpu utilization gain with NET_DMA.  Regardless of
whether it provides a benefit, it should not be crashing, so let's dig
a bit deeper.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
