From: Yuri Tikhonov <yur@emcraft.com>
Subject: async_tx: get best channel
Date: Fri, 19 Oct 2007 16:23:34 +0400
Message-ID: <200710191623.34381.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hello Dan,

 I have a suggestion regarding the async_tx_find_channel() procedure.

 First, a little introduction. Some processors (e.g. ppc440spe) have several DMA
engines (say DMA1 and DMA2) which are capable of performing the same type of 
operation, say XOR. The DMA2 engine may process the XOR operation faster than
the DMA1 engine, but DMA2 (which is faster) has some restrictions for the source
operand addresses, whereas there are no such restrictions for DMA1 (which is slower).
So the question is, how may ASYNC_TX select the DMA engine which will be the
most effective for the given tx operation ?

 In the example just described this means: if the faster engine, DMA2, may process
the tx operation with the given source operand addresses, then we select DMA2;
if the given source operand addresses cannot be processed with DMA2, then we
select the slower engine, DMA1.

 I see the following way for introducing such functionality.

 We may introduce an additional method in struct dma_device (let's call it device_estimate())
which would take the following as the arguments:
--- the list of sources to be processed during the given tx,
--- the type of operation (XOR, COPY, ...), 
--- perhaps something else, 
 and then estimate the effectiveness of processing this tx on the given channel.
 The async_tx_find_channel() function should call the device_estimate() method for each
registered dma channel and then select the most effective one.
 The architecture specific ADMA driver will be responsible for returning the greatest
value from the device_estimate() method for the channel which will be the most effective
for this given tx.

 What are your thoughts regarding this? Do you see any other effective ways for
enhancing ASYNC_TX with such functionality?

 Regards, Yuri

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
