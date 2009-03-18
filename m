From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 00/13] Asynchronous raid6 acceleration (part 1 of 2)
Date: Wed, 18 Mar 2009 12:20:16 -0700
Message-ID: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

This series constitutes the pieces of the raid6 acceleration work that are
aimed at the next merge window.  It implements:
1/ An api for asynchronous raid6 parity generation and recovery routines
2/ Extensions to the dmaengine framework and dmatest
3/ RAID6 support for iop13xx
4/ Removal of the BUILD_BUG_ON in async_xor to support platforms with
   sizeof(dma_addr_t) > sizeof(void *).  This increases the stack
   utilization in the asynchronous path.

This series is available via git at:

	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git raid6

...it is based on git://neil.brown.name/md md-scratch

Part 2, which needs more testing, is the conversion of md/raid6.  It is
available at:

	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git raid6-for-neil

---

Dan Williams (12):
      dmatest: add pq support
      dmatest: add dma interrupts and callbacks
      dmatest: add xor test
      dmaengine: allow dma support for async_tx to be toggled
      iop-adma: P+Q self test
      iop-adma: P+Q support for iop13xx adma engines
      async_tx: add support for asynchronous RAID6 recovery operations
      async_tx: add support for asynchronous GF multiplication
      async_tx: add sum check flags
      async_tx: kill needless module_{init|exit}
      async_tx: provide __async_inline for HAS_DMA=n archs
      md/raid6: move raid6 data processing to raid6_pq.ko

Yuri Tikhonov (1):
      async_tx: don't use src_list argument of async_xor() for dma addresses

 arch/arm/include/asm/hardware/iop3xx-adma.h   |   68 +++-
 arch/arm/include/asm/hardware/iop_adma.h      |    1 +
 arch/arm/mach-iop13xx/include/mach/adma.h     |  107 +++++-
 arch/arm/mach-iop13xx/setup.c                 |    2 +-
 crypto/async_tx/Kconfig                       |    9 +
 crypto/async_tx/Makefile                      |    2 +
 crypto/async_tx/async_memcpy.c                |   13 -
 crypto/async_tx/async_memset.c                |   13 -
 crypto/async_tx/async_pq.c                    |  590 +++++++++++++++++++++++++
 crypto/async_tx/async_r6recov.c               |  272 ++++++++++++
 crypto/async_tx/async_tx.c                    |   23 +-
 crypto/async_tx/async_xor.c                   |   40 +--
 drivers/dma/Kconfig                           |   11 +
 drivers/dma/dmatest.c                         |  333 ++++++++++----
 drivers/dma/iop-adma.c                        |  285 ++++++++++++-
 drivers/md/Kconfig                            |    4 +
 drivers/md/Makefile                           |    4 +-
 drivers/md/mktables.c                         |   14 +-
 drivers/md/raid5.c                            |   14 +-
 drivers/md/raid5.h                            |    7 +-
 drivers/md/raid6algos.c                       |   21 +-
 drivers/md/raid6altivec.uc                    |    2 +-
 drivers/md/raid6int.uc                        |    2 +-
 drivers/md/raid6mmx.c                         |    2 +-
 drivers/md/raid6recov.c                       |    8 +-
 drivers/md/raid6sse1.c                        |    2 +-
 drivers/md/raid6sse2.c                        |    2 +-
 drivers/md/raid6test/Makefile                 |    2 +-
 drivers/md/raid6test/test.c                   |    2 +-
 include/linux/async_tx.h                      |   56 +++-
 include/linux/dmaengine.h                     |   97 ++++-
 drivers/md/raid6.h => include/linux/raid/pq.h |    3 -
 32 files changed, 1792 insertions(+), 219 deletions(-)
 create mode 100644 crypto/async_tx/async_pq.c
 create mode 100644 crypto/async_tx/async_r6recov.c
 rename drivers/md/raid6.h => include/linux/raid/pq.h (97%)

