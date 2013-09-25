From: mwilck@arcor.de
Subject: [PATCH 6/6] tests/10ddf-incremental-wrong-order: new unit test
Date: Wed, 25 Sep 2013 22:42:02 +0200
Message-ID: <1380141722-31454-3-git-send-email-mwilck@arcor.de>
References: <1380050242-31857-2-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1380050242-31857-2-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

This is a test simulating two temporary missing disks. These will
have less recent meta data than the other disks in the container.
When the array is reassembled, we expect mdadm to detect that
and react to it by using the meta data of the more recent disks
as reference.

This test FAILS with mdadm 3.3 for DDF.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/10ddf-incremental-wrong-order |  131 +++++++++++++++++++++++++++++++++++
 1 files changed, 131 insertions(+), 0 deletions(-)
 create mode 100644 tests/10ddf-incremental-wrong-order

diff --git a/tests/10ddf-incremental-wrong-order b/tests/10ddf-incremental-wrong-order
new file mode 100644
index 0000000..2324f1d
--- /dev/null
+++ b/tests/10ddf-incremental-wrong-order
@@ -0,0 +1,131 @@
+# An array is assembled incompletely. Some disks will
+# have later metadata than others.
+# The array is then reassembled in the "wrong" order -
+# older meta data first.
+# This FAILS with mdadm 3.3
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
+mke2fs $member0
+mke2fs $member1
+sha_0a=$(sha1_sum $member0)
+sha_1a=$(sha1_sum $member1)
+
+mdadm -Ss
+sleep 1
+
+# Add all devices except those for $member0
+mdadm -I $dev10
+mdadm -I $dev11
+
+# Start runnable members ($member1) and write
+mdadm -IRs
+e2fsck -fy $member1
+sha_1b=$(sha1_sum $member1)
+
+mdadm -Ss
+sleep 1
+
+# Seq number should be different now
+seq8a=$(mdadm -E $dev8 | sed -n 's/^ *Seq : //p')
+seq10a=$(mdadm -E $dev10 | sed -n 's/^ *Seq : //p')
+
+if [ $seq8a -ge $seq10a ]; then
+    ret=1
+    echo ERROR: sequential number of $dev10 not bigger than $dev8
+fi
+if [ x$sha_1a = x$sha_1b ]; then
+    ret=1
+    echo ERROR: sha1sums equal after write
+fi
+
+#[ -f /var/tmp/mdmon.log ] && cat /var/tmp/mdmon.log
+
+# Now reassemble 
+# Note that we add the previously missing disks first.
+# $dev10 should have a higher seq number than $dev8
+for d in $dev8 $dev9 $dev10 $dev11; do
+    mdadm -I $d  
+done
+
+mdadm -IRs
+sha_0c=$(sha1_sum $member0)
+sha_1c=$(sha1_sum $member1)
+
+mdadm -Ss
+sleep 1
+
+seq8c=$(mdadm -E $dev8 | sed -n 's/^ *Seq : //p')
+seq10c=$(mdadm -E $dev10 | sed -n 's/^ *Seq : //p')
+
+if [ x$sha_0a != x$sha_0c ]; then
+    ret=1
+    echo ERROR: sha1sum of $member0 has changed
+fi
+if [ x$sha_1b != x$sha_1c ]; then
+    ret=1
+    echo ERROR: sha1sum of $member1 has changed
+fi
+if [ \( $seq10a -ge $seq10c \) -o \( $seq8c -ne $seq10c \) ]; then
+    ret=1
+    echo ERROR: sequential numbers are wrong
+fi
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
+# Now try assembly
+if mdadm -A $container $dev8 $dev9 $dev10 $dev11; then
+    mdadm -IR $container
+    sha_0d=$(sha1_sum $member0)
+    sha_1d=$(sha1_sum $member1)
+    mdadm -Ss
+    sleep 1
+    seq8d=$(mdadm -E $dev8 | sed -n 's/^ *Seq : //p')
+    seq10d=$(mdadm -E $dev10 | sed -n 's/^ *Seq : //p')
+    if [ x$sha_0a != x$sha_0d ]; then
+	ret=1
+	echo ERROR: sha1sum of $member0 has changed
+    fi
+    if [ x$sha_1b != x$sha_1d ]; then
+	ret=1
+	echo ERROR: sha1sum of $member1 has changed
+    fi
+    if [ \( $seq10a -ge $seq10d \) -o \( $seq8d -ne $seq10d \) ]; then
+	ret=1
+	echo ERROR: sequential numbers are wrong
+    fi
+else
+    ret=1
+    echo ERROR: assembly failed
+fi
+
+if [ $ret -ne 0 ]; then
+    mdadm -E $dev10
+    mdadm -E $dev8
+fi
+rm -f $tmp /var/tmp/mdmon.log
+[ $ret -eq 0 ]
-- 
1.7.3.4
