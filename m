From: Jim Kukunas <james.t.kukunas@linux.intel.com>
Subject: [PATCH] lib/raid6: fix sparse warnings in recovery functions
Date: Wed, 23 May 2012 21:54:18 -0700
Message-ID: <1337835258-26903-1-git-send-email-james.t.kukunas@linux.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, fengguang.wu@intel.com
List-Id: linux-raid.ids

Make the recovery functions static to fix the following sparse warnings:

lib/raid6/recov.c:25:6: warning: symbol 'raid6_2data_recov_intx1' was
not declared. Should it be static?
lib/raid6/recov.c:69:6: warning: symbol 'raid6_datap_recov_intx1' was
not declared. Should it be static?
lib/raid6/recov_ssse3.c:22:6: warning: symbol 'raid6_2data_recov_ssse3'
was not declared. Should it be static?
lib/raid6/recov_ssse3.c:197:6: warning: symbol 'raid6_datap_recov_ssse3'
was not declared. Should it be static?

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 lib/raid6/recov.c       |    7 ++++---
 lib/raid6/recov_ssse3.c |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/raid6/recov.c b/lib/raid6/recov.c
index 1805a5c..a95bccb 100644
--- a/lib/raid6/recov.c
+++ b/lib/raid6/recov.c
@@ -22,8 +22,8 @@
 #include <linux/raid/pq.h>
 
 /* Recover two failed data blocks. */
-void raid6_2data_recov_intx1(int disks, size_t bytes, int faila, int failb,
-		       void **ptrs)
+static void raid6_2data_recov_intx1(int disks, size_t bytes, int faila,
+		int failb, void **ptrs)
 {
 	u8 *p, *q, *dp, *dq;
 	u8 px, qx, db;
@@ -66,7 +66,8 @@ void raid6_2data_recov_intx1(int disks, size_t bytes, int faila, int failb,
 }
 
 /* Recover failure of one data block plus the P block */
-void raid6_datap_recov_intx1(int disks, size_t bytes, int faila, void **ptrs)
+static void raid6_datap_recov_intx1(int disks, size_t bytes, int faila,
+		void **ptrs)
 {
 	u8 *p, *q, *dq;
 	const u8 *qmul;		/* Q multiplier table */
diff --git a/lib/raid6/recov_ssse3.c b/lib/raid6/recov_ssse3.c
index b77266f..ecb0289 100644
--- a/lib/raid6/recov_ssse3.c
+++ b/lib/raid6/recov_ssse3.c
@@ -19,8 +19,8 @@ static int raid6_has_ssse3(void)
 		boot_cpu_has(X86_FEATURE_SSSE3);
 }
 
-void raid6_2data_recov_ssse3(int disks, size_t bytes, int faila, int failb,
-		       void **ptrs)
+static void raid6_2data_recov_ssse3(int disks, size_t bytes, int faila,
+		int failb, void **ptrs)
 {
 	u8 *p, *q, *dp, *dq;
 	const u8 *pbmul;	/* P multiplier table for B data */
@@ -194,7 +194,8 @@ void raid6_2data_recov_ssse3(int disks, size_t bytes, int faila, int failb,
 }
 
 
-void raid6_datap_recov_ssse3(int disks, size_t bytes, int faila, void **ptrs)
+static void raid6_datap_recov_ssse3(int disks, size_t bytes, int faila,
+		void **ptrs)
 {
 	u8 *p, *q, *dq;
 	const u8 *qmul;		/* Q multiplier table */
-- 
1.7.8.6

