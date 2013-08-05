From: mwilck@arcor.de
Subject: [PATCH 2/5] tests/10ddf-fail-twice: remove hard-coded assumptions
Date: Mon,  5 Aug 2013 22:37:48 +0200
Message-ID: <1375735071-9160-2-git-send-email-mwilck@arcor.de>
References: <1375735071-9160-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375735071-9160-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This test has some randomness because it is not always deterministic
which of the two arrays gets the spare and which remains degraded.
Handle it.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/10ddf-fail-twice |   71 +++++++++++++++++++++++++-----------------------
 1 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/tests/10ddf-fail-twice b/tests/10ddf-fail-twice
index 042b77b..6023db6 100644
--- a/tests/10ddf-fail-twice
+++ b/tests/10ddf-fail-twice
@@ -1,23 +1,3 @@
-# sanity check array creation
-
-ddf_check_hold() {
-   if mdadm --remove $1 $2; then
-       echo "$2 removal from $1 should have been blocked" >&2
-       cat /proc/mdstat >&2
-       mdadm -E $2
-       exit 1
-   fi
-}
-
-ddf_check_removal() {
-   if ! mdadm --remove $1 $2 ; then
-       echo "$2 removal from $1 should have succeeded" >&2
-       cat /proc/mdstat >&2
-       mdadm -E $2
-       exit 1
-   fi
-}
-
 . tests/env-ddf-template
 
 num_disks=5
@@ -29,28 +9,51 @@ mdadm -CR $member1 -n 3 -l 5 $container
 
 mdadm --wait $member1 $member0 || mdadm --wait $member1 $member0
 
-mdadm $member0 --fail $dev11
-mdadm $member1 --fail $dev9
+set -- $(get_raiddisks $member0)
+fail0=$1
+mdadm $member0 --fail $fail0
+set -- $(get_raiddisks $member1)
+fail1=$1
+mdadm $member1 --fail $fail1
 
 mdadm $container --add $dev13
 
 mdadm --wait $member1 $member0 || mdadm --wait $member1 $member0
 
-{ grep -q 'external:/md127/1.*\[3/3\]' /proc/mdstat &&
-  grep -q 'external:/md127/0.*\[2/1\]' /proc/mdstat; } || {
-     echo unexpected states in /proc/mdstat
-     cat /proc/mdstat
-     mdadm -Ss
-     exit 1
+
+devs0="$(get_raiddisks $member0)"
+devs1="$(get_raiddisks $member1)"
+
+present=$(($(get_present $member0) + $(get_present $member1)))
+[ $present -eq 4 ] || {
+    echo expected 4 present disks, got $present
+    devices for $member0: $devs0
+    devices for $member1: $devs1
+    exit 1
 }
 
-{ mdadm -E $dev10 | grep -q 'state\[0\] : Degraded, Consistent' &&
-  mdadm -E $dev10 | grep -q 'state\[1\] : Optimal, Consistent'; } || {
-     echo unexpected meta data state
-     mdadm -E $dev10
-     mdadm -Ss
+if echo "$devs0" | grep -q MISSING; then
+    good=1
+    bad=0
+else
+    good=0
+    bad=1
+fi
+
+# find a good device
+eval "set -- \$devs$good"
+check=$1 
+
+tmp=$(mktemp /tmp/mdtest-XXXXXX)
+mdadm -E $check >$tmp
+
+{ grep -q 'state\['$bad'\] : Degraded, Consistent' $tmp &&
+  grep -q 'state\['$good'\] : Optimal, Consistent' $tmp; } || {
+     echo unexpected meta data state on $check
+     mdadm -E $check
+     rm -f $tmp
      exit 1
 }
 
-mdadm -Ss
+rm -f $tmp
 exit 0
-- 
1.7.1
