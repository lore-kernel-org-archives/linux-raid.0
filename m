From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/1] prevent double open(O_RDWR) on raid creation
Date: Thu, 11 Apr 2013 15:18:33 +0200
Message-ID: <1365686313-30833-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1365686313-30833-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1365686313-30833-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: harald@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Harald Hoyer <harald@redhat.com>

This does not trigger the udev inotify twice and saves a lot of blk I/O
for the raid members.

Also fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=947815

Signed-off-by: Harald Hoyer <harald@redhat.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Kill.c        | 28 +++++++++++++++++-----------
 Manage.c      |  2 +-
 mdadm.c       |  4 ++--
 mdadm.h       |  2 +-
 super-ddf.c   |  2 +-
 super-intel.c |  2 +-
 super0.c      |  2 +-
 super1.c      |  2 +-
 8 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/Kill.c b/Kill.c
index f2fdb85..b5c93ae 100644
--- a/Kill.c
+++ b/Kill.c
@@ -29,7 +29,7 @@
 #include	"md_u.h"
 #include	"md_p.h"
 
-int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl)
+int Kill(char *dev, int oldfd, struct supertype *st, int force, int verbose, int noexcl)
 {
 	/*
 	 * Nothing fancy about Kill.  It just zeroes out a superblock
@@ -42,21 +42,26 @@ int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl)
 
 	int fd, rv = 0;
 
-	if (force)
-		noexcl = 1;
-	fd = open(dev, O_RDWR|(noexcl ? 0 : O_EXCL));
-	if (fd < 0) {
-		if (verbose >= 0)
-			pr_err("Couldn't open %s for write - not zeroing\n",
-				dev);
-		return 2;
+	if (oldfd != -1) {
+		fd = oldfd;
+	} else {
+		if (force)
+			noexcl = 1;
+		fd = open(dev, O_RDWR|(noexcl ? 0 : O_EXCL));
+		if (fd < 0) {
+			if (verbose >= 0)
+				pr_err("Couldn't open %s for write - not zeroing\n",
+					dev);
+			return 2;
+		}
 	}
 	if (st == NULL)
 		st = guess_super(fd);
 	if (st == NULL || st->ss->init_super == NULL) {
 		if (verbose >= 0)
 			pr_err("Unrecognised md component device - %s\n", dev);
-		close(fd);
+		if (oldfd == -1)
+			close(fd);
 		return 2;
 	}
 	st->ignore_hw_compat = 1;
@@ -76,7 +81,8 @@ int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl)
 			rv = 0;
 		}
 	}
-	close(fd);
+	if (oldfd == -1)
+		close(fd);
 	return rv;
 }
 
diff --git a/Manage.c b/Manage.c
index 6267c0c..509e921 100644
--- a/Manage.c
+++ b/Manage.c
@@ -785,7 +785,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 			return -1;
 		}
 
-		Kill(dv->devname, NULL, 0, -1, 0);
+		Kill(dv->devname, -1, NULL, 0, -1, 0);
 		dfd = dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
 		if (mdmon_running(tst->container_devnm))
 			tst->update_tail = &tst->updates;
diff --git a/mdadm.c b/mdadm.c
index 214afa3..d68ee96 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1739,11 +1739,11 @@ static int misc_list(struct mddev_dev *devlist,
 			continue;
 		case KillOpt: /* Zero superblock */
 			if (ss)
-				rv |= Kill(dv->devname, ss, c->force, c->verbose,0);
+				rv |= Kill(dv->devname, -1, ss, c->force, c->verbose, 0);
 			else {
 				int v = c->verbose;
 				do {
-					rv |= Kill(dv->devname, NULL, c->force, v, 0);
+					rv |= Kill(dv->devname, -1, NULL, c->force, v, 0);
 					v = -1;
 				} while (rv == 0);
 				rv &= ~2;
diff --git a/mdadm.h b/mdadm.h
index c7b5183..e55dec5 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1156,7 +1156,7 @@ extern int Monitor(struct mddev_dev *devlist,
 		   int dosyslog, char *pidfile, int increments,
 		   int share);
 
-extern int Kill(char *dev, struct supertype *st, int force, int verbose, int noexcl);
+extern int Kill(char *dev, int oldfd, struct supertype *st, int force, int verbose, int noexcl);
 extern int Kill_subarray(char *dev, char *subarray, int verbose);
 extern int Update_subarray(char *dev, char *subarray, char *update, struct mddev_ident *ident, int quiet);
 extern int Wait(char *dev);
diff --git a/super-ddf.c b/super-ddf.c
index c5f6f5c..a88699c 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2597,7 +2597,7 @@ static int write_init_super_ddf(struct supertype *st)
 	} else {
 		struct dl *d;
 		for (d = ddf->dlist; d; d=d->next)
-			while (Kill(d->devname, NULL, 0, -1, 1) == 0);
+			while (Kill(d->devname, d->fd, NULL, 0, -1, 1) == 0);
 		return __write_init_super_ddf(st);
 	}
 }
diff --git a/super-intel.c b/super-intel.c
index 24016b7..743a7fc 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5221,7 +5221,7 @@ static int write_init_super_imsm(struct supertype *st)
 	} else {
 		struct dl *d;
 		for (d = super->disks; d; d = d->next)
-			Kill(d->devname, NULL, 0, -1, 1);
+			Kill(d->devname, d->fd, NULL, 0, -1, 1);
 		return write_super_imsm(st, 1);
 	}
 }
diff --git a/super0.c b/super0.c
index 1f4dc75..57b549e 100644
--- a/super0.c
+++ b/super0.c
@@ -779,7 +779,7 @@ static int write_init_super0(struct supertype *st)
 			continue;
 		if (di->fd == -1)
 			continue;
-		while (Kill(di->devname, NULL, 0, -1, 1) == 0)
+		while (Kill(di->devname, di->fd, NULL, 0, -1, 1) == 0)
 			;
 
 		sb->disks[di->disk.number].state &= ~(1<<MD_DISK_FAULTY);
diff --git a/super1.c b/super1.c
index d0f1d5f..e3eeb80 100644
--- a/super1.c
+++ b/super1.c
@@ -1333,7 +1333,7 @@ static int write_init_super1(struct supertype *st)
 		if (di->fd < 0)
 			continue;
 
-		while (Kill(di->devname, NULL, 0, -1, 1) == 0)
+		while (Kill(di->devname, di->fd, NULL, 0, -1, 1) == 0)
 			;
 
 		sb->dev_number = __cpu_to_le32(di->disk.number);
-- 
1.8.1.4

