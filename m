From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2] mdadm/r5cache: allow adding journal to array without journal
Date: Thu, 16 Mar 2017 16:24:05 -0700
Message-ID: <20170316232405.3523257-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Currently, --add-journal can be only used to recreate broken journal
for arrays with journal since  creation. As the kernel code getting
more mature, this constraint is no longer necessary.

This patch allows --add-journal to add journal to array without
journal.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Manage.c   | 9 ---------
 mdadm.8.in | 5 ++---
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/Manage.c b/Manage.c
index 5c3d2b9..d038b68 100644
--- a/Manage.c
+++ b/Manage.c
@@ -946,7 +946,6 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 
 	/* only add journal to array that supports journaling */
 	if (dv->disposition == 'j') {
-		struct mdinfo mdi;
 		struct mdinfo *mdp;
 
 		mdp = sysfs_read(fd, NULL, GET_ARRAY_STATE);
@@ -960,14 +959,6 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			pr_err("%s is not readonly, cannot add journal.\n", devname);
 			return -1;
 		}
-
-		sysfs_free(mdp);
-
-		tst->ss->getinfo_super(tst, &mdi, NULL);
-		if (mdi.journal_device_required == 0) {
-			pr_err("%s does not support journal device.\n", devname);
-			return -1;
-		}
 		disc.raid_disk = 0;
 	}
 
diff --git a/mdadm.8.in b/mdadm.8.in
index df1d460..9e5e896 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1474,9 +1474,8 @@ the device is found or <slot>:missing in case the device is not found.
 
 .TP
 .BR \-\-add-journal
-Recreate journal for RAID-4/5/6 array that lost a journal device. In the
-current implementation, this command cannot add a journal to an array
-that had a failed journal. To avoid interrupting on-going write opertions,
+Add journal to an existing array, or recreate journal for RAID-4/5/6 array
+that lost a journal device. To avoid interrupting on-going write opertions,
 .B \-\-add-journal
 only works for array in Read-Only state.
 
-- 
2.9.3

