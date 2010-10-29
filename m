From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 09/17] Monitor: avoid skipping checks on external arays
Date: Fri, 29 Oct 2010 15:23:26 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FC9@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From bb9ca6dbe0a92e00b21cd8985533b561b40ed6b9 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Mon, 25 Oct 2010 11:30:43 +0200
Subject: [PATCH 09/17] Monitor: avoid skipping checks on external arays

utime is not correct for external metadata so we can only
skip further checks for native metadata

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   33 ++++++++++++++++++++++++++-------
 1 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index a4bfedd..d915d7d 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -50,6 +50,7 @@ struct state {
 	int devstate[MaxDisks];
 	unsigned devid[MaxDisks];
 	int percent;
+	char *metadata_version;
 	struct state *next;
 };
 
@@ -223,6 +224,7 @@ int Monitor(mddev_dev_t devlist,
 				st->spare_group = strdup(mdlist->spare_group);
 			else
 				st->spare_group = NULL;
+			st->metadata_version = NULL;
 			statelist = st;
 		}
 	} else {
@@ -240,6 +242,7 @@ int Monitor(mddev_dev_t devlist,
 			st->percent = -2;
 			st->expected_spares = -1;
 			st->spare_group = NULL;
+			st->metadata_version = NULL;
 			if (mdlist) {
 				st->expected_spares = mdlist->spare_disks;
 				if (mdlist->spare_group)
@@ -328,17 +331,22 @@ int Monitor(mddev_dev_t devlist,
 				/* external arrays don't update utime */
 				array.utime = time(0);
 
-			if (st->utime == array.utime &&
-			    st->failed == array.failed_disks &&
-			    st->working == array.working_disks &&
-			    st->spare == array.spare_disks &&
-			    (mse == NULL  || (
-				    mse->percent == st->percent
-				    ))) {
+			/* utime cannot  be trusted for external
+			 * metadata, so treat utime for external
+			 * metadata as different
+			 */
+			if  (st->utime == array.utime &&
+			     st->metadata_version &&
+			     !is_external(st->metadata_version) &&
+			     st->failed == array.failed_disks &&
+			     st->working == array.working_disks &&
+			     st->spare == array.spare_disks &&
+			     mse->percent == st->percent) {
 				close(fd);
 				st->err = 0;
 				continue;
 			}
+
 			if (st->utime == 0 && /* new array */
 			    mse->pattern && strchr(mse->pattern, '_') /* degraded */
 				)
@@ -454,6 +462,16 @@ int Monitor(mddev_dev_t devlist,
 			st->utime = array.utime;
 			st->raid = array.raid_disks;
 			st->err = 0;
+			if (mse->metadata_version) {
+				if (!st->metadata_version)
+					st->metadata_version = strdup(mse->metadata_version);
+				else if (strcmp(st->metadata_version,
+						mse->metadata_version) != 0) {
+					free(st->metadata_version);
+					st->metadata_version = strdup(mse->metadata_version);
+				}
+			}
+
 		}
 		/* now check if there are any new devices found in mdstat */
 		if (scan) {
@@ -486,6 +504,7 @@ int Monitor(mddev_dev_t devlist,
 					st->devnum = mse->devnum;
 					st->percent = -2;
 					st->spare_group = NULL;
+					st->metadata_version = NULL;
 					st->expected_spares = -1;
 					statelist = st;
 					if (test)
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

