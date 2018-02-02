From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 02/19] mdadm/test: add disk metadata infos in save_log
Date: Fri,  2 Feb 2018 14:10:46 +0800
Message-ID: <1517551863-1511-3-git-send-email-zlliu@suse.com>
References: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/func.sh | 2 ++
 tests/func.sh           | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/clustermd_tests/func.sh b/clustermd_tests/func.sh
index 2387424..8ac5921 100644
--- a/clustermd_tests/func.sh
+++ b/clustermd_tests/func.sh
@@ -178,6 +178,8 @@ save_log()
 			then
 				echo "##$ip: mdadm -X ${md_disks[@]}" >> $logdir/$logfile
 				ssh $ip "mdadm -X ${md_disks[@]}" >> $logdir/$logfile
+				echo "##$ip: mdadm -E ${md_disks[@]}" >> $logdir/$logfile
+				ssh $ip "mdadm -E ${md_disks[@]}" >> $logdir/$logfile
 			fi
 		else
 			echo "##$ip: no array assembled!" >> $logdir/$logfile
diff --git a/tests/func.sh b/tests/func.sh
index 40c6026..6bfdafe 100644
--- a/tests/func.sh
+++ b/tests/func.sh
@@ -55,6 +55,8 @@ save_log() {
 			then
 				echo "## $HOSTNAME: mdadm -X ${md_disks[@]}" >> $logdir/$logfile
 				$mdadm -X ${md_disks[@]} >> $logdir/$logfile
+				echo "## $HOSTNAME: mdadm -E ${md_disks[@]}" >> $logdir/$logfile
+				$mdadm -E ${md_disks[@]} >> $logdir/$logfile
 			fi
 		else
 			echo "## $HOSTNAME: no array assembled!" >> $logdir/$logfile
-- 
2.6.6

