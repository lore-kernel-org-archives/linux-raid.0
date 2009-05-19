From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 00/11] Asynchronous raid6 acceleration (part 1 of 3)
Date: Mon, 18 May 2009 17:59:26 -0700
Message-ID: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: maan@systemlinux.org, linux-kernel@vger.kernel.org, yur@emcraft.com, hpa@zytor.com
List-Id: linux-raid.ids

This series extends the async_tx api to include support for offloading raid6
operations to hardware.  Part 2 covers updates to the iop-adma driver to
enable raid6.  Part 3 covers the changes to md/raid6 to use the async_tx api
for its raid6 computations.

A merge of these 3 topic series is available via the raid6 branch of
async_tx.git:

	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git raid6

There are several changes since v1 of the patch set[1].  The primary updates
are:
1/ Address H. Peter Anvin's comments around the asynchronous raid6 recovery
   implementation.  It has been rewritten to more closely model the existing
   recovery implementation [2].

2/ Address Andre Noll's comment concerning the excessive number of arguments
   passed to the async_* routines.  Common parameters are now passed in a
   structure.

3/ Address Neil Brown's comment that we should solve the "kernel stack space
   limits the size of an array" problem with pre-allocated buffers.
   stripe_head objects now carry a kmalloc'd 'scribble' buffer relieving the
   stack pressure of raid computations.

4/ Various updates to get the code to pass the new raid6 recovery self test

Please review.

Thanks,
Dan

[1] http://marc.info/?l=linux-raid&m=123740421725422&w=2
[2] http://marc.info/?l=linux-raid&m=124096283425451&w=2

---

Dan Williams (11):
      async_tx: rename zero_sum to val
      async_tx: kill ASYNC_TX_DEP_ACK flag
      async_tx: structify submission arguments, add scribble
      async_xor: permit callers to pass in a 'dma/page scribble' region
      md/raid5: add scribble region for buffer lists
      async_tx: add sum check flags
      async_tx: kill needless module_{init|exit}
      async_tx: add support for asynchronous GF multiplication
      async_tx: add support for asynchronous RAID6 recovery operations
      dmatest: add pq support
      async_tx: raid6 recovery self test

 arch/arm/include/asm/hardware/iop3xx-adma.h |    5 
 arch/arm/mach-iop13xx/include/mach/adma.h   |   12 -
 arch/arm/mach-iop13xx/setup.c               |   10 -
 arch/arm/plat-iop/adma.c                    |    2 
 crypto/async_tx/Kconfig                     |    9 +
 crypto/async_tx/Makefile                    |    3 
 crypto/async_tx/async_memcpy.c              |   34 +-
 crypto/async_tx/async_memset.c              |   36 +-
 crypto/async_tx/async_pq.c                  |  399 +++++++++++++++++++++++++++
 crypto/async_tx/async_raid6_recov.c         |  292 ++++++++++++++++++++
 crypto/async_tx/async_tx.c                  |   53 +---
 crypto/async_tx/async_xor.c                 |  168 +++++------
 crypto/async_tx/raid6test.c                 |  212 ++++++++++++++
 drivers/dma/Kconfig                         |    2 
 drivers/dma/dmaengine.c                     |    8 -
 drivers/dma/dmatest.c                       |   26 ++
 drivers/dma/iop-adma.c                      |   40 +--
 drivers/md/Kconfig                          |   13 +
 drivers/md/raid5.c                          |  123 ++++++--
 drivers/md/raid5.h                          |   10 +
 include/linux/async_tx.h                    |  103 +++++--
 include/linux/dmaengine.h                   |   87 +++++-
 22 files changed, 1347 insertions(+), 300 deletions(-)
 create mode 100644 crypto/async_tx/async_pq.c
 create mode 100644 crypto/async_tx/async_raid6_recov.c
 create mode 100644 crypto/async_tx/raid6test.c
