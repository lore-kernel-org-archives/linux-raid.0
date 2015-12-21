From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 3/3] Add new journal to array that does not have journal
Date: Mon, 21 Dec 2015 11:23:43 -0800
Message-ID: <1450725823-1832511-4-git-send-email-songliubraving@fb.com>
References: <1450725823-1832511-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450725823-1832511-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

This patch enables adding journal to an array that does not have journal before.

To add the journal, the array should finish resync. Otherwise, mdadm complains:

[root] mdadm --add-journal /dev/md0 /dev/sdb8 -vvv
mdadm: /dev/md0 has active resync, please retry after resync is done.

The array need to be restarted for the journal to work:

[root] mdadm --add-journal /dev/md0 /dev/sdb8
mdadm: Making /dev/md0 readonly before adding journal...
mdadm: Added new journal to /dev/md0.
mdadm: Please restart the array to make it live.

[root] mdadm --stop /dev/md*
mdadm: stopped /dev/md0

[root] mdadm -A /dev/md0 /dev/sdb[12358]
mdadm: device 8 in /dev/md0 has wrong state in superblock, but /dev/sdb8 seems ok
mdadm: /dev/md0 has been started with 4 drives and 1 journal.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 Assemble.c |  5 +----
 Manage.c   | 32 ++++++++++++++++++++++++++------
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index a7cd163..4ddd650 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1556,10 +1556,7 @@ try_again:
 		 */
 		if (content->array.level != LEVEL_MULTIPATH) {
 			if (devices[j].i.disk.state & (1<<MD_DISK_JOURNAL)) {
-				if (content->journal_device_required)
-					journalcnt++;
-				else	/* unexpected journal, mark as faulty */
-					devices[j].i.disk.state |= (1<<MD_DISK_FAULTY);
+				journalcnt++;
 			} else if (!(devices[j].i.disk.state & (1<<MD_DISK_ACTIVE))) {
 				if (!(devices[j].i.disk.state
 				      & (1<<MD_DISK_FAULTY))) {
diff --git a/Manage.c b/Manage.c
index 7e1b94b..da14b99 100644
--- a/Manage.c
+++ b/Manage.c
@@ -740,6 +740,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	struct supertype *dev_st = NULL;
 	int j;
 	mdu_disk_info_t disc;
+	int new_journal = 0;
 
 	if (!get_dev_size(tfd, dv->devname, &ldsize)) {
 		if (dv->disposition == 'M')
@@ -935,19 +936,33 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	if (dv->disposition == 'j') {
 		struct mdinfo mdi;
 		struct mdinfo *mdp;
+		struct mdstat_ent *mds, *m;
+		int percent = -1;
+
+		mds = mdstat_read(0, 0);
+		for (m = mds; m; m = m->next)
+			if (strcmp(m->devnm, fd2devnm(fd)) == 0)
+				percent = m->percent;
+		free_mdstat(mds);
+
+		if (percent > 0) {
+			pr_err("%s has active resync, please retry after resync is done.\n", devname);
+			return -1;
+		}
 
 		mdp = sysfs_read(fd, NULL, GET_ARRAY_STATE);
 
 		if (strncmp(mdp->sysfs_array_state, "readonly", 8) != 0) {
-			pr_err("%s is not readonly, cannot add journal.\n", devname);
-			return -1;
+			pr_err("Making %s readonly before adding journal...\n", devname);
+			if (Manage_ro(devname, fd, 1)) {
+				pr_err("Please retry.\n");
+				return -1;
+			}
 		}
 
 		tst->ss->getinfo_super(tst, &mdi, NULL);
-		if (mdi.journal_device_required == 0) {
-			pr_err("%s does not support journal device.\n", devname);
-			return -1;
-		}
+		if (mdi.journal_device_required == 0)
+			new_journal = 1;
 		disc.raid_disk = 0;
 	}
 
@@ -1064,6 +1079,11 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 		close(container_fd);
 	} else {
 		tst->ss->free_super(tst);
+		if (new_journal) {
+			pr_err("Added new journal to %s. \n", devname);
+			pr_err("Please restart the array to make it live.\n");
+			return 1;
+		}
 		if (ioctl(fd, ADD_NEW_DISK, &disc)) {
 			if (dv->disposition == 'j')
 				pr_err("Failed to hot add %s as journal, "
-- 
2.4.6

