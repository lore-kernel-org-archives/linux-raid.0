From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 1/2] Create: check the node nums when create clustered raid
Date: Wed,  4 May 2016 16:33:43 +0800
Message-ID: <1462350824-9872-2-git-send-email-gqjiang@suse.com>
References: <1462350824-9872-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1462350824-9872-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

It doesn't make sense to create a clustered raid
with only 1 node.

Reported-by: Zhilong Liu <zlliu@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Create.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Create.c b/Create.c
index 1e4a6ee..717086b 100644
--- a/Create.c
+++ b/Create.c
@@ -114,8 +114,13 @@ int Create(struct supertype *st, char *mddev,
 	unsigned long long newsize;
 
 	int major_num = BITMAP_MAJOR_HI;
-	if (s->bitmap_file && strcmp(s->bitmap_file, "clustered") == 0)
+	if (s->bitmap_file && strcmp(s->bitmap_file, "clustered") == 0) {
 		major_num = BITMAP_MAJOR_CLUSTERED;
+		if (c->nodes <= 1) {
+			pr_err("At least 2 nodes are needed for cluster-md\n");
+			return 1;
+		}
+	}
 
 	memset(&info, 0, sizeof(info));
 	if (s->level == UnSet && st && st->ss->default_geometry)
-- 
2.6.2

