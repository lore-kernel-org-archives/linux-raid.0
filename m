From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: PATCH 2/3] move_spare function modified and moved to Manage.c
Date: Tue, 4 Jan 2011 15:04:59 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E759FE2@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

From 2779f42c919a6870f9cfab6478cc97858d7ad7f8 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Tue, 4 Jan 2011 15:22:21 +0100
Subject: [PATCH 2/3] move_spare function modified and moved to Manage.c
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

It will also be needed for Incremental.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Manage.c  |   44 ++++++++++++++++++++++++++++++++++++++++++++
 Monitor.c |   51 ++++-----------------------------------------------
 mdadm.h   |    1 +
 3 files changed, 49 insertions(+), 47 deletions(-)

diff --git a/Manage.c b/Manage.c
index 81fa986..6b0853d 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1096,4 +1096,48 @@ int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident
 
 	return rv;
 }
+
+/* Move spare from one array to another
+ * If adding to destination array fails
+ * add back to original array
+ * Returns 1 on success, 0 on failure */
+int move_spare(char *from_devname, char *to_devname, dev_t devid)
+{
+	struct mddev_dev devlist;
+	char devname[20];
+
+	/* try to remove and add */
+	int fd1 = open(to_devname, O_RDONLY);
+	int fd2 = open(from_devname, O_RDONLY);
+
+	if (fd1 < 0 || fd2 < 0) {
+		if (fd1>=0) close(fd1);
+		if (fd2>=0) close(fd2);
+		return 0;
+	}
+
+	devlist.next = NULL;
+	devlist.used = 0;
+	devlist.re_add = 0;
+	devlist.writemostly = 0;
+	devlist.devname = devname;
+	sprintf(devname, "%d:%d", major(devid), minor(devid));
+
+	devlist.disposition = 'r';
+	if (Manage_subdevs(from_devname, fd2, &devlist, -1, 0, NULL) == 0) {
+		devlist.disposition = 'a';
+		if (Manage_subdevs(to_devname, fd1, &devlist, -1, 0, NULL) == 0) {
+			/* make sure manager is aware of changes */
+			ping_manager(to_devname);
+			ping_manager(from_devname);
+			close(fd1);
+			close(fd2);
+			return 1;
+		}
+		else Manage_subdevs(from_devname, fd2, &devlist, -1, 0, NULL);
+	}
+	close(fd1);
+	close(fd2);
+	return 0;
+}
 #endif
diff --git a/Monitor.c b/Monitor.c
index 428c227..8f28382 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -722,51 +722,6 @@ unsigned long long min_spare_size_required(struct state *st)
 	return rv;
 }
 
-static int move_spare(struct state *from, struct state *to,
-		      dev_t devid,
-		      struct alert_info *info)
-{
-	struct mddev_dev devlist;
-	char devname[20];
-
-	/* try to remove and add */
-	int fd1 = open(to->devname, O_RDONLY);
-	int fd2 = open(from->devname, O_RDONLY);
-
-	if (fd1 < 0 || fd2 < 0) {
-		if (fd1>=0) close(fd1);
-		if (fd2>=0) close(fd2);
-		return 0;
-	}
-
-	devlist.next = NULL;
-	devlist.used = 0;
-	devlist.re_add = 0;
-	devlist.writemostly = 0;
-	devlist.devname = devname;
-	sprintf(devname, "%d:%d", major(devid), minor(devid));
-
-	devlist.disposition = 'r';
-	if (Manage_subdevs(from->devname, fd2, &devlist, -1, 0, NULL) == 0) {
-		devlist.disposition = 'a';
-		if (Manage_subdevs(to->devname, fd1, &devlist, -1, 0, NULL) == 0) {
-			alert("MoveSpare", to->devname, from->devname, info);
-			/* make sure we will see newly added spare before next
-			 * time through loop
-			 */
-			ping_manager(to->devname);
-			ping_manager(from->devname);
-			close(fd1);
-			close(fd2);
-			return 1;
-		}
-		else Manage_subdevs(from->devname, fd2, &devlist, -1, 0, NULL);
-	}
-	close(fd1);
-	close(fd2);
-	return 0;
-}
-
 static int check_donor(struct state *from, struct state *to)
 {
 	struct state *sub;
@@ -912,8 +867,10 @@ static void try_spare_migration(struct state *statelist, struct alert_info *info
 					devid = choose_spare(from, to, domlist,
 							     min_size);
 				if (devid > 0
-				    && move_spare(from, to, devid, info))
-						break;
+				    && move_spare(from->devname, to->devname, devid)) {
+					alert("MoveSpare", to->devname, from->devname, info);
+					break;
+				}
 			}
 			domain_free(domlist);
 		}
diff --git a/mdadm.h b/mdadm.h
index dd5c901..925f997 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1100,6 +1100,7 @@ extern struct mdinfo *container_chose_spares(struct supertype *st,
 					     struct domainlist *domlist,
 					     char *spare_group,
 					     const char *metadata, int get_one);
+extern int move_spare(char *from_devname, char *to_devname, dev_t devid);
 extern int add_disk(int mdfd, struct supertype *st,
 		    struct mdinfo *sra, struct mdinfo *info);
 extern int remove_disk(int mdfd, struct supertype *st,
-- 
1.7.1

