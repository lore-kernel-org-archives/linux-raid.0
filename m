From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 14/35] incremental: add domain/subset support
Date: Mon, 16 Aug 2010 10:48:24 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9DB@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From fe7bf2117e991d4e8c7a1e777958e89288a83d25 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Mon, 28 Jun 2010 16:49:58 +0200
Subject: [PATCH 14/35] incremental: add domain/subset support

incremental with block device passed as an argument will check
if domain/subset pair of block device is the same as
domain/subset of array (if already running) incremental is allowed.
---
 Incremental.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 3501bc1..6c30f51 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -93,6 +93,9 @@ int Incremental(char *devname, int verbose, int runstop,
 	int trustworthy = FOREIGN;
 	char *name_to_use;
 	mdu_array_info_t ainf;
+	struct domain_ent *dev_de = NULL, *arr_de = NULL;
+	struct subset *dev_ss = NULL, *arr_ss;
+	char *array_device = NULL;
 
 	struct createinfo *ci = conf_get_create_info();
 
@@ -151,6 +154,23 @@ int Incremental(char *devname, int verbose, int runstop,
 
 	memset(&info, 0, sizeof(info));
 	st->ss->getinfo_super(st, &info);
+
+	if (!st->loaded_container) { /* check for container does not make sense */
+		dev_de = conf_get_domain(devname, (char *)st->ss->name);
+		if (!dev_de) {
+			fprintf(stderr, Name ": failed to determine domain for %s\n",
+				devname);
+			st->ss->free_super(st);
+			return 1;
+		}
+		dev_ss = conf_get_subset(devname, st, dev_de);
+		if (!dev_ss) {
+			fprintf(stderr, Name ": failed to determine domain subset for %s\n",
+				devname);
+			st->ss->free_super(st);
+			return 1;
+		}
+	}
 	/* 3/ Check if there is a match in mdadm.conf */
 
 	array_list = conf_get_ident(NULL);
@@ -199,6 +219,37 @@ int Incremental(char *devname, int verbose, int runstop,
 					array_list->devname);
 			continue;
 		}
+		if (array_list->devname) /* either name or uuid */
+			array_device = get_array_devname(array_list->devname);
+		else
+			array_device =
+			get_array_devname_by_uuid(&array_list->uuid);
+		/* check only if array is already running and
+		 * adding device */
+		if (array_device && dev_de) {
+			/* handle == -1, to open device in function*/
+			if (get_active_array_domain(array_device, -1,
+				&arr_de, &arr_ss)) {
+				if (verbose > 0)
+					fprintf(stderr, Name " : cannot determine "
+							     "domain of array %s.\n",
+						array_device);
+					free(array_device);
+				continue;
+
+				}
+			if (dev_de != arr_de || dev_ss != arr_ss) {
+				if (verbose > 0)
+					fprintf(stderr, Name ": %s does not belong to "
+							"the same domain/subset as "
+							"array %s.\n",
+						devname, array_list->devname ?
+						array_list->devname : "");
+				free(array_device);
+				continue;
+			}
+		}
+		free(array_device);
 		/* FIXME, should I check raid_disks and level too?? */
 
 		if (match) {
@@ -366,6 +417,8 @@ int Incremental(char *devname, int verbose, int runstop,
 		struct mdinfo *sra;
 		struct supertype *st2;
 		struct mdinfo info2, *d;
+		struct domain_ent *de2;
+		struct subset *ss2;
 
 		if (mp->path)
 			strcpy(chosen_name, mp->path);
@@ -389,6 +442,31 @@ int Incremental(char *devname, int verbose, int runstop,
 				close(dfd2);
 				return 2;
 			}
+			if (strncmp(sra->devs->sys_name, "dev-", 4) == 0) {
+				de2 = conf_get_domain(sra->devs->sys_name + 4,
+						      (char *)st2->ss->name);
+				if (!de2) {
+					fprintf(stderr, Name ": failed to determine domain for %s\n",
+						devname);
+					st->ss->free_super(st);
+					return 1;
+				}
+				ss2 = conf_get_subset(devname, st, de2);
+				if (!ss2) {
+					fprintf(stderr, Name ": failed to determine domain subset for %s\n",
+						devname);
+					st->ss->free_super(st);
+					return 1;
+				}
+				if (dev_de != de2 || dev_ss != ss2) {
+					fprintf(stderr, Name ": /dev/%s does not belong to "
+							     "the same domain/subset as "
+							     "%s.\n",
+							     sra->devs->sys_name + 4,
+							     devname);
+					return 2;
+				}
+			}
 			close(dfd2);
 			memset(&info2, 0, sizeof(info2));
 			st2->ss->getinfo_super(st2, &info2);
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

