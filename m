From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 0/4] Asynchronous raid6 acceleration (part 2 of 3)
Date: Mon, 31 Aug 2009 08:40:37 -0700
Message-ID: <20090831153946.1068.86702.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
List-Id: linux-raid.ids

RAID6 acceleration support for the iop13xx ADMA engines.  The iop13xx platform
has three Application DMA engines providing support for offloading raid
operations.  Channel0 and Channel1 support memcpy and xor.  Channel2 adds pq
support.

The combined series is available at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git raid6

The changes since v1 are:
1/ Fix the case for continuing a p-disabled pq calculation
2/ A lockdep annotation for teaching lockdep about iop-adma cross channel
   dependency submissions.
---

Dan Williams (4):
      iop-adma: P+Q self test
      iop-adma: P+Q support for iop13xx adma engines
      iop-adma: fix lockdep false positive
      iop-adma: cleanup iop_adma_run_tx_complete_actions


 arch/arm/include/asm/hardware/iop3xx-adma.h |   76 +++++
 arch/arm/include/asm/hardware/iop_adma.h    |    1 
 arch/arm/mach-iop13xx/include/mach/adma.h   |  107 +++++++
 drivers/dma/iop-adma.c                      |  437 ++++++++++++++++++++++++---
 4 files changed, 577 insertions(+), 44 deletions(-)
