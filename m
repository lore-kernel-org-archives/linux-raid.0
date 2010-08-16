From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 18/35] Assemble: assembly with domains - two runs for imsm
 spares
Date: Mon, 16 Aug 2010 10:51:17 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9E6@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 3c7f90ada7b70a9f5f2822b13c78ee6689ab01d1 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Wed, 23 Jun 2010 12:10:15 +0100
Subject: [PATCH 18/35] Assemble: assembly with domains - two runs for imsm spares

UUID of an imsm spare matches any array but
we are not able to decide if the spare can be assembled with the array
until we know this array's domain. Spares found before determining
array's domain are marked and matched in second run.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Assemble.c |   46 ++++++++++++++++++++++++++++++++++++----------
 1 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index cc51428..a1ec8cb 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -168,6 +168,8 @@ int Assemble(struct supertype *st, char *mddev,
 	char *name = NULL;
 	int trustworthy;
 	char chosen_name[1024];
+	int run = 0;
+	int spare;
 
 	struct domain_ent *domain = NULL, *de;
 	struct subset *subset = NULL, *ss;
@@ -221,7 +223,9 @@ int Assemble(struct supertype *st, char *mddev,
 	if (verbose>0)
 	    fprintf(stderr, Name ": looking for devices for %s\n",
 		    mddev ? mddev : "further assembly");
-
+	run = 0;
+	spare = 0;
+second_run:
 	/* first walk the list of devices to find a consistent set
 	 * that match the criterea, if that is possible.
 	 * We flag the ones we like with 'used'.
@@ -234,8 +238,14 @@ int Assemble(struct supertype *st, char *mddev,
 		struct stat stb;
 		struct supertype *tst = dup_super(st);
 
-		if (tmpdev->used > 1) continue;
-
+		if (tmpdev->used == 2)
+			continue;
+		if (run == 1) {
+			if (tmpdev->used != 3)
+				continue;
+			else
+				tmpdev->used = 0;
+		}
 		if (ident->devices &&
 		    !match_oneof(ident->devices, devname)) {
 			if (report_missmatch)
@@ -399,13 +409,22 @@ int Assemble(struct supertype *st, char *mddev,
 			}
 			ss = conf_get_subset(devname, st, de);
 			if (!domain) {
-				if (report_missmatch) {
-					fprintf(stderr, Name ": Base domain set for "
-							     "device: %s\n",
-							devname);
+				if (memcmp(content->uuid, uuid_match_any,
+					   sizeof(int[4])) != 0) {
+					if (report_missmatch) {
+						fprintf(stderr, Name ": Base domain set for "
+							"device: %s\n", devname);
+					}
+					domain = de;
+					subset = ss;
+				} else{
+					/* imsm spares only
+					 * we don't know if this spare can
+					 * be used until we know domain
+					 * so mark it for second run */
+					tmpdev->used = 3;
+					spare = 1; /* set flag */
 				}
-				domain = de;
-				subset = ss;
 			} else {
 				if (domain != de || subset != ss) {
 					if (report_missmatch)
@@ -524,7 +543,8 @@ int Assemble(struct supertype *st, char *mddev,
 			return 1;
 		}
 
-		tmpdev->used = 1;
+		if (tmpdev->used != 3)
+			tmpdev->used = 1;
 
 	loop:
 		if (tmpdev->content)
@@ -533,6 +553,12 @@ int Assemble(struct supertype *st, char *mddev,
 			tst->ss->free_super(tst);
 	}
 
+	/* We may have missed some spares before domain was determined */
+	if (run == 0 && spare && domain) {
+		run = 1;
+		goto second_run;
+	}
+
 	if (!st || !st->sb || !content)
 		return 2;
 
-- 
1.6.4.2

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

