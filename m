From: <stockhausen@collogia.de>
Subject: [PATCH v1 8/8]     raid6 algorithms: xor_syndrome() for SSE2
Date: Sun, 10 Aug 2014 11:57:11 +0000
Message-ID: <cee09be7-f723-4b7d-8d1f-50fe75ed431e@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-536bb4c3-4d62-40ab-a149-076518efa84d"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-536bb4c3-4d62-40ab-a149-076518efa84d
Content-Type: text/plain

commit 7f663c35e25822fbbe407a605c0a9765d8133cc2
Author: Markus Stockhausen <markus.stockhausen@collogia.de>
Date:   Sun Aug 10 09:50:19 2014 +0000

    raid6 algorithms: xor_syndrome() for SSE2
    
    The second and (last) optimized XOR syndrome calculation. This version
    supports right and left side optimization. All CPUs with architecture
    older than Haswell will benefit from it.
    
    It should be noted that SSE2 movntdq kills performance for memory areas
    that are read and written simultaneously in chunks smaller than cache
    line size. So use movdqa instead for P/Q writes in sse21 and sse22 XOR
    functions.

diff --git a/lib/raid6/sse2.c b/lib/raid6/sse2.c
index 7ec2b6e..f7ddabc 100644
--- a/lib/raid6/sse2.c
+++ b/lib/raid6/sse2.c
@@ -91,7 +91,49 @@ static void raid6_sse21_gen_syndrome(int disks, size_t bytes, void **ptrs)
 static void raid6_sse21_xor_syndrome(int disks, int start, int stop,
 				     size_t bytes, void **ptrs)
 {
-	/* enable hasxor if implemented */
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	int d, z, z0;
+
+	z0 = stop;		/* P/Q right side optimization */
+	p = dptr[disks-2];	/* XOR parity */
+	q = dptr[disks-1];	/* RS syndrome */
+
+	kernel_fpu_begin();
+
+	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
+
+	for ( d = 0 ; d < bytes ; d += 16 ) {
+		asm volatile("movdqa %0,%%xmm4" :: "m" (dptr[z0][d]));
+		asm volatile("movdqa %0,%%xmm2" : : "m" (p[d]));
+		asm volatile("pxor %xmm4,%xmm2");
+		/* P/Q data pages */
+		for ( z = z0-1 ; z >= start ; z-- ) {
+			asm volatile("pxor %xmm5,%xmm5");
+			asm volatile("pcmpgtb %xmm4,%xmm5");
+			asm volatile("paddb %xmm4,%xmm4");
+			asm volatile("pand %xmm0,%xmm5");
+			asm volatile("pxor %xmm5,%xmm4");
+			asm volatile("movdqa %0,%%xmm5" :: "m" (dptr[z][d]));
+			asm volatile("pxor %xmm5,%xmm2");
+			asm volatile("pxor %xmm5,%xmm4");
+		}
+		/* P/Q left side optimization */
+		for ( z = start-1 ; z >= 0 ; z-- ) {
+			asm volatile("pxor %xmm5,%xmm5");
+			asm volatile("pcmpgtb %xmm4,%xmm5");
+			asm volatile("paddb %xmm4,%xmm4");
+			asm volatile("pand %xmm0,%xmm5");
+			asm volatile("pxor %xmm5,%xmm4");
+		}
+		asm volatile("pxor %0,%%xmm4" : : "m" (q[d]));
+		/* Don't use movntdq for r/w memory area < cache line */
+		asm volatile("movdqa %%xmm4,%0" : "=m" (q[d]));
+		asm volatile("movdqa %%xmm2,%0" : "=m" (p[d]));
+	}
+
+	asm volatile("sfence" : : : "memory");
+	kernel_fpu_end();
 }
 
 const struct raid6_calls raid6_sse2x1 = {
@@ -100,7 +142,7 @@ const struct raid6_calls raid6_sse2x1 = {
 	raid6_have_sse2,
 	"sse2x1",
 	1,			/* Has cache hints */
-	0			/* XOR not yet implemented */
+	1
 };
 
 /*
@@ -161,7 +203,68 @@ static void raid6_sse22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 static void raid6_sse22_xor_syndrome(int disks, int start, int stop,
 				     size_t bytes, void **ptrs)
 {
-	/* enable hasxor if implemented */
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	int d, z, z0;
+
+	z0 = stop;		/* P/Q right side optimization */
+	p = dptr[disks-2];	/* XOR parity */
+	q = dptr[disks-1];	/* RS syndrome */
+
+	kernel_fpu_begin();
+
+	asm volatile("movdqa %0,%%xmm0" : : "m" (raid6_sse_constants.x1d[0]));
+
+	for ( d = 0 ; d < bytes ; d += 32 ) {
+		asm volatile("movdqa %0,%%xmm4" :: "m" (dptr[z0][d]));
+		asm volatile("movdqa %0,%%xmm6" :: "m" (dptr[z0][d+16]));
+		asm volatile("movdqa %0,%%xmm2" : : "m" (p[d]));
+		asm volatile("movdqa %0,%%xmm3" : : "m" (p[d+16]));
+		asm volatile("pxor %xmm4,%xmm2");
+		asm volatile("pxor %xmm6,%xmm3");
+		/* P/Q data pages */
+		for ( z = z0-1 ; z >= start ; z-- ) { 
+			asm volatile("pxor %xmm5,%xmm5");
+			asm volatile("pxor %xmm7,%xmm7");
+			asm volatile("pcmpgtb %xmm4,%xmm5");
+			asm volatile("pcmpgtb %xmm6,%xmm7");
+			asm volatile("paddb %xmm4,%xmm4");
+			asm volatile("paddb %xmm6,%xmm6");
+			asm volatile("pand %xmm0,%xmm5");
+			asm volatile("pand %xmm0,%xmm7");
+			asm volatile("pxor %xmm5,%xmm4");
+			asm volatile("pxor %xmm7,%xmm6");
+			asm volatile("movdqa %0,%%xmm5" :: "m" (dptr[z][d]));
+			asm volatile("movdqa %0,%%xmm7" :: "m" (dptr[z][d+16]));
+			asm volatile("pxor %xmm5,%xmm2");
+			asm volatile("pxor %xmm7,%xmm3");
+			asm volatile("pxor %xmm5,%xmm4");
+			asm volatile("pxor %xmm7,%xmm6");
+		}
+		/* P/Q left side optimization */
+		for ( z = start-1 ; z >= 0 ; z-- ) {
+			asm volatile("pxor %xmm5,%xmm5");
+			asm volatile("pxor %xmm7,%xmm7");
+			asm volatile("pcmpgtb %xmm4,%xmm5");
+			asm volatile("pcmpgtb %xmm6,%xmm7");
+			asm volatile("paddb %xmm4,%xmm4");
+			asm volatile("paddb %xmm6,%xmm6");
+			asm volatile("pand %xmm0,%xmm5");
+			asm volatile("pand %xmm0,%xmm7");
+			asm volatile("pxor %xmm5,%xmm4");
+			asm volatile("pxor %xmm7,%xmm6");
+		}
+		asm volatile("pxor %0,%%xmm4" : : "m" (q[d]));
+		asm volatile("pxor %0,%%xmm6" : : "m" (q[d+16]));
+		/* Don't use movntdq for r/w memory area < cache line */
+		asm volatile("movdqa %%xmm4,%0" : "=m" (q[d]));
+		asm volatile("movdqa %%xmm6,%0" : "=m" (q[d+16]));
+		asm volatile("movdqa %%xmm2,%0" : "=m" (p[d]));
+		asm volatile("movdqa %%xmm3,%0" : "=m" (p[d+16]));
+	}
+
+	asm volatile("sfence" : : : "memory");
+	kernel_fpu_end();
 }
 
 
@@ -171,7 +274,7 @@ const struct raid6_calls raid6_sse2x2 = {
 	raid6_have_sse2,
 	"sse2x2",
 	1,			/* Has cache hints */
-	0			/* XOR not yet implemented */
+	1
 };
 
 #ifdef CONFIG_X86_64
@@ -268,7 +371,109 @@ static void raid6_sse24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
 				     size_t bytes, void **ptrs)
 {
-	/* enable hasxor if implemented */
+	u8 **dptr = (u8 **)ptrs;
+	u8 *p, *q;
+	int d, z, z0;
+
+	z0 = stop;		/* P/Q right side optimization */
+	p = dptr[disks-2];	/* XOR parity */
+	q = dptr[disks-1];	/* RS syndrome */
+
+	kernel_fpu_begin();
+
+	asm volatile("movdqa %0,%%xmm0" :: "m" (raid6_sse_constants.x1d[0]));
+
+	for ( d = 0 ; d < bytes ; d += 64 ) {
+		asm volatile("movdqa %0,%%xmm4" :: "m" (dptr[z0][d]));
+		asm volatile("movdqa %0,%%xmm6" :: "m" (dptr[z0][d+16]));
+		asm volatile("movdqa %0,%%xmm12" :: "m" (dptr[z0][d+32]));
+		asm volatile("movdqa %0,%%xmm14" :: "m" (dptr[z0][d+48]));
+		asm volatile("movdqa %0,%%xmm2" : : "m" (p[d]));
+		asm volatile("movdqa %0,%%xmm3" : : "m" (p[d+16]));
+		asm volatile("movdqa %0,%%xmm10" : : "m" (p[d+32]));
+		asm volatile("movdqa %0,%%xmm11" : : "m" (p[d+48]));
+		asm volatile("pxor %xmm4,%xmm2");
+		asm volatile("pxor %xmm6,%xmm3");
+		asm volatile("pxor %xmm12,%xmm10");
+		asm volatile("pxor %xmm14,%xmm11");
+		/* P/Q data pages */
+		for ( z = z0-1 ; z >= start ; z-- ) {
+			asm volatile("prefetchnta %0" :: "m" (dptr[z][d]));
+			asm volatile("prefetchnta %0" :: "m" (dptr[z][d+32]));
+			asm volatile("pxor %xmm5,%xmm5");
+			asm volatile("pxor %xmm7,%xmm7");
+			asm volatile("pxor %xmm13,%xmm13");
+			asm volatile("pxor %xmm15,%xmm15");
+			asm volatile("pcmpgtb %xmm4,%xmm5");
+			asm volatile("pcmpgtb %xmm6,%xmm7");
+			asm volatile("pcmpgtb %xmm12,%xmm13");
+			asm volatile("pcmpgtb %xmm14,%xmm15");
+			asm volatile("paddb %xmm4,%xmm4");
+			asm volatile("paddb %xmm6,%xmm6");
+			asm volatile("paddb %xmm12,%xmm12");
+			asm volatile("paddb %xmm14,%xmm14");
+			asm volatile("pand %xmm0,%xmm5");
+			asm volatile("pand %xmm0,%xmm7");
+			asm volatile("pand %xmm0,%xmm13");
+			asm volatile("pand %xmm0,%xmm15");
+			asm volatile("pxor %xmm5,%xmm4");
+			asm volatile("pxor %xmm7,%xmm6");
+			asm volatile("pxor %xmm13,%xmm12");
+			asm volatile("pxor %xmm15,%xmm14");
+			asm volatile("movdqa %0,%%xmm5" :: "m" (dptr[z][d]));
+			asm volatile("movdqa %0,%%xmm7" :: "m" (dptr[z][d+16]));
+			asm volatile("movdqa %0,%%xmm13" :: "m" (dptr[z][d+32]));
+			asm volatile("movdqa %0,%%xmm15" :: "m" (dptr[z][d+48]));
+			asm volatile("pxor %xmm5,%xmm2");
+			asm volatile("pxor %xmm7,%xmm3");
+			asm volatile("pxor %xmm13,%xmm10");
+			asm volatile("pxor %xmm15,%xmm11");
+			asm volatile("pxor %xmm5,%xmm4");
+			asm volatile("pxor %xmm7,%xmm6");
+			asm volatile("pxor %xmm13,%xmm12");
+			asm volatile("pxor %xmm15,%xmm14");
+		}
+		asm volatile("prefetchnta %0" :: "m" (q[d]));
+		asm volatile("prefetchnta %0" :: "m" (q[d+32]));
+		/* P/Q left side optimization */
+		for ( z = start-1 ; z >= 0 ; z-- ) {
+			asm volatile("pxor %xmm5,%xmm5");
+			asm volatile("pxor %xmm7,%xmm7");
+			asm volatile("pxor %xmm13,%xmm13");
+			asm volatile("pxor %xmm15,%xmm15");
+			asm volatile("pcmpgtb %xmm4,%xmm5");
+			asm volatile("pcmpgtb %xmm6,%xmm7");
+			asm volatile("pcmpgtb %xmm12,%xmm13");
+			asm volatile("pcmpgtb %xmm14,%xmm15");
+			asm volatile("paddb %xmm4,%xmm4");
+			asm volatile("paddb %xmm6,%xmm6");
+			asm volatile("paddb %xmm12,%xmm12");
+			asm volatile("paddb %xmm14,%xmm14");
+			asm volatile("pand %xmm0,%xmm5");
+			asm volatile("pand %xmm0,%xmm7");
+			asm volatile("pand %xmm0,%xmm13");
+			asm volatile("pand %xmm0,%xmm15");
+			asm volatile("pxor %xmm5,%xmm4");
+			asm volatile("pxor %xmm7,%xmm6");
+			asm volatile("pxor %xmm13,%xmm12");
+			asm volatile("pxor %xmm15,%xmm14");
+		}
+		asm volatile("movntdq %%xmm2,%0" : "=m" (p[d]));
+		asm volatile("movntdq %%xmm3,%0" : "=m" (p[d+16]));
+		asm volatile("movntdq %%xmm10,%0" : "=m" (p[d+32]));
+		asm volatile("movntdq %%xmm11,%0" : "=m" (p[d+48]));
+		asm volatile("pxor %0,%%xmm4" : : "m" (q[d]));
+		asm volatile("pxor %0,%%xmm6" : : "m" (q[d+16]));
+		asm volatile("pxor %0,%%xmm12" : : "m" (q[d+32]));
+		asm volatile("pxor %0,%%xmm14" : : "m" (q[d+48]));
+		asm volatile("movntdq %%xmm4,%0" : "=m" (q[d]));
+		asm volatile("movntdq %%xmm6,%0" : "=m" (q[d+16]));
+		asm volatile("movntdq %%xmm12,%0" : "=m" (q[d+32]));
+		asm volatile("movntdq %%xmm14,%0" : "=m" (q[d+48]));
+	}
+
+	asm volatile("sfence" : : : "memory");
+	kernel_fpu_end();
 }
 
 
@@ -278,7 +483,7 @@ const struct raid6_calls raid6_sse2x4 = {
 	raid6_have_sse2,
 	"sse2x4",
 	1,			/* Has cache hints */
-	0			/* XOR not yet implemented */
+	1
 };
 
 #endif /* CONFIG_X86_64 */

------=_NextPartTM-000-536bb4c3-4d62-40ab-a149-076518efa84d
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-536bb4c3-4d62-40ab-a149-076518efa84d--
