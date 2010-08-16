From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 12/35] create: respect domains/subsets during create process
Date: Mon, 16 Aug 2010 10:47:26 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9D6@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 669de81946d0c69ec6892a3b8ae9ce89cffe6e8d Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Thu, 10 Jun 2010 11:56:59 +0200
Subject: [PATCH 12/35] create: respect domains/subsets during create process

---
 Create.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/Create.c b/Create.c
index b04388f..2ea4205 100644
--- a/Create.c
+++ b/Create.c
@@ -116,6 +116,8 @@ int Create(struct supertype *st, char *mddev,
 	char chosen_name[1024];
 	struct map_ent *map = NULL;
 	unsigned long long newsize;
+	struct domain_ent *base_de = NULL;
+	struct subset *base_ss;
 
 	int major_num = BITMAP_MAJOR_HI;
 
@@ -281,6 +283,8 @@ int Create(struct supertype *st, char *mddev,
 	info.array.working_disks = 0;
 	dnum = 0;
 	for (dv=devlist; dv && !have_container; dv=dv->next, dnum++) {
+		struct domain_ent *de;
+		struct subset *ss;
 		char *dname = dv->devname;
 		unsigned long long freesize;
 		if (strcasecmp(dname, "missing")==0) {
@@ -343,6 +347,31 @@ int Create(struct supertype *st, char *mddev,
 			}
 		}
 
+		de = conf_get_domain(dname, (char *)st->ss->name);
+		if (!de) {
+			fprintf(stderr, Name ": Can't determine domain of %s.",
+				dname);
+			if (st)
+				st->ss->free_super(st);
+			return 1;
+		}
+		ss = conf_get_subset(dname, st, de);
+		if (!base_de) {
+			base_de = de;
+			base_ss = ss;
+			if (verbose > 0)
+				fprintf(stderr, Name ": Base domain set for "
+						"device: %s\n", dname);
+		} else {
+			if (base_de != de || base_ss != ss) {
+				if (verbose > 0)
+					fprintf(stderr, Name ": %s does not belong to the same "
+							"domain/subset.\n",
+						dname);
+					return 1;
+			}
+		}
+
 		freesize /= 2; /* convert to K */
 		if (chunk) {
 			/* round to chunk size */
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

