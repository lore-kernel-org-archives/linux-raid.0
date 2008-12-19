From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re[2]: [PATCH 02/11][v2] async_tx: add support for asynchronous GF multiplication
Date: Fri, 19 Dec 2008 10:43:17 +0300
Message-ID: <714415337.20081219104317@emcraft.com>
References: <200812090055.42334.yur@emcraft.com> <e9c3a7c20812171034l7403c788y9fd1e7ce217cb41b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20812171034l7403c788y9fd1e7ce217cb41b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

Hello Dan,

On Wednesday, December 17, 2008 you wrote:

 [..]

>> +       /* DMAs use destinations as sources, so use BIDIRECTIONAL mapping */
>> +       dma_dest[0] = !blocks[src_cnt] ? 0 :
>> +                               dma_map_page(dma->dev, blocks[src_cnt],
>> +                                            offset, len, DMA_BIDIRECTIONAL);

> "0" could be a valid dma address on some architectures.
> DMA_ERROR_CODE looks like the closest fit for what we are trying to do
> here, but that only exists on sparc and powerpc.  We could add a
> "dest_mask" parameter to device_prep_dma_pq where the mask is  1 =
> p-only, 2 = q-only, and 3 = p and q.

 Understood. We can just introduce new DMA_xxx flags and pass them 
among the other ones passed with device_prep_dma_pq() to ADMA driver 
instead of introducing a new "dest_mask" parameter. Though, I guess, 
you meant exactly the same.

>> +       dma_dest[1] = !blocks[src_cnt+1] ? 0 :
>> +                               dma_map_page(dma->dev, blocks[src_cnt+1],
>> +                                            offset, len, DMA_BIDIRECTIONAL);
>> +
>> +       for (i = 0; i < src_cnt; i++)
>> +               dma_src[i] = dma_map_page(dma->dev, blocks[i],
>> +                                         offset, len, DMA_TO_DEVICE);
>> +
>> +       while (src_cnt) {
>> +               async_flags = flags;
>> +               pq_src_cnt = min(src_cnt, dma->max_pq);
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
>> +
>> +               /* Since we have clobbered the src_list we are committed
>> +                * to doing this asynchronously.  Drivers force forward
>> +                * progress in case they can not provide a descriptor
>> +                */
>> +               tx = dma->device_prep_dma_pq(chan, dma_dest,
>> +                                            &dma_src[src_off], pq_src_cnt,
>> +                                            scf_list ? &scf_list[src_off] :
>> +                                                       NULL,
>> +                                            len, dma_flags);

> ...one nit for readability can we replace these ternary conditionals
> with proper if-else statements?  i.e.

>                 if (scf_list)
>                         scf = &scf_list[src_off];
>                 else
>                         scf = NULL;
>                 tx = dma->device_prep_dma_pq(chan, dma_dest,
>                                              &dma_src[src_off], pq_src_cnt,
>                                              scf, len, dma_flags);

 Thanks for pointing this. Sure. Furthermore, it's additionally even a 
question of performance: e.g. in do_async_pq() we do this "? : " in a 
cycle, whereas there is absolutely no reason to think it changes.

 [..]

>> +/**
>> + * async_pq_zero_sum - attempt a PQ parities check with a dma engine.
>> + * @blocks: array of source pages. The 0..src_cnt-1 are the sources, the
>> + *     src_cnt and src_cnt+1 are the P and Q destinations to check, resp.
>> + *     Only one of two destinations may be present.
>> + *     NOTE: client code must assume the contents of this array are destroyed
>> + * @scf: coefficients to use in GF-multiplications
>> + * @offset: offset in pages to start transaction
>> + * @src_cnt: number of source pages
>> + * @len: length in bytes
>> + * @presult: where to store the result of P-ckeck, which is 0 if P-parity
>> + *     OK, and non-zero otherwise.
>> + * @qresult: where to store the result of P-ckeck, which is 0 if Q-parity
>> + *     OK, and non-zero otherwise.
>> + * @flags: ASYNC_TX_ASSUME_COHERENT, ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
>> + * @depend_tx: depends on the result of this transaction.
>> + * @cb_fn: function to call when the xor completes
>> + * @cb_param: parameter to pass to the callback routine
>> + */
>> +struct dma_async_tx_descriptor *
>> +async_pq_zero_sum(struct page **blocks, unsigned char *scf,
>> +       unsigned int offset, int src_cnt, size_t len,
>> +       u32 *presult, u32 *qresult, enum async_tx_flags flags,
>> +       struct dma_async_tx_descriptor *depend_tx,
>> +       dma_async_tx_callback cb_fn, void *cb_param)
>> +{
>> +       struct dma_chan *chan = async_tx_find_channel(depend_tx,
>> +                                                     DMA_PQ_ZERO_SUM,
>> +                                                     &blocks[src_cnt], 2,
>> +                                                     blocks, src_cnt, len);
>> +       struct dma_device *device = chan ? chan->device : NULL;
>> +       struct dma_async_tx_descriptor *tx = NULL;
>> +
>> +       BUG_ON(src_cnt < 2);
>> +
>> +       if (device && src_cnt <= device->max_pq) {
>> +               dma_addr_t dma_src[src_cnt + 2];
>> +               enum dma_ctrl_flags dma_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
>> +               int i;
>> +
>> +               for (i = 0; i < src_cnt + 2; i++)
>> +                       dma_src[i] = blocks[i] ? dma_map_page(device->dev,
>> +                                       blocks[i], offset, len,
>> +                                       DMA_TO_DEVICE) : 0;

> If we go with the "dest_mask" approach to specifying p and q then we
> need to separate them into their own parameter here... although in
> this case it would be a "src_mask" to select p or q.

 We shouldn't do this if enhance 'enum dma_ctrl_flags' with, say, 
DMA_PREP_P_PRESENT, DMA_PREP_Q_PRESENT. The adma driver which support 
device_prep_dma_pqzero_sum() then should use/or not first dma_src 
(which are destinations) depending on dma_flags set.

 [..]

>> diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
>> index 0f50d4c..5d6b639 100644
>> --- a/include/linux/async_tx.h
>> +++ b/include/linux/async_tx.h
>> @@ -42,6 +42,12 @@ struct dma_chan_ref {
>>  * @ASYNC_TX_XOR_ZERO_DST: this flag must be used for xor operations where the
>>  * the destination address is not a source.  The asynchronous case handles this
>>  * implicitly, the synchronous case needs to zero the destination block.
>> + * @ASYNC_TX_PQ_ZERO_P: this flag must be used for async_pq operations since the
>> + * destination there is always the source (the result of P after async_pq is
>> + * xor-ed with the previous content of P block if this flag isn't set).
>> + * @ASYNC_TX_PQ_ZERO_Q: this flag must be used for async_pq operations since the
>> + * destination there is always the source (the result of Q after async_pq is
>> + * xor-ed with the previous content of Q block if this flag isn't set).
>>  * @ASYNC_TX_XOR_DROP_DST: this flag must be used if the destination address is
>>  * also one of the source addresses.  In the synchronous case the destination
>>  * address is an implied source, whereas the asynchronous case it must be listed
>> @@ -50,12 +56,17 @@ struct dma_chan_ref {
>>  * @ASYNC_TX_ACK: immediately ack the descriptor, precludes setting up a
>>  * dependency chain
>>  * @ASYNC_TX_DEP_ACK: ack the dependency descriptor.  Useful for chaining.
>> + * @ASYNC_TX_ASYNC_ONLY: if set then try to perform operation requested only in
>> + * the asynchronous mode.
>>  */
>>  enum async_tx_flags {
>>        ASYNC_TX_XOR_ZERO_DST    = (1 << 0),
>> -       ASYNC_TX_XOR_DROP_DST    = (1 << 1),
>> -       ASYNC_TX_ACK             = (1 << 3),
>> -       ASYNC_TX_DEP_ACK         = (1 << 4),
>> +       ASYNC_TX_PQ_ZERO_P       = (1 << 1),
>> +       ASYNC_TX_PQ_ZERO_Q       = (1 << 2),
>> +       ASYNC_TX_XOR_DROP_DST    = (1 << 3),
>> +       ASYNC_TX_ACK             = (1 << 4),
>> +       ASYNC_TX_DEP_ACK         = (1 << 5),
>> +       ASYNC_TX_ASYNC_ONLY      = (1 << 6),
>>  };
>>
>>  #ifdef CONFIG_DMA_ENGINE
>> @@ -146,5 +157,33 @@ async_trigger_callback(enum async_tx_flags flags,
>>        struct dma_async_tx_descriptor *depend_tx,
>>        dma_async_tx_callback cb_fn, void *cb_fn_param);
>>
>> +struct dma_async_tx_descriptor *
>> +async_pqxor(struct page *pdest, struct page *qdest,
>> +       struct page **src_list, unsigned char *scoef_list,
>> +       unsigned int offset, int src_cnt, size_t len, enum async_tx_flags flags,
>> +       struct dma_async_tx_descriptor *depend_tx,
>> +       dma_async_tx_callback callback, void *callback_param);
>> +

> ...forgot to update the declartion.

 Argh.. Missed this when re-generated my final internal patch version.

> In this case async_pq() can be declared static since nothing outside
> of async_pq.c calls it.

 It's not true. async_r6_dd_recov() and async_r6_dp_recov() functions 
actively utilize async_pq(). See crypto/async_tx/async_r6recov.c.

 [..]

>>  void async_tx_quiesce(struct dma_async_tx_descriptor **tx);
>>  #endif /* _ASYNC_TX_H_ */
>> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
>> index adb0b08..84525c3 100644
>> --- a/include/linux/dmaengine.h
>> +++ b/include/linux/dmaengine.h
>> @@ -81,7 +81,7 @@ enum dma_status {
>>  enum dma_transaction_type {
>>        DMA_MEMCPY,
>>        DMA_XOR,
>> -       DMA_PQ_XOR,
>> +       DMA_PQ,
>>        DMA_DUAL_XOR,
>>        DMA_PQ_UPDATE,
>>        DMA_ZERO_SUM,
>> @@ -123,6 +123,8 @@ enum dma_ctrl_flags {
>>        DMA_CTRL_ACK = (1 << 1),
>>        DMA_COMPL_SKIP_SRC_UNMAP = (1 << 2),
>>        DMA_COMPL_SKIP_DEST_UNMAP = (1 << 3),
>> +       DMA_PREP_ZERO_P = (1 << 4),
>> +       DMA_PREP_ZERO_Q = (1 << 5),
>>  };

> I would rather not add operation-type-specific flags to
> dma_ctrl_flags.

 But we need somehow:

1) point the ADMA driver should it clear the destination or not;
2) if (1), then what destination(s) to clear.

 Above I even propose to add two more flags here :) Are there any 
reasons why we should spare dma_ctrl_flags, and, instead of adding a 
couple of new flag bits which are even do not lead to the sizeof(enum) 
growth, increase the stack usage and, in general, the time of 
functions calls by adding new parameters to ADMA methods ?

>   In this case can we set up a dependency chain with
> async_memset()?

 Well, we can. But wouldn't this be an overhead? For example, 
ppc440spe DMA allows to do so-called RXOR which overwrites, and 
doesn't take care of destinations. So, we can do ZERO_DST(s)+PQ in one 
short on one DMA engine. Again, I'm not sure that keeping 
dma_ctrl_flags unchanged is worthy of creating such a dependency; 
it'll obviously lead both to degradation of performance & increasing 
of CPU utilization.

>>
>>  /**
>> @@ -299,6 +301,7 @@ struct dma_async_tx_descriptor {
>>  * @global_node: list_head for global dma_device_list
>>  * @cap_mask: one or more dma_capability flags
>>  * @max_xor: maximum number of xor sources, 0 if no capability
>> + * @max_pq: maximum number of PQ sources, 0 if no capability
>>  * @refcount: reference count
>>  * @done: IO completion struct
>>  * @dev_id: unique device ID
>> @@ -308,7 +311,9 @@ struct dma_async_tx_descriptor {
>>  * @device_free_chan_resources: release DMA channel's resources
>>  * @device_prep_dma_memcpy: prepares a memcpy operation
>>  * @device_prep_dma_xor: prepares a xor operation
>> + * @device_prep_dma_pq: prepares a pq operation
>>  * @device_prep_dma_zero_sum: prepares a zero_sum operation
>> + * @device_prep_dma_pqzero_sum: prepares a pqzero_sum operation
>>  * @device_prep_dma_memset: prepares a memset operation
>>  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
>>  * @device_prep_slave_sg: prepares a slave dma operation
>> @@ -322,6 +327,7 @@ struct dma_device {
>>        struct list_head global_node;
>>        dma_cap_mask_t  cap_mask;
>>        int max_xor;
>> +       int max_pq;
>>

> max_xor and max_pq can be changed to unsigned shorts to keep the size
> of the struct the same.

 Right.

>>        struct kref refcount;
>>        struct completion done;
>> @@ -339,9 +345,17 @@ struct dma_device {
>>        struct dma_async_tx_descriptor *(*device_prep_dma_xor)(
>>                struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
>>                unsigned int src_cnt, size_t len, unsigned long flags);
>> +       struct dma_async_tx_descriptor *(*device_prep_dma_pq)(
>> +               struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
>> +               unsigned int src_cnt, unsigned char *scf,
>> +               size_t len, unsigned long flags);
>>        struct dma_async_tx_descriptor *(*device_prep_dma_zero_sum)(
>>                struct dma_chan *chan, dma_addr_t *src, unsigned int src_cnt,
>>                size_t len, u32 *result, unsigned long flags);
>> +       struct dma_async_tx_descriptor *(*device_prep_dma_pqzero_sum)(
>> +               struct dma_chan *chan, dma_addr_t *src, unsigned int src_cnt,
>> +               unsigned char *scf,
>> +               size_t len, u32 *presult, u32 *qresult, unsigned long flags);

> I would rather we turn the 'result' parameter into a pointer to flags
> where bit 0 is the xor/p result and bit1 is the q result.

 Yes, this'll be better.


 Thanks for reviewing. I'll re-generate ASYNC_TX patch (in the parts 
where I absolutely agreed with you), and then re-post. Any comments 
regarding RAID-6 part?

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

