From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Re[2]: [PATCH 02/11][v3] async_tx: add support for asynchronous
	GF multiplication
Date: Fri, 16 Jan 2009 11:28:04 -0700
Message-ID: <e9c3a7c20901161028v3320b14ay68df8360fff2b8a5@mail.gmail.com>
References: <200901130343.06895.yur@emcraft.com>
	 <e9c3a7c20901141656g2fec1802vcecc4ae433838bb3@mail.gmail.com>
	 <1328000796.20090116144156@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1328000796.20090116144156@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuri Tikhonov <yur@emcraft.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

On Fri, Jan 16, 2009 at 4:41 AM, Yuri Tikhonov <yur@emcraft.com> wrote:
>> I don't think this will work as we will be mixing Q into the new P and
>> P into the new Q.  In order to support (src_cnt > device->max_pq) we
>> need to explicitly tell the driver that the operation is being
>> continued (DMA_PREP_CONTINUE) and to apply different coeffeicients to
>> P and Q to cancel the effect of including them as sources.
>
>  With DMA_PREP_ZERO_P/Q approach, the Q isn't mixed into new P, and P
> isn't mixed into new Q. For your example of max_pq=4:
>
>  p, q = PQ(src0, src1, src2, src3, src4, COEF({01}, {02}, {04}, {08}, {10}))
>
>  with the current implementation will be split into:
>
>  p, q = PQ(src0, src1, src2, src3, COEF({01}, {02}, {04}, {08})
>  p`,q` = PQ(src4, COEF({10}))
>
>  which will result to the following:
>
>  p = ((dma_flags & DMA_PREP_ZERO_P) ? 0 : old_p) + src0 + src1 + src2 + src3
>  q = ((dma_flags & DMA_PREP_ZERO_Q) ? 0 : old_q) + {01}*src0 + {02}*src1 + {04}*src2 + {08}*src3
>
>  p` = p + src4
>  q` = q + {10}*src4
>

Huh?  Does the ppc440spe engine have some notion of flagging a source
as old_p/old_q?  Otherwise I do not see how the engine will not turn
this into:

p` = p + src4 + q
q` = q + {10}*src4 + {x}*p

I think you missed the fact that we have passed p and q back in as
sources.  Unless we have multiple p destinations and multiple q
destinations, or hardware support for continuations I do not see how
you can guarantee this split.

>  I'm afraid that the difference (13/4, 125/32) is very significant, so
> getting rid of DMA_PREP_ZERO_P/Q will eat most of the improvement
> which could be achieved with the current approach.

Data corruption is a slightly higher cost :-).

>
>>  but at this point I do not see a cleaner alternatve for engines like iop13xx.
>
>  I can't find any description of iop13xx processors at Intel's
> web-site, only 3xx:
>
> http://www.intel.com/design/iio/index.htm?iid=ipp_embed+embed_io
>
>  So, it's hard for me to do any suggestions. I just wonder - doesn't
> iop13xx allow users to program destination addresses into the sources
> fields of descriptors?

Yes it does, but the engine does not know it is a destination.

Take a look at page 496 of the following and tell me if you come to a
different conclusion.
http://download.intel.com/design/iio/docs/31503602.pdf

Thanks,
Dan
