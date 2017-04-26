From: Zhilong Liu <zlliu@suse.com>
Subject: [mdadm PATCH] Create: move STOP_ARRAY to abort_locked
Date: Wed, 26 Apr 2017 15:03:49 +0800
Message-ID: <1493190229-14329-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: neilb@suse.com, linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

The sysfs entry and devnm would be created once create_mddev()
performed successfully, but the creating isn't completed here,
move STOP_ARRAY to abort_locked, the purpose is to cleanup the
partially created array.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Create.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/Create.c b/Create.c
index 6ca0924..fe0ab7e 100644
--- a/Create.c
+++ b/Create.c
@@ -904,10 +904,8 @@ int Create(struct supertype *st, char *mddev,
 					remove_partitions(fd);
 				if (st->ss->add_to_super(st, &inf->disk,
 							 fd, dv->devname,
-							 dv->data_offset)) {
-					ioctl(mdfd, STOP_ARRAY, NULL);
+							 dv->data_offset))
 					goto abort_locked;
-				}
 				st->ss->getinfo_super(st, inf, NULL);
 				safe_mode_delay = inf->safe_mode_delay;
 
@@ -1008,7 +1006,6 @@ int Create(struct supertype *st, char *mddev,
 			sysfs_set_safemode(&info, safe_mode_delay);
 			if (err) {
 				pr_err("failed to activate array.\n");
-				ioctl(mdfd, STOP_ARRAY, NULL);
 				goto abort;
 			}
 		} else if (c->readonly &&
@@ -1018,7 +1015,6 @@ int Create(struct supertype *st, char *mddev,
 					  "array_state", "readonly") < 0) {
 				pr_err("Failed to start array: %s\n",
 				       strerror(errno));
-				ioctl(mdfd, STOP_ARRAY, NULL);
 				goto abort;
 			}
 		} else {
@@ -1030,7 +1026,6 @@ int Create(struct supertype *st, char *mddev,
 				if (info.array.chunk_size & (info.array.chunk_size-1)) {
 					cont_err("Problem may be that chunk size is not a power of 2\n");
 				}
-				ioctl(mdfd, STOP_ARRAY, NULL);
 				goto abort;
 			}
 			/* if start_ro module parameter is set, array is
@@ -1061,7 +1056,9 @@ int Create(struct supertype *st, char *mddev,
 	map_remove(&map, fd2devnm(mdfd));
 	map_unlock(&map);
 
-	if (mdfd >= 0)
+	if (mdfd >= 0) {
+		ioctl(mdfd, STOP_ARRAY, NULL);
 		close(mdfd);
+	}
 	return 1;
 }
-- 
2.6.6

