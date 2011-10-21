From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/2] Create() don't leave the lock hanging on error
Date: Fri, 21 Oct 2011 17:15:58 +0200
Message-ID: <1319210159-8711-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Create.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/Create.c b/Create.c
index 79564c5..3e85785 100644
--- a/Create.c
+++ b/Create.c
@@ -554,14 +554,16 @@ int Create(struct supertype *st, char *mddev,
 	/* We need to create the device */
 	map_lock(&map);
 	mdfd = create_mddev(mddev, name, autof, LOCAL, chosen_name);
-	if (mdfd < 0)
+	if (mdfd < 0) {
+		map_unlock(&map);
 		return 1;
+	}
 	mddev = chosen_name;
 
 	vers = md_get_version(mdfd);
 	if (vers < 9000) {
 		fprintf(stderr, Name ": Create requires md driver version 0.90.0 or later\n");
-		goto abort;
+		goto abort_locked;
 	} else {
 		mdu_array_info_t inf;
 		memset(&inf, 0, sizeof(inf));
@@ -569,7 +571,7 @@ int Create(struct supertype *st, char *mddev,
 		if (inf.working_disks != 0) {
 			fprintf(stderr, Name ": another array by this name"
 				" is already running.\n");
-			goto abort;
+			goto abort_locked;
 		}
 	}
 
@@ -665,7 +667,7 @@ int Create(struct supertype *st, char *mddev,
 		}
 	}
 	if (!st->ss->init_super(st, &info.array, size, name, homehost, uuid))
-		goto abort;
+		goto abort_locked;
 
 	total_slots = info.array.nr_disks;
 	st->ss->getinfo_super(st, &info, NULL);
@@ -910,7 +912,7 @@ int Create(struct supertype *st, char *mddev,
 					Name ": Failed to write metadata to %s\n",
 					dv->devname);
 				st->ss->free_super(st);
-				goto abort;
+				goto abort_locked;
 			}
 
 			/* update parent container uuid */
@@ -993,6 +995,7 @@ int Create(struct supertype *st, char *mddev,
 
  abort:
 	map_lock(&map);
+ abort_locked:
 	map_remove(&map, fd2devnum(mdfd));
 	map_unlock(&map);
 
-- 
1.7.4.4

