From: Dan Williams <dan.j.williams@intel.com>
Subject: [git pull] dmaengine, async_tx, and raid6 for 2.6.32
Date: Thu, 17 Sep 2009 10:25:27 -0700
Message-ID: <1253208327.25626.36.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754808AbZIQRZ1@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Maciej Sosnowski <maciej.sosnowski@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

Hi Neil, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

...to receive:

1/ Async_tx extensions for raid6 including syndrome generation and
recovery.  A test suite module, raid6test based on hpa's userspace test,
has been added to unit test the recovery code.

2/ md/raid6 conversion to the new async routines.  This includes a
percpu conversion of stripe cache operations.

3/ An experimental multicore option for raid processing.  This is a
trivial (i.e. easily revertible) extension on top of the percpu
conversion.  It is marked experimental as it currently appears to
oversubscribe the cpus, but still shows some modest gains to throughput
(+4% seq write for 16-way SATA raid6).

4/ A new dma driver for SuperH platforms (shdma)

5/ Support for version 3.2 Intel(R) QuickData Technology devices which
adds raid5/6 offload support to the ioatdma driver.  This work also
includes a re-factoring of the driver [1].

6/ The fsldma driver picks up "slave" support.

7/ Various dmaengine fix ups

The bulk of this has been in linux-next for at least a week.  Patches to
address feedback from you and Maciej are copied below.  I chose to
append these rather than rebase to preserve the commit numbers as seen
by linux-next.

Thanks,
Dan

Atsushi Nemoto (1):
      dmaengine: Move all map_sg/unmap_sg for slave channel to its client

Dan Williams (81):
      Merge branch 'dmaengine' into async-tx-raid6
      async_tx: rename zero_sum to val
      async_tx: kill ASYNC_TX_DEP_ACK flag
      async_tx: structify submission arguments, add scribble
      async_xor: permit callers to pass in a 'dma/page scribble' region
      md/raid6: release spare page at ->stop()
      ioat: move to drivers/dma/ioat/
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
      Merge commit 'v2.6.31-rc1' into dmaengine
      ioat: move definitions to dma.h
      ioat: convert ioat_probe to pcim/devm
      ioat: cleanup some long deref chains and 80 column collisions
      ioat: kill function prototype ifdef guards
      ioat: split ioat_dma_probe into core/version-specific routines
      ioat: fix type mismatch for ->dmacount
      ioat: define descriptor control bit-field
      ioat1: move descriptor allocation from submit to prep
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
      Merge branch 'md-raid6-accel' into ioat3.2
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
      Merge branch 'ioat' into dmaengine
      dw_dmac: implement a private tx_list
      fsldma: implement a private tx_list
      iop-adma: implement a private tx_list
      ioat: implement a private tx_list
      mv_xor: implement a private tx_list
      at_hdmac: implement a private tx_list
      txx9dmac: implement a private tx_list
      dmaengine: kill tx_list
      ioat2,3: cacheline align software descriptor allocations
      Merge branch 'iop-raid6' into async-tx-next
      Merge branch 'dmaengine' into async-tx-next
      Merge commit 'md/for-linus' into async-tx-next
      async_tx: remove HIGHMEM64G restriction
      ioat: driver version 4.0
      md/raid6: eliminate BUG_ON with side effect
      md/raid6: cleanup ops_run_compute6_2
      ioat2: clarify ring size limits
      raid6test: fix stack overflow

Ira Snyder (2):
      fsldma: split apart external pause and request count features
      fsldma: Add DMA_SLAVE support

Maciej Sosnowski (1):
      dca: registering requesters in multiple dca domains

Nobuhiro Iwamatsu (1):
      dmaengine: sh: Add Support SuperH DMA Engine driver

Roland Dreier (2):
      Add MODULE_DEVICE_TABLE() so ioatdma module is autoloaded
      I/OAT: Convert to PCI_VDEVICE()

Stephen Hemminger (1):
      dca: module load should not be an error message

Tom Picard (1):
      ioat3: ioat3.2 pci ids for Jasper Forest

Yuri Tikhonov (5):
      md/raid5,6: common schedule_reconstruction for raid5/6
      md/raid6: asynchronous handle_stripe_fill6
      md/raid6: asynchronous handle_stripe_dirtying6
      md/raid6: asynchronous handle_stripe6
      md/raid6: remove synchronous infrastructure

 Documentation/crypto/async-tx-api.txt              |   75 +-
 arch/arm/include/asm/hardware/iop3xx-adma.h        |   81 +-
 arch/arm/include/asm/hardware/iop_adma.h           |    3 +
 arch/arm/mach-iop13xx/include/mach/adma.h          |  119 ++-
 arch/arm/mach-iop13xx/setup.c                      |   17 +-
 arch/arm/plat-iop/adma.c                           |    4 +-
 arch/powerpc/include/asm/fsldma.h                  |  136 ++
 arch/sh/drivers/dma/Kconfig                        |   12 +-
 arch/sh/drivers/dma/Makefile                       |    3 +-
 arch/sh/include/asm/dma-sh.h                       |   13 +
 crypto/async_tx/Kconfig                            |    9 +
 crypto/async_tx/Makefile                           |    3 +
 crypto/async_tx/async_memcpy.c                     |   44 +-
 crypto/async_tx/async_memset.c                     |   43 +-
 crypto/async_tx/async_pq.c                         |  395 +++++
 crypto/async_tx/async_raid6_recov.c                |  455 +++++
 crypto/async_tx/async_tx.c                         |   87 +-
 crypto/async_tx/async_xor.c                        |  207 ++--
 crypto/async_tx/raid6test.c                        |  240 +++
 drivers/dca/dca-core.c                             |  124 ++-
 drivers/dma/Kconfig                                |   14 +-
 drivers/dma/Makefile                               |    4 +-
 drivers/dma/at_hdmac.c                             |   60 +-
 drivers/dma/at_hdmac_regs.h                        |    1 +
 drivers/dma/dmaengine.c                            |   94 +-
 drivers/dma/dmatest.c                              |   40 +
 drivers/dma/dw_dmac.c                              |   50 +-
 drivers/dma/dw_dmac_regs.h                         |    1 +
 drivers/dma/fsldma.c                               |  288 +++-
 drivers/dma/fsldma.h                               |    4 +-
 drivers/dma/ioat.c                                 |  202 ---
 drivers/dma/ioat/Makefile                          |    2 +
 drivers/dma/{ioat_dca.c => ioat/dca.c}             |   13 +-
 drivers/dma/ioat/dma.c                             | 1238 ++++++++++++++
 drivers/dma/ioat/dma.h                             |  337 ++++
 drivers/dma/ioat/dma_v2.c                          |  870 ++++++++++
 drivers/dma/ioat/dma_v2.h                          |  190 +++
 drivers/dma/ioat/dma_v3.c                          | 1220 ++++++++++++++
 drivers/dma/ioat/hw.h                              |  215 +++
 drivers/dma/ioat/pci.c                             |  210 +++
 .../dma/{ioatdma_registers.h => ioat/registers.h}  |   54 +-
 drivers/dma/ioat_dma.c                             | 1741 --------------------
 drivers/dma/ioatdma.h                              |  165 --
 drivers/dma/ioatdma_hw.h                           |   70 -
 drivers/dma/iop-adma.c                             |  491 +++++-
 drivers/dma/iovlock.c                              |   10 +
 drivers/dma/mv_xor.c                               |    7 +-
 drivers/dma/mv_xor.h                               |    4 +-
 drivers/dma/shdma.c                                |  786 +++++++++
 drivers/dma/shdma.h                                |   64 +
 drivers/dma/txx9dmac.c                             |   24 +-
 drivers/dma/txx9dmac.h                             |    1 +
 drivers/idle/i7300_idle.c                          |   20 +-
 drivers/md/Kconfig                                 |   26 +
 drivers/md/raid5.c                                 | 1475 ++++++++++-------
 drivers/md/raid5.h                                 |   28 +-
 drivers/mmc/host/atmel-mci.c                       |    9 +-
 include/linux/async_tx.h                           |  129 ++-
 include/linux/dca.h                                |   11 +-
 include/linux/dmaengine.h                          |  179 ++-
 include/linux/pci_ids.h                            |   10 +
 61 files changed, 9119 insertions(+), 3308 deletions(-)
 create mode 100644 arch/powerpc/include/asm/fsldma.h
 create mode 100644 crypto/async_tx/async_pq.c
 create mode 100644 crypto/async_tx/async_raid6_recov.c
 create mode 100644 crypto/async_tx/raid6test.c
 delete mode 100644 drivers/dma/ioat.c
 create mode 100644 drivers/dma/ioat/Makefile
 rename drivers/dma/{ioat_dca.c => ioat/dca.c} (98%)
 create mode 100644 drivers/dma/ioat/dma.c
 create mode 100644 drivers/dma/ioat/dma.h
 create mode 100644 drivers/dma/ioat/dma_v2.c
 create mode 100644 drivers/dma/ioat/dma_v2.h
 create mode 100644 drivers/dma/ioat/dma_v3.c
 create mode 100644 drivers/dma/ioat/hw.h
 create mode 100644 drivers/dma/ioat/pci.c
 rename drivers/dma/{ioatdma_registers.h => ioat/registers.h} (84%)
 delete mode 100644 drivers/dma/ioat_dma.c
 delete mode 100644 drivers/dma/ioatdma.h
 delete mode 100644 drivers/dma/ioatdma_hw.h
 create mode 100644 drivers/dma/shdma.c
 create mode 100644 drivers/dma/shdma.h

Late arrivals:
commit 1b6df6930994d5d027375b07ac9da63644eb5758
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Sep 16 21:03:29 2009 -0700

    raid6test: fix stack overflow
    
    Testing on x86_64 with NDISKS=255 yields:
    
       do_IRQ: modprobe near stack overflow (cur:ffff88007d19c000,sp:ffff88007d19c128)
    
    ...and eventually
    
       general protection fault: 0000 [#1]
    
    Moving the scribble buffers off the stack allows the test to complete
    successfully.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
index 98c83ca..3ec27c7 100644
--- a/crypto/async_tx/raid6test.c
+++ b/crypto/async_tx/raid6test.c
@@ -28,6 +28,7 @@
 #define NDISKS 16 /* Including P and Q */
 
 static struct page *dataptrs[NDISKS];
+static addr_conv_t addr_conv[NDISKS];
 static struct page *data[NDISKS+3];
 static struct page *spare;
 static struct page *recovi;
@@ -69,7 +70,6 @@ static char disk_type(int d, int disks)
 static void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, struct page **ptrs)
 {
 	struct async_submit_ctl submit;
-	addr_conv_t addr_conv[disks];
 	struct completion cmp;
 	struct dma_async_tx_descriptor *tx = NULL;
 	enum sum_check_flags result = ~0;
@@ -156,7 +156,6 @@ static int test_disks(int i, int j, int disks)
 
 static int test(int disks, int *tests)
 {
-	addr_conv_t addr_conv[disks];
 	struct dma_async_tx_descriptor *tx;
 	struct async_submit_ctl submit;
 	struct completion cmp;

commit 376ec37667b510453f5a62fcd95d762786e6a0a9
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Sep 16 15:16:50 2009 -0700

    ioat2: clarify ring size limits
    
    With the addition of ioat_max_alloc_order it is not clear what the
    maximum allocation order is, so document that in the modinfo.  Also take
    an opportunity to kill a stray semicolon.
    
    Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 5d6ac49..8fd0b59 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -42,18 +42,19 @@
 int ioat_ring_alloc_order = 8;
 module_param(ioat_ring_alloc_order, int, 0644);
 MODULE_PARM_DESC(ioat_ring_alloc_order,
-		 "ioat2+: allocate 2^n descriptors per channel (default: n=8)");
+		 "ioat2+: allocate 2^n descriptors per channel"
+		 " (default: 8 max: 16)");
 static int ioat_ring_max_alloc_order = IOAT_MAX_ORDER;
 module_param(ioat_ring_max_alloc_order, int, 0644);
 MODULE_PARM_DESC(ioat_ring_max_alloc_order,
-		 "ioat2+: upper limit for dynamic ring resizing (default: n=16)");
+		 "ioat2+: upper limit for ring size (default: 16)");
 
 void __ioat2_issue_pending(struct ioat2_dma_chan *ioat)
 {
 	void * __iomem reg_base = ioat->base.reg_base;
 
 	ioat->pending = 0;
-	ioat->dmacount += ioat2_ring_pending(ioat);;
+	ioat->dmacount += ioat2_ring_pending(ioat);
 	ioat->issued = ioat->head;
 	/* make descriptor updates globally visible before notifying channel */
 	wmb();

commit 6c910a78e495b4c1778a8b136b37fe3c05712730
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Sep 16 12:24:54 2009 -0700

    md/raid6: cleanup ops_run_compute6_2
    
    Neil says:
    	"It is correct as it stands, but the fact that every branch in
    	 the 'if' part ends with a 'return' isn't immediately obvious,
    	 so it is clearer if we are explicit about the if / then / else
    	 structure."
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0a5f03d..1898eda 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -810,7 +810,7 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 	BUG_ON(!test_bit(R5_Wantcompute, &tgt2->flags));
 
-	/* we need to open-code set_syndrome_sources to handle to the
+	/* we need to open-code set_syndrome_sources to handle the
 	 * slot number conversion for 'faila' and 'failb'
 	 */
 	for (i = 0; i < disks ; i++)
@@ -879,18 +879,21 @@ ops_run_compute6_2(struct stripe_head *sh, struct raid5_percpu *percpu)
 			return async_gen_syndrome(blocks, 0, count+2,
 						  STRIPE_SIZE, &submit);
 		}
-	}
-
-	init_async_submit(&submit, ASYNC_TX_FENCE, NULL, ops_complete_compute,
-			  sh, to_addr_conv(sh, percpu));
-	if (failb == syndrome_disks) {
-		/* We're missing D+P. */
-		return async_raid6_datap_recov(syndrome_disks+2, STRIPE_SIZE,
-					       faila, blocks, &submit);
 	} else {
-		/* We're missing D+D. */
-		return async_raid6_2data_recov(syndrome_disks+2, STRIPE_SIZE,
-					       faila, failb, blocks, &submit);
+		init_async_submit(&submit, ASYNC_TX_FENCE, NULL,
+				  ops_complete_compute, sh,
+				  to_addr_conv(sh, percpu));
+		if (failb == syndrome_disks) {
+			/* We're missing D+P. */
+			return async_raid6_datap_recov(syndrome_disks+2,
+						       STRIPE_SIZE, faila,
+						       blocks, &submit);
+		} else {
+			/* We're missing D+D. */
+			return async_raid6_2data_recov(syndrome_disks+2,
+						       STRIPE_SIZE, faila, failb,
+						       blocks, &submit);
+		}
 	}
 }
 

commit 2d6e4ecc87d20299bcb249dd62efbd73496744c3
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Sep 16 12:11:54 2009 -0700

    md/raid6: eliminate BUG_ON with side effect
    
    As pointed out by Neil it should be possible to build a driver with all
    BUG_ON statements deleted.  It's bad form to have a BUG_ON with a side
    effect.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9b00a22..0a5f03d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3214,8 +3214,10 @@ static bool handle_stripe6(struct stripe_head *sh)
 		/* now count some things */
 		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
 		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
-		if (test_bit(R5_Wantcompute, &dev->flags))
-			BUG_ON(++s.compute > 2);
+		if (test_bit(R5_Wantcompute, &dev->flags)) {
+			s.compute++;
+			BUG_ON(s.compute > 2);
+		}
 
 		if (test_bit(R5_Wantfill, &dev->flags)) {
 			s.to_fill++;
