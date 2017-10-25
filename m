From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2] mdadm: make create clustered raid10 possible
Date: Wed, 25 Oct 2017 09:19:13 +0800
Message-ID: <20171025011913.16870-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This change to make we can create a clustered
raid10 array as well.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 mdadm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index 7cdcdba7c652..bf3da870f360 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1542,8 +1542,8 @@ int main(int argc, char *argv[])
 				break;
 			}
 
-			if (s.level != 1) {
-				pr_err("--bitmap=clustered is currently supported with RAID mirror only\n");
+			if (s.level != 1 && s.level != 10) {
+				pr_err("--bitmap=clustered is currently supported with raid1/10 only\n");
 				rv = 1;
 				break;
 			}
-- 
2.10.0

