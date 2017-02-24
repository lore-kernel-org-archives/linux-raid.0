From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 01/14] md-cluster: remove unnecessary header files
Date: Fri, 24 Feb 2017 11:15:11 +0800
Message-ID: <1487906124-20107-2-git-send-email-gqjiang@suse.com>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.de, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

md-cluster.h is already included in md.h, so remove
the redundant one and we don't want to cross include
header file too.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 1 -
 drivers/md/md-cluster.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 2b13117fb918..03c38ed222ce 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -16,7 +16,6 @@
 #include <linux/raid/md_p.h>
 #include "md.h"
 #include "bitmap.h"
-#include "md-cluster.h"
 
 #define LVB_SIZE	64
 #define NEW_DEV_TIMEOUT 5000
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index e765499ba591..8f26a5e80810 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -3,8 +3,6 @@
 #ifndef _MD_CLUSTER_H
 #define _MD_CLUSTER_H
 
-#include "md.h"
-
 struct mddev;
 struct md_rdev;
 
-- 
2.6.2

