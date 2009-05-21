From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/3] Asynchronous raid6 acceleration (part 2 of 3)
Date: Thu, 21 May 2009 12:04:07 -0700
Message-ID: <20090521190336.18676.46149.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: adhiraj@linsyssoft.com
List-Id: linux-raid.ids

This series adds P+Q operations to the iop-adma driver.  Part1 [1] added the
async_tx api extensions for raid6.  Part3 includes the changes to md/raid6 to
utilize the api extensions.  All three topics are merged into the 'raid6'
branch of async_tx.git:

	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git raid6

This implementation has been verified with the raid6test module [2].

Please review.

Thanks,
Dan

[1] http://marc.info/?l=linux-raid&m=124269482227272&w=2
[2] http://marc.info/?l=linux-raid&m=124269519527629&w=2

---

Dan Williams (3):
      iop-adma: P+Q self test
      iop-adma: P+Q support for iop13xx adma engines
      iop-adma: cleanup iop_adma_run_tx_complete_actions


 arch/arm/include/asm/hardware/iop3xx-adma.h |   76 +++++
 arch/arm/include/asm/hardware/iop_adma.h    |    1 
 arch/arm/mach-iop13xx/include/mach/adma.h   |  107 +++++++
 drivers/dma/iop-adma.c                      |  427 ++++++++++++++++++++++++---
 4 files changed, 568 insertions(+), 43 deletions(-)

