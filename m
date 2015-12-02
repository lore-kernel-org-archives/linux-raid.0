From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/3] [mdadm] recreate journal in mdadm
Date: Tue, 1 Dec 2015 17:13:25 -0800
Message-ID: <1449018805-320020-3-git-send-email-songliubraving@fb.com>
References: <1449018805-320020-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449018805-320020-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Example work flow:

./mdadm --fail /dev/md1 /dev/sdb2
mdadm: set /dev/sdb2 faulty in /dev/md1

./mdadm --stop /dev/md1
mdadm: stopped /dev/md1

./mdadm -A --scan --force
mdadm: Journal is missing or stale, starting array read only.
mdadm: /dev/md/1 has been started with 15 drives.

./mdadm --add-journal /dev/md1 /dev/sdb2
mdadm: Journal created on /dev/sdb2.
mdadm: Please restart /dev/md1.

./mdadm --stop /dev/md1
mdadm: stopped /dev/md1

./mdadm -A --scan
mdadm: clearing FAULTY flag for new journal in /dev/md/1 for /dev/sdb2
mdadm: Marking array /dev/md/1 as 'clean'
mdadm: /dev/md/1 has been started with 15 drives and 1 journal.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 Assemble.c |  8 +++++++-
 Manage.c   | 32 +++++++++++++++++++++++++++++++-
 ReadMe.c   |  1 +
 mdadm.c    |  8 ++++++++
 mdadm.h    |  1 +
 super1.c   |  3 ++-
 6 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 90c9918..6b9a6da 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1688,7 +1688,13 @@ try_again:

 		if (st->ss->update_super(st, &devices[j].i, "assemble", NULL,
 					 c->verbose, 0, NULL)) {
-			if (c->force) {
+			if (devices[j].i.disk.state & (1<<MD_DISK_JOURNAL)) {
+				if (c->verbose >= 0)
+					pr_err("clearing FAULTY flag for new journal in %s for %s\n",
+					       mddev, devices[j].devname);
+				change = 1;
+				content->journal_clean = 1;
+			} else if (c->force) {
 				if (c->verbose >= 0)
 					pr_err("clearing FAULTY flag for device %d in %s for %s\n",
 					       j, mddev, devices[j].devname);
diff --git a/Manage.c b/Manage.c
index 2df303d..930865a 100644
--- a/Manage.c
+++ b/Manage.c
@@ -825,7 +825,8 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 		}

 		/* Make sure device is large enough */
-		if (tst->sb &&
+		if (dv->disposition != 'j' &&  /* skip size check for Journal */
+		    tst->sb &&
 		    tst->ss->avail_size(tst, ldsize/512, INVALID_SECTORS) <
 		    array_size) {
 			if (dv->disposition == 'M')
@@ -929,8 +930,30 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	else
 		disc.number = raid_slot;
 	disc.state = 0;
+
+	/* only add journal to array that supports journaling */
+	if (dv->disposition == 'j') {
+		struct mdinfo mdi;
+		struct mdinfo *mdp;
+
+		mdp = sysfs_read(fd, NULL, GET_ARRAY_STATE);
+
+		if (strncmp(mdp->sysfs_array_state, "readonly", 8) != 0) {
+			pr_err("%s is not readonly, cannot add journal.\n", devname);
+			return -1;
+		}
+
+		tst->ss->getinfo_super(tst, &mdi, NULL);
+		if (mdi.journal_device_required == 0) {
+			pr_err("%s does not support journal device.\n", devname);
+			return -1;
+		}
+	}
+
 	if (array->not_persistent==0) {
 		int dfd;
+		if (dv->disposition == 'j')
+			disc.state |= 1 << MD_DISK_JOURNAL;
 		if (dv->writemostly == 1)
 			disc.state |= 1 << MD_DISK_WRITEMOSTLY;
 		dfd = dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
@@ -1038,6 +1061,11 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 		ping_monitor(devnm);
 		sysfs_free(sra);
 		close(container_fd);
+	} else if (dv->disposition == 'j') {
+		/* do not call ioctl(ADD_NEW_DISK) for journal */
+		pr_err("Journal created on %s.\n", dv->devname);
+		pr_err("Please restart %s.\n", devname);
+		return 1;
 	} else {
 		tst->ss->free_super(tst);
 		if (ioctl(fd, ADD_NEW_DISK, &disc)) {
@@ -1277,6 +1305,7 @@ int Manage_subdevs(char *devname, int fd,
 	 *	   try HOT_ADD_DISK
 	 *         If that fails EINVAL, try ADD_NEW_DISK
 	 *  'S' - add the device as a spare - don't try re-add
+	 *  'j' - add the device as a journal device
 	 *  'A' - re-add the device
 	 *  'r' - remove the device: HOT_REMOVE_DISK
 	 *        device can be 'faulty' or 'detached' in which case all
@@ -1509,6 +1538,7 @@ int Manage_subdevs(char *devname, int fd,
 			goto abort;
 		case 'a':
 		case 'S': /* --add-spare */
+		case 'j': /* --add-journal */
 		case 'A':
 		case 'M': /* --re-add missing */
 		case 'F': /* --re-add faulty  */
diff --git a/ReadMe.c b/ReadMe.c
index fb5a671..566fc8d 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -157,6 +157,7 @@ struct option long_options[] = {
     /* Management */
     {"add",       0, 0, Add},
     {"add-spare", 0, 0, AddSpare},
+    {"add-journal", 0, 0, AddJournal},
     {"remove",    0, 0, Remove},
     {"fail",      0, 0, Fail},
     {"set-faulty",0, 0, Fail},
diff --git a/mdadm.c b/mdadm.c
index f56a8cf..feec3b7 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -190,6 +190,7 @@ int main(int argc, char *argv[])
 		case 'a':
 		case Add:
 		case AddSpare:
+		case AddJournal:
 		case 'r':
 		case Remove:
 		case Replace:
@@ -925,6 +926,13 @@ int main(int argc, char *argv[])
 		case O(MANAGE,AddSpare): /* add drive - never re-add */
 			devmode = 'S';
 			continue;
+		case O(MANAGE,AddJournal): /* add journal */
+			if (s.journaldisks && (s.level < 4 || s.level > 6)) {
+				pr_err("--add-journal is only supported for RAID level 4/5/6.\n");
+				exit(2);
+			}
+			devmode = 'j';
+			continue;
 		case O(MANAGE,ReAdd):
 			devmode = 'A';
 			continue;
diff --git a/mdadm.h b/mdadm.h
index 1b027bb..c16bcd7 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -345,6 +345,7 @@ enum special_options {
 	ManageOpt,
 	Add,
 	AddSpare,
+	AddJournal,
 	Remove,
 	Fail,
 	Replace,
diff --git a/super1.c b/super1.c
index 1735c2d..893f9bf 100644
--- a/super1.c
+++ b/super1.c
@@ -1713,7 +1713,8 @@ static int write_init_super1(struct supertype *st)
 		if (rfd >= 0)
 			close(rfd);

-		sb->events = 0;
+		if (!(di->disk.state & (1<<MD_DISK_JOURNAL)))
+			sb->events = 0;

 		refst = dup_super(st);
 		if (load_super1(refst, di->fd, NULL)==0) {
--
2.4.6
