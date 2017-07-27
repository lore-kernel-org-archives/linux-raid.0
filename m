From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH v2] Monitor: containers don't have the same sysfs properties as arrays
Date: Thu, 27 Jul 2017 15:22:08 +0200
Message-ID: <1501161728-580-1-git-send-email-mariusz.tkaczyk@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
List-Id: linux-raid.ids

GET_MISMATCH option doesn't exist for containers so sysfs_read fails if
this information is requested. Set options according to the device using
information from /proc/mdstat.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 Monitor.c | 45 +++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 48c451c..de470bd 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -465,6 +465,8 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	int last_disk;
 	int new_array = 0;
 	int retval;
+	int is_container;
+	unsigned long array_only_flags = 0;
 
 	if (test)
 		alert("TestMessage", dev, NULL, ainfo);
@@ -475,6 +477,25 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	if (fd < 0)
 		goto disappeared;
 
+	if (st->devnm[0] == 0)
+		strcpy(st->devnm, fd2devnm(fd));
+
+	for (mse2 = mdstat; mse2; mse2 = mse2->next)
+		if (strcmp(mse2->devnm, st->devnm) == 0) {
+			mse2->devnm[0] = 0; /* flag it as "used" */
+			mse = mse2;
+		}
+
+	if (!mse) {
+		/* duplicated array in statelist
+		 * or re-created after reading mdstat
+		 */
+		st->err++;
+		goto out;
+	}
+
+	is_container = mse->level == NULL;
+
 	if (!md_array_active(fd))
 		goto disappeared;
 
@@ -482,11 +503,12 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	if (md_get_array_info(fd, &array) < 0)
 		goto disappeared;
 
-	if (st->devnm[0] == 0)
-		strcpy(st->devnm, fd2devnm(fd));
+	if (!is_container)
+		array_only_flags |= GET_MISMATCH;
+
+	sra = sysfs_read(-1, st->devnm, GET_LEVEL | GET_DISKS | GET_DEVS |
+			GET_STATE | array_only_flags);
 
-	sra = sysfs_read(-1, st->devnm, GET_LEVEL | GET_DISKS | GET_MISMATCH |
-			 GET_DEVS | GET_STATE);
 	if (!sra)
 		goto disappeared;
 
@@ -500,19 +522,6 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		goto out;
 	}
 
-	for (mse2 = mdstat; mse2; mse2 = mse2->next)
-		if (strcmp(mse2->devnm, st->devnm) == 0) {
-			mse2->devnm[0] = 0; /* flag it as "used" */
-			mse = mse2;
-		}
-
-	if (!mse) {
-		/* duplicated array in statelist
-		 * or re-created after reading mdstat*/
-		st->err++;
-		close(fd);
-		goto out;
-	}
 	/* this array is in /proc/mdstat */
 	if (array.utime == 0)
 		/* external arrays don't update utime, so
@@ -653,7 +662,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
  out:
 	if (sra)
 		sysfs_free(sra);
-	if (fd > 0)
+	if (fd >= 0)
 		close(fd);
 	return retval;
 
-- 
1.8.3.1

