From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 11/35] assembly: user domain/subset from configuration file
 in assembly process
Date: Mon, 16 Aug 2010 10:46:21 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9D2@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 09a95a3c44383c6829d9ce3d77f981ed91e05d82 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Tue, 15 Jun 2010 15:26:25 +0200
Subject: [PATCH 11/35] assembly: user domain/subset from configuration file in assembly process

Device and volume/container must be in the same domain/subset to be
assembled.
---
 Assemble.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 1504f1f..cc51428 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -169,6 +169,9 @@ int Assemble(struct supertype *st, char *mddev,
 	int trustworthy;
 	char chosen_name[1024];
 
+	struct domain_ent *domain = NULL, *de;
+	struct subset *subset = NULL, *ss;
+
 	if (get_linux_version() < 2004000)
 		old_linux = 1;
 
@@ -384,6 +387,35 @@ int Assemble(struct supertype *st, char *mddev,
 			if (tst == NULL || tst->sb == NULL)
 				continue;
 		}
+
+		if (!tst->loaded_container) { /* do not test container, just members */
+			de = conf_get_domain(devname, (char *)tst->ss->name);
+			if (!de) {
+				fprintf(stderr, Name ": Can't determine domain of %s.",
+						devname);
+				if (st)
+					st->ss->free_super(st);
+				return 1;
+			}
+			ss = conf_get_subset(devname, st, de);
+			if (!domain) {
+				if (report_missmatch) {
+					fprintf(stderr, Name ": Base domain set for "
+							     "device: %s\n",
+							devname);
+				}
+				domain = de;
+				subset = ss;
+			} else {
+				if (domain != de || subset != ss) {
+					if (report_missmatch)
+						fprintf(stderr, Name ": %s does not belong to the same "
+						"domain/subset.\n",
+								devname);
+					goto loop;
+				}
+			}
+		}
 		/* If we are this far, then we are nearly commited to this device.
 		 * If the super_block doesn't exist, or doesn't match others,
 		 * then we probably cannot continue
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

