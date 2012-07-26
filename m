From: NeilBrown <neilb@suse.de>
Subject: [PATCH 0/4] Plugging changes for blk/md/umem
Date: Thu, 26 Jul 2012 12:58:29 +1000
Message-ID: <20120726025650.32180.65163.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Hi Jens,
 the following series makes a number of changes to plugging, moving
 common code from md and umem into block, and modifying it to allow
 md to get more value out of it.
 They've been sitting in -next for a while.
 Are you OK with me forwarding them to Linus, or would you rather they
 went though your tree?

Thanks,
NeilBrown

---

NeilBrown (3):
      blk: pass from_schedule to non-request unplug functions.
      blk: centralize non-request unplug handling.
      md: remove plug_cnt feature of plugging.

Shaohua Li (1):
      block: stack unplug


 block/blk-core.c       |   44 ++++++++++++++++++++++++++++--------
 drivers/block/umem.c   |   37 ++++++------------------------
 drivers/md/md.c        |   59 ++++--------------------------------------------
 drivers/md/md.h        |   11 ++++++---
 drivers/md/raid1.c     |    3 +-
 drivers/md/raid10.c    |    3 +-
 drivers/md/raid5.c     |    5 ++--
 include/linux/blkdev.h |    8 +++++--
 8 files changed, 63 insertions(+), 107 deletions(-)

-- 
Signature

