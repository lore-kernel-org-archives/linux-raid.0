From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 3] md: raid6: Fix mktable.c
Date: Fri, 7 Dec 2007 16:41:45 +1100
Message-ID: <1071207054145.7870@suse.de>
References: <20071207163806.7539.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids


From: "H. Peter Anvin" <hpa@zytor.com>

Make both mktables.c and its output CodingStyle compliant.  Update the
copyright notice.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/mktables.c |   43 +++++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff .prev/drivers/md/mktables.c ./drivers/md/mktables.c
--- .prev/drivers/md/mktables.c	2007-12-03 14:47:09.000000000 +1100
+++ ./drivers/md/mktables.c	2007-12-03 14:56:06.000000000 +1100
@@ -1,13 +1,10 @@
-#ident "$Id: mktables.c,v 1.2 2002/12/12 22:41:27 hpa Exp $"
-/* ----------------------------------------------------------------------- *
+/* -*- linux-c -*- ------------------------------------------------------- *
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
 
@@ -73,8 +70,8 @@ int main(int argc, char *argv[])
 		for (j = 0; j < 256; j += 8) {
 			printf("\t\t");
 			for (k = 0; k < 8; k++)
-				printf("0x%02x, ", gfmul(i, j+k));
-			printf("\n");
+				printf("0x%02x,%c", gfmul(i, j + k),
+				       (k == 7) ? '\n' : ' ');
 		}
 		printf("\t},\n");
 	}
@@ -83,47 +80,41 @@ int main(int argc, char *argv[])
 	/* Compute power-of-2 table (exponent) */
 	v = 1;
 	printf("\nconst u8 __attribute__((aligned(256)))\n"
-		"raid6_gfexp[256] =\n"
-		"{\n");
+	       "raid6_gfexp[256] =\n" "{\n");
 	for (i = 0; i < 256; i += 8) {
 		printf("\t");
 		for (j = 0; j < 8; j++) {
-			exptbl[i+j] = v;
-			printf("0x%02x, ", v);
+			exptbl[i + j] = v;
+			printf("0x%02x,%c", v, (j == 7) ? '\n' : ' ');
 			v = gfmul(v, 2);
 			if (v == 1)
 				v = 0;	/* For entry 255, not a real entry */
 		}
-		printf("\n");
 	}
 	printf("};\n");
 
 	/* Compute inverse table x^-1 == x^254 */
 	printf("\nconst u8 __attribute__((aligned(256)))\n"
-		"raid6_gfinv[256] =\n"
-		"{\n");
+	       "raid6_gfinv[256] =\n" "{\n");
 	for (i = 0; i < 256; i += 8) {
 		printf("\t");
 		for (j = 0; j < 8; j++) {
-			v = gfpow(i+j, 254);
-			invtbl[i+j] = v;
-			printf("0x%02x, ", v);
+			invtbl[i + j] = v = gfpow(i + j, 254);
+			printf("0x%02x,%c", v, (j == 7) ? '\n' : ' ');
 		}
-		printf("\n");
 	}
 	printf("};\n");
 
 	/* Compute inv(2^x + 1) (exponent-xor-inverse) table */
 	printf("\nconst u8 __attribute__((aligned(256)))\n"
-		"raid6_gfexi[256] =\n"
-		"{\n");
+	       "raid6_gfexi[256] =\n" "{\n");
 	for (i = 0; i < 256; i += 8) {
 		printf("\t");
 		for (j = 0; j < 8; j++)
-			printf("0x%02x, ", invtbl[exptbl[i+j]^1]);
-		printf("\n");
+			printf("0x%02x,%c", invtbl[exptbl[i + j] ^ 1],
+			       (j == 7) ? '\n' : ' ');
 	}
-	printf("};\n\n");
+	printf("};\n");
 
 	return 0;
 }
