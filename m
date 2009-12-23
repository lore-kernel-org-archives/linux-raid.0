From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/3] ioatdma fixes for 2.6.33-rc
Date: Tue, 22 Dec 2009 17:25:50 -0700
Message-ID: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752918AbZLWA1I@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: maciej.sosnowski@intel.com
List-Id: linux-raid.ids

These fix recently discovered issues with the ioatdma driver and are
tagged for -stable.  They are currently on the 'fixes' branch of
async_tx.git and will head upstream shortly.

     git://git.kernel.org/linux/kernel/git/djbw/async_tx.git fixes

---

Dan Williams (3):
      ioat2,3: put channel hardware in known state at init
      async_tx: expand async raid6 test to cover ioatdma corner case
      ioat3: fix p-disabled q-continuation


 crypto/async_tx/raid6test.c  |    7 ++++
 drivers/dma/ioat/dma.c       |    2 +
 drivers/dma/ioat/dma.h       |   18 +++++++++++
 drivers/dma/ioat/dma_v2.c    |   69 ++++++++++++++++++++++++++++++++----------
 drivers/dma/ioat/dma_v2.h    |    2 +
 drivers/dma/ioat/dma_v3.c    |   60 +++++++++++++++++++++++++++----------
 drivers/dma/ioat/registers.h |    1 +
 7 files changed, 125 insertions(+), 34 deletions(-)
