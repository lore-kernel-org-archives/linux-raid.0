From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 23/35] Monitor: link container-volumes in statelist
Date: Mon, 16 Aug 2010 10:57:51 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8FA00@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 2d059753de6282ad5f9f4e82e631f98015a2e1e6 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 23 Jul 2010 22:44:14 +0100
Subject: [PATCH 23/35] Monitor: link container-volumes in statelist

To avoid repeated retrieving parent container when looking for spares.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 Monitor.c |  118 ++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 94 insertions(+), 24 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 088d511..91a8b69 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -38,6 +38,37 @@ static void alert(char *event, char *dev, char *disc, char *mailaddr, char *mail
  * At least it isn't MD_SB_DISKS.
  */
 #define MaxDisks 384
+struct state {
+	char *devname;
+	int devnum;	/* to sync with mdstat info */
+	long utime;
+	int err;
+	int active, working, failed, spare, raid, total;
+	int expected_spares;
+	int devstate[MaxDisks];
+	int devid[MaxDisks];
+	int percent;
+	char *metadata_version;
+	struct state *volumes; /* for a container it is a link its all volumes */
+	struct state *parent;  /* for volumes it is a link to its container */
+	struct state *next;
+};
+
+
+
+static void add_to_cont(struct state *cont, struct state *vol)
+{
+	struct state *last = NULL, *iter = NULL;
+
+	vol->parent = cont;
+	iter = last = cont;
+	while (iter != vol && (iter = iter->volumes) != NULL)
+		last = iter;
+	/* don't duplicate volume entries on the list */
+	if (iter != vol)
+		last->volumes = vol;
+}
+
 int Monitor(mddev_dev_t devlist,
 	    char *mailaddr, char *alert_cmd,
 	    int period, int daemonise, int scan, int oneshot,
@@ -80,21 +111,10 @@ int Monitor(mddev_dev_t devlist,
 	 * that appears in /proc/mdstat
 	 */
 
-	struct state {
-		char *devname;
-		int devnum;	/* to sync with mdstat info */
-		long utime;
-		int err;
-		int active, working, failed, spare, raid;
-		int expected_spares;
-		int devstate[MaxDisks];
-		int devid[MaxDisks];
-		int percent;
-		struct state *next;
-	} *statelist = NULL;
 	int finished = 0;
 	struct mdstat_ent *mdstat = NULL;
 	char *mailfrom = NULL;
+	struct state *statelist = NULL;
 
 	if (!mailaddr) {
 		mailaddr = conf_get_mailaddr();
@@ -197,6 +217,10 @@ int Monitor(mddev_dev_t devlist,
 			st->devnum = INT_MAX;
 			st->percent = -2;
 			st->expected_spares = mdlist->spare_disks;
+			st->metadata_version = NULL;
+			st->parent = NULL;
+			st->volumes = NULL;
+			st->total = 0;
 			statelist = st;
 		}
 	} else {
@@ -213,6 +237,10 @@ int Monitor(mddev_dev_t devlist,
 			st->devnum = INT_MAX;
 			st->percent = -2;
 			st->expected_spares = -1;
+			st->metadata_version = NULL;
+			st->parent = NULL;
+			st->volumes = NULL;
+			st->total = 0;
 			if (mdlist) {
 				st->expected_spares = mdlist->spare_disks;
 			}
@@ -237,6 +265,8 @@ int Monitor(mddev_dev_t devlist,
 			int fd;
 			unsigned int i;
 
+			st->parent = NULL;
+			st->volumes = NULL;
 			if (test)
 				alert("TestMessage", dev, NULL, mailaddr, mailfrom, alert_cmd, dosyslog);
 			fd = open(dev, O_RDONLY);
@@ -299,17 +329,22 @@ int Monitor(mddev_dev_t devlist,
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
+			if ((st->utime == array.utime &&
+			   ((st->metadata_version == NULL) ||
+			     !is_external(st->metadata_version))) &&
+			     st->failed == array.failed_disks &&
+			     st->working == array.working_disks &&
+			     st->spare == array.spare_disks &&
+			    (mse == NULL  || (mse->percent == st->percent))) {
 				close(fd);
 				st->err = 0;
 				continue;
 			}
+
 			if (st->utime == 0 && /* new array */
 			    mse->pattern && strchr(mse->pattern, '_') /* degraded */
 				)
@@ -424,17 +459,28 @@ int Monitor(mddev_dev_t devlist,
 			st->failed = array.failed_disks;
 			st->utime = array.utime;
 			st->raid = array.raid_disks;
+			st->total = array.raid_disks + array.nr_disks;
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
+
 		/* now check if there are any new devices found in mdstat */
 		if (scan) {
 			struct mdstat_ent *mse;
 			for (mse=mdstat; mse; mse=mse->next)
 				if (mse->devnum != INT_MAX &&
-				    mse->level &&
-				    (strcmp(mse->level, "raid0")!=0 &&
-				     strcmp(mse->level, "linear")!=0)
-					) {
+				   (!mse->level  || /* retrieve containers */
+				    (strcmp(mse->level, "raid0") != 0 &&
+				     strcmp(mse->level, "linear") != 0))) {
 					struct state *st = malloc(sizeof *st);
 					mdu_array_info_t array;
 					int fd;
@@ -456,6 +502,10 @@ int Monitor(mddev_dev_t devlist,
 					st->err = 1;
 					st->devnum = mse->devnum;
 					st->percent = -2;
+					st->metadata_version = NULL;
+					st->parent = NULL;
+					st->volumes = NULL;
+					st->total = 0;
 					st->expected_spares = -1;
 					statelist = st;
 					if (test)
@@ -465,6 +515,27 @@ int Monitor(mddev_dev_t devlist,
 				}
 		}
 
+		/* search the statelist to connect external
+		 * metadata volumes with their containers
+		 */
+		for (st = statelist; st; st = st->next) {
+			if (st->metadata_version &&
+			    is_external(st->metadata_version) &&
+			    is_subarray(st->metadata_version+9)) {
+				struct state *cont = NULL;
+
+				for (cont = statelist; cont; cont = cont->next) {
+					if (!cont->err &&
+					    cont->parent == NULL &&
+					    cont->metadata_version &&
+					    devname2devnum(st->metadata_version+10)
+					    == cont->devnum) {
+						add_to_cont(cont, st);
+						break;
+					}
+				}
+			}
+		}
 		if (!new_found) {
 			if (oneshot)
 				break;
@@ -478,7 +549,6 @@ int Monitor(mddev_dev_t devlist,
 	return 0;
 }
 
-
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

