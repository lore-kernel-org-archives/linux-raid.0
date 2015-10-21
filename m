From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 3/3] mdadm: add test script for raid456 journal
Date: Wed, 21 Oct 2015 11:35:16 -0700
Message-ID: <1445452516-2816184-4-git-send-email-songliubraving@fb.com>
References: <1445452516-2816184-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1445452516-2816184-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, hch@infradead.org, dan.j.williams@intel.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 test                 |  9 ++++++++
 tests/20raid5journal | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)
 create mode 100644 tests/20raid5journal

diff --git a/test b/test
index d0a6cb8..13f1bda 100755
--- a/test
+++ b/test
@@ -246,6 +246,15 @@ check() {
        fi
       ;;
 
+    readonly )
+       grep -s "read-only" > /dev/null /proc/mdstat || {
+                echo >&2 "ERROR array is not read-only!"; cat /proc/mdstat ; exit 1; }
+      ;;
+
+    inactive )
+       grep -s "inactive" > /dev/null /proc/mdstat || {
+                echo >&2 "ERROR array is not inactive!"; cat /proc/mdstat ; exit 1; }
+      ;;
     * ) echo >&2 ERROR unknown check $1 ; exit 1;
    esac
 }
diff --git a/tests/20raid5journal b/tests/20raid5journal
new file mode 100644
index 0000000..f751ace
--- /dev/null
+++ b/tests/20raid5journal
@@ -0,0 +1,64 @@
+# check write journal of raid456
+
+# test --detail
+test_detail_shows_journal() {
+    mdadm -D $1 | grep journal || {
+        echo >&2 "ERROR --detail does show journal device!"; mdadm -D $1 ; exit 1; }
+}
+
+# test --examine
+test_examine_shows_journal() {
+    mdadm -E $1 | grep Journal || {
+        echo >&2 "ERROR --examine does show Journal device!"; mdadm -E $1 ; exit 1; }
+}
+
+# test --create
+create_with_journal_and_stop() {
+    mdadm -CR $md0 -l5 -n4 $dev0 $dev1 $dev2 $dev3 --write-journal $dev4
+    check wait
+    tar cf - /etc > $md0
+    ./raid6check $md0 0 0 | grep 'Error detected' && exit 1
+    test_detail_shows_journal $md0
+    test_examine_shows_journal $dev4
+    mdadm -S $md0
+}
+
+# test --assemble
+test_assemble() {
+    create_with_journal_and_stop
+    if mdadm -A $md0 $dev0 $dev1 $dev2 $dev3
+    then
+        echo >&2 "ERROR should return 1 when journal is missing!"; cat /proc/mdstat ; exit 1;
+    fi
+    mdadm -S $md0
+
+    mdadm -A $md0 $dev0 $dev1 $dev2 $dev3 --force
+    check readonly
+    mdadm -S $md0
+}
+
+# test --incremental
+test_incremental() {
+    create_with_journal_and_stop
+    for d in $dev0 $dev1 $dev2 $dev3
+    do
+        mdadm -I $d
+    done
+    check inactive
+    mdadm -I $dev4
+    check raid5
+    mdadm -S $md0
+
+    # test --incremental with journal missing
+    for d in $dev0 $dev1 $dev2 $dev3
+    do
+        mdadm -I $d
+    done
+    mdadm -R $md0
+    check readonly
+    mdadm -S $md0
+}
+
+create_with_journal_and_stop
+test_assemble
+test_incremental
-- 
2.4.6

