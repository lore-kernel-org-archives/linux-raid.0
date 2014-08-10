From: <stockhausen@collogia.de>
Subject: [PATCH v1 4/8]     raid6 algorithms: show xor_syndrome() benchmarks on startup
Date: Sun, 10 Aug 2014 11:56:48 +0000
Message-ID: <afc3b6f7-3671-4946-9cf9-f9ffa55143de@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-7b0c26c6-04aa-4999-abec-26bbf0888f1e"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-7b0c26c6-04aa-4999-abec-26bbf0888f1e
Content-Type: text/plain

commit b84f0bfead0da0334aeff90a291fd00a84881538
Author: Markus Stockhausen <markus.stockhausen@collogia.de>
Date:   Sun Aug 10 09:39:12 2014 +0000

    raid6 algorithms: show xor_syndrome() benchmarks on startup
    
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

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index f0b1aa3..dc1ec40 100644
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
+			if (!(*algo)->hasxor)
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
+                                                     PAGE_SIZE, *dptrs);
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
+		if (best->hasxor)
+			printk(", xor() %ld MB/s, rmw enabled",
+			       (bestxorperf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2+1));
+		printk("\n");
 		raid6_call = *best;
 	} else
 		printk("raid6: Yikes!  No algorithm found!\n");

------=_NextPartTM-000-7b0c26c6-04aa-4999-abec-26bbf0888f1e
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

------=_NextPartTM-000-7b0c26c6-04aa-4999-abec-26bbf0888f1e--
