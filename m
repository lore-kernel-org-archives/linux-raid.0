From: Jes.Sorensen@redhat.com
Subject: [PATCH 01/11] Fix memory leaks in reshape_array()
Date: Mon, 31 Oct 2011 15:02:29 +0100
Message-ID: <1320069759-13361-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Grow.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 08581d2..05350dd 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1882,8 +1882,8 @@ static int reshape_array(char *container, int fd, char *devname,
 	struct mddev_dev *dv;
 	int added_disks;
 
-	int *fdlist;
-	unsigned long long *offsets;
+	int *fdlist = NULL;
+	unsigned long long *offsets = NULL;
 	int d;
 	int nrdisks;
 	int err;
@@ -2339,6 +2339,9 @@ started:
 		abort_reshape(sra);
 		goto release;
 	default:
+		free(fdlist);
+		free(offsets);
+		sysfs_free(sra);
 		return 0;
 	case 0:
 		map_fork();
@@ -2366,6 +2369,9 @@ started:
 			d - odisks, fdlist+odisks,
 			offsets+odisks);
 
+	free(fdlist);
+	free(offsets);
+
 	if (backup_file && done)
 		unlink(backup_file);
 	if (!done) {
@@ -2381,6 +2387,7 @@ started:
 		/* no need to wait for the reshape to finish as
 		 * there is nothing more to do.
 		 */
+		sysfs_free(sra);
 		exit(0);
 	}
 	wait_reshape(sra);
@@ -2445,17 +2452,21 @@ started:
 			st->update_tail = NULL;
 	}
 out:
+	sysfs_free(sra);
 	if (forked)
 		return 0;
 	unfreeze(st);
 	exit(0);
 
 release:
+	free(fdlist);
+	free(offsets);
 	if (orig_level != UnSet && sra) {
 		c = map_num(pers, orig_level);
 		if (c && sysfs_set_str(sra, NULL, "level", c) == 0)
 			fprintf(stderr, Name ": aborting level change\n");
 	}
+	sysfs_free(sra);
 	if (!forked)
 		unfreeze(st);
 	return 1;
-- 
1.7.6.4

