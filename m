From: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Subject: [PATCH 0/2] Enable polling on stackable devices
Date: Sat, 25 Jan 2020 21:41:36 -0700
Message-ID: <20200126044138.5066-1-andrzej.jakowski@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, song@kernel.org
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
List-Id: linux-raid.ids

IO polling is available on blk-mq devices. Currently it is not possible to
perform IO polling on stackable devices like MD. 

We have built a prototype exposing new function for bio devices to do IO
polling on them. That function is in available on request_queue so bio based
drivers can provide handler for it. 

IO polling has been provided for RAID-0 level for MD.

Andrzej Jakowski (2):
  block: introduce polling on bio level
  md: enable io polling

 block/blk-core.c       |  3 ++-
 block/blk-mq.c         | 26 ++++++++++++++++++++++++++
 drivers/md/md.c        | 39 +++++++++++++++++++++++++++++++++++----
 include/linux/blkdev.h |  2 ++
 4 files changed, 65 insertions(+), 5 deletions(-)

-- 
2.20.1
