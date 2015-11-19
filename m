From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 1/2] mdadm: let cluster raid could also add disk within incremental mode
Date: Thu, 19 Nov 2015 13:59:18 +0800
Message-ID: <1447912759-6239-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com
Cc: rgoldwyn@suse.com, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

For cluster raid, the disc.state need to be changed accordingly under
incremental mode.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Incremental.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Incremental.c b/Incremental.c
index 781d27d..7afa7d7 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -444,6 +444,10 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 		/* add disk needs to know about containers */
 		if (st->ss->external)
 			sra->array.level = LEVEL_CONTAINER;
+
+		if (info.array.state & (1 << MD_SB_CLUSTERED))
+			info.disk.state |= (1 << MD_DISK_CLUSTER_ADD);
+
 		err = add_disk(mdfd, st, sra, &info);
 		if (err < 0 && errno == EBUSY) {
 			/* could be another device present with the same
-- 
2.1.4

