From: mwilck@arcor.de
Subject: [PATCH 3/5] tests/10ddf-fail-spare: new unit test
Date: Mon,  5 Aug 2013 22:37:49 +0200
Message-ID: <1375735071-9160-3-git-send-email-mwilck@arcor.de>
References: <1375735071-9160-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375735071-9160-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This is Albert Pauw's latest test. Note that this FAILS.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/10ddf-fail-spare |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)
 create mode 100644 tests/10ddf-fail-spare

diff --git a/tests/10ddf-fail-spare b/tests/10ddf-fail-spare
new file mode 100644
index 0000000..60e8110
--- /dev/null
+++ b/tests/10ddf-fail-spare
@@ -0,0 +1,37 @@
+# sanity check array creation
+. tests/env-ddf-template
+
+mdadm --zero-superblock $dev8 $dev9 $dev10 $dev11 $dev12 $dev13
+mdadm -CR $container -e ddf -l container -n 5 $dev8 $dev9 $dev10 $dev11 $dev12
+
+mdadm -CR $member0 -l raid1 -n 2 $container >/tmp/mdmon.txt 2>&1
+#$dir/mdadm -CR $member0 -l raid1 -n 2 $container >/tmp/mdmon.txt 2>&1
+
+check wait
+
+set -- $(get_raiddisks $member0)
+fail0=$1
+mdadm -f $member0 $fail0
+
+# need to sleep shortly here, to give monitor some time to active the spare
+sleep 0.5
+check wait
+
+if mdadm -CR $member1 -l raid5 -n 3 $container; then
+   echo error: create should have failed
+   set -- $(get_raiddisks $member0)
+   d0=$1
+   set -- $(get_raiddisks $member1)
+   d1=$1
+   cat /proc/mdstat
+   mdadm -E $d0
+   mdadm -E $d1
+   mdadm -E $fail0
+   rv=1
+#   cat /tmp/mdmon.txt
+else
+   rv=0
+fi
+
+#  rm -f /tmp/mdmon.txt
+exit $rv
-- 
1.7.1
