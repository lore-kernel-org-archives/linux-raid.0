From: gqjiang@suse.com
Subject: [PATCH V2 06/11] Convert a bitmap=none device to clustered
Date: Fri,  8 May 2015 16:50:24 +0800
Message-ID: <1431075029-5484-7-git-send-email-gqjiang@suse.com>
References: <1431075029-5484-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431075029-5484-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

This adds the ability to convert a regular md without bitmap
(--bitmap=none) to a clustered device (--bitmap=clustered).

To convert a device with --bitmap=internal or --bitmap=external,
you have to convert to --bitmap=none and then re-execute the
command with --bitmap=clustered.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Grow.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/Grow.c b/Grow.c
index 9a573fd..1122cec 100644
--- a/Grow.c
+++ b/Grow.c
@@ -330,9 +330,16 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			}
 			return 0;
 		}
-		pr_err("Internal bitmap already present on %s\n",
-			devname);
-		return 1;
+		if ((strcmp(s->bitmap_file, "clustered")==0) && (array.state & (1<<MD_SB_CLUSTERED))) {
+			pr_err("Clustered bitmap already present on %s\n",
+					devname);
+			return 1;
+		}
+		if ((strcmp(s->bitmap_file, "internal")==0) && (!(array.state & (1<<MD_SB_CLUSTERED)))) {
+			pr_err("Internal bitmap already present on %s\n",
+					devname);
+			return 1;
+		}
 	}
 
 	if (strcmp(s->bitmap_file, "none") == 0) {
@@ -375,7 +382,8 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 		free(st);
 		return 1;
 	}
-	if (strcmp(s->bitmap_file, "internal") == 0) {
+	if ((strcmp(s->bitmap_file, "internal") == 0) ||
+		(strcmp(s->bitmap_file, "clustered") == 0)) {
 		int rv;
 		int d;
 		int offset_setable = 0;
@@ -384,6 +392,8 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			pr_err("Internal bitmaps not supported with %s metadata\n", st->ss->name);
 			return 1;
 		}
+		st->nodes = c->nodes;
+		st->cluster_name = c->homecluster;
 		mdi = sysfs_read(fd, NULL, GET_BITMAP_LOCATION);
 		if (mdi)
 			offset_setable = 1;
@@ -426,6 +436,8 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			rv = sysfs_set_num_signed(mdi, NULL, "bitmap/location",
 						  mdi->bitmap_offset);
 		} else {
+			if (strcmp(s->bitmap_file, "clustered") == 0)
+				array.state |= (1<<MD_SB_CLUSTERED);
 			array.state |= (1<<MD_SB_BITMAP_PRESENT);
 			rv = ioctl(fd, SET_ARRAY_INFO, &array);
 		}
-- 
1.7.12.4

