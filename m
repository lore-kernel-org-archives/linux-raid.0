From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/4] FIX: delta_disk can have UnSet value
Date: Thu, 10 Feb 2011 14:56:18 +0100
Message-ID: <20110210135618.9276.14139.stgit@gklab-128-013.igk.intel.com>
References: <20110210134710.9276.91430.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110210134710.9276.91430.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Delta_disk can be set to UnSet value.
This can a cause to pass wrong parameter to reshape_super().
To avoid such situations raid_disks and delta_disks parameters
have to be passed to reshape_super() separately.
It will be up to reshape_super() function validation
and usage of this parameters to avoid not valid values.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c        |   15 +++++++++------
 mdadm.h       |    3 ++-
 super-intel.c |    5 ++++-
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/Grow.c b/Grow.c
index 402da5e..9ae2ecd 100644
--- a/Grow.c
+++ b/Grow.c
@@ -565,7 +565,8 @@ static void wait_reshape(struct mdinfo *sra)
 
 static int reshape_super(struct supertype *st, long long size, int level,
 			 int layout, int chunksize, int raid_disks,
-			 char *backup_file, char *dev, int verbose)
+			 int delta_disks, char *backup_file, char *dev,
+			 int verbose)
 {
 	/* nothing extra to check in the native case */
 	if (!st->ss->external)
@@ -578,7 +579,8 @@ static int reshape_super(struct supertype *st, long long size, int level,
 	}
 
 	return st->ss->reshape_super(st, size, level, layout, chunksize,
-				     raid_disks, backup_file, dev, verbose);
+				     raid_disks, delta_disks, backup_file, dev,
+				     verbose);
 }
 
 static void sync_metadata(struct supertype *st)
@@ -1416,7 +1418,8 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 	if (size >= 0 && (size == 0 || size != array.size)) {
 		long long orig_size = array.size;
 
-		if (reshape_super(st, size, UnSet, UnSet, 0, 0, NULL, devname, !quiet)) {
+		if (reshape_super(st, size, UnSet, UnSet, 0, 0, UnSet, NULL,
+				  devname, !quiet)) {
 			rv = 1;
 			goto release;
 		}
@@ -1438,7 +1441,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 
 			/* restore metadata */
 			if (reshape_super(st, orig_size, UnSet, UnSet, 0, 0,
-					  NULL, devname, !quiet) == 0)
+					  UnSet, NULL, devname, !quiet) == 0)
 				sync_metadata(st);
 			fprintf(stderr, Name ": Cannot set device size for %s: %s\n",
 				devname, strerror(err));
@@ -1575,7 +1578,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 
 		if (reshape_super(st, info.component_size, info.new_level,
 				  info.new_layout, info.new_chunk,
-				  info.array.raid_disks + info.delta_disks,
+				  info.array.raid_disks, info.delta_disks,
 				  backup_file, devname, quiet)) {
 			rv = 1;
 			goto release;
@@ -2123,7 +2126,7 @@ int reshape_container(char *container, int cfd, char *devname,
 	 */
 	if (reshape_super(st, -1, info->new_level,
 			  info->new_layout, info->new_chunk,
-			  info->array.raid_disks + info->delta_disks,
+			  info->array.raid_disks, info->delta_disks,
 			  backup_file, devname, quiet)) {
 		unfreeze(st);
 		return 1;
diff --git a/mdadm.h b/mdadm.h
index 608095f..9f20ba1 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -719,7 +719,8 @@ extern struct superswitch {
 	 */
 	int (*reshape_super)(struct supertype *st, long long size, int level,
 			     int layout, int chunksize, int raid_disks,
-			     char *backup, char *dev, int verbose); /* optional */
+			     int delta_disks, char *backup, char *dev,
+			     int verbose); /* optional */
 	int (*manage_reshape)( /* optional */
 		int afd, struct mdinfo *sra, struct reshape *reshape,
 		struct supertype *st, unsigned long blocks,
diff --git a/super-intel.c b/super-intel.c
index 4a9c230..fed831d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7052,7 +7052,8 @@ int imsm_takeover(struct supertype *st, struct geo_params *geo)
 
 static int imsm_reshape_super(struct supertype *st, long long size, int level,
 			      int layout, int chunksize, int raid_disks,
-			      char *backup, char *dev, int verbose)
+			      int delta_disks, char *backup, char *dev,
+			      int verbose)
 {
 	int ret_val = 1;
 	struct geo_params geo;
@@ -7068,6 +7069,8 @@ static int imsm_reshape_super(struct supertype *st, long long size, int level,
 	geo.layout = layout;
 	geo.chunksize = chunksize;
 	geo.raid_disks = raid_disks;
+	if (delta_disks != UnSet)
+		geo.raid_disks += delta_disks;
 
 	dprintf("\tfor level      : %i\n", geo.level);
 	dprintf("\tfor raid_disks : %i\n", geo.raid_disks);

