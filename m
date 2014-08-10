From: <stockhausen@collogia.de>
Subject: [PATCH v1 3/8]     raid6 algorithms: improve test program
Date: Sun, 10 Aug 2014 11:56:42 +0000
Message-ID: <99a70809-0aea-4945-97c1-d0ae1232e5e9@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-43982794-bdd4-4d8d-ae88-e69231d0cff3"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-43982794-bdd4-4d8d-ae88-e69231d0cff3
Content-Type: text/plain

commit 9e94ae70f96c699bfe6d012fc2ce71b34476c898
Author: Markus Stockhausen <markus.stockhausen@collogia.de>
Date:   Sun Aug 10 09:35:50 2014 +0000

    raid6 algorithms: improve test program
    
    It is always helpful to have a test tool in place if we implement
    new data critical algorithms. So add some test routines to the raid6
    checker that can prove if the new xor_syndrome() works as expected.
    
    Run through all permutations of start/stop pages per algorithm and
    simulate a xor_syndrome() assisted rmw run. After each rmw check if
    the recovery algorithm still confirms that the stripe is fine.

diff --git a/lib/raid6/test/test.c b/lib/raid6/test/test.c
index 5a485b7..e2eb6b1 100644
--- a/lib/raid6/test/test.c
+++ b/lib/raid6/test/test.c
@@ -28,11 +28,11 @@ char *dataptrs[NDISKS];
 char data[NDISKS][PAGE_SIZE];
 char recovi[PAGE_SIZE], recovj[PAGE_SIZE];
 
-static void makedata(void)
+static void makedata(int start, int stop)
 {
 	int i, j;
 
-	for (i = 0; i < NDISKS; i++) {
+	for (i = start; i <= stop; i++) {
 		for (j = 0; j < PAGE_SIZE; j++)
 			data[i][j] = rand();
 
@@ -91,34 +91,55 @@ int main(int argc, char *argv[])
 {
 	const struct raid6_calls *const *algo;
 	const struct raid6_recov_calls *const *ra;
-	int i, j;
+	int i, j, p1, p2;
 	int err = 0;
 
-	makedata();
+	makedata(0, NDISKS-1);
 
 	for (ra = raid6_recov_algos; *ra; ra++) {
 		if ((*ra)->valid  && !(*ra)->valid())
 			continue;
+
 		raid6_2data_recov = (*ra)->data2;
 		raid6_datap_recov = (*ra)->datap;
 
 		printf("using recovery %s\n", (*ra)->name);
 
 		for (algo = raid6_algos; *algo; algo++) {
-			if (!(*algo)->valid || (*algo)->valid()) {
-				raid6_call = **algo;
+			if ((*algo)->valid && !(*algo)->valid())
+				continue;
+
+			raid6_call = **algo;
+
+			/* Nuke syndromes */
+			memset(data[NDISKS-2], 0xee, 2*PAGE_SIZE);
+
+			/* Generate assumed good syndrome */
+			raid6_call.gen_syndrome(NDISKS, PAGE_SIZE,
+						(void **)&dataptrs);
+
+			for (i = 0; i < NDISKS-1; i++)
+				for (j = i+1; j < NDISKS; j++)
+					err += test_disks(i, j);
+
+			if (!raid6_call.hasxor)
+				continue;
+
+			for (p1 = 0; p1 < NDISKS-2; p1++)
+				for (p2 = p1; p2 < NDISKS-2; p2++) {
 
-				/* Nuke syndromes */
-				memset(data[NDISKS-2], 0xee, 2*PAGE_SIZE);
+					/* Simulate rmw run */
+					raid6_call.xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
+								(void **)&dataptrs);
+					makedata(p1, p2);
+					raid6_call.xor_syndrome(NDISKS, p1, p2, PAGE_SIZE,
+                                                                (void **)&dataptrs);
 
-				/* Generate assumed good syndrome */
-				raid6_call.gen_syndrome(NDISKS, PAGE_SIZE,
-							(void **)&dataptrs);
+					for (i = 0; i < NDISKS-1; i++)
+						for (j = i+1; j < NDISKS; j++)
+							err += test_disks(i, j);
+				}
 
-				for (i = 0; i < NDISKS-1; i++)
-					for (j = i+1; j < NDISKS; j++)
-						err += test_disks(i, j);
-			}
 		}
 		printf("\n");
 	}

------=_NextPartTM-000-43982794-bdd4-4d8d-ae88-e69231d0cff3
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

------=_NextPartTM-000-43982794-bdd4-4d8d-ae88-e69231d0cff3--
