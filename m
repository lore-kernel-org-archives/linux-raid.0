From: saeed bishara <saeed.bishara@gmail.com>
Subject: Re: RAID/dmaengine violates the dma-streaming API
Date: Wed, 27 Apr 2011 14:42:57 +0300
Message-ID: <BANLkTi=30Q5=TAaPcE8SXt417S6e=RaY3Q@mail.gmail.com>
References: <BANLkTinMA_U1r6K4t8UZKUr4nZBsWPSv9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinMA_U1r6K4t8UZKUr4nZBsWPSv9w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>, Dan Williams <dan.j.williams@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-raid.ids

On Sun, Apr 17, 2011 at 7:00 PM, saeed bishara <saeed.bishara@gmail.com=
> wrote:
> Hi,
> =C2=A0 =C2=A0 when md uses the dma for offloading xor and memcpy oper=
ations, it
> violates the dma-mapping API. =C2=A0here is the scenario I'm taking a=
bout
> (under write to degraded raid5):
> 1. ops_run_prexor sends xor operation from buffers A and B, and the
> destination is A.
> 2. ops_run_biodrain: sends mempcy operation from C to B.
> 3. ops_run_reconstruct5: sends xor operation from A and B, and the
> destination is A again.
>
> in step 1, the async tx maps A using dma_map_page, and in step 3, it
> maps again the same buffer. but, if the request from step 1 still
> being handled the dma engine, then we end with a case where the buffe=
r
> mapped while it still belongs to the dma hw.
> when the arch is ARMv6/SMP mode (without io coherency), the cache
> maintenance involves read/write access to the buffers, that means, th=
e
> second mapping above may access the buffer(with read/write) while the
> dma is writing to it!!.
>
Russell/Dan,
     can you have a look into this issue? what I see here is that the
raid stack issues dma_map_page to a buffer that still owned by DMA.

saeed

> also, from performance sake, it would be great if this multiple
> mappings get avoided.
>
> saeed
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
