From: Colin King <colin.king@canonical.com>
Subject: [PATCH] md/r5cache: remove redundant pointer bio
Date: Tue,  3 Jul 2018 07:51:09 +0100
Message-ID: <20180703065109.23620-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

From: Colin Ian King <colin.king@canonical.com>

Pointer bio is being assigned but is never used hence it is redundant
and can be removed.

Cleans up clang warning:
warning: variable 'bio' set but not used [-Wunused-but-set-variable]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/md/raid5-cache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 2b775abf377b..7416db70c6cc 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -717,7 +717,6 @@ static void r5c_disable_writeback_async(struct work_struct *work)
 static void r5l_submit_current_io(struct r5l_log *log)
 {
 	struct r5l_io_unit *io = log->current_io;
-	struct bio *bio;
 	struct r5l_meta_block *block;
 	unsigned long flags;
 	u32 crc;
@@ -730,7 +729,6 @@ static void r5l_submit_current_io(struct r5l_log *log)
 	block->meta_size = cpu_to_le32(io->meta_offset);
 	crc = crc32c_le(log->uuid_checksum, block, PAGE_SIZE);
 	block->checksum = cpu_to_le32(crc);
-	bio = io->current_bio;
 
 	log->current_io = NULL;
 	spin_lock_irqsave(&log->io_list_lock, flags);
-- 
2.17.1
