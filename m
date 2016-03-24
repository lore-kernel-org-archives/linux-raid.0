From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] Change the option from NoUpdate to NodeNumUpdate
Date: Thu, 24 Mar 2016 18:00:35 +0800
Message-ID: <1458813635-14175-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Actually, we need to use NodeNumUpdate here to
ensure there are enough spaces for those nodes.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Grow.c   | 2 +-
 super1.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 5953db2..f58c753 100755
--- a/Grow.c
+++ b/Grow.c
@@ -425,7 +425,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 						    bitmapsize, offset_setable,
 						    major)
 						)
-						st->ss->write_bitmap(st, fd2, NoUpdate);
+						st->ss->write_bitmap(st, fd2, NodeNumUpdate);
 					else {
 						pr_err("failed to create internal bitmap - chunksize problem.\n");
 						close(fd2);
diff --git a/super1.c b/super1.c
index baa9a96..d6f3c93 100644
--- a/super1.c
+++ b/super1.c
@@ -1867,7 +1867,7 @@ static int write_init_super1(struct supertype *st)
 		}
 
 		if (rv == 0 && (__le32_to_cpu(sb->feature_map) & 1))
-			rv = st->ss->write_bitmap(st, di->fd, NoUpdate);
+			rv = st->ss->write_bitmap(st, di->fd, NodeNumUpdate);
 		close(di->fd);
 		di->fd = -1;
 		if (rv)
-- 
2.6.2

