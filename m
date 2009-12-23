From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 10/13] Introduce MaxSector
Date: Tue, 22 Dec 2009 17:00:10 -0700
Message-ID: <20091223000010.31628.3425.stgit@dwillia2-linux.ch.intel.com>
References: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091222235807.31628.23231.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

Replace occurrences of ~0ULL to make it clear we are talking about maximal
resync/recovery position.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 Create.c      |    2 +-
 mdadm.h       |    1 +
 monitor.c     |    2 +-
 super-ddf.c   |    4 ++--
 super-intel.c |    8 ++++----
 super1.c      |    6 +++---
 6 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/Create.c b/Create.c
index 5b01b63..1ae7f92 100644
--- a/Create.c
+++ b/Create.c
@@ -527,7 +527,7 @@ int Create(struct supertype *st, char *mddev,
 	     assume_clean
 		) {
 		info.array.state = 1; /* clean, but one+ drive will be missing*/
-		info.resync_start = ~0ULL;
+		info.resync_start = MaxSector;
 	} else {
 		info.array.state = 0; /* not clean, but no errors */
 		info.resync_start = 0;
diff --git a/mdadm.h b/mdadm.h
index 7b75540..9cf15c4 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -149,6 +149,7 @@ struct mdinfo {
 	union {
 		unsigned long long resync_start; /* per-array resync position */
 		unsigned long long recovery_start; /* per-device rebuild position */
+		#define MaxSector  (~0ULL) /* resync/recovery complete position */
 	};
 	unsigned long		safe_mode_delay; /* ms delay to mark clean */
 	int			new_level, delta_disks, new_layout, new_chunk;
diff --git a/monitor.c b/monitor.c
index 58752a8..81fef49 100644
--- a/monitor.c
+++ b/monitor.c
@@ -75,7 +75,7 @@ static unsigned long long read_resync_start(int fd)
 	if (n <= 0)
 		return 0;
 	if (strncmp(buf, "none", 4) == 0)
-		return ~0ULL;
+		return MaxSector;
 	else
 		return strtoull(buf, NULL, 10);
 }
diff --git a/super-ddf.c b/super-ddf.c
index f5eb816..8c3f4be 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1433,7 +1433,7 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info)
 	    (ddf->virt->entries[info->container_member].init_state
 	     & DDF_initstate_mask)
 	    == DDF_init_full)
-		info->resync_start = ~0ULL;
+		info->resync_start = MaxSector;
 
 	uuid_from_super_ddf(st, info->uuid);
 
@@ -2921,7 +2921,7 @@ static struct mdinfo *container_content_ddf(struct supertype *st)
 			this->resync_start = 0;
 		} else {
 			this->array.state = 1;
-			this->resync_start = ~0ULL;
+			this->resync_start = MaxSector;
 		}
 		memcpy(this->name, ddf->virt->entries[i].name, 16);
 		this->name[16]=0;
diff --git a/super-intel.c b/super-intel.c
index 4072fc8..4bb1990 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1271,7 +1271,7 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 		/* FIXME add curr_migr_unit to resync_start conversion */
 		info->resync_start = 0;
 	else
-		info->resync_start = ~0ULL;
+		info->resync_start = MaxSector;
 
 	strncpy(info->name, (char *) dev->volume, MAX_RAID_SERIAL_LEN);
 	info->name[MAX_RAID_SERIAL_LEN] = 0;
@@ -3482,7 +3482,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 		 * offset
 		 */
 		unsigned long long minsize = size;
-		unsigned long long start_offset = ~0ULL;
+		unsigned long long start_offset = MaxSector;
 		int dcnt = 0;
 		if (minsize == 0)
 			minsize = MPB_SECTOR_CNT + IMSM_RESERVED_SECTORS;
@@ -3498,7 +3498,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
 				esize = e[i].start - pos;
 				if (esize >= minsize)
 					found = 1;
-				if (found && start_offset == ~0ULL) {
+				if (found && start_offset == MaxSector) {
 					start_offset = pos;
 					break;
 				} else if (found && pos != start_offset) {
@@ -3856,7 +3856,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 			 * FIXME handle dirty degraded
 			 */
 			if (skip && !dev->vol.dirty)
-				this->resync_start = ~0ULL;
+				this->resync_start = MaxSector;
 			if (skip)
 				continue;
 
diff --git a/super1.c b/super1.c
index 2c992a4..85bb598 100644
--- a/super1.c
+++ b/super1.c
@@ -659,9 +659,9 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		switch(__le32_to_cpu(sb->level)) {
 		case 5: case 4: case 6:
 			/* need to force clean */
-			if (sb->resync_offset != ~0ULL)
+			if (sb->resync_offset != MaxSector)
 				rv = 1;
-			sb->resync_offset = ~0ULL;
+			sb->resync_offset = MaxSector;
 		}
 	}
 	if (strcmp(update, "assemble")==0) {
@@ -855,7 +855,7 @@ static int init_super1(struct supertype *st, mdu_array_info_t *info,
 	sb->utime = sb->ctime;
 	sb->events = __cpu_to_le64(1);
 	if (info->state & (1<<MD_SB_CLEAN))
-		sb->resync_offset = ~0ULL;
+		sb->resync_offset = MaxSector;
 	else
 		sb->resync_offset = 0;
 	sb->max_dev = __cpu_to_le32((1024- sizeof(struct mdp_superblock_1))/

