From: Xiao Ni <xni@redhat.com>
Subject: [PATCH -v4 1/1] mdadm/test: Add one test case for raid5 reshape
Date: Thu, 20 Jul 2017 15:58:53 +0800
Message-ID: <1500537533-8470-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com
List-Id: linux-raid.ids

This case tries to allow raid5 reshape to use backwards direction.
It changes chunksize after reshape and stops the raid. Then starts
the raid again.

Signed-off-by: Xiao Ni <xni@redhat.com>
Suggested-by:  Jes Sorensen <jes.sorensen@gmail.com>
Suggested-by:  Zhilong Liu <zlliu@suse.com>
Suggested-by:  Paul Menzel <pmenzel@molgen.mpg.de>
---
 test           |  7 +++++++
 tests/02r5grow | 17 +++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/test b/test
index 87e2df2..98e2981 100755
--- a/test
+++ b/test
@@ -320,6 +320,13 @@ check() {
 		grep -sq "inactive" /proc/mdstat ||
 			die "array is not inactive!"
 		;;
+	# It only can be used when there is only one raid
+	chunk )
+		chunk_size=`awk -F',' '/chunk/{print $2}' /proc/mdstat | awk -F'[a-z]' '{print $1}'`
+		if [ "$chunk_size" -ne "$2" ] ; then
+			die "chunksize should be $2, but it's $chunk_size"
+		fi
+		;;
 	* )
 		die "unknown check $1"
 		;;
diff --git a/tests/02r5grow b/tests/02r5grow
index 386e82e..ea3101b 100644
--- a/tests/02r5grow
+++ b/tests/02r5grow
@@ -34,3 +34,20 @@ check nosync
 sh tests/testdev $md0 3 $[size/2] 128
 
 mdadm -S $md0
+
+# create a raid5 array and change the chunk
+mdadm -CR $md0 --level raid5 --metadata=1.1 --chunk=32 --raid-disks 3 --size $[size/2] $dev1 $dev2 $dev3
+check wait
+check state UUU
+check chunk 32
+
+mdadm $md0 --grow --chunk=64
+check reshape
+check wait
+check chunk 64
+
+mdadm -S $md0
+mdadm -As
+check state UUU
+check chunk 64
+mdadm -Ss
-- 
2.7.4

