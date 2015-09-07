From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/10] raid5-cache: clean up r5l_get_meta
Date: Mon,  7 Sep 2015 07:20:44 +0200
Message-ID: <1441603250-5119-5-git-send-email-hch@lst.de>
References: <1441603250-5119-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1441603250-5119-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Remove the only partially used local 'io' variable to simplify the code
flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 1e54249..10ccda3 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -291,16 +291,12 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 
 static int r5l_get_meta(struct r5l_log *log, unsigned int payload_size)
 {
-	struct r5l_io_unit *io;
-
-	io = log->current_io;
-	if (io && io->meta_offset + payload_size > PAGE_SIZE)
+	if (log->current_io &&
+	    log->current_io->meta_offset + payload_size > PAGE_SIZE)
 		r5l_submit_current_io(log);
-	io = log->current_io;
-	if (io)
-		return 0;
 
-	log->current_io = r5l_new_meta(log);
+	if (!log->current_io)
+		log->current_io = r5l_new_meta(log);
 	return 0;
 }
 
-- 
1.9.1

