From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH v3] Monitor: containers don't have the same sysfs properties as arrays
Date: Wed, 16 Aug 2017 14:22:32 +0200
Message-ID: <1502886152-14765-1-git-send-email-mariusz.tkaczyk@intel.com>
References: <544652f0-97d4-d228-7832-cd0268727433@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <544652f0-97d4-d228-7832-cd0268727433@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
List-Id: linux-raid.ids

GET_MISMATCH option doesn't exist for containers so sysfs_read fails if
this information is requested. Set options according to the device using
information from /proc/mdstat.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 Monitor.c | 46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 48c451c..f70e5b5 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -465,6 +465,8 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 	int last_disk;
 	int new_array = 0;
 	int retval;
+	int is_container = 0;
+	unsigned long array_only_flags = 0;
 
 	if (test)
 		alert("TestMessage", dev, NULL, ainfo);
@@ -475,6 +477,26 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
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
+	if (mse->level == NULL)
+		is_container = 1;
+
 	if (!md_array_active(fd))
 		goto disappeared;
 
@@ -482,11 +504,12 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
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
 
@@ -500,19 +523,6 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
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
@@ -653,7 +663,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
  out:
 	if (sra)
 		sysfs_free(sra);
-	if (fd > 0)
+	if (fd >= 0)
 		close(fd);
 	return retval;
 
-- 
1.8.3.1

