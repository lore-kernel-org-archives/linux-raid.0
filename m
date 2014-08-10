From: <stockhausen@collogia.de>
Subject: [PATCH v1 2/8]     raid6 algorithms: delta syndrome dummy functions
Date: Sun, 10 Aug 2014 11:56:36 +0000
Message-ID: <fbd693ba-5112-4503-95b3-b13509592e72@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-126af329-172f-4750-ad91-7805521829bb"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-126af329-172f-4750-ad91-7805521829bb
Content-Type: text/plain

commit c7afa4b260ab9b22950620ea5aa1f5abbb984519
Author: Markus Stockhausen <markus.stockhausen@collogia.de>
Date:   Sun Aug 10 09:33:18 2014 +0000

    raid6 algorithms: delta syndrome dummy functions
    
    Implementing rmw functionality for RAID6 requires optimized syndrome
    calculation. Up to now we can only generate a complete syndrome. The
    target P/Q pages are always overwritten. With this patch we provide
    a framework for inplace P/Q modification. Although a lot of coding
    was added it follows a simple rule: Duplicate existing gen_syndrome()
    functions to (still empty) xor_syndrome() ones.
    
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
    
    Additionally relax the setting of /sys/block/mdX/md/rmw_level to
    allow rmw enabling if the choosen algorithm offers xor_syndrome().

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ba32c1f..c1a0dfe 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5393,8 +5393,8 @@ raid5_store_rmw_level(struct mddev  *mddev, const char *page, size_t len)
 	    new != PARITY_PREFER_RMW)
 		return -EINVAL;
 
-	/* RAID6 does not support rmw yet */
-	if (new != PARITY_DISABLE_RMW && conf->level == 6)
+	/* RAID6 supports rmw depending on algorithm */
+	if (new != PARITY_DISABLE_RMW && conf->level == 6 && !raid6_call.hasxor)
 		return -EINVAL;
 
 	conf->rmw_level = new;
diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 73069cb..0384980 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -72,9 +72,11 @@ extern const char raid6_empty_zero_page[PAGE_SIZE];
 /* Routine choices */
 struct raid6_calls {
 	void (*gen_syndrome)(int, size_t, void **);
+	void (*xor_syndrome)(int, int, int, size_t, void **);
 	int  (*valid)(void);	/* Returns 1 if this routine set is usable */
 	const char *name;	/* Name of this routine set */
 	int prefer;		/* Has special performance attribute */
+	int hasxor;		/* Has additional XOR method */
 };
 
 /* Selected algorithm */
diff --git a/lib/raid6/altivec.uc b/lib/raid6/altivec.uc
index 7cc12b5..bdad7de 100644
--- a/lib/raid6/altivec.uc
+++ b/lib/raid6/altivec.uc
@@ -104,6 +104,24 @@ static void raid6_altivec$#_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	preempt_enable();
 }
 
+static void noinline
+raid6_altivec$#_gen_syndrome_real(int disks, int start, int stop,
+				  size_t bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
+
+static void raid6_altivec$#_xor_syndrome(int disks, int start, int stop,
+					 tsize_t bytes, void **ptrs)
+{
+	preempt_disable();
+	enable_kernel_altivec();
+
+	raid6_altivec$#_xor_syndrome_real(disks, start, stop, bytes, ptrs);
+
+	preempt_enable();
+}
+
 int raid6_have_altivec(void);
 #if $# == 1
 int raid6_have_altivec(void)
@@ -119,9 +137,11 @@ int raid6_have_altivec(void)
 
 const struct raid6_calls raid6_altivec$# = {
 	raid6_altivec$#_gen_syndrome,
+	raid6_altivec$#_xor_syndrome,
 	raid6_have_altivec,
 	"altivecx$#",
-	0
+	0,
+	0,			/* XOR not yet implemented */
 };
 
 #endif /* CONFIG_ALTIVEC */
diff --git a/lib/raid6/avx2.c b/lib/raid6/avx2.c
index bc3b1dd..225ca38 100644
--- a/lib/raid6/avx2.c
+++ b/lib/raid6/avx2.c
@@ -87,11 +87,19 @@ static void raid6_avx21_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_avx21_xor_syndrome(int disks, int start, int stop,
+				     size_t bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
+
 const struct raid6_calls raid6_avx2x1 = {
 	raid6_avx21_gen_syndrome,
+	raid6_avx21_xor_syndrome,
 	raid6_have_avx2,
 	"avx2x1",
-	1			/* Has cache hints */
+	1,			/* Has cache hints */
+	0			/* XOR not yet implemented */
 };
 
 /*
@@ -148,11 +156,19 @@ static void raid6_avx22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_avx22_xor_syndrome(int disks, int start, int stop,
+				     size_t bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
+
 const struct raid6_calls raid6_avx2x2 = {
 	raid6_avx22_gen_syndrome,
+	raid6_avx22_xor_syndrome,
 	raid6_have_avx2,
 	"avx2x2",
-	1			/* Has cache hints */
+	1,			/* Has cache hints */
+	0			/* XOR not yet implemented */
 };
 
 #ifdef CONFIG_X86_64
@@ -240,11 +256,19 @@ static void raid6_avx24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_avx24_xor_syndrome(int disks, int start, int stop,
+				     size_t bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
+
 const struct raid6_calls raid6_avx2x4 = {
 	raid6_avx24_gen_syndrome,
+	raid6_avx24_xor_syndrome,
 	raid6_have_avx2,
 	"avx2x4",
-	1			/* Has cache hints */
+	1,			/* Has cache hints */
+	0			/* XOR not yet implemented */
 };
 #endif
 
diff --git a/lib/raid6/int.uc b/lib/raid6/int.uc
index 5b50f8d..283a9a3 100644
--- a/lib/raid6/int.uc
+++ b/lib/raid6/int.uc
@@ -107,11 +107,19 @@ static void raid6_int$#_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 }
 
+static void raid6_int$#_xor_syndrome(int disks, int start, int stop,
+				     size_t bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
+
 const struct raid6_calls raid6_intx$# = {
 	raid6_int$#_gen_syndrome,
-	NULL,		/* always valid */
+	raid6_int$#_xor_syndrome,
+	NULL,			/* always valid */
 	"int" NSTRING "x$#",
-	0
+	0,
+	0			/* XOR not yet implemented */
 };
 
 #endif
diff --git a/lib/raid6/mmx.c b/lib/raid6/mmx.c
index 590c71c..6ed27c7 100644
--- a/lib/raid6/mmx.c
+++ b/lib/raid6/mmx.c
@@ -74,11 +74,19 @@ static void raid6_mmx1_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_mmx1_xor_syndrome(int disks, int start, int stop,
+				    size_t bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
+
 const struct raid6_calls raid6_mmxx1 = {
 	raid6_mmx1_gen_syndrome,
+	raid6_mmx1_xor_syndrome,
 	raid6_have_mmx,
 	"mmxx1",
-	0
+	0,
+	0			/* XOR not yet implemented */
 };
 
 /*
@@ -132,11 +140,19 @@ static void raid6_mmx2_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_mmx2_xor_syndrome(int disks, int start, int stop,
+				    size_t bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
+
 const struct raid6_calls raid6_mmxx2 = {
 	raid6_mmx2_gen_syndrome,
+	raid6_mmx2_xor_syndrome,
 	raid6_have_mmx,
 	"mmxx2",
-	0
+	0,
+	0			/* XOR not yet implemented */
 };
 
 #endif
diff --git a/lib/raid6/neon.c b/lib/raid6/neon.c
index 36ad470..a0af518 100644
--- a/lib/raid6/neon.c
+++ b/lib/raid6/neon.c
@@ -40,11 +40,26 @@
 					(unsigned long)bytes, ptrs);	\
 		kernel_neon_end();					\
 	}								\
+	static void raid6_neon ## _n ## _xor_syndrome(int disks,	\
+					int start, int stop,		\
+					size_t bytes, void **ptrs)	\
+	{								\
+		void raid6_neon ## _n  ## _xor_syndrome_real(int,	\
+						int, int,		\
+						unsigned long, void**);	\
+		kernel_neon_begin();					\
+		raid6_neon ## _n ## _xor_syndrome_real(disks,		\
+					start, stop,			\
+					(unsigned long)bytes, ptrs);	\
+		kernel_neon_end();					\
+	}								\
 	struct raid6_calls const raid6_neonx ## _n = {			\
 		raid6_neon ## _n ## _gen_syndrome,			\
+		raid6_neon ## _n ## _xor_syndrome,			\
 		raid6_have_neon,					\
 		"neonx" #_n,						\
-		0							\
+		0,							\
+		0		/* XOR not yet implemented */		\
 	}
 
 static int raid6_have_neon(void)
diff --git a/lib/raid6/neon.uc b/lib/raid6/neon.uc
index 1b9ed79..c5e30f0 100644
--- a/lib/raid6/neon.uc
+++ b/lib/raid6/neon.uc
@@ -78,3 +78,9 @@ void raid6_neon$#_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
 		vst1q_u8(&q[d+NSIZE*$$], wq$$);
 	}
 }
+
+void raid6_neon$#_xor_syndrome_real(int disks, int start, int stop,
+				    unsigned long bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
diff --git a/lib/raid6/sse1.c b/lib/raid6/sse1.c
index f762971..5a43c87 100644
--- a/lib/raid6/sse1.c
+++ b/lib/raid6/sse1.c
@@ -90,11 +90,19 @@ static void raid6_sse11_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_sse11_xor_syndrome(int disks, int start, int stop,
+				     size_t bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
+
 const struct raid6_calls raid6_sse1x1 = {
 	raid6_sse11_gen_syndrome,
+	raid6_sse11_xor_syndrome,
 	raid6_have_sse1_or_mmxext,
 	"sse1x1",
-	1			/* Has cache hints */
+	1,			/* Has cache hints */
+	0			/* XOR not yet implemented */
 };
 
 /*
@@ -152,11 +160,20 @@ static void raid6_sse12_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_sse12_xor_syndrome(int disks, int start, int stop,
+				     size_t bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
+
+
 const struct raid6_calls raid6_sse1x2 = {
 	raid6_sse12_gen_syndrome,
+	raid6_sse12_xor_syndrome,
 	raid6_have_sse1_or_mmxext,
 	"sse1x2",
-	1			/* Has cache hints */
+	1,			/* Has cache hints */
+	0			/* XOR not yet implemented */
 };
 
 #endif
diff --git a/lib/raid6/sse2.c b/lib/raid6/sse2.c
index 85b82c8..7ec2b6e 100644
--- a/lib/raid6/sse2.c
+++ b/lib/raid6/sse2.c
@@ -88,11 +88,19 @@ static void raid6_sse21_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_sse21_xor_syndrome(int disks, int start, int stop,
+				     size_t bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
+
 const struct raid6_calls raid6_sse2x1 = {
 	raid6_sse21_gen_syndrome,
+	raid6_sse21_xor_syndrome,
 	raid6_have_sse2,
 	"sse2x1",
-	1			/* Has cache hints */
+	1,			/* Has cache hints */
+	0			/* XOR not yet implemented */
 };
 
 /*
@@ -150,11 +158,20 @@ static void raid6_sse22_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_sse22_xor_syndrome(int disks, int start, int stop,
+				     size_t bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
+
+
 const struct raid6_calls raid6_sse2x2 = {
 	raid6_sse22_gen_syndrome,
+	raid6_sse22_xor_syndrome,
 	raid6_have_sse2,
 	"sse2x2",
-	1			/* Has cache hints */
+	1,			/* Has cache hints */
+	0			/* XOR not yet implemented */
 };
 
 #ifdef CONFIG_X86_64
@@ -248,11 +265,20 @@ static void raid6_sse24_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	kernel_fpu_end();
 }
 
+static void raid6_sse24_xor_syndrome(int disks, int start, int stop,
+				     size_t bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
+
+
 const struct raid6_calls raid6_sse2x4 = {
 	raid6_sse24_gen_syndrome,
+	raid6_sse24_xor_syndrome,
 	raid6_have_sse2,
 	"sse2x4",
-	1			/* Has cache hints */
+	1,			/* Has cache hints */
+	0			/* XOR not yet implemented */
 };
 
 #endif /* CONFIG_X86_64 */
diff --git a/lib/raid6/tilegx.uc b/lib/raid6/tilegx.uc
index e7c2945..ce619c1 100644
--- a/lib/raid6/tilegx.uc
+++ b/lib/raid6/tilegx.uc
@@ -78,9 +78,17 @@ void raid6_tilegx$#_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 }
 
+void raid6_tilegx$#_gen_syndrome(int disks, int start, int stop,
+				 size_t bytes, void **ptrs)
+{
+	/* enable hasxor if implemented */
+}
+
 const struct raid6_calls raid6_tilegx$# = {
 	raid6_tilegx$#_gen_syndrome,
+	raid6_tilegx$#_xor_syndrome,
 	NULL,
 	"tilegx$#",
-	0
+	0,
+	0			/* XOR not yet implemented */
 };

------=_NextPartTM-000-126af329-172f-4750-ad91-7805521829bb
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

------=_NextPartTM-000-126af329-172f-4750-ad91-7805521829bb--
