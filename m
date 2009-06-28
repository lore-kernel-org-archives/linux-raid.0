From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: async_xor() has some issue
Date: Sun, 28 Jun 2009 08:54:21 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07A31D52@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Looks like there is bug in the do_async_xor() function where" dma_addr_t
*dma_src = (dma_addr_t *) src_list;" causing corrupting source
addresses.  And dma_src is being modified in the for loop. This should
be something like dma_addr_t dma_src[src_cnt].
 
/* do_async_xor - dma map the pages and perform the xor with an engine
*/
static __async_inline struct dma_async_tx_descriptor *
do_async_xor(struct dma_chan *chan, struct page *dest, struct page
**src_list,
             unsigned int offset, int src_cnt, size_t len,
             enum async_tx_flags flags,
             struct dma_async_tx_descriptor *depend_tx,
             dma_async_tx_callback cb_fn, void *cb_param)
{
        struct dma_device *dma = chan->device;
        >>>>dma_addr_t *dma_src = (dma_addr_t *) src_list;
        struct dma_async_tx_descriptor *tx = NULL;
        int src_off = 0;
        int i;
        dma_async_tx_callback _cb_fn;
        void *_cb_param;
        enum async_tx_flags async_flags;
        enum dma_ctrl_flags dma_flags;
        int xor_src_cnt;
        dma_addr_t dma_dest;
        /* map the dest bidrectional in case it is re-used as a source
*/
        dma_dest = dma_map_page(dma->dev, dest, offset, len,
DMA_BIDIRECTIONAL);
        printk("dest=0x%x\n",dest);
        for (i = 0; i < src_cnt; i++) {
                /* only map the dest once */
                if (unlikely(src_list[i] == dest)) {
                        dma_src[i] = dma_dest;
                        continue;
                }
                printk("src_list[%d]=0x%x\n",i,src_list[i]);
                dma_src[i] = dma_map_page(dma->dev, src_list[i], offset,
                                          len, DMA_TO_DEVICE);
        }
