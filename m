From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 3/3] mdadm/test: Get rid of fast_sync()
Date: Wed,  7 Jun 2017 17:31:28 +0800
Message-ID: <1496827888-17118-4-git-send-email-zlliu@suse.com>
References: <1496827888-17118-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1496827888-17118-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

fast_sync() is no longer used, so remove it.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 test | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/test b/test
index 8ecfe99..3cb4bc0 100755
--- a/test
+++ b/test
@@ -337,10 +337,6 @@ testdev() {
 	return 0
 }
 
-fast_sync() {
-	echo 200000 > /proc/sys/dev/raid/speed_limit_max
-}
-
 rotest() {
 	dev=$1
 	fsck -fn $dev >&2
-- 
2.6.6

