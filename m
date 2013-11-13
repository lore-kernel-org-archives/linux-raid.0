From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/4] ioatdma: 16-source operation fixes
Date: Wed, 13 Nov 2013 12:12:14 -0800
Message-ID: <20131113200146.12667.19447.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dmaengine@vger.kernel.org
Cc: vinod.koul@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A collection of fixes to address failures caught by raid6test for the
greater than 16-source cases.

raid6test is also updated to run these corner cases by default going
forward.

This only impacts arrays larger than 16 disks on platforms with v3.3 of
the ioatdma engine (Intel(R) Atom S1200 family).

---

Dan Williams (4):
      ioatdma: fix sed pool selection
      ioatdma: fix selection of 16 vs 8 source path
      ioatdma: clean up sed pool kmem_cache
      raid6test: add new corner case for ioatdma driver


 crypto/async_tx/raid6test.c |   10 ++++-
 drivers/dma/ioat/dma.h      |    1 
 drivers/dma/ioat/dma_v2.h   |    1 
 drivers/dma/ioat/dma_v3.c   |   88 +++++++++++--------------------------------
 drivers/dma/ioat/pci.c      |   20 +++++++---
 5 files changed, 47 insertions(+), 73 deletions(-)
