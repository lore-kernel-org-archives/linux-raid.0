From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH] Fix race between --create and --incremental
Date: Wed,  9 Apr 2014 17:14:59 +0200
Message-ID: <1397056499-6743-1-git-send-email-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

This modifies locking in Create to eliminate a situation where
--incremental can assemble a device between write_init_super() and
add_disk(), which causes Create to fail.

It sporadically occurs e.g. when metadata is written on a device,
causing an udev change event which triggers mdadm --incremental.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Create.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Create.c b/Create.c
index 692ff52..bac9181 100644
--- a/Create.c
+++ b/Create.c
@@ -833,6 +833,7 @@ int Create(struct supertype *st, char *mddev,
 
 	infos = xmalloc(sizeof(*infos) * total_slots);
 	enable_fds(total_slots);
+	map_lock(&map);
 	for (pass=1; pass <=2 ; pass++) {
 		struct mddev_dev *moved_disk = NULL; /* the disk that was moved out of the insert point */
 
@@ -886,7 +887,7 @@ int Create(struct supertype *st, char *mddev,
 						pr_err("failed to open %s "
 							"after earlier success - aborting\n",
 							dv->devname);
-						goto abort;
+						goto abort_locked;
 					}
 					fstat(fd, &stb);
 					inf->disk.major = major(stb.st_rdev);
@@ -898,7 +899,7 @@ int Create(struct supertype *st, char *mddev,
 							 fd, dv->devname,
 							 dv->data_offset)) {
 					ioctl(mdfd, STOP_ARRAY, NULL);
-					goto abort;
+					goto abort_locked;
 				}
 				st->ss->getinfo_super(st, inf, NULL);
 				safe_mode_delay = inf->safe_mode_delay;
@@ -924,7 +925,7 @@ int Create(struct supertype *st, char *mddev,
 					pr_err("ADD_NEW_DISK for %s "
 					       "failed: %s\n",
 					       dv->devname, strerror(errno));
-					goto abort;
+					goto abort_locked;
 				}
 				break;
 			}
@@ -941,7 +942,6 @@ int Create(struct supertype *st, char *mddev,
 			 * the subarray cursor such that ->getinfo_super once
 			 * again returns container info.
 			 */
-			map_lock(&map);
 			st->ss->getinfo_super(st, &info_new, NULL);
 			if (st->ss->external && s->level != LEVEL_CONTAINER &&
 			    !same_uuid(info_new.uuid, info.uuid, 0)) {
@@ -966,12 +966,12 @@ int Create(struct supertype *st, char *mddev,
 					   info_new.uuid, path);
 				free(path);
 			}
-			map_unlock(&map);
 
 			flush_metadata_updates(st);
 			st->ss->free_super(st);
 		}
 	}
+	map_unlock(&map);
 	free(infos);
 
 	if (s->level == LEVEL_CONTAINER) {
-- 
1.8.4.5

