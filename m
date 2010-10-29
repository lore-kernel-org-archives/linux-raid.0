From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 06/17] Monitor: set err on arrays not in mdstat
Date: Fri, 29 Oct 2010 15:20:17 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FC0@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From ea0b01b7c470686bf98c9e4ccd2a4c0ab49aeb89 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 23 Jul 2010 21:33:37 +0200
Subject: [PATCH 06/17] Monitor: set err on arrays not in mdstat

mse can be NULL when the array was not in mdstat when we read it
but existed in statelist and was recreated after reading mdstat.
In this case we set err as we can't get full update on this array
this time.
If the same array is given twice in command line it appears twice
in statelist. The first one will mark mse->devnum=INT_MAX
so the second one can't find mse. We set err on the second one as
it's not needed. Also if it becomes degraded we would look for spares
twice for the same array.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 0f0adb5..51df8fb 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -264,13 +264,20 @@ int Monitor(mddev_dev_t devlist,
 						st->devnum = -1- (minor(stb.st_rdev)>>6);
 				}
 			}
-
 			for (mse2 = mdstat ; mse2 ; mse2=mse2->next)
 				if (mse2->devnum == st->devnum) {
 					mse2->devnum = INT_MAX; /* flag it as "used" */
 					mse = mse2;
 				}
 
+			if (!mse) {
+				/* duplicated array in statelist
+				 * or re-created after reading mdstat*/
+				st->err = 1;
+				close(fd);
+				continue;
+			}
+			/* this array is in /proc/mdstat */
 			if (array.utime == 0)
 				/* external arrays don't update utime */
 				array.utime = time(0);
@@ -287,7 +294,6 @@ int Monitor(mddev_dev_t devlist,
 				continue;
 			}
 			if (st->utime == 0 && /* new array */
-			    mse &&	/* is in /proc/mdstat */
 			    mse->pattern && strchr(mse->pattern, '_') /* degraded */
 				)
 				alert("DegradedArray", dev, NULL, mailaddr, mailfrom, alert_cmd, dosyslog);
@@ -296,12 +302,10 @@ int Monitor(mddev_dev_t devlist,
 			    st->expected_spares > 0 &&
 			    array.spare_disks < st->expected_spares)
 				alert("SparesMissing", dev, NULL, mailaddr, mailfrom, alert_cmd, dosyslog);
-			if (mse &&
-			    st->percent == -1 &&
+			if (st->percent == -1 &&
 			    mse->percent >= 0)
 				alert("RebuildStarted", dev, NULL, mailaddr, mailfrom, alert_cmd, dosyslog);
-			if (mse &&
-			    st->percent >= 0 &&
+			if (st->percent >= 0 &&
 			    mse->percent >= 0 &&
 			    (mse->percent / increments) > (st->percent / increments)) {
 				char percentalert[15]; // "RebuildNN" (10 chars) or "RebuildStarted" (15 chars)
@@ -315,8 +319,7 @@ int Monitor(mddev_dev_t devlist,
 				      dev, NULL, mailaddr, mailfrom, alert_cmd, dosyslog);
 			}
 
-			if (mse &&
-			    mse->percent == -1 &&
+			if (mse->percent == -1 &&
 			    st->percent >= 0) {
 				/* Rebuild/sync/whatever just finished.
 				 * If there is a number in /mismatch_cnt,
@@ -333,10 +336,7 @@ int Monitor(mddev_dev_t devlist,
 				if (sra)
 					free(sra);
 			}
-
-			if (mse)
-				st->percent = mse->percent;
-
+			st->percent = mse->percent;
 
 			for (i=0; i<MaxDisks && i <= array.raid_disks + array.nr_disks;
 			     i++) {
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

