From: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Subject: [PATCH v2 0/2] Enable polling on stackable devices
Date: Tue, 11 Feb 2020 12:17:27 -0700
Message-ID: <20200211191729.4745-1-andrzej.jakowski@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: axboe@kernel.dk, song@kernel.org
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
List-Id: linux-raid.ids

Changes since v1:
 - reintroduced original blk_poll() function that has been removed some time
   ago (Jens)

 - added fastpath calls to blk_mq_poll() in blk_poll() (Christoph, Jens)

 - incorporated code style fixes into md patch (Christoph)
 
[1]: https://lore.kernel.org/linux-block/20200126044138.5066-1-andrzej.jakowski@linux.intel.com/T/#t

---

IO polling is available on blk-mq devices. It is not possible to perform IO
polling on stackable devices like MD.

In this patch series we propose to reintroduce blk_poll() function. blk_poll()
when called on stackable block device that supports polling will invoke its
polling handler. Otherwise it will call blk_mq_poll() directly for fast
accesses.

This patch set also includes example implemetation of polling on MD RAID-0
volume.

---

TODO:
 - introduce REQ_NOWAIT support for stackable devices in a separate patchset 
   (Christoph)

Andrzej Jakowski (1):
  block: reintroduce polling on bio level

Artur Paszkiewicz (1):
  md: enable io polling

 block/blk-core.c       | 28 ++++++++++++++++++++++++++++
 block/blk-mq.c         | 23 ++---------------------
 block/blk-mq.h         |  2 ++
 drivers/md/md.c        | 40 ++++++++++++++++++++++++++++++++++++----
 include/linux/blkdev.h |  2 ++
 5 files changed, 70 insertions(+), 25 deletions(-)

-- 
2.20.1
