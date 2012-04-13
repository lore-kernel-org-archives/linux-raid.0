From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 05/14] FIX: Support metadata changes rollback
Date: Fri, 13 Apr 2012 16:51:59 +0200
Message-ID: <1334328728-12544-6-git-send-email-adam.kwolek@intel.com>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
 <1334328728-12544-5-git-send-email-adam.kwolek@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-5-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com, Adam Kwolek <adam.kwolek@intel.com>
List-Id: linux-raid.ids

Function reshape_super() guards metadata changes.
It is used to apply changes rollback in error case also.
As change (apply and rollback) can be not bi-directional reshape_super()
has to know if current action is metadata change that should be guarded
using metadata restrictions, or this is metadata rollback change
executed due to error occurrence.

In second case change has to be unconditional.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c        |   16 ++++++++++------
 mdadm.h       |    4 ++++
 super-intel.c |    2 +-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/Grow.c b/Grow.c
index 5fd44aa..8c7bafc 100644
--- a/Grow.c
+++ b/Grow.c
@@ -650,7 +650,7 @@ static void wait_reshape(struct mdinfo *sra)
 static int reshape_super(struct supertype *st, long long size, int level,
 			 int layout, int chunksize, int raid_disks,
 			 int delta_disks, char *backup_file, char *dev,
-			 int verbose)
+			 int direction, int verbose)
 {
 	/* nothing extra to check in the native case */
 	if (!st->ss->external)
@@ -664,7 +664,7 @@ static int reshape_super(struct supertype *st, long long size, int level,
 
 	return st->ss->reshape_super(st, size, level, layout, chunksize,
 				     raid_disks, delta_disks, backup_file, dev,
-				     verbose);
+				     direction, verbose);
 }
 
 static void sync_metadata(struct supertype *st)
@@ -1631,7 +1631,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			orig_size = array.size;
 
 		if (reshape_super(st, size, UnSet, UnSet, 0, 0, UnSet, NULL,
-				  devname, !quiet)) {
+				  devname, APPLY_METADATA_CHANGES, !quiet)) {
 			rv = 1;
 			goto release;
 		}
@@ -1697,7 +1697,9 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 
 			/* restore metadata */
 			if (reshape_super(st, orig_size, UnSet, UnSet, 0, 0,
-					  UnSet, NULL, devname, !quiet) == 0)
+					  UnSet, NULL, devname,
+					  ROLLBACK_METADATA_CHANGES,
+					  !quiet) == 0)
 				sync_metadata(st);
 			fprintf(stderr, Name ": Cannot set device size for %s: %s\n",
 				devname, strerror(err));
@@ -1909,7 +1911,8 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		if (reshape_super(st, info.component_size, info.new_level,
 				  info.new_layout, info.new_chunk,
 				  info.array.raid_disks, info.delta_disks,
-				  backup_file, devname, quiet)) {
+				  backup_file, devname, APPLY_METADATA_CHANGES,
+				  quiet)) {
 			rv = 1;
 			goto release;
 		}
@@ -2608,7 +2611,8 @@ int reshape_container(char *container, char *devname,
 	    reshape_super(st, -1, info->new_level,
 			  info->new_layout, info->new_chunk,
 			  info->array.raid_disks, info->delta_disks,
-			  backup_file, devname, quiet)) {
+			  backup_file, devname, APPLY_METADATA_CHANGES,
+			  quiet)) {
 		unfreeze(st);
 		return 1;
 	}
diff --git a/mdadm.h b/mdadm.h
index 9f58800..686d4b4 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -740,9 +740,13 @@ extern struct superswitch {
 	 * initialized to indicate if reshape is being performed at the
 	 * container or subarray level
 	 */
+#define APPLY_METADATA_CHANGES		1
+#define ROLLBACK_METADATA_CHANGES	0
+
 	int (*reshape_super)(struct supertype *st, long long size, int level,
 			     int layout, int chunksize, int raid_disks,
 			     int delta_disks, char *backup, char *dev,
+			     int direction,
 			     int verbose); /* optional */
 	int (*manage_reshape)( /* optional */
 		int afd, struct mdinfo *sra, struct reshape *reshape,
diff --git a/super-intel.c b/super-intel.c
index 9220318..62aeeb3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10020,7 +10020,7 @@ int imsm_takeover(struct supertype *st, struct geo_params *geo)
 static int imsm_reshape_super(struct supertype *st, long long size, int level,
 			      int layout, int chunksize, int raid_disks,
 			      int delta_disks, char *backup, char *dev,
-			      int verbose)
+			      int direction, int verbose)
 {
 	int ret_val = 1;
 	struct geo_params geo;
-- 
1.6.4.2

