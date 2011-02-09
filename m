From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH] imsm: Test for raid1 -> raid0 takeover added
Date: Wed, 09 Feb 2011 13:55:18 +0100
Message-ID: <20110209125518.6363.83824.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Patch introduces test for raid1 to raid0 takeover operation
verification for imsm metadata format.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 tests/18imsm-r1_2d-takeover-r0_1d |   22 ++++++++++++++++++++++
 tests/imsm-grow-template          |    2 +-
 2 files changed, 23 insertions(+), 1 deletions(-)
 create mode 100644 tests/18imsm-r1_2d-takeover-r0_1d

diff --git a/tests/18imsm-r1_2d-takeover-r0_1d b/tests/18imsm-r1_2d-takeover-r0_1d
new file mode 100644
index 0000000..1697d60
--- /dev/null
+++ b/tests/18imsm-r1_2d-takeover-r0_1d
@@ -0,0 +1,22 @@
+. tests/env-imsm-template
+
+# RAID 1 volume, 2 disks change to RAID 0 volume, 1 disks
+# POSITIVE test
+
+num_disks=2
+device_list="$dev0 $dev1"
+
+# Before: RAID 1 volume, 2 disks
+vol0_level=1
+vol0_comp_size=$((5 * 1024))
+vol0_chunk=64
+vol0_num_comps=$(( $num_disks - 1 )) 
+vol0_offset=0
+
+# After: RAID 0 volume, 1 disks, 64k chunk size
+vol0_new_level=0
+vol0_new_num_comps=1
+vol0_new_chunk=64
+new_num_disks=0
+
+. tests/imsm-grow-template 0 1
diff --git a/tests/imsm-grow-template b/tests/imsm-grow-template
index 0944d09..7c212c4 100644
--- a/tests/imsm-grow-template
+++ b/tests/imsm-grow-template
@@ -78,7 +78,7 @@ if [ $migration_test -ne 0 ]; then
 		new_num_disks=$num_disks
 	fi
 	grow_member $member0 $new_num_disks $vol0_new_num_comps $vol0_new_level $vol0_comp_size $vol0_offset $vol0_new_chunk
-	if [ $vol1_new_chunk -ne 0 ]; then
+	if [[ $vol1_new_chunk -ne 0 ]] ; then
 		grow_member $member1 $new_num_disks $vol1_new_num_comps $vol1_new_level $vol1_comp_size $vol1_offset $vol1_new_chunk
 	fi
 else

