From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/2] mdadm/r5cache: allow adding journal to array without journal
Date: Wed, 15 Mar 2017 11:28:49 -0700
Message-ID: <20170315182850.3628010-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

We use to apply constraints to --add-journal:
  1. We only support recreate journal for arrays with missing journal;
  2. The array need to be readonly when the journal is added.

As the kernel code getting more mature, these constraints are no longer
necessary. This patch removes this constraints from mdadm.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Manage.c   | 29 ++++-------------------------
 md_p.h     |  5 +++++
 mdadm.8.in |  7 ++-----
 3 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/Manage.c b/Manage.c
index 5c3d2b9..289b7ce 100644
--- a/Manage.c
+++ b/Manage.c
@@ -946,28 +946,13 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 
 	/* only add journal to array that supports journaling */
 	if (dv->disposition == 'j') {
-		struct mdinfo mdi;
-		struct mdinfo *mdp;
-
-		mdp = sysfs_read(fd, NULL, GET_ARRAY_STATE);
-		if (!mdp) {
-			pr_err("%s unable to read array state.\n", devname);
-			return -1;
-		}
-
-		if (strncmp(mdp->sysfs_array_state, "readonly", 8) != 0) {
-			sysfs_free(mdp);
-			pr_err("%s is not readonly, cannot add journal.\n", devname);
+		if ((array->state & (1<<MD_SB_HAS_JOURNAL)) &&
+		    !(array->state & (1<<MD_SB_JOURNAL_REMOVABLE))) {
+			pr_err("%s has a working journal. Hot spare journal device is not supported.\n",
+			       devname);
 			return -1;
 		}
 
-		sysfs_free(mdp);
-
-		tst->ss->getinfo_super(tst, &mdi, NULL);
-		if (mdi.journal_device_required == 0) {
-			pr_err("%s does not support journal device.\n", devname);
-			return -1;
-		}
 		disc.raid_disk = 0;
 	}
 
@@ -1097,12 +1082,6 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 				       dv->devname, j, strerror(errno));
 			return -1;
 		}
-		if (dv->disposition == 'j') {
-			pr_err("Journal added successfully, making %s read-write\n", devname);
-			if (Manage_ro(devname, fd, -1))
-				pr_err("Failed to make %s read-write\n", devname);
-		}
-
 	}
 	if (verbose >= 0)
 		pr_err("added %s\n", dv->devname);
diff --git a/md_p.h b/md_p.h
index dc9fec1..7081bd9 100644
--- a/md_p.h
+++ b/md_p.h
@@ -121,6 +121,11 @@ typedef struct mdp_device_descriptor_s {
 				   * in container can be activated */
 #define MD_SB_CLUSTERED		5 /* MD is clustered  */
 #define	MD_SB_BITMAP_PRESENT	8 /* bitmap may be present nearby */
+#define	MD_SB_HAS_JOURNAL	9
+#define	MD_SB_JOURNAL_REMOVABLE	10 /* journal _feature_ can be removed,
+				    * which means the journal is either
+				    * missing or Faulty
+				    */
 
 typedef struct mdp_superblock_s {
 	/*
diff --git a/mdadm.8.in b/mdadm.8.in
index df1d460..087f679 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1474,11 +1474,8 @@ the device is found or <slot>:missing in case the device is not found.
 
 .TP
 .BR \-\-add-journal
-Recreate journal for RAID-4/5/6 array that lost a journal device. In the
-current implementation, this command cannot add a journal to an array
-that had a failed journal. To avoid interrupting on-going write opertions,
-.B \-\-add-journal
-only works for array in Read-Only state.
+Add journal to an existing array, or recreate journal for RAID-4/5/6 array
+that lost a journal device.
 
 .TP
 .BR \-\-failfast
-- 
2.9.3

