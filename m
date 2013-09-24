From: mwilck@arcor.de
Subject: [PATCH 3/3] tests/10ddf-fail-readd-readonly: new unit test.
Date: Tue, 24 Sep 2013 21:17:22 +0200
Message-ID: <1380050242-31857-2-git-send-email-mwilck@arcor.de>
References: <1380048798-31699-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1380048798-31699-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

A test for my recent patch "Monitor: write meta data in readonly state,
sometimes". Test that a faulty disk is recorded in the meta data.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/10ddf-fail-readd-readonly |   71 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)
 create mode 100644 tests/10ddf-fail-readd-readonly

diff --git a/tests/10ddf-fail-readd-readonly b/tests/10ddf-fail-readd-readonly
new file mode 100644
index 0000000..ed24585
--- /dev/null
+++ b/tests/10ddf-fail-readd-readonly
@@ -0,0 +1,71 @@
+# Simple fail / re-add test
+. tests/env-ddf-template
+
+tmp=$(mktemp /tmp/mdtest-XXXXXX)
+rm -f $tmp
+
+mdadm --zero-superblock $dev8 $dev9
+mdadm -CR $container -e ddf -l container -n 2 $dev8 $dev9
+
+mdadm -CR $member0 -l raid1 -n 2 $container
+#$dir/mdadm -CR $member0 -l raid1 -n 2 $container >/tmp/mdmon.txt 2>&1
+
+check wait
+
+set -- $(get_raiddisks $member0)
+fail0=$1
+mdadm $member0 --fail $fail0
+
+sleep 1
+set -- $(get_raiddisks $member0)
+case $1 in MISSING) shift;; esac
+good0=$1
+
+# Check that the meta data now show one disk as failed
+ret=0
+for x in $@; do
+    mdadm -E $x  >$tmp
+    if ! grep -q 'state\[0\] : Degraded, Consistent' $tmp; then
+	echo ERROR: member 0 should be degraded in meta data on $x
+	ret=1
+    fi
+    phys=$(grep $x $tmp)
+    case $x:$phys in
+    $fail0:*active/Offline,\ Failed);;
+    $good0:*active/Online);;
+    *) echo ERROR: wrong phys disk state for $x
+       ret=1
+       ;;
+    esac
+done
+
+mdadm $container --remove $fail0
+
+# We re-add the disk now
+mdadm $container --add $fail0
+
+sleep 1
+mdadm --wait $member0
+
+set -- $(get_raiddisks $member0)
+case $1:$2 in
+    $dev8:$dev9|$dev9:$dev8);;
+    *) echo ERROR: bad raid disks "$@"; ret=1;;
+esac
+
+mdadm -Ss
+for x in $@; do
+    mdadm -E $x  >$tmp
+    if ! grep -q 'state\[0\] : Optimal, Consistent' $tmp; then
+	echo ERROR: member 0 should be optimal in meta data on $x
+	ret=1
+    fi
+done
+
+rm -f $tmp
+if [ $ret -ne 0 ]; then
+    mdadm -E $dev8
+    mdadm -E $dev9
+fi
+
+[ $ret -eq 0 ]
-- 
1.7.3.4
