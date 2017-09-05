From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 1/3] mdadm/grow: Component size must be larger than chunk size
Date: Tue,  5 Sep 2017 17:41:36 +0800
Message-ID: <1504604498-26048-2-git-send-email-zlliu@suse.com>
References: <1504604498-26048-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1504604498-26048-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Grow: Changing component size must be larger than current
chunk size against stripe raids, otherwise Grow_reshape()
would set s->size to '0'.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Grow.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Grow.c b/Grow.c
index 534ba80..f0a21ff 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1816,6 +1816,12 @@ int Grow_reshape(char *devname, int fd,
 		return 1;
 	}
 
+	if (array.level > 1 &&
+	   (array.chunk_size / 1024) > (int)s->size) {
+		pr_err("component size must be larger than chunk size.\n");
+		return 1;
+	}
+
 	st = super_by_fd(fd, &subarray);
 	if (!st) {
 		pr_err("Unable to determine metadata format for %s\n", devname);
-- 
2.6.6

