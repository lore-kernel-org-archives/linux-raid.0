From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re[2]: [PATCH 02/11][v3] async_tx: add support for asynchronous GF multiplication
Date: Fri, 16 Jan 2009 14:41:56 +0300
Message-ID: <1328000796.20090116144156@emcraft.com>
References: <200901130343.06895.yur@emcraft.com> <e9c3a7c20901141656g2fec1802vcecc4ae433838bb3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20901141656g2fec1802vcecc4ae433838bb3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids



 Hello Dan,

 Thanks for review. Some comments below.

On Thursday, January 15, 2009 you wrote:

[..]

>> +/**
>> + * do_async_pq - asynchronously calculate P and/or Q
>> + */
>> +static struct dma_async_tx_descriptor *
>> +do_async_pq(struct dma_chan *chan, struct page **blocks, unsigned char *scfs,
>> +       unsigned int offset, int src_cnt, size_t len, enum async_tx_flags flags,
>> +       struct dma_async_tx_descriptor *depend_tx,
>> +       dma_async_tx_callback cb_fn, void *cb_param)
>> +{
>> +       struct dma_device *dma = chan->device;
>> +       dma_addr_t dma_dest[2], dma_src[src_cnt];
>> +       struct dma_async_tx_descriptor *tx = NULL;
>> +       dma_async_tx_callback _cb_fn;
>> +       void *_cb_param;
>> +       unsigned char *scf = NULL;
>> +       int i, src_off = 0;
>> +       unsigned short pq_src_cnt;
>> +       enum async_tx_flags async_flags;
>> +       enum dma_ctrl_flags dma_flags = 0;
>> +
>> +       /*  If we won't handle src_cnt in one shot, then the following
>> +        * flag(s) will be set only on the first pass of prep_dma
>> +        */
>> +       if (flags & ASYNC_TX_PQ_ZERO_P)
>> +               dma_flags |= DMA_PREP_ZERO_P;
>> +       if (flags & ASYNC_TX_PQ_ZERO_Q)
>> +               dma_flags |= DMA_PREP_ZERO_Q;
>> +
>> +       /* DMAs use destinations as sources, so use BIDIRECTIONAL mapping */
>> +       if (blocks[src_cnt]) {
>> +               dma_dest[0] = dma_map_page(dma->dev, blocks[src_cnt],
>> +                                          offset, len, DMA_BIDIRECTIONAL);
>> +               dma_flags |= DMA_PREP_HAVE_P;
>> +       }
>> +       if (blocks[src_cnt+1]) {
>> +               dma_dest[1] = dma_map_page(dma->dev, blocks[src_cnt+1],
>> +                                          offset, len, DMA_BIDIRECTIONAL);
>> +               dma_flags |= DMA_PREP_HAVE_Q;
>> +       }
>> +
>> +       for (i = 0; i < src_cnt; i++)
>> +               dma_src[i] = dma_map_page(dma->dev, blocks[i],
>> +                                         offset, len, DMA_TO_DEVICE);
>> +
>> +       while (src_cnt) {
>> +               async_flags = flags;
>> +               pq_src_cnt = min(src_cnt, (int)dma->max_pq);
>> +               /* if we are submitting additional pqs, leave the chain open,
>> +                * clear the callback parameters, and leave the destination
>> +                * buffers mapped
>> +                */
>> +               if (src_cnt > pq_src_cnt) {
>> +                       async_flags &= ~ASYNC_TX_ACK;
>> +                       dma_flags |= DMA_COMPL_SKIP_DEST_UNMAP;
>> +                       _cb_fn = NULL;
>> +                       _cb_param = NULL;
>> +               } else {
>> +                       _cb_fn = cb_fn;
>> +                       _cb_param = cb_param;
>> +               }
>> +               if (_cb_fn)
>> +                       dma_flags |= DMA_PREP_INTERRUPT;
>> +               if (scfs)
>> +                       scf = &scfs[src_off];
>> +
>> +               /* Since we have clobbered the src_list we are committed
>> +                * to doing this asynchronously.  Drivers force forward
>> +                * progress in case they can not provide a descriptor
>> +                */
>> +               tx = dma->device_prep_dma_pq(chan, dma_dest,
>> +                                            &dma_src[src_off], pq_src_cnt,
>> +                                            scf, len, dma_flags);
>> +               if (unlikely(!tx))
>> +                       async_tx_quiesce(&depend_tx);
>> +
>> +               /* spin wait for the preceeding transactions to complete */
>> +               while (unlikely(!tx)) {
>> +                       dma_async_issue_pending(chan);
>> +                       tx = dma->device_prep_dma_pq(chan, dma_dest,
>> +                                       &dma_src[src_off], pq_src_cnt,
>> +                                       scf, len, dma_flags);
>> +               }
>> +
>> +               async_tx_submit(chan, tx, async_flags, depend_tx,
>> +                               _cb_fn, _cb_param);
>> +
>> +               depend_tx = tx;
>> +               flags |= ASYNC_TX_DEP_ACK;
>> +
>> +               if (src_cnt > pq_src_cnt) {
>> +                       /* drop completed sources */
>> +                       src_cnt -= pq_src_cnt;
>> +                       src_off += pq_src_cnt;
>> +
>> +                       /* use the intermediate result as a source; we
>> +                        * clear DMA_PREP_ZERO, so prep_dma_pq will
>> +                        * include destination(s) into calculations. Thus
>> +                        * keep DMA_PREP_HAVE_x in dma_flags only
>> +                        */
>> +                       dma_flags &= (DMA_PREP_HAVE_P | DMA_PREP_HAVE_Q);

> I don't think this will work as we will be mixing Q into the new P and
> P into the new Q.  In order to support (src_cnt > device->max_pq) we
> need to explicitly tell the driver that the operation is being
> continued (DMA_PREP_CONTINUE) and to apply different coeffeicients to
> P and Q to cancel the effect of including them as sources.

 With DMA_PREP_ZERO_P/Q approach, the Q isn't mixed into new P, and P 
isn't mixed into new Q. For your example of max_pq=4:

 p, q = PQ(src0, src1, src2, src3, src4, COEF({01}, {02}, {04}, {08}, {10}))

 with the current implementation will be split into:

 p, q = PQ(src0, src1, src2, src3, COEF({01}, {02}, {04}, {08})
 p`,q` = PQ(src4, COEF({10}))

 which will result to the following:

 p = ((dma_flags & DMA_PREP_ZERO_P) ? 0 : old_p) + src0 + src1 + src2 + src3
 q = ((dma_flags & DMA_PREP_ZERO_Q) ? 0 : old_q) + {01}*src0 + {02}*src1 + {04}*src2 + {08}*src3
 
 p` = p + src4
 q` = q + {10}*src4

 But, if we get rid of DMA_PREP_ZERO_P/Q, then the mess with P/Q will 
have a place indeed.

>  Here is an
> example of supporting a 5 source pq operation where max_pq == 4 (the
> minimum).

>     p, q = PQ(src0, src1, src2, src3, COEF({01}, {02}, {04}, {08}))
>     p', q' = PQ(p, q, q, src4, COEF({00}, {01}, {00}, {10}))

>     p' = p + q + q + src4 = p + src4 = P
>     q' = {00}*p + {01}*q + {00}*q + {10}*src4 = q + {10)*src4 = Q

> ...at no point do we need to zero P or Q.  Yes, this requires a lot of
> extra work for incremental sources,

 I would say, that 'very very lot'. In general this means that for 
the cases of N sources > max_pq we'll have to do:

 C = 1 + ceil((N-max_pq)/(max_pq - 3)) number of calls to ADMA.

 E.g., for max_pq = 4:

 N = 5 => C = 2,
 N = 6 => C = 3,
 ..
 N = 15 => C = 12,
 N = 16 => C = 13,
 ..
 N = 128 => C = 125.


 If we stay with the current approach of using DMA_PREP_ZERO_P/Q, then

 C = 1 + ceil((N-max_pq)/max_pq)) number of calls to ADMA.

 And the same series will result to:

 N = 5 => C = 2,
 N = 6 => C = 2,
 ..
 N = 15 => C = 4,
 N = 16 => C = 4,
 ..
 N = 128 => C = 32.


 I'm afraid that the difference (13/4, 125/32) is very significant, so 
getting rid of DMA_PREP_ZERO_P/Q will eat most of the improvement 
which could be achieved with the current approach.

>  but at this point I do not see a cleaner alternatve for engines like iop13xx.

 I can't find any description of iop13xx processors at Intel's 
web-site, only 3xx:

http://www.intel.com/design/iio/index.htm?iid=ipp_embed+embed_io

 So, it's hard for me to do any suggestions. I just wonder - doesn't 
iop13xx allow users to program destination addresses into the sources 
fields of descriptors?

>> +               } else
>> +                       break;
>> +       }
>> +
>> +       return tx;
>> +}
>> +
>> +/**
>> + * do_sync_pq - synchronously calculate P and Q
>> + */
>> +static void
>> +do_sync_pq(struct page **blocks, unsigned char *scfs, unsigned int offset,
>> +       int src_cnt, size_t len, enum async_tx_flags flags,
>> +       struct dma_async_tx_descriptor *depend_tx,
>> +       dma_async_tx_callback cb_fn, void *cb_param)
>> +{
>> +       int i, pos;
>> +       uint8_t *p = NULL, *q = NULL, *src;
>> +
>> +       /* set destination addresses */
>> +       if (blocks[src_cnt])
>> +               p = (uint8_t *)(page_address(blocks[src_cnt]) + offset);
>> +       if (blocks[src_cnt+1])
>> +               q = (uint8_t *)(page_address(blocks[src_cnt+1]) + offset);
>> +
>> +       if (flags & ASYNC_TX_PQ_ZERO_P) {
>> +               BUG_ON(!p);
>> +               memset(p, 0, len);
>> +       }
>> +
>> +       if (flags & ASYNC_TX_PQ_ZERO_Q) {
>> +               BUG_ON(!q);
>> +               memset(q, 0, len);
>> +       }
>> +
>> +       for (i = 0; i < src_cnt; i++) {
>> +               src = (uint8_t *)(page_address(blocks[i]) + offset);
>> +               for (pos = 0; pos < len; pos++) {
>> +                       if (p)
>> +                               p[pos] ^= src[pos];
>> +                       if (q)
>> +                               q[pos] ^= raid6_gfmul[scfs[i]][src[pos]];
>> +               }
>> +       }
>> +       async_tx_sync_epilog(cb_fn, cb_param);
>> +}

> sync_pq like sync_gensyndrome should not care about the current
> contents of p and q, just regenerate from the current sources.  This
> kills another site where ASYNC_TX_PQ_ZERO_{P,Q} is used.

 Well, perhaps you are right. The ASYNC_TX_PQ_ZERO_{P,Q} is set for 
the most common cases of using async_pq, i.e. the parity generating. 
The wrap-around async_gen_syndrome() function always set these flags 
before calling async_pq().

 The cases where ASYNC_TX_PQ_ZERO_{P,Q} isn't set are:

(a) async_pq can't process the sources in one short because of src_cnt > 
max_pq, so it should re-use the intermediate results (destination) as 
the sources;

(b) async_r6_dd_recov() does XOR with async_pq() assuming re-using the 
destination as the source.


 So, I would say that ASYNC_TX_PQ_ZERO_{P,Q} should definitely go 
away, if there were no significant overheads in (a) implemented 
without these flags (see above).

>> +
>> +/**
>> + * async_pq - attempt to do XOR and Galois calculations in parallel using
>> + *     a dma engine.
>> + * @blocks: source block array from 0 to (src_cnt-1) with the p destination
>> + *     at blocks[src_cnt] and q at blocks[src_cnt + 1]. Only one of two
>> + *     destinations may be present (another then has to be set to NULL).
>> + *     By default, the result of calculations is XOR-ed with the initial
>> + *     content of the destinationa buffers. Use ASYNC_TX_PQ_ZERO_x flags
>> + *     to avoid this.
>> + *     NOTE: client code must assume the contents of this array are destroyed
>> + * @scfs: array of source coefficients used in GF-multiplication
>> + * @offset: offset in pages to start transaction
>> + * @src_cnt: number of source pages
>> + * @len: length in bytes
>> + * @flags: ASYNC_TX_PQ_ZERO_P, ASYNC_TX_PQ_ZERO_Q, ASYNC_TX_ASSUME_COHERENT,
>> + *     ASYNC_TX_ACK, ASYNC_TX_DEP_ACK, ASYNC_TX_ASYNC_ONLY
>> + * @depend_tx: depends on the result of this transaction.
>> + * @cb_fn: function to call when the operation completes
>> + * @cb_param: parameter to pass to the callback routine
>> + */
>> +struct dma_async_tx_descriptor *
>> +async_pq(struct page **blocks, unsigned char *scfs, unsigned int offset,
>> +       int src_cnt, size_t len, enum async_tx_flags flags,
>> +       struct dma_async_tx_descriptor *depend_tx,
>> +       dma_async_tx_callback cb_fn, void *cb_param)
>> +{
>> +       struct dma_chan *chan = async_tx_find_channel(depend_tx, DMA_PQ,
>> +                                       &blocks[src_cnt], 2,
>> +                                       blocks, src_cnt, len);
>> +       struct dma_device *device = chan ? chan->device : NULL;
>> +       struct dma_async_tx_descriptor *tx = NULL;
>> +
>> +       if (!device && (flags & ASYNC_TX_ASYNC_ONLY))
>> +               return NULL;
>> +
>> +       if (device) {
>> +               /* run pq asynchronously */
>> +               tx = do_async_pq(chan, blocks, scfs, offset, src_cnt,
>> +                       len, flags, depend_tx, cb_fn,cb_param);
>> +       } else {
>> +               /* run pq synchronously */
>> +               if (!blocks[src_cnt+1]) {
>> +                       struct page *pdst = blocks[src_cnt];
>> +                       int i;
>> +
>> +                       /* Calculate P-parity only.
>> +                        * As opposite to async_xor(), async_pq() assumes
>> +                        * that destinations are included into calculations,
>> +                        * so we should re-arrange the xor src list to
>> +                        * achieve the similar behavior.
>> +                        */
>> +                       if (!(flags & ASYNC_TX_PQ_ZERO_P)) {
>> +                               /* If async_pq() user doesn't set ZERO flag,
>> +                                * it's assumed that destination has some
>> +                                * reasonable data to include in calculations.
>> +                                * The destination must be at position 0, so
>> +                                * shift the sources and put pdst at the
>> +                                * beginning of the list.
>> +                                */
>> +                               for (i = src_cnt - 1; i >= 0; i--)
>> +                                       blocks[i+1] = blocks[i];
>> +                               blocks[0] = pdst;
>> +                               src_cnt++;
>> +                               flags |= ASYNC_TX_XOR_DROP_DST;
>> +                       } else {
>> +                               /* If async_pq() user want to clear P, then
>> +                                * this will be done automatically in async
>> +                                * case, and with the help of ZERO_DST in
>> +                                * the sync one.
>> +                                */
>> +                               flags &= ~ASYNC_TX_PQ_ZERO_P;
>> +                               flags |= ASYNC_TX_XOR_ZERO_DST;
>> +                       }
>> +
>> +                       return async_xor(pdst, blocks, offset,
>> +                                        src_cnt, len, flags, depend_tx,
>> +                                        cb_fn, cb_param);

> If we assume that async_pq always regenerates parity and never reuses
> the old value then we can get gid of the !(flags & ASYNC_TX_PQ_ZERO_P)
> path.  In the case where code does need to reuse the old P,
> async_r6recov.c, it should call async_xor directly since that routine
> provides this semantic.

 Right. The question is - will we get rid of ZERO_P/Q or not.

[..]

>> @@ -81,14 +81,28 @@ enum dma_transaction_type {
>>  *     dependency chains
>>  * @DMA_COMPL_SKIP_SRC_UNMAP - set to disable dma-unmapping the source buffer(s)
>>  * @DMA_COMPL_SKIP_DEST_UNMAP - set to disable dma-unmapping the destination(s)
>> + * @DMA_PREP_HAVE_P - set if the destination list includes the correct
>> + *     address of P (P-parity should be handled)
>> + * @DMA_PREP_HAVE_Q - set if the destination list includes the correct
>> + *     address of Q (Q-parity should be handled)
>> + * @DMA_PREP_ZERO_P - set if P has to be zeroed before proceeding
>> + * @DMA_PREP_ZERO_Q - set if Q has to be zeroed before proceeding
>>  */
>>  enum dma_ctrl_flags {
>>        DMA_PREP_INTERRUPT = (1 << 0),
>>        DMA_CTRL_ACK = (1 << 1),
>>        DMA_COMPL_SKIP_SRC_UNMAP = (1 << 2),
>>        DMA_COMPL_SKIP_DEST_UNMAP = (1 << 3),
>> +
>> +       DMA_PREP_HAVE_P = (1 << 4),
>> +       DMA_PREP_HAVE_Q = (1 << 5),
>> +       DMA_PREP_ZERO_P = (1 << 6),
>> +       DMA_PREP_ZERO_Q = (1 << 7),
>>  };
>>
>> +#define DMA_PCHECK_FAILED      (1 << 0)
>> +#define DMA_QCHECK_FAILED      (1 << 1)

> Perhaps turn these into an enum such that we can pass around a enum
> pq_check_flags pointer rather than a non-descript u32 *.

 Agree.

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

