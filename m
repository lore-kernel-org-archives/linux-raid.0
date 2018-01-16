From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 4/8] mdadm/test: add '--testdir=' to switch choosing test suite
Date: Tue, 16 Jan 2018 17:45:05 +0800
Message-ID: <1516095909-12968-5-git-send-email-zlliu@suse.com>
References: <1516095909-12968-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1516095909-12968-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

By now, mdadm has two test suites to cover traditional sofr-raid
testing and clustermd testing, the '--testdir=' option supports
to switch which suite to test, tests/ or clustermd_tests/.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 clustermd_tests/func.sh |  2 --
 test                    | 32 ++++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/clustermd_tests/func.sh b/clustermd_tests/func.sh
index f88d33f..2387424 100644
--- a/clustermd_tests/func.sh
+++ b/clustermd_tests/func.sh
@@ -1,7 +1,5 @@
 #!/bin/bash
 
-CLUSTER_CONF=$PWD/cluster_conf
-
 check_ssh()
 {
 	NODE1="$(grep '^NODE1' $CLUSTER_CONF | cut -d'=' -f2)"
diff --git a/test b/test
index 6175c25..4ddef38 100755
--- a/test
+++ b/test
@@ -1,14 +1,12 @@
 #!/bin/bash
 #
 # run test suite for mdadm
-
-. tests/func.sh
-
 mdadm=$PWD/mdadm
-testdir="tests"
 targetdir="/var/tmp"
 logdir="$targetdir"
 config=/tmp/mdadm.conf
+testdir=
+devlist=
 
 savelogs=0
 exitonerror=1
@@ -114,6 +112,7 @@ do_help() {
 	Example for disk mode: ./test --dev=disk --disks=/dev/sda{2..15}
 	Options:
 		--tests=test1,test2,...     Comma separated list of tests to run
+		--testdir=                  Specify testdir as tests|clustermd_tests
 		--raidtype=                 raid0|linear|raid1|raid456|raid10|ddf|imsm
 		--disable-multipath         Disable any tests involving multipath
 		--disable-integrity         Disable slow tests of RAID[56] consistency
@@ -134,6 +133,29 @@ parse_args() {
 	for i in $*
 	do
 		case $i in
+		--testdir=* )
+			case ${i##*=} in
+			tests )
+				testdir=tests
+			;;
+			clustermd_tests )
+				testdir=clustermd_tests
+				CLUSTER_CONF="$PWD/$testdir/cluster_conf"
+			;;
+			* )
+				echo "Unknown argument: $i"
+				do_help
+				exit 1
+			;;
+			esac
+		;;
+		esac
+	done
+	[ -z "$testdir" ] && testdir=tests
+	. $testdir/func.sh
+	for i in $*
+	do
+		case $i in
 		[0-9][0-9] )
 			prefix=$i
 			;;
@@ -147,6 +169,8 @@ parse_args() {
 			cleanup
 			exit 0
 			;;
+		--testdir=* )
+			;;
 		--tests=* )
 			TESTLIST=($(echo ${i##*=} | sed -e 's/,/ /g'))
 			;;
-- 
2.6.6

