From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] Grow.c: change size to be unsigned and use '0' in case of 'no
	change'
Date: Fri, 10 Aug 2012 16:06:34 +0200
Message-ID: <20120810140634.13510.1639.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, ed.ciechanowski@intel.com, Jacek.Danecki@intel.com
List-Id: linux-raid.ids

The 'size' has been changed to be unsigned recently.
Analogous changes should be made to reshape_super().
'0' should be used in case of 'no change' now.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 Grow.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Grow.c b/Grow.c
index d13b7f3..f1ce284 100644
--- a/Grow.c
+++ b/Grow.c
@@ -639,8 +639,8 @@ static void wait_reshape(struct mdinfo *sra)
 	close(fd);
 }
 
-static int reshape_super(struct supertype *st, long long size, int level,
-			 int layout, int chunksize, int raid_disks,
+static int reshape_super(struct supertype *st, unsigned long long size,
+			 int level, int layout, int chunksize, int raid_disks,
 			 int delta_disks, char *backup_file, char *dev,
 			 int direction, int verbose)
 {
@@ -1987,7 +1987,7 @@ size_change_error:
 		/* Impose these changes on a single array.  First
 		 * check that the metadata is OK with the change. */
 
-		if (reshape_super(st, -1, info.new_level,
+		if (reshape_super(st, 0, info.new_level,
 				  info.new_layout, info.new_chunk,
 				  info.array.raid_disks, info.delta_disks,
 				  c->backup_file, devname, APPLY_METADATA_CHANGES,
@@ -2672,10 +2672,10 @@ int reshape_container(char *container, char *devname,
 	int last_devnum = -1;
 
 	/* component_size is not meaningful for a container,
-	 * so pass '-1' meaning 'no change'
+	 * so pass '0' meaning 'no change'
 	 */
 	if (!restart &&
-	    reshape_super(st, -1, info->new_level,
+	    reshape_super(st, 0, info->new_level,
 			  info->new_layout, info->new_chunk,
 			  info->array.raid_disks, info->delta_disks,
 			  backup_file, devname, APPLY_METADATA_CHANGES,

