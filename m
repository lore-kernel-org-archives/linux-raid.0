From: Dan Williams <dan.j.williams@intel.com>
Subject: dmaengine 3.13 v2
Date: Fri, 15 Nov 2013 10:33:38 -0800
Message-ID: <CAPcyv4iQQutRipP+XQGPAxfQVj9C_K9SEjGF_Rd1=ZkgTZnjow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Jon Mason <jon.mason@intel.com>, Linus Walleij <linus.walleij@linaro.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Vinod,

Here is the pull request for 3.13 fixed up to address the breakage in
the ntb driver.

Thanks to Bart for getting the cleanup started.  dmaengine has quite a
few more clean up opportunities.  The next items I'm targeting are the
removal of NET_DMA and integrating async_tx directly into md/raid so
that we can 1/ finally stop overlapping dma mappings 2/ remove
operation chaining support from drivers (kill DMA_CTRL_ACK ).

For comparison I placed a test merge of your tree and mine at
dmaengine.git/test [1].

Please pull, thanks Vinod!

--
Dan

The following changes since commit 31d141e3a666269a3b6fcccddb0351caf7454240:

  Linux 3.12-rc6 (2013-10-19 12:28:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine
tags/dmaengine-3.13-v2

for you to fetch changes up to 82a1402eaee5dab1f3ab2d5aa4c316451374c5af:

  dma: mv_xor: Fix mis-usage of mmio 'base' and 'high_base' registers
(2013-11-14 11:04:42 -0800)

----------------------------------------------------------------
dmaengine-3.13

1/ Bartlomiej and Dan finalized a rework of the dma address unmap
   implementation.

2/ In the course of testing 1/ a collection of enhancements to dmatest
   fell out.  Notably basic performance statistics, and fixed / enhanced
   test control through new module parameters 'run', 'wait', 'noverify',
   and 'verbose'.  Thanks to Andriy and Linus for their review.

3/ Testing the raid related corner cases of 1/ triggered bugs in the
   recently added 16-source operation support in the ioatdma driver.

4/ Some minor fixes / cleanups to mv_xor and ioatdma.

----------------------------------------------------------------
Bartlomiej Zolnierkiewicz (4):
      dmatest: make driver unmap also source buffers by itself
      NTB: convert to dmaengine_unmap_data
      dmaengine: remove DMA unmap from drivers
      dmaengine: remove DMA unmap flags

Dan Williams (26):
      dmaengine: consolidate memcpy apis
      dmaengine: prepare for generic 'unmap' data
      dmaengine: reference counted unmap data
      async_memcpy: convert to dmaengine_unmap_data
      async_xor: convert to dmaengine_unmap_data
      async_xor_val: convert to dmaengine_unmap_data
      async_raid6_recov: convert to dmaengine_unmap_data
      async_pq: convert to dmaengine_unmap_data
      async_pq_val: convert to dmaengine_unmap_data
      Revert "dmatest: append verify result to results"
      dmatest: replace stored results mechanism, with uniform messages
      dmatest: cleanup redundant "dmatest: " prefixes
      dmatest: restore ability to start test at module load and init
      dmatest: support xor-only, or pq-only channels in tests
      dmatest: use pseudo random numbers
      dmatest: add support for skipping verification and random data setup
      dmatest: add basic performance metrics
      dmatest: add a 'wait' parameter
      dmatest: convert to dmaengine_unmap_data
      dmatest: verbose mode
      ioatdma: fix sed pool selection
      ioatdma: fix selection of 16 vs 8 source path
      ioatdma: clean up sed pool kmem_cache
      raid6test: add new corner case for ioatdma driver
      ioat: kill msix_single_vector support
      ioat: fix ioat3_irq_reinit

Dave Jiang (1):
      ioatdma: Fix bug in selftest after removal of DMA_MEMSET.

Ezequiel Garcia (2):
      dma: mv_xor: Remove unneeded NULL address check
      dma: mv_xor: Fix mis-usage of mmio 'base' and 'high_base' registers

 Documentation/dmatest.txt                   |  72 ++-
 arch/arm/include/asm/hardware/iop3xx-adma.h |  30 -
 arch/arm/include/asm/hardware/iop_adma.h    |   4 -
 arch/arm/mach-iop13xx/include/mach/adma.h   |  26 -
 crypto/async_tx/async_memcpy.c              |  37 +-
 crypto/async_tx/async_pq.c                  | 174 +++---
 crypto/async_tx/async_raid6_recov.c         |  61 +-
 crypto/async_tx/async_xor.c                 | 123 ++--
 crypto/async_tx/raid6test.c                 |  10 +-
 drivers/ata/pata_arasan_cf.c                |   3 +-
 drivers/dma/amba-pl08x.c                    |  32 +-
 drivers/dma/at_hdmac.c                      |  26 +-
 drivers/dma/dmaengine.c                     | 262 +++++---
 drivers/dma/dmatest.c                       | 915 +++++++++++-----------------
 drivers/dma/dw/core.c                       |  25 +-
 drivers/dma/ep93xx_dma.c                    |  30 +-
 drivers/dma/fsldma.c                        |  17 +-
 drivers/dma/ioat/dma.c                      |  49 +-
 drivers/dma/ioat/dma.h                      |  14 -
 drivers/dma/ioat/dma_v2.c                   |   2 +-
 drivers/dma/ioat/dma_v2.h                   |   1 -
 drivers/dma/ioat/dma_v3.c                   | 315 ++--------
 drivers/dma/ioat/pci.c                      |  20 +-
 drivers/dma/iop-adma.c                      |  97 +--
 drivers/dma/mv_xor.c                        |  52 +-
 drivers/dma/mv_xor.h                        |  25 +-
 drivers/dma/pl330.c                         |   2 +
 drivers/dma/ppc4xx/adma.c                   | 270 +-------
 drivers/dma/timb_dma.c                      |  37 +-
 drivers/dma/txx9dmac.c                      |  25 +-
 drivers/media/platform/m2m-deinterlace.c    |   3 +-
 drivers/media/platform/timblogiw.c          |   2 +-
 drivers/misc/carma/carma-fpga.c             |   3 +-
 drivers/mtd/nand/atmel_nand.c               |   3 +-
 drivers/mtd/nand/fsmc_nand.c                |   2 -
 drivers/net/ethernet/micrel/ks8842.c        |   6 +-
 drivers/ntb/ntb_transport.c                 |  86 ++-
 drivers/spi/spi-dw-mid.c                    |   4 +-
 include/linux/dmaengine.h                   |  64 +-
 39 files changed, 1018 insertions(+), 1911 deletions(-)

[1]: git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine test
