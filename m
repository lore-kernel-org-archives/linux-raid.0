From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 3/6] md: linear.c: Remove broken debug code.
Date: Fri, 25 Jul 2008 17:27:49 +0200
Message-ID: <1216999672-4943-4-git-send-email-maan@systemlinux.org>
References: <1216999672-4943-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1216999672-4943-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

conf->smallest_size is undefined since day one of the git repo..

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/linear.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index c36e4f7..f33b574 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -365,29 +365,6 @@ static int linear_make_request (struct request_queue *q, struct bio *bio)
 static void linear_status (struct seq_file *seq, mddev_t *mddev)
 {
 
-#undef MD_DEBUG
-#ifdef MD_DEBUG
-	int j;
-	linear_conf_t *conf = mddev_to_conf(mddev);
-	sector_t s = 0;
-  
-	seq_printf(seq, "      ");
-	for (j = 0; j < mddev->raid_disks; j++)
-	{
-		char b[BDEVNAME_SIZE];
-		s += conf->smallest_size;
-		seq_printf(seq, "[%s",
-			   bdevname(conf->hash_table[j][0].rdev->bdev,b));
-
-		while (s > conf->hash_table[j][0].offset +
-		           conf->hash_table[j][0].size)
-			seq_printf(seq, "/%s] ",
-				   bdevname(conf->hash_table[j][1].rdev->bdev,b));
-		else
-			seq_printf(seq, "] ");
-	}
-	seq_printf(seq, "\n");
-#endif
 	seq_printf(seq, " %dk rounding", mddev->chunk_size/1024);
 }
 
-- 
1.5.4.3

