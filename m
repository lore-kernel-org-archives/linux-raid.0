From: Lidong Zhong <lidong.zhong@suse.com>
Subject: [PATCH] Detail: show correct bitmap info for cluster raid device
Date: Mon, 16 Mar 2020 10:16:49 +0800
Message-ID: <20200316021649.4423-1-lidong.zhong@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org, guoqing.jiang@cloud.ionos.com
List-Id: linux-raid.ids

Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
---
 Detail.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Detail.c b/Detail.c
index 832485f..daec4f1 100644
--- a/Detail.c
+++ b/Detail.c
@@ -468,7 +468,9 @@ int Detail(char *dev, struct context *c)
 		if (ioctl(fd, GET_BITMAP_FILE, &bmf) == 0 && bmf.pathname[0]) {
 			printf("     Intent Bitmap : %s\n", bmf.pathname);
 			printf("\n");
-		} else if (array.state & (1<<MD_SB_BITMAP_PRESENT))
+		} else if (array.state & (1<<MD_SB_CLUSTERED))
+			printf("     Intent Bitmap : Internal(Clustered)\n\n");
+		else if (array.state & (1<<MD_SB_BITMAP_PRESENT))
 			printf("     Intent Bitmap : Internal\n\n");
 		atime = array.utime;
 		if (atime)
-- 
2.16.4
