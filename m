From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 1/2] UT: imsm reshape test suite update
Date: Thu, 21 Apr 2011 23:56:31 +0100
Message-ID: <66C59AD0932712458090B447266D638C012892FC26@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Check if desired level has been reached is added.
Additionally missing spares for r0->r5 migration has been added.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 tests/16imsm-r0_3d-migrate-r5_4d |    1 +
 tests/16imsm-r0_5d-migrate-r5_6d |    1 +
 tests/env-imsm-template          |    7 +++++++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tests/16imsm-r0_3d-migrate-r5_4d b/tests/16imsm-r0_3d-migrate-r5_4d
index 4f45479..ac65031 100644
--- a/tests/16imsm-r0_3d-migrate-r5_4d
+++ b/tests/16imsm-r0_3d-migrate-r5_4d
@@ -5,6 +5,7 @@
 
 num_disks=3
 device_list="$dev0 $dev1 $dev2"
+spare_list="$dev3"
 
 # Before: RAID 0, 3 disks, 64k chunk size
 vol0_level=0
diff --git a/tests/16imsm-r0_5d-migrate-r5_6d b/tests/16imsm-r0_5d-migrate-r5_6d
index bee505b..8133fc5 100644
--- a/tests/16imsm-r0_5d-migrate-r5_6d
+++ b/tests/16imsm-r0_5d-migrate-r5_6d
@@ -5,6 +5,7 @@
 
 num_disks=5
 device_list="$dev0 $dev1 $dev2 $dev3 $dev4"
+spare_list="$dev5"
 
 # Before: RAID 0, 5 disks, 64k chunk size
 vol0_level=0
diff --git a/tests/env-imsm-template b/tests/env-imsm-template
index 30b73db..4c3d039 100644
--- a/tests/env-imsm-template
+++ b/tests/env-imsm-template
@@ -38,6 +38,13 @@ imsm_check() {
 		err=$((err + 1))
 	    fi
         done
+        #add prefix raid if only number is passed
+	[ "$t_level" -eq "$t_level" 2>/dev/null ] && t_level=raid$t_level
+        _level=`cat ${sysfs}/md/level`
+        if ! [ "$t_level" == $_level ]; then
+            echo "**Error**: Array level mismatch - expected $t_level, actual $_level" >&2
+            err=$((err + 1))
+        fi
         _size=`cat ${sysfs}/md/array_size`
         if [ $t_size -ne $_size ]; then
             echo "**Error**: Array size mismatch - expected $t_size, actual $_size" >&2
-- 
1.7.3.4
