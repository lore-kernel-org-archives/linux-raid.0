From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 00/14] Asynchronous raid6 acceleration (part 1 of 3)
Date: Sat, 29 Aug 2009 19:30:00 -0700
Message-ID: <20090830022908.5934.72142.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752430AbZH3CaA@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Extend the async_tx api to include routines for offloading raid6 operations to
hardware.  This is part1, part2 contains raid6 extensions to the iop-adma
driver, and part3 contains the changes to make the md/raid6 driver
asynchronous.

The combined series is available at:

   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git raid6

The changes since v2 [1] are:
1/ Moved various stripe handling resources to a percpu allocation.
   Specifically the 'scribble' buffer (for passing and converting address
   lists) and the raid6 spare page have been moved.

2/ Added 4-disk and 5-disk special cases to the raid6 recovery code as
   they are special with respect to offload engines.  The recovery
   algorithms use a zero page in the place of the dead data pages.  When
   the async_tx api sees the raid6_empty_zero_page as a source it simply
   drops it in the asynchronous path.  This can result, for example, in a
   PQ operation with a source count of zero in the case of recovering 2
   data disks in a 4-disk array.  This does not map to hardware so the
   recovery code refactors the operation in these special cases.  The
   raid6test module has been updated to hit these cases.

I can carry this in async_tx.git/next, or let me know if you would
rather pull this into md.git/for-next.

Thanks,
Dan

[1]: http://marc.info/?l=linux-raid&m=124269482227272&w=2

Note, I know that "md/raid6: release spare page at ->stop()" is already
upstream, but I have not rebased the tree to preserve the testing that
has gone into this series to date.

---

Dan Williams (14):
      async_tx: rename zero_sum to val
      async_tx: kill ASYNC_TX_DEP_ACK flag
      async_tx: structify submission arguments, add scribble
      async_xor: permit callers to pass in a 'dma/page scribble' region
      md/raid6: release spare page at ->stop()
      md/raid6: move the spare page to a percpu allocation
      md/raid5,6: add percpu scribble region for buffer lists
      async_tx: add sum check flags
      async_tx: kill needless module_{init|exit}
      async_tx: remove walk of tx->parent chain in dma_wait_for_async_tx
      async_tx: add support for asynchronous GF multiplication
      async_tx: add support for asynchronous RAID6 recovery operations
      dmatest: add pq support
      async_tx: raid6 recovery self test

 Documentation/crypto/async-tx-api.txt       |   75 +++-
 arch/arm/include/asm/hardware/iop3xx-adma.h |    5 
 arch/arm/mach-iop13xx/include/mach/adma.h   |   12 -
 arch/arm/mach-iop13xx/setup.c               |   10 -
 arch/arm/plat-iop/adma.c                    |    2 
 crypto/async_tx/Kconfig                     |    9 +
 crypto/async_tx/Makefile                    |    3 
 crypto/async_tx/async_memcpy.c              |   39 +-
 crypto/async_tx/async_memset.c              |   38 +-
 crypto/async_tx/async_pq.c                  |  388 +++++++++++++++++++++++
 crypto/async_tx/async_raid6_recov.c         |  448 +++++++++++++++++++++++++++
 crypto/async_tx/async_tx.c                  |   83 ++---
 crypto/async_tx/async_xor.c                 |  199 ++++++------
 crypto/async_tx/raid6test.c                 |  241 ++++++++++++++
 drivers/dma/Kconfig                         |    2 
 drivers/dma/dmaengine.c                     |   53 +--
 drivers/dma/dmatest.c                       |   26 ++
 drivers/dma/iop-adma.c                      |   40 +-
 drivers/md/Kconfig                          |   13 +
 drivers/md/raid5.c                          |  452 ++++++++++++++++++---------
 drivers/md/raid5.h                          |   22 +
 include/linux/async_tx.h                    |  126 ++++++--
 include/linux/dmaengine.h                   |  116 ++++++-
 23 files changed, 1907 insertions(+), 495 deletions(-)
 create mode 100644 crypto/async_tx/async_pq.c
 create mode 100644 crypto/async_tx/async_raid6_recov.c
 create mode 100644 crypto/async_tx/raid6test.c
