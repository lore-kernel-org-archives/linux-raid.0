From: mwilck@arcor.de
Subject: [PATCH 4/4] tests/10ddf-fail-twice: New unit test
Date: Fri,  2 Aug 2013 00:35:17 +0200
Message-ID: <1375396517-8479-4-git-send-email-mwilck@arcor.de>
References: <1375396517-8479-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375396517-8479-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This is the test by Albert Pauw. Fail 2 disks, and add one.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/10ddf-fail-twice |   56 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)
 create mode 100644 tests/10ddf-fail-twice

diff --git a/tests/10ddf-fail-twice b/tests/10ddf-fail-twice
new file mode 100644
index 0000000..269b424
--- /dev/null
+++ b/tests/10ddf-fail-twice
@@ -0,0 +1,56 @@
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
+num_disks=5
+mdadm -CR $container -e ddf -n $num_disks $dev8 $dev9 $dev10 $dev11 $dev12
+ddf_check container $num_disks
+
+mdadm -CR $member0 -n 2 -l 1 $container
+mdadm -CR $member1 -n 3 -l 5 $container
+
+mdadm --wait $member1 $member0 || mdadm --wait $member1 $member0
+
+mdadm $member0 --fail $dev11
+mdadm $member1 --fail $dev9
+
+mdadm $container --add $dev13
+
+mdadm --wait $member1 $member0 || mdadm --wait $member1 $member0
+
+{ grep -q 'external:/md127/1.*\[3/3\]' /proc/mdstat && 
+  grep -q 'external:/md127/0.*\[2/1\]' /proc/mdstat; } || {
+     echo unexpected states in /proc/mdstat
+     cat /proc/mdstat
+     mdadm -Ss
+     exit 1
+}
+
+{ mdadm -E $dev10 | grep -q 'state\[0\] : Degraded, Consistent' &&
+  mdadm -E $dev10 | grep -q 'state\[1\] : Optimal, Consistent'; } || {
+     echo unexpected meta data state
+     mdadm -E $dev10
+     mdadm -Ss
+     exit 1
+}
+
+mdadm -Ss
+exit 0
-- 
1.7.1
