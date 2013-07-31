From: mwilck@arcor.de
Subject: [PATCH] tests/env-ddf-template: helper for new unit test
Date: Wed, 31 Jul 2013 07:36:32 +0200
Message-ID: <1375248992-7130-1-git-send-email-mwilck@arcor.de>
References: <1375219114-5626-11-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375219114-5626-11-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

I forgot to check in this helper script, similar to the one for IMSM.
It is needed by tests/10ddf-create-fail-rebuild.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 tests/env-ddf-template |   76 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)
 create mode 100644 tests/env-ddf-template

diff --git a/tests/env-ddf-template b/tests/env-ddf-template
new file mode 100644
index 0000000..28e19d0
--- /dev/null
+++ b/tests/env-ddf-template
@@ -0,0 +1,76 @@
+ddf_check() {
+    udevadm settle
+    case $1 in
+    container )
+        grep -s "blocks super external:ddf" /proc/mdstat > /dev/null || {
+            echo >&2 "**Fatal** Correctly formed container not found"; cat /proc/mdstat; exit 1; }
+        ;;
+    member )
+        t_member=$2
+        t_num_disks=$3
+        t_level=$4
+        t_rd_size=$5
+        t_size=$6
+        t_offset=$7
+        t_chunk=$8
+	t_layout=$9
+	
+	if [ $t_chunk -ne 0 ]; then
+	    t_rd_size=$((t_rd_size & ~(t_chunk - 1)))
+        fi
+	case $t_level in
+	0) t_size=$((t_num_disks*$t_rd_size));;
+	1) t_size=$t_rd_size;;
+	4|5) t_size=$(((t_num_disks-1)*$t_rd_size));;
+	6) t_size=$(((t_num_disks-2)*$t_rd_size));;
+	10) t_size=$((t_num_disks*$t_rd_size/t_layout));;
+	esac
+
+        err=0
+
+        eval `stat -L -c "let major=0x%t; let minor=0x%T;" $t_member`
+        sysfs=/sys/dev/block/${major}:${minor}
+        if [ ! -f ${sysfs}/md/array_state ]; then
+            echo "**Fatal**: Array member $t_member not found" >&2; cat /proc/mdstat >&2; exit 1
+        fi
+        _chunk=`cat ${sysfs}/md/chunk_size`
+        if [ $t_chunk -ne $((_chunk/1024)) ]; then
+            echo "**Error**: Chunk size mismatch - expected $t_chunk, actual $_chunk" >&2
+            err=$((err + 1))
+        fi
+        for i in `seq 0 $((t_num_disks - 1))`; do
+	    _offset=`cat ${sysfs}/md/rd${i}/offset`
+	    if [ $t_offset -ne $((_offset / 2)) ]; then
+		echo "**Error**: Offset mismatch - expected $t_offset, actual $((_offset/2))" >&2
+		err=$((err + 1))
+	    fi
+	    _rd_size=`cat ${sysfs}/md/rd${i}/size`
+	    if [ $t_rd_size -ne $_rd_size ]; then
+		echo "**Error**: Component size mismatch - expected $t_rd_size, actual $_rd_size" >&2
+		err=$((err + 1))
+	    fi
+        done
+        _size=`cat ${sysfs}/md/array_size`
+	[ o$_size = odefault ] && _size=$(($(cat ${sysfs}/size)/2))
+        if [ $t_size -ne $_size ]; then
+            echo "**Error**: Array size mismatch - expected $t_size, actual $_size" >&2
+            err=$((err + 1))
+        fi
+        if [ $err -gt 0 ]; then
+            echo "$t_member failed check" >&2
+            cat /proc/mdstat >&2
+            mdadm -E /dev/loop8 >&2
+            exit 1
+        fi
+        ;;
+    * )
+        echo >&2 "**Error** unknown check $1"; exit 1;
+    esac
+}
+
+container=/dev/md/ddf
+member0=/dev/md/vol0
+member1=/dev/md/vol1
+member2=/dev/md/vol2
+member3=/dev/md/vol3
+member4=/dev/md/vol4
-- 
1.7.1
