From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 29/35] Monitor: autorebuild funcionality added
Date: Mon, 16 Aug 2010 11:01:23 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8FA16@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 7bfafc9646157c0f98ddc49e77474f1c92e1104e Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 23 Jul 2010 23:49:46 +0200
Subject: [PATCH 29/35] Monitor: autorebuild funcionality added

We use previously defined functions to repair any degraded arrays found
by monitoring process. For each volume we check state, report any changes,
note minimum size of disks and link with parent container.
After all information is updated we call spare_sharing that searches
for suitable spares in other arrays and moves them to the arrays that
need them.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   91 +++++++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 59 insertions(+), 32 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 4c13095..c7e0798 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -55,7 +55,8 @@ struct state {
 	struct state *next;
 };
 
-
+static void spare_sharing(struct state *statelist, char *mailaddr,
+			  char *mailfrom, char *alert_cmd, int dosyslog);
 
 static void add_to_cont(struct state *cont, struct state *vol)
 {
@@ -106,6 +107,10 @@ int Monitor(mddev_dev_t devlist,
 	 *    DeviceDisappeared
 	 *      Couldn't access a device which was previously visible
 	 *
+	 * If we detect an array with active<raid and spare==0
+	 * we look at other arrays that have a spare
+	 * and are in the same domain and subset
+	 * Then we hot-remove and hot-add to the other array
 	 *
 	 * If devlist is NULL, then we can monitor everything because --scan
 	 * was given.  We get an initial list from config file and add anything
@@ -113,6 +118,7 @@ int Monitor(mddev_dev_t devlist,
 	 */
 
 	int finished = 0;
+	int anydegraded;
 	struct mdstat_ent *mdstat = NULL;
 	char *mailfrom = NULL;
 	struct state *statelist = NULL;
@@ -222,6 +228,9 @@ int Monitor(mddev_dev_t devlist,
 			st->parent = NULL;
 			st->volumes = NULL;
 			st->total = 0;
+			st->min_size = 0;
+			memset(st->devid, 0, MaxDisks*sizeof(int));
+			memset(st->devstate, 0, MaxDisks*sizeof(int));
 			statelist = st;
 		}
 	} else {
@@ -242,6 +251,9 @@ int Monitor(mddev_dev_t devlist,
 			st->parent = NULL;
 			st->volumes = NULL;
 			st->total = 0;
+			st->min_size = 0;
+			memset(st->devid, 0, MaxDisks*sizeof(int));
+			memset(st->devstate, 0, MaxDisks*sizeof(int));
 			if (mdlist) {
 				st->expected_spares = mdlist->spare_disks;
 			}
@@ -254,6 +266,7 @@ int Monitor(mddev_dev_t devlist,
 		int new_found = 0;
 		struct state *st;
 
+		anydegraded = 0;
 		if (mdstat)
 			free_mdstat(mdstat);
 		mdstat = mdstat_read(oneshot?0:1, 0);
@@ -334,18 +347,17 @@ int Monitor(mddev_dev_t devlist,
 			 * metadata, so treat utime for external
 			 * metadata as different
 			 */
-			if ((st->utime == array.utime &&
-			   ((st->metadata_version == NULL) ||
-			     !is_external(st->metadata_version))) &&
+			if  (st->utime == array.utime &&
+			    (st->metadata_version &&
+			     !is_external(st->metadata_version)) &&
 			     st->failed == array.failed_disks &&
 			     st->working == array.working_disks &&
 			     st->spare == array.spare_disks &&
-			    (mse == NULL  || (mse->percent == st->percent))) {
-				close(fd);
+			    (mse->percent == st->percent)) {
 				st->err = 0;
+				close(fd);
 				continue;
 			}
-
 			if (st->utime == 0 && /* new array */
 			    mse->pattern && strchr(mse->pattern, '_') /* degraded */
 				)
@@ -409,6 +421,7 @@ int Monitor(mddev_dev_t devlist,
 				int newstate=0;
 				int change;
 				char *dv = NULL;
+				unsigned long long dsize;
 				disc.number = i;
 				if (i > array.raid_disks + array.nr_disks) {
 					newstate = 0;
@@ -453,6 +466,19 @@ int Monitor(mddev_dev_t devlist,
 				}
 				st->devstate[i] = newstate;
 				st->devid[i] = makedev(disc.major, disc.minor);
+
+				if (!share)
+					continue;
+				/* for volumes only we get minimum disk size
+				 * (only active disks) */
+				fd = open(dv, O_RDONLY);
+				if (dv && newstate & (1<<MD_DISK_ACTIVE) &&
+				    array.raid_disks && fd >= 0 &&
+				    get_dev_size(fd, dv, &dsize) &&
+				    (st->min_size == 0 || dsize < st->min_size))
+					st->min_size = dsize;
+				if (fd >= 0)
+					close(fd);
 			}
 			st->active = array.active_disks;
 			st->working = array.working_disks;
@@ -462,6 +488,8 @@ int Monitor(mddev_dev_t devlist,
 			st->raid = array.raid_disks;
 			st->total = array.raid_disks + array.nr_disks;
 			st->err = 0;
+			if ((st->active < st->raid) && st->spare == 0)
+				anydegraded = 1;
 			if (mse->metadata_version) {
 				if (!st->metadata_version)
 					st->metadata_version = strdup(mse->metadata_version);
@@ -515,27 +543,26 @@ int Monitor(mddev_dev_t devlist,
 					new_found = 1;
 				}
 		}
-
-		/* search the statelist to connect external
-		 * metadata volumes with their containers
-		 */
-		for (st = statelist; st; st = st->next) {
-			if (st->metadata_version &&
-			    is_external(st->metadata_version) &&
-			    is_subarray(st->metadata_version+9)) {
-				struct state *cont = NULL;
-
-				for (cont = statelist; cont; cont = cont->next) {
-					if (!cont->err &&
-					    cont->parent == NULL &&
-					    cont->metadata_version &&
-					    devname2devnum(st->metadata_version+10)
-					    == cont->devnum) {
-						add_to_cont(cont, st);
-						break;
+		if (share && anydegraded) {
+			/* parent-volume linking only needed when sharing spares */
+			for (st = statelist; st; st = st->next) {
+				if (!st->err &&
+				    st->metadata_version &&
+				    is_external(st->metadata_version) &&
+				    is_subarray(st->metadata_version+9)) {
+					struct state *cont = NULL;
+					for (cont = statelist; cont; cont = cont->next) {
+						if (!cont->err &&
+						cont->parent == NULL &&
+						cont->metadata_version &&
+						devname2devnum(st->metadata_version+10)	== cont->devnum) {
+							add_to_cont(cont, st);
+							break;
+						}
 					}
 				}
 			}
+			spare_sharing(statelist, mailaddr, mailfrom, alert_cmd, dosyslog);
 		}
 		if (!new_found) {
 			if (oneshot)
@@ -597,9 +624,8 @@ fail:
 }
 
 int move_spare(struct state *st2, struct state *st1, int i,
-		      char *mailaddr, char *mailfrom, char *alert_cmd, 
-		      int dosyslog)
-
+	       char *mailaddr, char *mailfrom, char *alert_cmd,
+	       int dosyslog)
 {
 	struct mddev_dev_s devlist;
 	char devname[20];
@@ -652,7 +678,8 @@ int move_spare(struct state *st2, struct state *st1, int i,
 	return 0;
 }
 
-int dev_suitable(int i, struct state *st, unsigned long long size)
+
+static int dev_suitable(int i, struct state *st, unsigned long long size)
 {
 	unsigned long long ssize;
 	/* check if device not used in volumes, not failed, and big enough */
@@ -663,7 +690,7 @@ int dev_suitable(int i, struct state *st, unsigned long long size)
 }
 
 /* get states of all disks in each container from metadata*/
-int getinfo_containers(struct state *statelist)
+static int getinfo_containers(struct state *statelist)
 {
 	struct state *st;
 	struct supertype *sty;
@@ -721,8 +748,8 @@ cleanup:
  * and the same domain and subset
  * if found, hotremove/hotadd the spare (to parent container in external)
  */
-void spare_sharing(struct state *statelist, char *mailaddr,
-			   char *mailfrom, char *alert_cmd, int dosyslog)
+static void spare_sharing(struct state *statelist, char *mailaddr,
+			  char *mailfrom, char *alert_cmd, int dosyslog)
 {
 	struct state *st, *stp, *vol, *st2 = NULL;
 	struct domain_ent *domain, *spare_domain;
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

