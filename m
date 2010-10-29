From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 11/17] Monitor: link containers with subarrays in statelist
Date: Fri, 29 Oct 2010 15:24:16 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FCD@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From dca12f05c3fcbdd68c6063f4f55c60ee0ac70daf Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Mon, 8 Nov 2010 19:15:09 +0100
Subject: [PATCH 11/17] Monitor: link containers with subarrays in statelist

Each containers has list of its subarrays. Each subarray
has back link to its parent container.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 0f8a6b9..80cc553 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -45,17 +45,23 @@ struct state {
 	long utime;
 	int err;
 	char *spare_group;
-	int active, working, failed, spare, raid;
+	int active, working, failed, spare, raid, total;
 	int expected_spares;
 	int devstate[MaxDisks];
 	unsigned devid[MaxDisks];
 	int percent;
 	char *metadata_version;
+	struct state *subarray;/* for a container it is a link to first subarray
+				* for a subarray it is a link to next subarray
+				* in the same container */
+	struct state *parent;  /* for a subarray it is a link to its container
+				*/
 	struct state *next;
 };
 
 static void spare_sharing_in_spare_groups(struct state *statelist, char *mailaddr,
 				   char *mailfrom, char *alert_cmd, int dosyslog);
+static void link_containers_with_subarrays(struct state *list);
 
 int Monitor(mddev_dev_t devlist,
 	    char *mailaddr, char *alert_cmd,
@@ -225,6 +231,9 @@ int Monitor(mddev_dev_t devlist,
 			else
 				st->spare_group = NULL;
 			st->metadata_version = NULL;
+			st->parent = NULL;
+			st->subarray = NULL;
+			st->total = 0;
 			statelist = st;
 		}
 	} else {
@@ -243,6 +252,9 @@ int Monitor(mddev_dev_t devlist,
 			st->expected_spares = -1;
 			st->spare_group = NULL;
 			st->metadata_version = NULL;
+			st->parent = NULL;
+			st->subarray = NULL;
+			st->total = 0;
 			if (mdlist) {
 				st->expected_spares = mdlist->spare_disks;
 				if (mdlist->spare_group)
@@ -269,6 +281,8 @@ int Monitor(mddev_dev_t devlist,
 			int fd;
 			int i;
 
+			st->parent = NULL;
+			st->subarray = NULL;
 			if (test)
 				alert("TestMessage", dev, NULL, mailaddr, mailfrom, alert_cmd, dosyslog);
 			fd = open(dev, O_RDONLY);
@@ -461,6 +475,7 @@ int Monitor(mddev_dev_t devlist,
 			st->failed = array.failed_disks;
 			st->utime = array.utime;
 			st->raid = array.raid_disks;
+			st->total = array.raid_disks + array.nr_disks;
 			st->err = 0;
 			if (mse->metadata_version) {
 				if (!st->metadata_version)
@@ -505,6 +520,9 @@ int Monitor(mddev_dev_t devlist,
 					st->percent = -2;
 					st->spare_group = NULL;
 					st->metadata_version = NULL;
+					st->parent = NULL;
+					st->subarray = NULL;
+					st->total = 0;
 					st->expected_spares = -1;
 					statelist = st;
 					if (test)
@@ -513,8 +531,10 @@ int Monitor(mddev_dev_t devlist,
 					new_found = 1;
 				}
 		}
-		if (share)
+		if (share) {
 			spare_sharing_in_spare_groups(statelist, mailaddr, mailfrom, alert_cmd, dosyslog);
+			link_containers_with_subarrays(statelist);
+		}
 		if (!new_found) {
 			if (oneshot)
 				break;
@@ -593,6 +613,44 @@ static void spare_sharing_in_spare_groups(struct state *statelist, char *mailadd
 		}
 }
 
+static void add_to_cont(struct state *cont, struct state *sub)
+{
+	struct state *last = NULL, *iter = NULL;
+
+	sub->parent = cont;
+	iter = last = cont;
+	while (iter != sub && (iter = iter->subarray) != NULL)
+		last = iter;
+	/* don't duplicate subarray entries on the list */
+	if (iter != sub)
+		last->subarray = sub;
+}
+
+/* search the statelist to connect external
+ * metadata subarrays with their containers
+ */
+static void link_containers_with_subarrays(struct state *list)
+{
+	struct state *st;
+	for (st = list; st; st = st->next) {
+		if (st->metadata_version &&
+		    is_external(st->metadata_version) &&
+		    is_subarray(st->metadata_version+9)) {
+			struct state *cont = NULL;
+			for (cont = list; cont; cont = cont->next) {
+				if (!cont->err &&
+				    cont->parent == NULL &&
+				    cont->metadata_version &&
+				    devname2devnum(st->metadata_version+10)
+				    == cont->devnum) {
+					add_to_cont(cont, st);
+					break;
+				}
+			}
+		}
+	}
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

