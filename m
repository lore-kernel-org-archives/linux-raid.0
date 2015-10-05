From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/11] raid5-cache: clean up r5l_get_meta
Date: Mon,  5 Oct 2015 09:31:10 +0200
Message-ID: <1444030276-30850-6-git-send-email-hch@lst.de>
References: <1444030276-30850-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444030276-30850-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, neilb@suse.de
Cc: dan.j.williams@intel.com, Kernel-team@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Remove the only partially used local 'io' variable to simplify the code
flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-cache.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 0d18ed7..05126151 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -324,16 +324,12 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
 
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

