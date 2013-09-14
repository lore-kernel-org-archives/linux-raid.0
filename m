From: mwilck@arcor.de
Subject: [PATCH 1/3] DDF tests: allow to run on systems without /dev/sda
Date: Sat, 14 Sep 2013 22:47:10 +0200
Message-ID: <1379191632-32719-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Some ddf tests scripts assume that /dev/sda is always present.
That's wrong e.g. on VMs. Use a more general approach.
---
 tests/10ddf-create          |   10 ++++++----
 tests/10ddf-fail-two-spares |    5 +++--
 tests/env-ddf-template      |    9 +++++++++
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/tests/10ddf-create b/tests/10ddf-create
index 50c85ae..2f7747c 100644
--- a/tests/10ddf-create
+++ b/tests/10ddf-create
@@ -9,6 +9,8 @@
 # add some data, tear down the array, reassemble
 # and make sure it is still there.
 set -e
+. tests/env-ddf-template
+sda=$(get_rootdev) || exit 1
 
 mdadm -CR /dev/md/ddf0 -e ddf -n 5 $dev8 $dev9 $dev10 $dev11 $dev12
 mdadm -CR r5 -l5 -n5 /dev/md/ddf0 -z 5000
@@ -23,10 +25,10 @@ testdev /dev/md/r10 2 5000 512
 # r0/r10 will use 4608 due to chunk size, so that leaves 23552 for the rest
 testdev /dev/md/r1 1 23552 64
 testdev /dev/md/r0 3 23552 512
-dd if=/dev/sda of=/dev/md/r0 || true
-dd if=/dev/sda of=/dev/md/r10 || true
-dd if=/dev/sda of=/dev/md/r1 || true
-dd if=/dev/sda of=/dev/md/r5 || true
+dd if=$sda of=/dev/md/r0 || true
+dd if=$sda of=/dev/md/r10 || true
+dd if=$sda of=/dev/md/r1 || true
+dd if=$sda of=/dev/md/r5 || true
 
 s0=`sha1sum /dev/md/r0`
 s10=`sha1sum /dev/md/r10`
diff --git a/tests/10ddf-fail-two-spares b/tests/10ddf-fail-two-spares
index cc2cbb4..fa6e2e8 100644
--- a/tests/10ddf-fail-two-spares
+++ b/tests/10ddf-fail-two-spares
@@ -1,5 +1,6 @@
 # Simulate two disks failing shorty after each other
 . tests/env-ddf-template
+sda=$(get_rootdev) || exit 1
 tmp=$(mktemp /tmp/mdtest-XXXXXX)
 
 mdadm --zero-superblock $dev8 $dev9 $dev10 $dev11 $dev12 $dev13
@@ -13,8 +14,8 @@ mdadm -CR $member0 -l raid6 -n 4 $dev10 $dev11 $dev12 $dev13 -z 16384
 #	    >/tmp/mdmon.txt 2>&1
 mdadm -CR $member1 -l raid10 -n 4 $dev10 $dev11 $dev12 $dev13 -z 16384
 
-dd if=/dev/sda of=$member0 bs=1M
-dd if=/dev/sda of=$member1 bs=1M skip=16
+dd if=$sda of=$member0 bs=1M
+dd if=$sda of=$member1 bs=1M skip=16
 
 check wait
 
diff --git a/tests/env-ddf-template b/tests/env-ddf-template
index 1c1ca12..aa57fab 100644
--- a/tests/env-ddf-template
+++ b/tests/env-ddf-template
@@ -1,3 +1,12 @@
+get_rootdev() {
+    local dev=$(stat -c %D /)
+    local maj=$(expr $dev : '\(..\)')
+    local min=${dev#$maj}
+    local bd=/dev/$(basename $(readlink /sys/dev/block/$((0x$maj)):$((0x$min))))
+    [ -b $bd ] || exit 1
+    echo $bd
+}
+
 get_sysdir() {
     local mddev=$1
     [ -L $mddev ] && mddev=$(readlink -f $mddev)
-- 
1.7.3.4
