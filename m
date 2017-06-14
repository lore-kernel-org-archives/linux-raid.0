From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH v2 2/3] mdadm/test: Add '--raidtype=' to run different raidlevel cases
Date: Wed, 14 Jun 2017 21:02:52 +0800
Message-ID: <1497445373-27985-3-git-send-email-zlliu@suse.com>
References: <1497445373-27985-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1497445373-27985-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

It supports to specify the argument of "--raidtype"
to run the different raid level cases. Details refer
to the do_help() usage.
For example: ./test --raidtype=raid1
could execute all the raid1 test cases under tests/.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 test | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/test b/test
index 7ee523b..df2eeab 100755
--- a/test
+++ b/test
@@ -385,6 +385,7 @@ do_help() {
 	Usage: $0 [options]
 	Options:
 		--tests=test1,test2,...     Comma separated list of tests to run
+		--raidtype=                 raid0|linear|raid1|raid456|raid10|ddf|imsm
 		--disable-multipath         Disable any tests involving multipath
 		--disable-integrity         Disable slow tests of RAID[56] consistency
 		--logdir=directory          Directory to save all logfiles in
@@ -419,6 +420,36 @@ parse_args() {
 		--tests=* )
 			TESTLIST=($(echo ${i##*=} | sed -e 's/,/ /g'))
 			;;
+		--raidtype=* )
+			case ${i##*=} in
+			raid0 )
+				TESTLIST=($(ls $testdir | grep "[0-9][0-9]r0\|raid0"))
+				;;
+			linear )
+				TESTLIST=($(ls $testdir | grep "linear"))
+				;;
+			raid1 )
+				TESTLIST=($(ls $testdir | grep "[0-9][0-9]r1\|raid1" | grep -vi raid10))
+				;;
+			raid456 )
+				TESTLIST=($(ls $testdir | grep "[0-9][0-9]r[4-6]\|raid[4-6]"))
+				;;
+			raid10 )
+				TESTLIST=($(ls $testdir | grep "[0-9][0-9]r10\|raid10"))
+				;;
+			ddf )
+				TESTLIST=($(ls $testdir | grep "[0-9][0-9]ddf"))
+				;;
+			imsm )
+				TESTLIST=($(ls $testdir | grep "[0-9][0-9]imsm"))
+				;;
+			* )
+				echo "Unknown argument: $i"
+				do_help
+				exit 1
+				;;
+			esac
+			;;
 		--logdir=* )
 			logdir="${i##*=}"
 			;;
-- 
2.6.6

