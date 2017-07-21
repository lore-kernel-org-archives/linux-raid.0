From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH] Monitor: containers don't have the same sysfs properties as arrays
Date: Fri, 21 Jul 2017 14:15:37 +0200
Message-ID: <1500639337-12816-1-git-send-email-mariusz.tkaczyk@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
List-Id: linux-raid.ids

GET_MISMATCH option doesn't exist for containers so sysfs_read fails if
this information is requested. Set options according to the device using
information from /proc/mdstat.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Reviewed-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 Monitor.c | 50 ++++++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 48c451c..8d753ca 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -459,22 +459,41 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	mdu_array_info_t array;
 	struct mdstat_ent *mse = NULL, *mse2;
 	char *dev = st->devname;
-	int fd;
+	int fd = -1;
 	int i;
 	int remaining_disks;
 	int last_disk;
 	int new_array = 0;
-	int retval;
+	int retval = 0;
+	int is_container;
+	unsigned long array_only_flags = 0;
 
 	if (test)
 		alert("TestMessage", dev, NULL, ainfo);
 
-	retval = 0;
-
 	fd = open(dev, O_RDONLY);
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
 
@@ -482,11 +501,11 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	if (md_get_array_info(fd, &array) < 0)
 		goto disappeared;
 
-	if (st->devnm[0] == 0)
-		strcpy(st->devnm, fd2devnm(fd));
+	array_only_flags |= !is_container ? GET_MISMATCH : 0;
+
+	sra = sysfs_read(-1, st->devnm, GET_LEVEL | GET_DISKS | GET_DEVS |
+			GET_STATE | array_only_flags);
 
-	sra = sysfs_read(-1, st->devnm, GET_LEVEL | GET_DISKS | GET_MISMATCH |
-			 GET_DEVS | GET_STATE);
 	if (!sra)
 		goto disappeared;
 
@@ -500,19 +519,6 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
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
@@ -653,7 +659,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
  out:
 	if (sra)
 		sysfs_free(sra);
-	if (fd > 0)
+	if (fd >= 0)
 		close(fd);
 	return retval;
 
-- 
1.8.3.1

