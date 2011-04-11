From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/2] FIX: Set reshape parameters for all disks belongs to new
	array geometry
Date: Mon, 11 Apr 2011 15:39:17 +0200
Message-ID: <20110411133917.4917.81756.stgit@gklab-128-013.igk.intel.com>
References: <20110411133908.4917.6842.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110411133908.4917.6842.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

For external metadata mdinfo->array.raid_disks reports "old" disks geometry.
To work in the same way as native metadata, new_disks has to be used
instead mdinfo->array.raid_disks.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/Grow.c b/Grow.c
index 1fdee7e..a954cfd 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3097,19 +3097,20 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 		 char *backup_file, int verbose)
 {
 	int i, j;
-	int old_disks;
+	int old_disks, new_disks;
 	unsigned long long *offsets;
 	unsigned long long  nstripe, ostripe;
 	int ndata, odata;
 
 	if (st->ss->external) {
 		old_disks = info->array.raid_disks;
-		ndata = info->array.raid_disks + info->delta_disks - 1;
+		new_disks = info->array.raid_disks + info->delta_disks;
 	} else {
 		old_disks = info->array.raid_disks - info->delta_disks;
-		ndata = info->array.raid_disks - 1;
+		new_disks = info->array.raid_disks;
 	}
 	odata = old_disks - 1;
+	ndata = new_disks - 1;
 	if (info->array.level == 6) odata--; /* number of data disks */
 	if (info->new_level == 6) ndata--;
 
@@ -3268,8 +3269,8 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 			goto second_fail; /* Cannot find leading superblock */
 
 		/* Now need the data offsets for all devices. */
-		offsets = malloc(sizeof(*offsets)*info->array.raid_disks);
-		for(j=0; j<info->array.raid_disks; j++) {
+		offsets = malloc(sizeof(*offsets)*new_disks);
+		for (j = 0; j < new_disks; j++) {
 			if (fdlist[j] < 0)
 				continue;
 			if (st->ss->load_super(st, fdlist[j], NULL))
@@ -3282,7 +3283,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 		printf(Name ": restoring critical section\n");
 
 		if (restore_stripes(fdlist, offsets,
-				    info->array.raid_disks,
+				    new_disks,
 				    info->new_chunk,
 				    info->new_level,
 				    info->new_layout,
@@ -3298,7 +3299,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 		
 		if (bsb.magic[15] == '2' &&
 		    restore_stripes(fdlist, offsets,
-				    info->array.raid_disks,
+				    new_disks,
 				    info->new_chunk,
 				    info->new_level,
 				    info->new_layout,
@@ -3354,7 +3355,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 					info->reshape_progress = p2;
 			}
 		}
-		for (j=0; j<info->array.raid_disks; j++) {
+		for (j = 0; j < new_disks; j++) {
 			if (fdlist[j] < 0) continue;
 			if (st->ss->load_super(st, fdlist[j], NULL))
 				continue;

