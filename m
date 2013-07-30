From: mwilck@arcor.de
Subject: [PATCH 10/10] tests/10ddf-create-fail-rebuild: new unit test for DDF
Date: Tue, 30 Jul 2013 23:18:34 +0200
Message-ID: <1375219114-5626-11-git-send-email-mwilck@arcor.de>
References: <51F82D3B.6060104@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F82D3B.6060104@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

This test adds a new unit test similar to 009imsm-create-fail-rebuild.
With the previous patches, it actually succeeds on my system.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/10ddf-create-fail-rebuild |   77 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100644 tests/10ddf-create-fail-rebuild

diff --git a/tests/10ddf-create-fail-rebuild b/tests/10ddf-create-fail-rebuild
new file mode 100644
index 0000000..525c24d
--- /dev/null
+++ b/tests/10ddf-create-fail-rebuild
@@ -0,0 +1,77 @@
+# sanity check array creation
+
+ddf_check_hold() {
+   if mdadm --remove $1 $2; then
+       echo "$2 removal from $1 should have been blocked" >&2
+       cat /proc/mdstat >&2
+       mdadm -E $2
+       exit 1
+   fi
+}
+
+ddf_check_removal() {
+   if ! mdadm --remove $1 $2 ; then
+       echo "$2 removal from $1 should have succeeded" >&2
+       cat /proc/mdstat >&2
+       mdadm -E $2
+       exit 1
+   fi
+}
+
+. tests/env-ddf-template
+
+num_disks=2
+mdadm -CR $container -e ddf -n $num_disks $dev8 $dev9
+ddf_check container $num_disks
+
+# RAID0 + RAID1
+size=9000
+level=0
+chunk=64
+offset=0
+layout=0
+mdadm -CR $member0 $dev8 $dev9 -n $num_disks -l $level -z $size -c $chunk
+ddf_check member $member0 $num_disks $level $size $((size*2)) $offset $chunk $layout
+testdev $member0 $num_disks $size $chunk
+
+offset=$(((size & ~(chunk - 1))))
+size=4000
+level=1
+chunk=0
+mdadm -CR $member1 $dev8 $dev9 -n $num_disks -l $level -z $size
+ddf_check member $member1 $num_disks $level $size $size $offset $chunk $layout
+testdev $member1 1 $size 1
+check wait
+
+mdadm -Ss
+
+# RAID10 + RAID5
+num_disks=4
+mdadm -CR $container -e ddf -n $num_disks $dev8 $dev9 $dev10 $dev11
+ddf_check container $num_disks
+
+size=9000
+level=10
+chunk=64
+offset=0
+layout=2
+mdadm -CR $member0 $dev8 $dev9 $dev10 $dev11 -n $num_disks -l $level -z $size -c $chunk
+ddf_check member $member0 $num_disks $level $size $((size*2)) $offset $chunk $layout
+testdev $member0 $((num_disks-2)) $size $chunk
+
+offset=$(((size & ~(chunk - 1))))
+size=4000
+level=5
+mdadm -CR $member1 $dev8 $dev9 $dev10 $dev11 -n $num_disks -l $level -z $size -c $chunk
+ddf_check member $member1 $num_disks $level $size $((size*3)) $offset $chunk $layout
+testdev $member1 $((num_disks-1)) $size $chunk
+check wait
+
+# FAIL / REBUILD
+ddf_check_hold $container $dev8
+mdadm --fail $member0 $dev8
+mdadm --wait-clean --scan
+ddf_check_removal $container $dev8
+mdadm --add $container $dev12
+check wait
+ddf_check_hold $container $dev12
-- 
1.7.1
