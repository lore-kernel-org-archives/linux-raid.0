From: Christoph Hellwig <hch@lst.de>
Subject: remove leftovers of the old ->media_changed method
Date: Wed,  8 Jul 2020 14:25:40 +0200
Message-ID: <20200708122546.214579-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Hi Jens,

this series converts md as the last user of the ->media_changed method
over to the modern replacement, and then cleans up a few lose ends in
the area.

Diffstat:
 Documentation/cdrom/cdrom-standard.rst |   18 +-----------------
 Documentation/filesystems/locking.rst  |    4 +---
 arch/xtensa/platforms/iss/simdisk.c    |    2 --
 block/genhd.c                          |    7 +------
 drivers/cdrom/cdrom.c                  |   28 +++++-----------------------
 drivers/md/md.c                        |   19 ++++++++-----------
 drivers/mmc/core/block.c               |    3 ---
 fs/block_dev.c                         |   30 +++++++-----------------------
 fs/isofs/inode.c                       |    3 ---
 include/linux/blkdev.h                 |    2 --
 include/linux/cdrom.h                  |    2 --
 11 files changed, 23 insertions(+), 95 deletions(-)
