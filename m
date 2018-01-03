From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] mdadm: allow clustered raid10 to be created with default layout
Date: Wed,  3 Jan 2018 15:01:22 +0800
Message-ID: <20180103070122.5195-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Since the default layout of raid10 is n2, so we
should allow the behavior.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 mdadm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdadm.c b/mdadm.c
index 1053c46d9fd7..d978182218db 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1565,7 +1565,7 @@ int main(int argc, char *argv[])
 				rv = 1;
 				break;
 			}
-			if (s.level == 10 && !is_near_layout_10(s.layout)) {
+			if (s.level == 10 && !(is_near_layout_10(s.layout) || s.layout == UnSet)) {
 				pr_err("only near layout is supported with clustered raid10\n");
 				rv = 1;
 				break;
-- 
2.13.6

