From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 05/19] mdadm/clustermd_tests: delete meaningless commands in check
Date: Fri,  2 Feb 2018 14:10:49 +0800
Message-ID: <1517551863-1511-6-git-send-email-zlliu@suse.com>
References: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/func.sh | 2 --
 1 file changed, 2 deletions(-)

diff --git a/clustermd_tests/func.sh b/clustermd_tests/func.sh
index 329f610..c2be0e5 100644
--- a/clustermd_tests/func.sh
+++ b/clustermd_tests/func.sh
@@ -278,8 +278,6 @@ check()
 		bitmap )
 			for ip in ${NODES[@]}
 			do
-				echo $ip
-				ssh $ip cat /proc/mdstat
 				ssh $ip "grep -sq '$2' /proc/mdstat" ||
 					die "$ip: no '$2' found in /proc/mdstat."
 			done
-- 
2.6.6

