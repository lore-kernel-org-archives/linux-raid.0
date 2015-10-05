From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/11] raid5-cache: small log->seq cleanup
Date: Mon,  5 Oct 2015 09:31:15 +0200
Message-ID: <1444030276-30850-11-git-send-email-hch@lst.de>
References: <1444030276-30850-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444030276-30850-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: dan.j.williams@intel.com, Kernel-team@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 87fa3b5..e64f94e 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -312,12 +312,11 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 
 	io->log_start = log->log_start;
 	io->meta_offset = sizeof(struct r5l_meta_block);
-	io->seq = log->seq;
+	io->seq = log->seq++;
 
 	io->current_bio = r5l_bio_alloc(log, io);
 	bio_add_page(io->current_bio, io->meta_page, PAGE_SIZE, 0);
 
-	log->seq++;
 	r5_reserve_log_entry(log, io);
 
 	spin_lock_irq(&log->io_list_lock);
-- 
1.9.1

