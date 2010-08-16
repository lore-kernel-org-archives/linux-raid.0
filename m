From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 28/35] Monitor: added spare sharing and dev suitable
 functions
Date: Mon, 16 Aug 2010 11:00:35 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8FA13@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From d4a187747316328858f7e7937fd37bbd250e611d Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 23 Jul 2010 23:22:57 +0200
Subject: [PATCH 28/35] Monitor: added spare sharing and dev suitable functions

Main function searching for degraded arrays and moving
spares from other arrays in the same domain.
Dev_suitable checks disk status and size to decide if disk could
be used for rebuild in degraded array.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 6a203c3..4c13095 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -48,6 +48,7 @@ struct state {
 	int devstate[MaxDisks];
 	int devid[MaxDisks];
 	int percent;
+	unsigned long long min_size;
 	char *metadata_version;
 	struct state *volumes; /* for a container it is a link its all volumes */
 	struct state *parent;  /* for volumes it is a link to its container */
@@ -651,6 +652,16 @@ int move_spare(struct state *st2, struct state *st1, int i,
 	return 0;
 }
 
+int dev_suitable(int i, struct state *st, unsigned long long size)
+{
+	unsigned long long ssize;
+	/* check if device not used in volumes, not failed, and big enough */
+	if (st->devid[i] > 0 && st->devstate[i] == 0 &&
+	    (dev_size_from_id(st->devid[i], &ssize) && ssize >= size))
+		return 1;
+	return 0;
+}
+
 /* get states of all disks in each container from metadata*/
 int getinfo_containers(struct state *statelist)
 {
@@ -705,6 +716,97 @@ cleanup:
 	return 1;
 }
 
+/* If an array has active < raid && spare == 0
+ * Look for another array/container with unused, unfailed spare
+ * and the same domain and subset
+ * if found, hotremove/hotadd the spare (to parent container in external)
+ */
+void spare_sharing(struct state *statelist, char *mailaddr,
+			   char *mailfrom, char *alert_cmd, int dosyslog)
+{
+	struct state *st, *stp, *vol, *st2 = NULL;
+	struct domain_ent *domain, *spare_domain;
+	struct subset *subset, *spare_subset;
+	int i, ext, found;
+
+	if (!getinfo_containers(statelist))
+		return;
+	for (st = statelist; st; st = st->next) {
+		if (st->err || st->active == st->raid || st->spare > 0)
+			continue;
+
+		found = 0;
+		ext = is_external(st->metadata_version);
+		/*
+		 * for exernal metadata spare will be moved to parent container
+		 */
+		if (ext) {
+			stp = st->parent;
+			if (!stp)
+				continue;
+		} else {
+			stp = st;
+		}
+		for (i = 0; i < stp->total; i++)
+			if (dev_suitable(i, stp, st->min_size))
+				break;
+		if (i < stp->total)
+			/* there is a spare in array/parent container,
+			 * it was probably just added
+			 * but mdmon has not started recovery yet
+			 * we will not add any more spares for now */
+			continue;
+		if (!get_array_domain_and_subset(stp, &domain, &subset))
+			continue;
+
+		/* search for an array/container with unused spare */
+		for (st2 = statelist; st2; st2 = st2->next) {
+			if (st2->err || st2 == stp)
+				continue;
+			if ((ext && st2->parent != NULL) ||
+			    (strcmp(stp->metadata_version, st2->metadata_version)
+					!= 0))
+				continue;
+			if (ext) {
+				/* if container has degraded volume
+				 * we can't remove spares */
+				for (vol = st2->volumes; vol; vol = vol->volumes)
+					if (vol->active < vol->raid)
+						break;
+				if (vol)
+					continue;
+			} else {
+				if (st2->active < st2->raid)
+					continue;
+			}
+			if (!get_array_domain_and_subset(st2, &spare_domain,
+							 &spare_subset))
+				continue;
+			if ((domain != spare_domain) ||
+			    (subset != spare_subset)) {
+				/* no point looking
+				 * in that array/container */
+				continue;
+			} else {
+				for (i = 0; i < st2->total; i++) {
+					if (!dev_suitable(i, st2, st->min_size))
+						continue;
+					if (move_spare(st2, stp, i, mailaddr,
+						       mailfrom, alert_cmd,
+						       dosyslog)) {
+						found = 1;
+						/* stop searching disks */
+						break;
+					}
+				}
+			}
+			if (found)
+				break; /* stop searching arrays */
+		}
+	}
+	return;
+}
+
 static void alert(char *event, char *dev, char *disc, char *mailaddr, char *mailfrom, char *cmd,
 		  int dosyslog)
 {
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

