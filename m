From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/8] ioat fixes for 2.6.32
Date: Fri, 20 Nov 2009 00:06:14 -0700
Message-ID: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

This primarily addresses driver stability issues around pq/xor-validate
operations.  The complete fix is staged for 2.6.33.  Commit: "async_tx:
build-time toggling of async_{syndrome,xor}_val dma support" simply
disables this operation type for 2.6.32.

The rest are 1-line or few-line fixes.

---

Dan Williams (8):
      ioat3: fix pq completion versus channel deallocation race
      async_tx: build-time toggling of async_{syndrome,xor}_val dma support
      dmaengine: include xor/pq validate in device_has_all_tx_types()
      ioat2,3: report all uncorrectable errors
      ioat3: specify valid address for disabled-Q or disabled-P
      ioat2,3: disable asynchronous error notifications
      ioat3: dca and raid operations are incompatible
      ioat: silence "dca disabled" messages


 crypto/async_tx/Kconfig      |    5 +++++
 crypto/async_tx/async_pq.c   |   14 +++++++++++---
 crypto/async_tx/async_xor.c  |   15 ++++++++++++---
 drivers/dma/Kconfig          |    2 ++
 drivers/dma/dmaengine.c      |   10 ++++++++++
 drivers/dma/ioat/dca.c       |    6 +++---
 drivers/dma/ioat/dma.h       |    4 +---
 drivers/dma/ioat/dma_v2.c    |    2 ++
 drivers/dma/ioat/dma_v3.c    |   42 ++++++++++++++++++++++++++++++++++++------
 drivers/dma/ioat/hw.h        |    2 ++
 drivers/dma/ioat/registers.h |    4 +---
 11 files changed, 85 insertions(+), 21 deletions(-)

-- 
Dan
