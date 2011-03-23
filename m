From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 2/2] FIX: Tests: raid0->raid10 without degradation
Date: Wed, 23 Mar 2011 16:04:28 +0100
Message-ID: <20110323150428.15226.95059.stgit@gklab-128-111.igk.intel.com>
References: <20110323150115.15226.20076.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110323150115.15226.20076.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

raid0->raid10 transition needs at least 2 spare devices.
After level changing to raid10 recovery is triggered on
failed (missing) disks. At the end of recovery process
we have fully operational (not degraded) raid10 array.

Initialy there was possibility to migrate raid0->raid10
without recovery triggering (it results degraded raid10).
Now it is not possible.
This patch adapt tests to new mdadm's behavior.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 tests/18imsm-r0_2d-takeover-r10_4d |    4 +++-
 tests/env-imsm-template            |    7 -------
 tests/imsm-grow-template           |    7 ++-----
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/tests/18imsm-r0_2d-takeover-r10_4d b/tests/18imsm-r0_2d-takeover-r10_4d
index a1c395b..51ad3fc 100644
--- a/tests/18imsm-r0_2d-takeover-r10_4d
+++ b/tests/18imsm-r0_2d-takeover-r10_4d
@@ -5,6 +5,7 @@
 
 num_disks=2
 device_list="$dev0 $dev1"
+spare_list="$dev2 $dev3"
 
 # Before: RAID 0 volume, 2 disks, 256k chunk size
 vol0_level=0
@@ -18,4 +19,5 @@ vol0_new_level=10
 vol0_new_num_comps=$vol0_num_comps
 vol0_new_chunk=128
 
-. tests/imsm-grow-template 0 1 1
+. tests/imsm-grow-template 0 1
+
diff --git a/tests/env-imsm-template b/tests/env-imsm-template
index 7a2890c..30b73db 100644
--- a/tests/env-imsm-template
+++ b/tests/env-imsm-template
@@ -13,7 +13,6 @@ imsm_check() {
         t_size=$6
         t_offset=$7
         t_chunk=$8
-	t_takeover10=$9
 
         err=0
 
@@ -27,13 +26,7 @@ imsm_check() {
             echo "**Error**: Chunk size mismatch - expected $t_chunk, actual $_chunk" >&2
             err=$((err + 1))
         fi
-	if [ ! -z $t_takeover10 ] ; then
-		t_num_disks=$(( t_num_disks * 2 ))
-	fi
         for i in `seq 0 $((t_num_disks - 1))`; do
-	    if [ ! -z $t_takeover10 ] && [ ! -z $(( $i % 2 )) ] ; then
-		continue
-	    fi
 	    _offset=`cat ${sysfs}/md/rd${i}/offset`
 	    if [ $t_offset -ne $((_offset / 2)) ]; then
 		echo "**Error**: Offset mismatch - expected $t_offset, actual $_offset" >&2
diff --git a/tests/imsm-grow-template b/tests/imsm-grow-template
index d03752d..191f056 100644
--- a/tests/imsm-grow-template
+++ b/tests/imsm-grow-template
@@ -5,9 +5,6 @@ negative_test=$1
 # 0 - On-line Capacity Expansion test, otherwise LEVEL migration or CHUNK size migration test
 migration_test=$2
 
-# 1 - raid0 -> raid10 takeover verification
-takeover10_test=$3
-
 function grow_member() {
 	local member=$1
 	local disks=$2
@@ -31,8 +28,8 @@ function grow_member() {
 	fi
 	check wait
 	sleep 5
-	imsm_check member $member $disks $level $size $array_size $offset $chunk $takeover10_test
-	testdev $member $comps $size $chunk $takeover10_test
+	imsm_check member $member $disks $level $size $array_size $offset $chunk
+	testdev $member $comps $size $chunk
 }
 
 # Create container

