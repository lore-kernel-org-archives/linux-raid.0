From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 2/4] mdadm: output info more precisely when change bitmap to none
Date: Wed,  2 Dec 2015 00:30:10 +0800
Message-ID: <1448987412-3932-2-git-send-email-gqjiang@suse.com>
References: <1448987412-3932-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1448987412-3932-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, linux-raid@vger.kernel.org
Cc: rgoldwyn@suse.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

WHen change bitmap to none, the infos could be more accurate
based on existed bitmap type.

And s->bitmap_file is passed from cmd "--bitmap=TYPE", so
remove s->bitmap_file from err info since it should means
change the bitmap to one type failed rather than the type is
already presented.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Grow.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 80d7b22..30ff7f3 100644
--- a/Grow.c
+++ b/Grow.c
@@ -328,12 +328,15 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 		if (strcmp(s->bitmap_file, "none")==0) {
 			array.state &= ~(1<<MD_SB_BITMAP_PRESENT);
 			if (ioctl(fd, SET_ARRAY_INFO, &array)!= 0) {
-				pr_err("failed to remove internal bitmap.\n");
+				if (array.state & (1<<MD_SB_CLUSTERED))
+					pr_err("failed to remove clustered bitmap.\n");
+				else
+					pr_err("failed to remove internal bitmap.\n");
 				return 1;
 			}
 			return 0;
 		}
-		pr_err("%s bitmap already present on %s\n", s->bitmap_file, devname);
+		pr_err("bitmap already present on %s\n", devname);
 		return 1;
 	}
 
-- 
2.1.4

