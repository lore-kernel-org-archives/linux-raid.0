From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH 3/5] Introduce sys_hot_remove_disk()
Date: Mon, 27 Mar 2017 14:36:56 +1100
Message-ID: <149058581585.15679.12535145868752526948.stgit@noble>
References: <149058575542.15679.9804611071393072863.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149058575542.15679.9804611071393072863.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The new hot_remove_disk() will retry HOT_REMOVE_DISK
several times in the face of EBUSY.
However we sometimes remove a device by writing "remove" to the
"state" attributed.  This should be retried as well.
So introduce sys_hot_remove_disk() to repeat this action a few times.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 Manage.c |    6 +-----
 mdadm.h  |    1 +
 util.c   |   12 ++++++++++++
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/Manage.c b/Manage.c
index 9139f96e1431..edf5798aa87d 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1177,11 +1177,7 @@ int Manage_remove(struct supertype *tst, int fd, struct mddev_dev *dv,
 		/* device has been removed and we don't know
 		 * the major:minor number
 		 */
-		int n = write(sysfd, "remove", 6);
-		if (n != 6)
-			err = -1;
-		else
-			err = 0;
+		err = sys_hot_remove_disk(sysfd);
 	} else {
 		err = hot_remove_disk(fd, rdev);
 		if (err && errno == ENODEV) {
diff --git a/mdadm.h b/mdadm.h
index 53b3b5836841..52952a800ace 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1477,6 +1477,7 @@ extern int add_disk(int mdfd, struct supertype *st,
 extern int remove_disk(int mdfd, struct supertype *st,
 		       struct mdinfo *sra, struct mdinfo *info);
 extern int hot_remove_disk(int mdfd, unsigned long dev);
+extern int sys_hot_remove_disk(int statefd);
 extern int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info);
 unsigned long long min_recovery_start(struct mdinfo *array);
 
diff --git a/util.c b/util.c
index e176a9d466cf..43fd83e72ded 100644
--- a/util.c
+++ b/util.c
@@ -1813,6 +1813,18 @@ int hot_remove_disk(int mdfd, unsigned long dev)
 	return ret;
 }
 
+int sys_hot_remove_disk(int statefd)
+{
+	int cnt = 5;
+	int ret;
+
+	while ((ret = write(statefd, "remove", 6)) == -1 &&
+	       errno == EBUSY &&
+	       cnt-- > 0)
+		usleep(10000);
+	return ret == 6 ? 0 : -1;
+}
+
 int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info)
 {
 	/* Initialise kernel's knowledge of array.


