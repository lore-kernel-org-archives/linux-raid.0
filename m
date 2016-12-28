From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] imsm: enable bad block support for imsm metadata
Date: Wed, 28 Dec 2016 09:38:07 +0100
Message-ID: <1482914287-17630-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Enable bad block support for imsm metadata as commit e522751d605d
("seq_file: reset iterator to first record for zero offset") has been
accepted in upstream kernel. Prior to that patch mdmon had not been able
to read bad blocks sysfs file.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index df95957..29b2163 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3209,7 +3209,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 							info->array.chunk_size,
 							super->sector_size,
 							info->component_size);
-	info->bb.supported = 0;
+	info->bb.supported = 1;
 
 	memset(info->uuid, 0, sizeof(info->uuid));
 	info->recovery_start = MaxSector;
@@ -3376,7 +3376,7 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 	info->name[0] = 0;
 	info->recovery_start = MaxSector;
 	info->recovery_blocked = imsm_reshape_blocks_arrays_changes(st->sb);
-	info->bb.supported = 0;
+	info->bb.supported = 1;
 
 	/* do we have the all the insync disks that we expect? */
 	mpb = super->anchor;
@@ -7380,7 +7380,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 				info_d->component_size = blocks_per_member(map);
 			}
 
-			info_d->bb.supported = 0;
+			info_d->bb.supported = 1;
 			get_volume_badblocks(super->bbm_log, ord_to_idx(ord),
 					     info_d->data_offset,
 					     info_d->component_size,
@@ -8410,7 +8410,7 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 		di->data_offset = pba_of_lba0(map);
 		di->component_size = a->info.component_size;
 		di->container_member = inst;
-		di->bb.supported = 0;
+		di->bb.supported = 1;
 		super->random = random32();
 		di->next = rv;
 		rv = di;
-- 
1.8.3.1

