From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm/grow: correct the s->size > 1 to make 'max' work
Date: Thu, 23 Nov 2017 11:10:44 +0800
Message-ID: <1511406644-12565-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

To fix the commit: 1b21c449e6f2
(mdadm/grow: adding a test to ensure resize was required)

s->size > 1 : s->size is '1' when '--grow --size max'
parameter is specified, so correct this test here.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---

resend it due to the missed patch:
[PATCH v3] mdadm/grow: adding a test to ensure resize was required

 Grow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index 80176e3..3ee015b 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1815,7 +1815,7 @@ int Grow_reshape(char *devname, int fd,
 		return 1;
 	}
 
-	if (array.level > 1 && s->size > 0 &&
+	if (array.level > 1 && s->size > 1 &&
 	    (array.chunk_size / 1024) > (int)s->size) {
 		pr_err("component size must be larger than chunk size.\n");
 		return 1;
-- 
2.6.6

