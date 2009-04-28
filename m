From: Dan Williams <dan.j.williams@intel.com>
Subject: [rfc] Proof-of-concept: refactoring raid6 recovery for the async
	case
Date: Tue, 28 Apr 2009 16:53:39 -0700
Message-ID: <1240962819.10249.2.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The goal of the following implementation is to demonstrate a proposed
re-factoring of the raid6 recovery code to isolate the operations that
can be accelerated by hardware.  These operations are xor,
gf-multiplication by a scalar (mult), and sum_product (the xor-sum of
two vectors multiplied by two scalars).

This version passes the tests from drivers/md/raid6test/test.c and
barring objections the approach (of course not this code) will be used
in the next version of the async-raid6 patchset.

Thanks,
Dan

diff --git a/drivers/md/raid6recov.c b/drivers/md/raid6recov.c
index 2609f00..68414d7 100644
--- a/drivers/md/raid6recov.c
+++ b/drivers/md/raid6recov.c
@@ -20,14 +20,42 @@
 
 #include <linux/raid/pq.h>
 
+static void sum_product(u8 *dest, u8 **srcs, u8 *coef, size_t bytes)
+{
+	const u8 *amul;
+	const u8 *bmul;
+	u8 ax;
+	u8 bx;
+	u8 *a = srcs[0];
+	u8 *b = srcs[1];
+
+	amul = raid6_gfmul[coef[0]];
+	bmul  = raid6_gfmul[coef[1]];
+
+	/* Now do it... */
+	while ( bytes-- ) {
+		ax    = amul[*a++];
+		bx    = bmul[*b++];
+		*dest++ = ax ^ bx;
+	}
+}
+
+static void xor(u8 *dest, u8 *src, size_t bytes)
+{
+	while (bytes--) {
+		*dest = *dest ^ *src;
+		dest++, src++;
+	}
+}
+
 /* Recover two failed data blocks. */
 void raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 		       void **ptrs)
 {
 	u8 *p, *q, *dp, *dq;
 	u8 px, qx, db;
-	const u8 *pbmul;	/* P multiplier table for B data */
-	const u8 *qmul;		/* Q multiplier table (for both) */
+	u8 *srcs[2];
+	u8 coef[2];
 
 	p = (u8 *)ptrs[disks-2];
 	q = (u8 *)ptrs[disks-1];
@@ -50,26 +78,36 @@ void raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 	ptrs[disks-2] = p;
 	ptrs[disks-1] = q;
 
-	/* Now, pick the proper data tables */
-	pbmul = raid6_gfmul[raid6_gfexi[failb-faila]];
-	qmul  = raid6_gfmul[raid6_gfinv[raid6_gfexp[faila]^raid6_gfexp[failb]]];
+	xor(dp, p, bytes);
+	xor(dq, q, bytes);
 
-	/* Now do it... */
-	while ( bytes-- ) {
-		px    = *p ^ *dp;
-		qx    = qmul[*q ^ *dq];
-		*dq++ = db = pbmul[px] ^ qx; /* Reconstructed B */
-		*dp++ = db ^ px; /* Reconstructed A */
-		p++; q++;
-	}
+	/* Now, pick the proper data tables */
+	coef[0] = raid6_gfexi[failb-faila];
+	coef[1] = raid6_gfinv[raid6_gfexp[faila]^raid6_gfexp[failb]];
+	srcs[0] = dp;
+	srcs[1] = dq;
+	sum_product(dq, srcs, coef, bytes);
+
+	/* dq is now reconstructed B */
+	xor(dp, dq, bytes);
 }
 EXPORT_SYMBOL_GPL(raid6_2data_recov);
 
+static void mult(u8 *dest, u8 *src, u8 coef, size_t bytes)
+{
+	const u8 *qmul;		/* Q multiplier table */
+
+	qmul  = raid6_gfmul[coef];
+
+	while (bytes--)
+		*dest++ = qmul[*src++];
+}
+
 /* Recover failure of one data block plus the P block */
 void raid6_datap_recov(int disks, size_t bytes, int faila, void **ptrs)
 {
 	u8 *p, *q, *dq;
-	const u8 *qmul;		/* Q multiplier table */
+	u8 coef;
 
 	p = (u8 *)ptrs[disks-2];
 	q = (u8 *)ptrs[disks-1];
@@ -87,13 +125,11 @@ void raid6_datap_recov(int disks, size_t bytes, int faila, void **ptrs)
 	ptrs[disks-1] = q;
 
 	/* Now, pick the proper data tables */
-	qmul  = raid6_gfmul[raid6_gfinv[raid6_gfexp[faila]]];
+	coef = raid6_gfinv[raid6_gfexp[faila]];
 
-	/* Now do it... */
-	while ( bytes-- ) {
-		*p++ ^= *dq = qmul[*q ^ *dq];
-		q++; dq++;
-	}
+	xor(dq, q, bytes);
+	mult(dq, dq, coef, bytes);
+	xor(p, dq, bytes);
 }
 EXPORT_SYMBOL_GPL(raid6_datap_recov);
 


