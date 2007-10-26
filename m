From: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] raid6: clean up the style of raid6test/test.c
Date: Fri, 26 Oct 2007 11:22:42 -0700
Message-ID: <200710261829.l9QITA7L030413@tazenda.hos.anvin.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Ingo Molnar <mingo@redhat.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Clean up the coding style in raid6test/test.c.  Break it apart into
subfunctions to make the code more readable.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 drivers/md/raid6test/test.c |  117 +++++++++++++++++++++++++------------------
 1 files changed, 69 insertions(+), 48 deletions(-)

diff --git a/drivers/md/raid6test/test.c b/drivers/md/raid6test/test.c
index 0d5cd57..559cc41 100644
--- a/drivers/md/raid6test/test.c
+++ b/drivers/md/raid6test/test.c
@@ -1,12 +1,10 @@
 /* -*- linux-c -*- ------------------------------------------------------- *
  *
- *   Copyright 2002 H. Peter Anvin - All Rights Reserved
+ *   Copyright 2002-2007 H. Peter Anvin - All Rights Reserved
  *
- *   This program is free software; you can redistribute it and/or modify
- *   it under the terms of the GNU General Public License as published by
- *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
- *   Bostom MA 02111-1307, USA; either version 2 of the License, or
- *   (at your option) any later version; incorporated herein by reference.
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2 or (at your
+ *   option) any later version; incorporated herein by reference.
  *
  * ----------------------------------------------------------------------- */
 
@@ -30,67 +28,87 @@ char *dataptrs[NDISKS];
 char data[NDISKS][PAGE_SIZE];
 char recovi[PAGE_SIZE], recovj[PAGE_SIZE];
 
-void makedata(void)
+static void makedata(void)
 {
 	int i, j;
 
-	for (  i = 0 ; i < NDISKS ; i++ ) {
-		for ( j = 0 ; j < PAGE_SIZE ; j++ ) {
+	for (i = 0; i < NDISKS; i++) {
+		for (j = 0; j < PAGE_SIZE; j++)
 			data[i][j] = rand();
-		}
+
 		dataptrs[i] = data[i];
 	}
 }
 
+static char disk_type(int d)
+{
+	switch (d) {
+	case NDISKS-2:
+		return 'P';
+	case NDISKS-1:
+		return 'Q';
+	default:
+		return 'D';
+	}
+}
+
+static int test_disks(int i, int j)
+{
+	int erra, errb;
+
+	memset(recovi, 0xf0, PAGE_SIZE);
+	memset(recovj, 0xba, PAGE_SIZE);
+
+	dataptrs[i] = recovi;
+	dataptrs[j] = recovj;
+
+	raid6_dual_recov(NDISKS, PAGE_SIZE, i, j, (void **)&dataptrs);
+
+	erra = memcmp(data[i], recovi, PAGE_SIZE);
+	errb = memcmp(data[j], recovj, PAGE_SIZE);
+
+	if (i < NDISKS-2 && j == NDISKS-1) {
+		/* We don't implement the DQ failure scenario, since it's
+		   equivalent to a RAID-5 failure (XOR, then recompute Q) */
+		erra = errb = 0;
+	} else {
+		printf("algo=%-8s  faila=%3d(%c)  failb=%3d(%c)  %s\n",
+		       raid6_call.name,
+		       i, disk_type(i),
+		       j, disk_type(j),
+		       (!erra && !errb) ? "OK" :
+		       !erra ? "ERRB" :
+		       !errb ? "ERRA" : "ERRAB");
+	}
+
+	dataptrs[i] = data[i];
+	dataptrs[j] = data[j];
+
+	return erra || errb;
+}
+
 int main(int argc, char *argv[])
 {
-	const struct raid6_calls * const * algo;
+	const struct raid6_calls *const *algo;
 	int i, j;
-	int erra, errb;
+	int err = 0;
 
 	makedata();
 
-	for ( algo = raid6_algos ; *algo ; algo++ ) {
-		if ( !(*algo)->valid || (*algo)->valid() ) {
+	for (algo = raid6_algos; *algo; algo++) {
+		if (!(*algo)->valid || (*algo)->valid()) {
 			raid6_call = **algo;
 
 			/* Nuke syndromes */
 			memset(data[NDISKS-2], 0xee, 2*PAGE_SIZE);
 
 			/* Generate assumed good syndrome */
-			raid6_call.gen_syndrome(NDISKS, PAGE_SIZE, (void **)&dataptrs);
-
-			for ( i = 0 ; i < NDISKS-1 ; i++ ) {
-				for ( j = i+1 ; j < NDISKS ; j++ ) {
-					memset(recovi, 0xf0, PAGE_SIZE);
-					memset(recovj, 0xba, PAGE_SIZE);
-
-					dataptrs[i] = recovi;
-					dataptrs[j] = recovj;
-
-					raid6_dual_recov(NDISKS, PAGE_SIZE, i, j, (void **)&dataptrs);
-
-					erra = memcmp(data[i], recovi, PAGE_SIZE);
-					errb = memcmp(data[j], recovj, PAGE_SIZE);
-
-					if ( i < NDISKS-2 && j == NDISKS-1 ) {
-						/* We don't implement the DQ failure scenario, since it's
-						   equivalent to a RAID-5 failure (XOR, then recompute Q) */
-					} else {
-						printf("algo=%-8s  faila=%3d(%c)  failb=%3d(%c)  %s\n",
-						       raid6_call.name,
-						       i, (i==NDISKS-2)?'P':'D',
-						       j, (j==NDISKS-1)?'Q':(j==NDISKS-2)?'P':'D',
-						       (!erra && !errb) ? "OK" :
-						       !erra ? "ERRB" :
-						       !errb ? "ERRA" :
-						       "ERRAB");
-					}
-
-					dataptrs[i] = data[i];
-					dataptrs[j] = data[j];
-				}
-			}
+			raid6_call.gen_syndrome(NDISKS, PAGE_SIZE,
+						(void **)&dataptrs);
+
+			for (i = 0; i < NDISKS-1; i++)
+				for (j = i+1; j < NDISKS; j++)
+					err += test_disks(i, j);
 		}
 		printf("\n");
 	}
@@ -99,5 +117,8 @@ int main(int argc, char *argv[])
 	/* Pick the best algorithm test */
 	raid6_select_algo();
 
-	return 0;
+	if (err)
+		printf("\n*** ERRORS FOUND ***\n");
+
+	return err;
 }
-- 
1.5.3.4

