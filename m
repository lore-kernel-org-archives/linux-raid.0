From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 04/19] mdadm/clustermd_tests: add nobitmap in check
Date: Fri,  2 Feb 2018 14:10:48 +0800
Message-ID: <1517551863-1511-5-git-send-email-zlliu@suse.com>
References: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/func.sh | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/clustermd_tests/func.sh b/clustermd_tests/func.sh
index 5c0b168..329f610 100644
--- a/clustermd_tests/func.sh
+++ b/clustermd_tests/func.sh
@@ -284,6 +284,13 @@ check()
 					die "$ip: no '$2' found in /proc/mdstat."
 			done
 		;;
+		nobitmap )
+			for ip in ${NODES[@]}
+			do
+				ssh $ip "grep -sq 'bitmap' /proc/mdstat" &&
+					die "$ip: 'bitmap' found in /proc/mdstat."
+			done
+		;;
 		chunk )
 			for ip in ${NODES[@]}
 			do
-- 
2.6.6

