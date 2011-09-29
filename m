From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] fix: correct unlocking of map file
Date: Thu, 29 Sep 2011 09:55:20 +0200
Message-ID: <20110929075520.5470.28705.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

1. Three missing map_unlock() calls were added.
2. Map file's lock must be released by an explicit LOCK_UN operation,
   because duplicated (e.g. created by fork()) descriptors
   inherit the lock. As a result child process which inherits open
   descriptors with lock can block another process of mdadm.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 Incremental.c |    3 +++
 mapfile.c     |    4 ++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 571d45d..b90089b 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1472,6 +1472,7 @@ static int Incremental_container(struct supertype *st, char *devname,
 					"Cannot activate array(s).\n");
 		/* free container data and exit */
 		sysfs_free(list);
+		map_unlock(&map);
 		return 2;
 	}
 
@@ -1535,6 +1536,7 @@ static int Incremental_container(struct supertype *st, char *devname,
 					fprintf(stderr, Name ": array %s/%s is "
 						"explicitly ignored by mdadm.conf\n",
 						match->container, match->member);
+				map_unlock(&map);
 				return 2;
 			}
 			if (match)
@@ -1550,6 +1552,7 @@ static int Incremental_container(struct supertype *st, char *devname,
 		if (mdfd < 0) {
 			fprintf(stderr, Name ": failed to open %s: %s.\n",
 				chosen_name, strerror(errno));
+			map_unlock(&map);
 			return 2;
 		}
 
diff --git a/mapfile.c b/mapfile.c
index ff1e973..98c0780 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -149,6 +149,10 @@ int map_lock(struct map_ent **melp)
 void map_unlock(struct map_ent **melp)
 {
 	if (lf) {
+		/* lock must be released by an explicit LOCK_UN operation
+		 * because duplicated descriptors inherit the lock
+		 */
+		flock(fileno(lf), LOCK_UN);
 		/* must unlink before closing the file,
 		 * as only the owner of the lock may
 		 * unlink the file

