From: Chen Rong <rongx.a.chen@intel.com>
Subject: [PATCH 2/2] tests/20raid5journal: fix test_incremental
Date: Thu, 17 Aug 2017 15:41:21 +0800
Message-ID: <1502955681-17313-2-git-send-email-rongx.a.chen@intel.com>
References: <1502955681-17313-1-git-send-email-rongx.a.chen@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1502955681-17313-1-git-send-email-rongx.a.chen@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Chen Rong <rongx.a.chen@intel.com>
List-Id: linux-raid.ids

Remove "check inactive", the result of /proc/mdstat is "active (read-only)",
Can not add $dev4 to a read only filesystem, so do "mdadm -I $dev4" first.

Signed-off-by: Chen Rong <rongx.a.chen@intel.com>
---
 tests/20raid5journal | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/20raid5journal b/tests/20raid5journal
index f751ace..fee6c0c 100644
--- a/tests/20raid5journal
+++ b/tests/20raid5journal
@@ -40,12 +40,11 @@ test_assemble() {
 # test --incremental
 test_incremental() {
     create_with_journal_and_stop
+    mdadm -I $dev4
     for d in $dev0 $dev1 $dev2 $dev3
     do
         mdadm -I $d
     done
-    check inactive
-    mdadm -I $dev4
     check raid5
     mdadm -S $md0
 
-- 
2.7.4

