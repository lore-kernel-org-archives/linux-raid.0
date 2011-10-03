From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/4] Add recovery blocked field to mdinfo
Date: Mon, 03 Oct 2011 18:13:46 +0200
Message-ID: <20111003161346.18410.46658.stgit@gklab-128-013.igk.intel.com>
References: <20111003160839.18410.33275.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111003160839.18410.33275.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When container is assembled while reshape is active on one of its member
whole container can be required to be blocked from monitoring.
For such purpose field recovery blocked is added to mdinfo structure.

When metadata handler finds active reshape in container it should set
recovery_blocked field to disable whole container monitoring during
reshape.

For arrays that doesn't use containers, recovery_blocked field
has the same value as reshape_active field e.g. super0/1.
In fact,recovery is blocked during reshape for such arrays.
For ddf, metadata handler doesn't set reshape_active field,
so recovery_blocked is not set also.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c  |    2 +-
 mdadm.h     |    7 +++++++
 super-ddf.c |    2 ++
 super0.c    |    2 ++
 super1.c    |    2 ++
 5 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index afca38e..4511f4d 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1527,7 +1527,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		if (sysfs_set_array(content, md_get_version(mdfd)) != 0)
 			return 1;
 
-	if (content->reshape_active)
+	if (st->ss->external && content->recovery_blocked)
 		block_subarray(content);
 
 	if (sra)
diff --git a/mdadm.h b/mdadm.h
index f219c95..c397045 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -196,6 +196,13 @@ struct mdinfo {
 						    */
 	int			reshape_active;
 	unsigned long long	reshape_progress;
+	int			recovery_blocked; /* for external metadata it
+						   * indicates that there is
+						   * reshape in progress in
+						   * container,
+						   * for native metadata it is
+						   * reshape_active field mirror
+						   */
 	union {
 		unsigned long long resync_start; /* per-array resync position */
 		unsigned long long recovery_start; /* per-device rebuild position */
diff --git a/super-ddf.c b/super-ddf.c
index 7312ba4..d3f8b29 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1374,6 +1374,7 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
 
 	info->recovery_start = MaxSector;
 	info->reshape_active = 0;
+	info->recovery_blocked = 0;
 	info->name[0] = 0;
 
 	info->array.major_version = -1;
@@ -1449,6 +1450,7 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
 	info->recovery_start = MaxSector;
 	info->resync_start = 0;
 	info->reshape_active = 0;
+	info->recovery_blocked = 0;
 	if (!(ddf->virt->entries[info->container_member].state
 	      & DDF_state_inconsistent)  &&
 	    (ddf->virt->entries[info->container_member].init_state
diff --git a/super0.c b/super0.c
index f791e9d..3061ecf 100644
--- a/super0.c
+++ b/super0.c
@@ -387,6 +387,8 @@ static void getinfo_super0(struct supertype *st, struct mdinfo *info, char *map)
 	} else
 		info->reshape_active = 0;
 
+	info->recovery_blocked = info->reshape_active;
+
 	sprintf(info->name, "%d", sb->md_minor);
 	/* work_disks is calculated rather than read directly */
 	for (i=0; i < MD_SB_DISKS; i++)
diff --git a/super1.c b/super1.c
index 0cd4124..9a72681 100644
--- a/super1.c
+++ b/super1.c
@@ -626,6 +626,8 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 	} else
 		info->reshape_active = 0;
 
+	info->recovery_blocked = info->reshape_active;
+
 	if (map)
 		for (i=0; i<map_disks; i++)
 			map[i] = 0;

