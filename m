From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 3] md: raid6: clean up the style of raid6test/test.c
Date: Fri, 7 Dec 2007 16:41:53 +1100
Message-ID: <1071207054153.7890@suse.de>
References: <20071207163806.7539.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids


From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 26 Oct 2007 11:22:42 -0700

Clean up the coding style in raid6test/test.c.  Break it apart into
subfunctions to make the code more readable.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid6test/test.c |  115 ++++++++++++++++++++++++------------------
 1 file changed, 68 insertions(+), 47 deletions(-)

diff .prev/drivers/md/raid6test/test.c ./drivers/md/raid6test/test.c
--- .prev/drivers/md/raid6test/test.c	2007-12-03 14:57:55.000000000 +1100
+++ ./drivers/md/raid6test/test.c	2007-12-03 14:57:55.000000000 +1100
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
+			raid6_call.gen_syndrome(NDISKS, PAGE_SIZE,
+						(void **)&dataptrs);
 
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
