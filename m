From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH 02/11] async_tx: add support for asynchronous GF multiplication
Date: Fri, 14 Nov 2008 18:28:08 -0700
Message-ID: <e9c3a7c20811141728m3fee8a00jb1be0f36fb852fdd@mail.gmail.com>
References: <1226589364-5619-1-git-send-email-yanok@emcraft.com>
	 <1226589364-5619-3-git-send-email-yanok@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1226589364-5619-3-git-send-email-yanok@emcraft.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ilya Yanok <yanok@emcraft.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, yur@emcraft.com, wd@denx.de, dzu@denx.de
List-Id: linux-raid.ids

On Thu, Nov 13, 2008 at 8:15 AM, Ilya Yanok <yanok@emcraft.com> wrote:
> This adds support for doing asynchronous GF multiplication by adding
> four additional functions to async_tx API:
>  async_pqxor() does simultaneous XOR of sources and XOR of sources
> GF-multiplied by given coefficients.
>  async_pqxor_zero_sum() checks if results of calculations match given
> ones.
>  async_gen_syndrome() does sumultaneous XOR and R/S syndrome of sources.
>  async_syndrome_zerosum() checks if results of XOR/syndrome calculation
> matches given ones.
>
> Latter two functions just use pqxor with approprite coefficients in
> asynchronous case but have significant optimizations if synchronous
> case.
>
> To support this API dmaengine driver should set DMA_PQ_XOR and
> DMA_PQ_ZERO_SUM capabilities and provide device_prep_dma_pqxor and
> device_prep_dma_pqzero_sum methods in dma_device structure.
>
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
> Signed-off-by: Ilya Yanok <yanok@emcraft.com>
> ---

A few comments
1/ I don't see code for handling cases where the src_cnt exceeds the
hardware maximum.
2/ dmaengine.h defines DMA_PQ_XOR but these patches should really
change that to DMA_PQ and do s/pqxor/pq/ across the rest of the code
base.
3/ In my implementation (unfinished) of async_pq I decided to make the
prototype:

+/**
+ * async_pq - attempt to generate p (xor) and q (Reed-Solomon code) with a
+ *     dma engine for a given set of blocks.  This routine assumes a field of
+ *     GF(2^8) with a primitive polynomial of 0x11d and a generator of {02}.
+ *     In the synchronous case the p and q blocks are used as temporary
+ *     storage whereas dma engines have their own internal buffers.  The
+ *     ASYNC_TX_PQ_ZERO_P and ASYNC_TX_PQ_ZERO_Q flags clear the
+ *     destination(s) before they are used.
+ * @blocks: source block array ordered from 0..src_cnt with the p destination
+ *     at blocks[src_cnt] and q at blocks[src_cnt + 1]
+ *     NOTE: client code must assume the contents of this array are destroyed
+ * @offset: offset in pages to start transaction
+ * @src_cnt: number of source pages: 2 < src_cnt <= 255
+ * @len: length in bytes
+ * @flags: ASYNC_TX_ACK, ASYNC_TX_DEP_ACK
+ * @depend_tx: p+q operation depends on the result of this transaction.
+ * @cb_fn: function to call when p+q generation completes
+ * @cb_param: parameter to pass to the callback routine
+ */
+struct dma_async_tx_descriptor *
+async_pq(struct page **blocks, unsigned int offset, int src_cnt, size_t len,
+        enum async_tx_flags flags, struct dma_async_tx_descriptor *depend_tx,
+        dma_async_tx_callback cb_fn, void *cb_param)

Where p and q are not specified separately.  This matches more closely
how the current gen_syndrome is specified with the goal of not
requiring any changes to existing software raid6 interface.

Thoughts?

--
Dan
