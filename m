From: Dan Williams <dan.j.williams@intel.com>
Subject: What's in async_tx.git/next for 2.6.32?
Date: Sat, 05 Sep 2009 12:22:43 -0700
Message-ID: <4AA2BA83.5020707@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, linux-raid <linux-raid@vger.kernel.org>, "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
List-Id: linux-raid.ids

Provided Neil and Peter provide their acks for the raid6 acceleration 
work, here is what is pending in async_tx.git/next for 2.6.32:

1/ Ira's DMA_SLAVE support for the fsldma driver that just missed the 
2.6.31 window
2/ raid6 extensions to the async_tx api
3/ percpu conversion of the md-raid456 stripe processing resources 
(address buffers / raid6-spare-page)
4/ conversion of md-raid6 to the asynchronous raid6 api
5/ experimental support for offloading stripe processing to the async 
thread pool (multicore raid)
6/ raid offload support for the ioatdma driver (v3.2 of Intel(R) 
QuickData Technology)

    git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

Atsushi Nemoto (1):
       dmaengine: Move all map_sg/unmap_sg for slave channel to its client

Dan Williams (67):
       async_tx: rename zero_sum to val
       async_tx: kill ASYNC_TX_DEP_ACK flag
       async_tx: structify submission arguments, add scribble
       async_xor: permit callers to pass in a 'dma/page scribble' region
       md/raid6: release spare page at ->stop()
       ioat: move to drivers/dma/ioat/
       ioat: move definitions to dma.h
       ioat: convert ioat_probe to pcim/devm
       ioat: cleanup some long deref chains and 80 column collisions
       ioat: kill function prototype ifdef guards
       ioat: split ioat_dma_probe into core/version-specific routines
       ioat: fix type mismatch for ->dmacount
       ioat: define descriptor control bit-field
       ioat1: move descriptor allocation from submit to prep
       md/raid6: move the spare page to a percpu allocation
       md/raid5,6: add percpu scribble region for buffer lists
       async_tx: add sum check flags
       async_tx: kill needless module_{init|exit}
       async_tx: remove walk of tx->parent chain in dma_wait_for_async_tx
       async_tx: add support for asynchronous GF multiplication
       async_tx: add support for asynchronous RAID6 recovery operations
       dmatest: add pq support
       async_tx: raid6 recovery self test
       iop-adma: cleanup iop_adma_run_tx_complete_actions
       iop-adma: fix lockdep false positive
       iop-adma: P+Q support for iop13xx adma engines
       iop-adma: P+Q self test
       md/raid5: factor out mark_uptodate from ops_complete_compute5
       md/raid6: asynchronous raid6 operations
       md/raid6: asynchronous handle_parity_check6
       md/raid456: distribute raid processing over multiple cores
       ioat: fix self test interrupts
       ioat: prepare the code for ioat[12]_dma_chan split
       ioat2,3: convert to a true ring buffer
       ioat1: kill unused unmap parameters
       ioat: add some dev_dbg() calls
       ioat: cleanup completion status reads
       ioat: ignore reserved bits for chancnt and xfercap
       ioat: preserve chanctrl bits when re-arming interrupts
       ioat: ___devinit annotate the initialization paths
       ioat1: trim ioat_dma_desc_sw
       ioat: switch watchdog and reset handler from workqueue to timer
       ioat2,3: dynamically resize descriptor ring
       net_dma: poll for a descriptor after allocation failure
       dw_dmac: implement a private tx_list
       fsldma: implement a private tx_list
       iop-adma: implement a private tx_list
       ioat: implement a private tx_list
       mv_xor: implement a private tx_list
       at_hdmac: implement a private tx_list
       dmaengine: kill tx_list
       ioat2,3: cacheline align software descriptor allocations
       dmaengine: add fence support
       dmaengine, async_tx: add a "no channel switch" allocator
       dmaengine: cleanup unused transaction types
       dmaengine, async_tx: support alignment checks
       ioat2+: add fence support
       ioat3: hardware version 3.2 register / descriptor definitions
       ioat3: split ioat3 support to its own file, add memset
       ioat: add 'ioat' sysfs attributes
       ioat3: enable dca for completion writes
       ioat3: xor support
       ioat3: xor self test
       ioat3: pq support
       ioat3: support xor via pq descriptors
       ioat3: interrupt descriptor support
       ioat3: segregate raid engines

Ira Snyder (2):
       fsldma: split apart external pause and request count features
       fsldma: Add DMA_SLAVE support

Roland Dreier (2):
       Add MODULE_DEVICE_TABLE() so ioatdma module is autoloaded
       I/OAT: Convert to PCI_VDEVICE()

Tom Picard (1):
       ioat3: ioat3.2 pci ids for Jasper Forest

Yuri Tikhonov (5):
       md/raid5,6: common schedule_reconstruction for raid5/6
       md/raid6: asynchronous handle_stripe_fill6
       md/raid6: asynchronous handle_stripe_dirtying6
       md/raid6: asynchronous handle_stripe6
       md/raid6: remove synchronous infrastructure
