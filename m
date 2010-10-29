From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 07/17] Monitor: spare-group based spare sharing moved to
 separate function
Date: Fri, 29 Oct 2010 15:20:47 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FC2@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From 9ce79a49188faef21c4b1ea24154a670ae3516c2 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 22 Oct 2010 15:05:51 +0200
Subject: [PATCH 07/17] Monitor: spare-group based spare sharing moved to separate function

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |  155 +++++++++++++++++++++++++++++++++---------------------------
 1 files changed, 85 insertions(+), 70 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 51df8fb..f898b2e 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -38,6 +38,24 @@ static void alert(char *event, char *dev, char *disc, char *mailaddr, char *mail
  * At least it isn't MD_SB_DISKS.
  */
 #define MaxDisks 384
+
+struct state {
+	char *devname;
+	int devnum;	/* to sync with mdstat info */
+	long utime;
+	int err;
+	char *spare_group;
+	int active, working, failed, spare, raid;
+	int expected_spares;
+	int devstate[MaxDisks];
+	unsigned devid[MaxDisks];
+	int percent;
+	struct state *next;
+};
+
+static void spare_sharing_in_spare_groups(struct state *statelist, char *mailaddr,
+				   char *mailfrom, char *alert_cmd, int dosyslog);
+
 int Monitor(mddev_dev_t devlist,
 	    char *mailaddr, char *alert_cmd,
 	    int period, int daemonise, int scan, int oneshot,
@@ -85,19 +103,7 @@ int Monitor(mddev_dev_t devlist,
 	 * that appears in /proc/mdstat
 	 */
 
-	struct state {
-		char *devname;
-		int devnum;	/* to sync with mdstat info */
-		long utime;
-		int err;
-		char *spare_group;
-		int active, working, failed, spare, raid;
-		int expected_spares;
-		int devstate[MaxDisks];
-		unsigned devid[MaxDisks];
-		int percent;
-		struct state *next;
-	} *statelist = NULL;
+	struct state *statelist = NULL;
 	int finished = 0;
 	struct mdstat_ent *mdstat = NULL;
 	char *mailfrom = NULL;
@@ -448,64 +454,9 @@ int Monitor(mddev_dev_t devlist,
 					new_found = 1;
 				}
 		}
-		/* If an array has active < raid && spare == 0 && spare_group != NULL
-		 * Look for another array with spare > 0 and active == raid and same spare_group
-		 *  if found, choose a device and hotremove/hotadd
-		 */
-		for (st = statelist; st; st=st->next)
-			if (st->active < st->raid &&
-			    st->spare == 0 &&
-			    st->spare_group != NULL) {
-				struct state *st2;
-				for (st2=statelist ; st2 ; st2=st2->next)
-					if (st2 != st &&
-					    st2->spare > 0 &&
-					    st2->active == st2->raid &&
-					    st2->spare_group != NULL &&
-					    strcmp(st->spare_group, st2->spare_group) == 0) {
-						/* try to remove and add */
-						int fd1 = open(st->devname, O_RDONLY);
-						int fd2 = open(st2->devname, O_RDONLY);
-						int dev = -1;
-						int d;
-						if (fd1 < 0 || fd2 < 0) {
-							if (fd1>=0) close(fd1);
-							if (fd2>=0) close(fd2);
-							continue;
-						}
-						for (d=st2->raid; d < MaxDisks; d++) {
-							if (st2->devid[d] > 0 &&
-							    st2->devstate[d] == 0) {
-								dev = st2->devid[d];
-								break;
-							}
-						}
-						if (dev > 0) {
-							struct mddev_dev_s devlist;
-							char devname[20];
-							devlist.next = NULL;
-							devlist.used = 0;
-							devlist.re_add = 0;
-							devlist.writemostly = 0;
-							devlist.devname = devname;
-							sprintf(devname, "%d:%d", major(dev), minor(dev));
-
-							devlist.disposition = 'r';
-							if (Manage_subdevs(st2->devname, fd2, &devlist, -1, 0) == 0) {
-								devlist.disposition = 'a';
-								if (Manage_subdevs(st->devname, fd1, &devlist, -1, 0) == 0) {
-									alert("MoveSpare", st->devname, st2->devname, mailaddr, mailfrom, alert_cmd, dosyslog);
-									close(fd1);
-									close(fd2);
-									break;
-								}
-								else Manage_subdevs(st2->devname, fd2, &devlist, -1, 0);
-							}
-						}
-						close(fd1);
-						close(fd2);
-					}
-			}
+
+		spare_sharing_in_spare_groups(statelist, mailaddr, mailfrom, alert_cmd, dosyslog);
+
 		if (!new_found) {
 			if (oneshot)
 				break;
@@ -519,6 +470,70 @@ int Monitor(mddev_dev_t devlist,
 	return 0;
 }
 
+/* If an array has active < raid && spare == 0 && spare_group != NULL
+ * Look for another array with spare > 0 and active == raid and same spare_group
+ *  if found, choose a device and hotremove/hotadd
+ */
+static void spare_sharing_in_spare_groups(struct state *statelist, char *mailaddr,
+					  char *mailfrom, char *alert_cmd, int dosyslog)
+{
+	struct state *st;
+
+	for (st = statelist; st; st=st->next)
+		if (st->active < st->raid &&
+		    st->spare == 0 &&
+		    st->spare_group != NULL) {
+			struct state *st2;
+			for (st2=statelist ; st2 ; st2=st2->next)
+				if (st2 != st &&
+				    st2->spare > 0 &&
+				    st2->active == st2->raid &&
+				    st2->spare_group != NULL &&
+				    strcmp(st->spare_group, st2->spare_group) == 0) {
+					/* try to remove and add */
+					int fd1 = open(st->devname, O_RDONLY);
+					int fd2 = open(st2->devname, O_RDONLY);
+					int dev = -1;
+					int d;
+					if (fd1 < 0 || fd2 < 0) {
+						if (fd1>=0) close(fd1);
+						if (fd2>=0) close(fd2);
+						continue;
+					}
+					for (d=st2->raid; d < MaxDisks; d++) {
+						if (st2->devid[d] > 0 &&
+						    st2->devstate[d] == 0) {
+							dev = st2->devid[d];
+							break;
+						    }
+					}
+					if (dev > 0) {
+						struct mddev_dev_s devlist;
+						char devname[20];
+						devlist.next = NULL;
+						devlist.used = 0;
+						devlist.re_add = 0;
+						devlist.writemostly = 0;
+						devlist.devname = devname;
+						sprintf(devname, "%d:%d", major(dev), minor(dev));
+						devlist.disposition = 'r';
+						if (Manage_subdevs(st2->devname, fd2, &devlist, -1, 0) == 0) {
+							devlist.disposition = 'a';
+							if (Manage_subdevs(st->devname, fd1, &devlist, -1, 0) == 0) {
+								alert("MoveSpare", st->devname, st2->devname, mailaddr,
+								      mailfrom, alert_cmd, dosyslog);
+								close(fd1);
+								close(fd2);
+								break;
+							}
+							else Manage_subdevs(st2->devname, fd2, &devlist, -1, 0);
+						}
+					}
+					close(fd1);
+					close(fd2);
+				}
+		}
+}
 
 static void alert(char *event, char *dev, char *disc, char *mailaddr, char *mailfrom, char *cmd,
 		  int dosyslog)
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

