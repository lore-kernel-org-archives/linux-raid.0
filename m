From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 03/19] mdadm/test: add do_clean to ensure each case only catch its own testlog
Date: Fri,  2 Feb 2018 14:10:47 +0800
Message-ID: <1517551863-1511-4-git-send-email-zlliu@suse.com>
References: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1517551863-1511-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/func.sh | 9 +++++++--
 test                    | 4 +---
 tests/func.sh           | 8 +++++++-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/clustermd_tests/func.sh b/clustermd_tests/func.sh
index 8ac5921..5c0b168 100644
--- a/clustermd_tests/func.sh
+++ b/clustermd_tests/func.sh
@@ -196,9 +196,8 @@ do_setup()
 	ulimit -c unlimited
 }
 
-cleanup()
+do_clean()
 {
-	check_ssh
 	for ip in $NODE1 $NODE2
 	do
 		ssh $ip "mdadm -Ssq; dmesg -c > /dev/null"
@@ -206,6 +205,12 @@ cleanup()
 	mdadm --zero ${devlist[@]} &> /dev/null
 }
 
+cleanup()
+{
+	check_ssh
+	do_clean
+}
+
 # check: $1/cluster_node $2/feature $3/optional
 check()
 {
diff --git a/test b/test
index 024cb63..111a2e7 100755
--- a/test
+++ b/test
@@ -82,11 +82,9 @@ do_test() {
 	if [ -f "$_script" ]
 	then
 		rm -f $targetdir/stderr
-		# stop all arrays, just incase some script left an array active.
-		$mdadm -Ssq 2> /dev/null
-		mdadm --zero $devlist 2> /dev/null
 		# this might have been reset: restore the default.
 		echo 2000 > /proc/sys/dev/raid/speed_limit_max
+		do_clean
 		# source script in a subshell, so it has access to our
 		# namespace, but cannot change it.
 		echo -ne "$_script... "
diff --git a/tests/func.sh b/tests/func.sh
index 6bfdafe..8cfee0c 100644
--- a/tests/func.sh
+++ b/tests/func.sh
@@ -88,6 +88,13 @@ cleanup() {
 	esac
 }
 
+do_clean()
+{
+	mdadm -Ss > /dev/null
+	mdadm --zero $devlist 2> /dev/null
+	dmesg -c > /dev/null
+}
+
 check_env() {
 	user=$(id -un)
 	[ "X$user" != "Xroot" ] && {
@@ -141,7 +148,6 @@ do_setup() {
 
 	check_env
 	[ -d $logdir ] || mkdir -p $logdir
-	dmesg -c > /dev/null
 
 	devlist=
 	if [ "$DEVTYPE" == "loop" ]
-- 
2.6.6

