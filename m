From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re[4]: [PATCH 02/11][v3] async_tx: add support for asynchronous GF
	multiplication
Date: Sat, 17 Jan 2009 15:19:37 +0300
Message-ID: <81938970.20090117151937__30745.0571949177$1232194960$gmane$org@emcraft.com>
References: <200901130343.06895.yur@emcraft.com>
	<e9c3a7c20901141656g2fec1802vcecc4ae433838bb3@mail.gmail.com>
	<1328000796.20090116144156@emcraft.com>
	<e9c3a7c20901161028v3320b14ay68df8360fff2b8a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <e9c3a7c20901161028v3320b14ay68df8360fff2b8a5@mail.gmail.com>
List-Unsubscribe: <https://ozlabs.org/mailman/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, wd@denx.de, dzu@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

Hello Dan,

On Friday, January 16, 2009 you wrote:

> On Fri, Jan 16, 2009 at 4:41 AM, Yuri Tikhonov <yur@emcraft.com> wrote:
>>> I don't think this will work as we will be mixing Q into the new P and
>>> P into the new Q.  In order to support (src_cnt > device->max_pq) we
>>> need to explicitly tell the driver that the operation is being
>>> continued (DMA_PREP_CONTINUE) and to apply different coeffeicients to
>>> P and Q to cancel the effect of including them as sources.
>>
>>  With DMA_PREP_ZERO_P/Q approach, the Q isn't mixed into new P, and P
>> isn't mixed into new Q. For your example of max_pq=4:
>>
>>  p, q = PQ(src0, src1, src2, src3, src4, COEF({01}, {02}, {04}, {08}, {10}))
>>
>>  with the current implementation will be split into:
>>
>>  p, q = PQ(src0, src1, src2, src3, COEF({01}, {02}, {04}, {08})
>>  p`,q` = PQ(src4, COEF({10}))
>>
>>  which will result to the following:
>>
>>  p = ((dma_flags & DMA_PREP_ZERO_P) ? 0 : old_p) + src0 + src1 + src2 + src3
>>  q = ((dma_flags & DMA_PREP_ZERO_Q) ? 0 : old_q) + {01}*src0 + {02}*src1 + {04}*src2 + {08}*src3
>>
>>  p` = p + src4
>>  q` = q + {10}*src4
>>

> Huh?  Does the ppc440spe engine have some notion of flagging a source
> as old_p/old_q?  Otherwise I do not see how the engine will not turn
> this into:

> p` = p + src4 + q
> q` = q + {10}*src4 + {x}*p

> I think you missed the fact that we have passed p and q back in as
> sources.  Unless we have multiple p destinations and multiple q
> destinations, or hardware support for continuations I do not see how
> you can guarantee this split.

 I guess, I've got your point. You are missing the fact that 
destinations for 'p' and 'q' are passed in device_prep_dma_pq() method 
separately from sources. Speaking your words: we do not have multiple 
destinations through the while() cycles, the destinations are the same 
in each pass.

 Please look at do_async_pq() implementation more carefully: 'blocks' 
is a pointer to 'src_cnt' sources _plus_ two destination pages (as 
it's stated in async_pq() description). Before coming into the while() 
cycle we save destinations in the dma_dest[] array, and then pass this 
to device_prep_dma_pq() in each (src_cnt/max_pq) cycle. That is, we do 
not passes destinations as the sources explicitly: we just clear 
DMA_PREP_ZERO_P/Q flags to notify ADMA level that this have to XOR the 
current content of destination(s) with the result of new operation.

>>  I'm afraid that the difference (13/4, 125/32) is very significant, so
>> getting rid of DMA_PREP_ZERO_P/Q will eat most of the improvement
>> which could be achieved with the current approach.

> Data corruption is a slightly higher cost :-).

>>
>>>  but at this point I do not see a cleaner alternatve for engines like iop13xx.
>>
>>  I can't find any description of iop13xx processors at Intel's
>> web-site, only 3xx:
>>
>> http://www.intel.com/design/iio/index.htm?iid=ipp_embed+embed_io
>>
>>  So, it's hard for me to do any suggestions. I just wonder - doesn't
>> iop13xx allow users to program destination addresses into the sources
>> fields of descriptors?

> Yes it does, but the engine does not know it is a destination.

> Take a look at page 496 of the following and tell me if you come to a
> different conclusion.
> http://download.intel.com/design/iio/docs/31503602.pdf

 I see. The major difference in the implementation of support for P+Q 
in ppc440spe DMA engines is that ppc440spe allows to include (xor) the 
previous content of P_Result and/or Q_Result just by setting a 
corresponding indication in the destination (P_Result and/or Q_Result) 
address(es) 

 The "5.7.5 P+Q Update Operation" case won't help here, since, if 
I understand it right, it doesn't allow to set up different 
multipliers for Old and New Data.

 So, it looks like your approach:

p', q' = PQ(p, q, q, src4, COEF({00}, {01}, {00}, {10}))

 is the only possible way of including the previous P/Q content into 
the calculation.

 But I still think, that this p'/q' hack should have a place on the 
ADMA level, not ASYNC_TX. It looks more generic if ASYNC_TX will 
assume that ADMA is capable of p'=p+src / q'=q+{}*src. Otherwise, 
we'll have an overhead for the DMAs which could work without this 
overhead.

 In your case, the IOP ADMA driver should handle the situation when it 
receives 4 sources to be P+Qed with the previous contents of 
destinations, for example, by generating the sequence of 4 descriptors 
to process such a request.

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com
