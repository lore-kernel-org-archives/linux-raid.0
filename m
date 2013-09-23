From: mwilck@arcor.de
Subject: [PATCH 2/2] tests/10ddf-fail-stop-readd: New DDF unit test
Date: Mon, 23 Sep 2013 21:40:01 +0200
Message-ID: <1379965201-9108-2-git-send-email-mwilck@arcor.de>
References: <1379965201-9108-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1379965201-9108-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This is similar to 10ddf-fail-readd. The difference is that the
array is stopped and incrementally assembled before the disk is
re-added.
---
 tests/10ddf-fail-stop-readd |   66 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 tests/10ddf-fail-stop-readd

diff --git a/tests/10ddf-fail-stop-readd b/tests/10ddf-fail-stop-readd
new file mode 100644
index 0000000..4a0511a
--- /dev/null
+++ b/tests/10ddf-fail-stop-readd
@@ -0,0 +1,66 @@
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
+# Write to the array
+mke2fs $member0
+check wait
+
+set -- $(get_raiddisks $member0)
+fail0=$1
+mdadm $member0 --fail $fail0
+
+sleep 1
+mdadm $container --remove $fail0
+
+set -- $(get_raiddisks $member0)
+case $1 in MISSING) shift;; esac
+good0=$1
+
+mdadm -Ss
+
+sleep 1
+# Now simulate incremental assembly
+mdadm -I $good0
+mdadm -IRs
+
+# Write to the array
+mke2fs $member0
+
+# We re-add the disk now
+mdadm $container --add $fail0
+
+sleep 1
+mdadm --wait $member0
+
+ret=0
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
