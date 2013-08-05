From: mwilck@arcor.de
Subject: [PATCH 1/5] tests/env-ddf-template: some helper functions
Date: Mon,  5 Aug 2013 22:37:47 +0200
Message-ID: <1375735071-9160-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

helper functions to determine the list of devices in an array,
etc.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/env-ddf-template |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/tests/env-ddf-template b/tests/env-ddf-template
index fa7af1f..1c1ca12 100644
--- a/tests/env-ddf-template
+++ b/tests/env-ddf-template
@@ -1,3 +1,24 @@
+get_sysdir() {
+    local mddev=$1
+    [ -L $mddev ] && mddev=$(readlink -f $mddev)
+    echo "/sys/class/block/$(basename $mddev)/md"
+}
+
+get_raiddisks() {
+    sysdir=$(get_sysdir "$1")
+    for i in $(seq 0 $(($(cat $sysdir/raid_disks)-1))); do
+	if [ -d $sysdir/rd$i ]; then
+	    readlink -f /dev/block/$(cat $sysdir/rd$i/block/dev)
+	else
+	    echo MISSING
+        fi
+    done
+}
+
+get_present() {
+    get_raiddisks $1 | grep -vc MISSING
+}
+
 ddf_check() {
     udevadm settle
     case $1 in
-- 
1.7.1
