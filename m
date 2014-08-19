From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v2 1/6] raid6 algorithms: delta syndrome functions
Date: Tue, 19 Aug 2014 16:36:27 +0000
Message-ID: <8856a21a-9fe7-4dab-87a7-13124034298e@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-8e15479e-3c84-4466-9baf-9204477f84bb"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-8e15479e-3c84-4466-9baf-9204477f84bb
Content-Type: text/plain

commit 43e7125abf25101ef0127d2a2b23c5d738d51bd1
Author: Markus Stockhausen <markus.stockhausen@collogia.de>
Date:   Tue Aug 19 15:57:14 2014 +0000

    raid6 algorithms: delta syndrome functions
    
    v2: Fill xor_syndrome() with NULL where not yet implemented. Merge
    boot performance message
    
    Implementing rmw functionality for RAID6 requires optimized syndrome
    calculation. Up to now we can only generate a complete syndrome. The
    target P/Q pages are always overwritten. With this patch we provide
    a framework for inplace P/Q modification. In the first place simply
    fill those functions with NULL values.
    
    xor_syndrome() has two additional parameters: start & stop. These
    will indicate the first and last page that are changing during a
    rmw run. That makes it possible to avoid several unneccessary loops
    and speed up calculation. The caller needs to implement the following
    logic to make the functions work.
    
    1) xor_syndrome(disks, start, stop, ...): "Remove" all data of source
    blocks inside P/Q between (and including) start and end.
    
    2) modify any block with start <= block <= stop
    
    3) xor_syndrome(disks, start, stop, ...): "Reinsert" all data of
    source blocks into P/Q between (and including) start and end.
    
    The benchmark numbers of the gen_syndrome() functions are displayed in
    the kernel log. Do the same for the xor_syndrome() functions. This
    will help to analyze performance problems and give an rough estimate
    how well the algorithm works. The choice of the fastest algorithm will
    still depend on the gen_syndrome() performance.
    
    With the start/stop page implementation the speed can vary a lot in real
    life. E.g. a change of page 0 & page 15 on a stripe will be harder to
    compute than the case where page 0 & page 1 are XOR candidates. To be not
    to enthusiatic about the expected speeds we will run a worse case test
    that simulates a change on the upper half of the stripe. So we do:
    
    1) calculation of P/Q for the upper pages
    
    2) continuation of Q for the lower (empty) pages

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 73069cb..a7a06d1 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -72,6 +72,7 @@ extern const char raid6_empty_zero_page[PAGE_SIZE];
 /* Routine choices */
 struct raid6_calls {
 	void (*gen_syndrome)(int, size_t, void **);
+	void (*xor_syndrome)(int, int, int, size_t, void **);
 	int  (*valid)(void);	/* Returns 1 if this routine set is usable */
 	const char *name;	/* Name of this routine set */
 	int prefer;		/* Has special performance attribute */
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index f0b1aa3..07c687d 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -131,11 +131,12 @@ static inline const struct raid6_recov_calls *raid6_choose_recov(void)
 static inline const struct raid6_calls *raid6_choose_gen(
 	void *(*const dptrs)[(65536/PAGE_SIZE)+2], const int disks)
 {
-	unsigned long perf, bestperf, j0, j1;
+	unsigned long perf, bestgenperf, bestxorperf, j0, j1;
+	int start = (disks>>1)-1, stop = disks-3;	/* work on the second half of the disks */
 	const struct raid6_calls *const *algo;
 	const struct raid6_calls *best;
 
-	for (bestperf = 0, best = NULL, algo = raid6_algos; *algo; algo++) {
+	for (bestgenperf = 0, bestxorperf = 0, best = NULL, algo = raid6_algos; *algo; algo++) {
 		if (!best || (*algo)->prefer >= best->prefer) {
 			if ((*algo)->valid && !(*algo)->valid())
 				continue;
@@ -153,19 +154,46 @@ static inline const struct raid6_calls *raid6_choose_gen(
 			}
 			preempt_enable();
 
-			if (perf > bestperf) {
-				bestperf = perf;
+			if (perf > bestgenperf) {
+				bestgenperf = perf;
 				best = *algo;
 			}
-			printk("raid6: %-8s %5ld MB/s\n", (*algo)->name,
+			printk("raid6: %-8s gen() %5ld MB/s\n", (*algo)->name,
 			       (perf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2));
+
+			if (!(*algo)->xor_syndrome)
+				continue;
+
+			perf = 0;
+
+			preempt_disable();
+			j0 = jiffies;
+			while ((j1 = jiffies) == j0)
+				cpu_relax();
+			while (time_before(jiffies,
+					    j1 + (1<<RAID6_TIME_JIFFIES_LG2))) {
+				(*algo)->xor_syndrome(disks, start, stop,
+						      PAGE_SIZE, *dptrs);
+				perf++;
+			}
+			preempt_enable();
+
+			if (best == *algo)
+				bestxorperf = perf;
+
+			printk("raid6: %-8s xor() %5ld MB/s\n", (*algo)->name,
+			       (perf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2+1));
 		}
 	}
 
 	if (best) {
-		printk("raid6: using algorithm %s (%ld MB/s)\n",
+		printk("raid6: using algorithm %s gen() %ld MB/s",
 		       best->name,
-		       (bestperf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2));
+		       (bestgenperf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2));
+		if (best->xor_syndrome)
+			printk(", xor() %ld MB/s, rmw enabled",
+			       (bestxorperf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2+1));
+		printk("\n");
 		raid6_call = *best;
 	} else
 		printk("raid6: Yikes!  No algorithm found!\n");
diff --git a/lib/raid6/altivec.uc b/lib/raid6/altivec.uc
index 7cc12b5..bec27fc 100644
--- a/lib/raid6/altivec.uc
+++ b/lib/raid6/altivec.uc
@@ -119,6 +119,7 @@ int raid6_have_altivec(void)
 
 const struct raid6_calls raid6_altivec$# = {
 	raid6_altivec$#_gen_syndrome,
+	NULL,			/* XOR not yet implemented */
 	raid6_have_altivec,
 	"altivecx$#",
 	0
diff --git a/lib/raid6/avx2.c b/lib/raid6/avx2.c
index bc3b1dd..7673400 100644
--- a/lib/raid6/avx2.c
+++ b/lib/raid6/avx2.c
@@ -89,6 +89,7 @@ static void raid6_avx21_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_avx2x1 = {
 	raid6_avx21_gen_syndrome,
+	NULL,			/* XOR not yet implemented */
 	raid6_have_avx2,
 	"avx2x1",
 	1			/* Has cache hints */
@@ -150,6 +151,7 @@ static void raid6_avx22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_avx2x2 = {
 	raid6_avx22_gen_syndrome,
+	NULL,			/* XOR not yet implemented */
 	raid6_have_avx2,
 	"avx2x2",
 	1			/* Has cache hints */
@@ -242,6 +244,7 @@ static void raid6_avx24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_avx2x4 = {
 	raid6_avx24_gen_syndrome,
+	NULL,			/* XOR not yet implemented */
 	raid6_have_avx2,
 	"avx2x4",
 	1			/* Has cache hints */
diff --git a/lib/raid6/int.uc b/lib/raid6/int.uc
index 5b50f8d..5ca60be 100644
--- a/lib/raid6/int.uc
+++ b/lib/raid6/int.uc
@@ -109,7 +109,8 @@ static void raid6_int$#_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_intx$# = {
 	raid6_int$#_gen_syndrome,
-	NULL,		/* always valid */
+	NULL,			/* XOR not yet implemented */
+	NULL,			/* always valid */
 	"int" NSTRING "x$#",
 	0
 };
diff --git a/lib/raid6/mmx.c b/lib/raid6/mmx.c
index 590c71c..b3b0e1f 100644
--- a/lib/raid6/mmx.c
+++ b/lib/raid6/mmx.c
@@ -76,6 +76,7 @@ static void raid6_mmx1_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_mmxx1 = {
 	raid6_mmx1_gen_syndrome,
+	NULL,			/* XOR not yet implemented */
 	raid6_have_mmx,
 	"mmxx1",
 	0
@@ -134,6 +135,7 @@ static void raid6_mmx2_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_mmxx2 = {
 	raid6_mmx2_gen_syndrome,
+	NULL,			/* XOR not yet implemented */
 	raid6_have_mmx,
 	"mmxx2",
 	0
diff --git a/lib/raid6/neon.c b/lib/raid6/neon.c
index 36ad470..d9ad6ee 100644
--- a/lib/raid6/neon.c
+++ b/lib/raid6/neon.c
@@ -42,6 +42,7 @@
 	}								\
 	struct raid6_calls const raid6_neonx ## _n = {			\
 		raid6_neon ## _n ## _gen_syndrome,			\
+		NULL,		/* XOR not yet implemented */		\
 		raid6_have_neon,					\
 		"neonx" #_n,						\
 		0							\
diff --git a/lib/raid6/sse1.c b/lib/raid6/sse1.c
index f762971..9025b8c 100644
--- a/lib/raid6/sse1.c
+++ b/lib/raid6/sse1.c
@@ -92,6 +92,7 @@ static void raid6_sse11_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_sse1x1 = {
 	raid6_sse11_gen_syndrome,
+	NULL,			/* XOR not yet implemented */
 	raid6_have_sse1_or_mmxext,
 	"sse1x1",
 	1			/* Has cache hints */
@@ -154,6 +155,7 @@ static void raid6_sse12_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_sse1x2 = {
 	raid6_sse12_gen_syndrome,
+	NULL,			/* XOR not yet implemented */
 	raid6_have_sse1_or_mmxext,
 	"sse1x2",
 	1			/* Has cache hints */
diff --git a/lib/raid6/sse2.c b/lib/raid6/sse2.c
index 85b82c8..31acd59 100644
--- a/lib/raid6/sse2.c
+++ b/lib/raid6/sse2.c
@@ -90,6 +90,7 @@ static void raid6_sse21_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_sse2x1 = {
 	raid6_sse21_gen_syndrome,
+	NULL,			/* XOR not yet implemented */
 	raid6_have_sse2,
 	"sse2x1",
 	1			/* Has cache hints */
@@ -152,6 +153,7 @@ static void raid6_sse22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_sse2x2 = {
 	raid6_sse22_gen_syndrome,
+	NULL,			/* XOR not yet implemented */
 	raid6_have_sse2,
 	"sse2x2",
 	1			/* Has cache hints */
@@ -250,6 +252,7 @@ static void raid6_sse24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_sse2x4 = {
 	raid6_sse24_gen_syndrome,
+	NULL,			/* XOR not yet implemented */
 	raid6_have_sse2,
 	"sse2x4",
 	1			/* Has cache hints */
diff --git a/lib/raid6/tilegx.uc b/lib/raid6/tilegx.uc
index e7c2945..2dd291a 100644
--- a/lib/raid6/tilegx.uc
+++ b/lib/raid6/tilegx.uc
@@ -80,6 +80,7 @@ void raid6_tilegx$#_gen_syndrome(int disks, size_t bytes, void **ptrs)
 
 const struct raid6_calls raid6_tilegx$# = {
 	raid6_tilegx$#_gen_syndrome,
+	NULL,			/* XOR not yet implemented */
 	NULL,
 	"tilegx$#",
 	0

------=_NextPartTM-000-8e15479e-3c84-4466-9baf-9204477f84bb
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

------=_NextPartTM-000-8e15479e-3c84-4466-9baf-9204477f84bb--
