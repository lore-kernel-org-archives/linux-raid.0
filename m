From: mwilck@arcor.de
Subject: [PATCH 5/6] tests/10ddf-assemble-missing: new unit test
Date: Wed, 25 Sep 2013 22:42:01 +0200
Message-ID: <1380141722-31454-2-git-send-email-mwilck@arcor.de>
References: <1380050242-31857-2-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1380050242-31857-2-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This is a test case for handling incremental
assembly correctly after disks had been missing once.

This test is the basis for other similar but more tricky
test cases involving inconsitent meta data.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/10ddf-assemble-missing |   58 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 58 insertions(+), 0 deletions(-)
 create mode 100644 tests/10ddf-assemble-missing

diff --git a/tests/10ddf-assemble-missing b/tests/10ddf-assemble-missing
new file mode 100644
index 0000000..e36843f
--- /dev/null
+++ b/tests/10ddf-assemble-missing
@@ -0,0 +1,58 @@
+# An array is assembled incompletely.
+# The previously missing disks are then added again.
+# Nothing is written, so this should work cleanly.
+. tests/env-ddf-template
+tmp=$(mktemp /tmp/mdtest-XXXXXX)
+rm -f $tmp /var/tmp/mdmon.log
+ret=0
+
+mdadm -CR $container -e ddf -n 4 $dev8 $dev9 $dev10 $dev11
+ddf_check container 4
+
+mdadm -CR $member1 -n 4 -l 10 $dev8 $dev10 $dev9 $dev11 -z 10000
+mdadm -CR $member0 -n 2 -l 1 $dev8 $dev9 -z 10000
+
+mdadm --wait $member0
+mdadm --wait $member1
+
+mdadm -Ss
+sleep 1
+
+# Add all devices except those for $member0
+mdadm -I $dev10
+mdadm -I $dev11
+
+# Start runnable members
+mdadm -IRs
+mdadm -Ss
+
+#[ -f /var/tmp/mdmon.log ] && cat /var/tmp/mdmon.log
+
+# Now reassemble
+# This should work because BVDs weren't written to
+for d in $dev8 $dev9 $dev10 $dev11; do
+    mdadm -I $d
+done
+mdadm -Ss
+
+# Expect consistent state
+for d in $dev10 $dev8; do
+    mdadm -E $d>$tmp
+    for x in 0 1; do
+	egrep 'state\['$x'\] : Optimal, Consistent' $tmp || {
+	    ret=1
+	    echo ERROR: $member0 has unexpected state on $d
+	}
+    done
+    if [ x$(egrep -c 'active/Online$' $tmp) != x4 ]; then
+	ret=1
+	echo ERROR: unexpected number of online disks on $d
+    fi
+done
+
+if [ $ret -ne 0 ]; then
+    mdadm -E $dev10
+    mdadm -E $dev8
+fi
+rm -f $tmp /var/tmp/mdmon.log
+[ $ret -eq 0 ]
-- 
1.7.3.4
