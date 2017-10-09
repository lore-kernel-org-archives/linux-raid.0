From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 1/3] mdadm/Grow: fix the broken raid level conversion
Date: Mon,  9 Oct 2017 16:21:12 +0800
Message-ID: <1507537274-29350-2-git-send-email-zlliu@suse.com>
References: <1507537274-29350-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1507537274-29350-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

To fix the commit: 4b74a905a67e
(mdadm/grow: Component size must be larger than chunk size)
Since cannot change component size at the same time as other
changes, ensure the 'level' is UnSet when changing component
size, and also not affect the raid level conversion.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Grow.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index 1149753..180fd78 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1814,7 +1814,8 @@ int Grow_reshape(char *devname, int fd,
 	}
 
 	if (array.level > 1 &&
-	   (array.chunk_size / 1024) > (int)s->size) {
+	   (array.chunk_size / 1024) > (int)s->size &&
+	    s->level == UnSet) {
 		pr_err("component size must be larger than chunk size.\n");
 		return 1;
 	}
-- 
2.6.6

