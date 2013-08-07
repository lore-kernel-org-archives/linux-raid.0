From: mwilck@arcor.de
Subject: [PATCH] tests/10ddf-fail-two-spares: new unit test
Date: Wed,  7 Aug 2013 22:38:03 +0200
Message-ID: <1375907883-8202-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This is one more unit test for failure/recovery, this time with
double redundancy, which isn't covered by the other tests.
---
 tests/10ddf-fail-two-spares |   85 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 85 insertions(+), 0 deletions(-)
 create mode 100644 tests/10ddf-fail-two-spares

diff --git a/tests/10ddf-fail-two-spares b/tests/10ddf-fail-two-spares
new file mode 100644
index 0000000..cc2cbb4
--- /dev/null
+++ b/tests/10ddf-fail-two-spares
@@ -0,0 +1,85 @@
+# Simulate two disks failing shorty after each other
+. tests/env-ddf-template
+tmp=$(mktemp /tmp/mdtest-XXXXXX)
+
+mdadm --zero-superblock $dev8 $dev9 $dev10 $dev11 $dev12 $dev13
+mdadm -CR $container -e ddf -l container -n 6 \
+      $dev8 $dev9 $dev10 $dev11 $dev12 $dev13
+
+#fast_sync
+
+mdadm -CR $member0 -l raid6 -n 4 $dev10 $dev11 $dev12 $dev13 -z 16384
+#$dir/mdadm -CR $member0 -l raid6 -n 4 $dev10 $dev11 $dev12 $dev13  -z 16384 \
+#	    >/tmp/mdmon.txt 2>&1
+mdadm -CR $member1 -l raid10 -n 4 $dev10 $dev11 $dev12 $dev13 -z 16384
+
+dd if=/dev/sda of=$member0 bs=1M
+dd if=/dev/sda of=$member1 bs=1M skip=16
+
+check wait
+
+sum0=$(sha1sum $member0)
+sum1=$(sha1sum $member1)
+
+mdadm --fail $member1 $dev11
+sleep 1
+mdadm --fail $member1 $dev12
+
+# We will have 4 resync procedures, 2 spares for 2 arrays.
+mdadm --wait $member1 $member0
+mdadm --wait $member1 $member0
+
+devs0="$(get_raiddisks $member0)"
+devs1="$(get_raiddisks $member1)"
+expected="$dev10
+$dev13
+$dev8
+$dev9"
+
+ret=0
+if [ "$(echo "$devs0" | sort)" != "$expected" \
+   -o "$(echo "$devs1" | sort)" != "$expected" ]; then
+    echo ERROR: unexpected members
+    echo $member0: $devs0
+    echo $member1: $devs1
+    ret=1
+fi
+
+mdadm -E $dev10 >$tmp
+if ! grep -q 'state\[0\] : Optimal, Consistent' $tmp; then
+    echo ERROR: $member0 should be optimal in meta data
+    ret=1
+fi
+if ! grep -q 'state\[1\] : Optimal, Consistent' $tmp; then
+    echo ERROR: $member1 should be optimal in meta data
+    ret=1
+fi
+if [ x"$(grep -c active/Online $tmp)" != x4 ]; then
+    echo ERROR: expected 4 online disks
+    ret=1
+fi
+if [ x"$(grep -c "Offline, Failed" $tmp)" != x2 ]; then
+    echo ERROR: expected 2 failed disks
+    ret=1
+fi
+
+sum0a=$(sha1sum $member0)
+sum1a=$(sha1sum $member1)
+
+if [ "$sum0" != "$sum0a" -o "$sum1" != "$sum1a" ]; then
+   echo ERROR: checksum mismatch
+   ret=1
+fi
+
+if [ $ret -eq 1 ]; then
+    cat /proc/mdstat
+    cat $tmp
+fi
+
+[ -f /tmp/mdmon.txt ] && {
+  cat /tmp/mdmon.txt
+  rm -f /tmp/mdmon.txt
+}
+rm -f $tmp
+
+[ $ret -eq 0 ]
-- 
1.7.1
