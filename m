From: Neil Brown <neilb@suse.de>
Subject: PULL REQUEST - md updates for 2.6.32, mostly raid6 offload
Date: Fri, 18 Sep 2009 15:41:32 +1000
Message-ID: <19123.7564.203923.745681@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
  please pull md and related updates as below.
  Most of this is support for offloading the RAID6 calculation onto
  dedicated hardware, hence the crypto/async_tx and drives/dma
  changes.  This makes RAID6 more consistent with RAID5 which already
  supports XOR offload.
  The only bit that is really from me is a couple of fixes for sparse
  warnings, one of which was really an error. (It is a pity spares in
  so noisy....)

Thanks,
NeilBrown


The following changes since commit 0cc6d77e55eca9557bbe41bf2db94b31aa8fcb2a:
  Linus Torvalds (1):
        Merge branch 'x86-setup-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

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

NeilBrown (3):
      md: remove sparse waring "symbol xxx shadows an earlier one"
      md: remove sparse warnings about lock context.
      Merge branch 'next' of git://git.kernel.org/.../djbw/async_tx into for-linus

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
 drivers/md/bitmap.c                                |    5 +-
 drivers/md/md.c                                    |   10 +-
 drivers/md/raid0.c                                 |    5 +-
 drivers/md/raid10.c                                |    2 +-
 drivers/md/raid5.c                                 | 1484 +++++++++++-------
 drivers/md/raid5.h                                 |   28 +-
 drivers/mmc/host/atmel-mci.c                       |    9 +-
 include/linux/async_tx.h                           |  129 ++-
 include/linux/dca.h                                |   11 +-
 include/linux/dmaengine.h                          |  179 ++-
 include/linux/pci_ids.h                            |   10 +
 65 files changed, 9137 insertions(+), 3321 deletions(-)
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
