From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [mdadm PATCH 7/11] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:46:47 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65CC@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From cbcbc3066adf64cd292cc148d6a8ad87231fb8ac Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:08:47 +0100
Subject: [PATCH] OLCE: use takeover to raid5 for raid0 OLCE

Changes to be committed:
	modified:   Grow.c
	modified:   managemon.c
	modified:   mdmon.h
	modified:   monitor.c
	modified:   super-intel.c

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c        |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 managemon.c   |   11 +++++++++
 mdmon.h       |    6 +++++
 monitor.c     |   16 ++++++++++++++
 super-intel.c |    8 +++++++
 5 files changed, 98 insertions(+), 7 deletions(-)

diff --git a/Grow.c b/Grow.c
index f332766..e568c37 100644
--- a/Grow.c
+++ b/Grow.c
@@ -559,6 +559,12 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		return 1;
 	}
 
+	/* =========  OLCE Takeover =========== */
+	if ((array.level == 0) && (level == UnSet)) {
+		/* for raid0 use takeover to raid5 */
+		level = 5;
+	}
+	
 	/* ========= set size =============== */
 	if (size >= 0 && (size == 0 || size != array.size)) {
 		array.size = size;
@@ -788,6 +794,26 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 				goto release;
 			}
 
+			st = super_by_fd(fd);
+			/* check if container doesn't contains nothing more than raid 0 and 5 */
+			if (st != NULL) 	{
+				if (st->ss->external) {
+					/* for external meta we would like takeover raid0->raid5 */
+					if ((array.level != 0) || (level != 5)) {
+						st->ss->free_super(st);
+						st = NULL;
+						fprintf(stderr, Name ": %s: could not set level to %s for external super.\n",
+							devname, c);
+						rv = 1;
+						goto release;
+					}
+				}
+			} else {
+				fprintf(stderr, Name ": cannot handle arrays with superblock version %d\n", array.major_version);
+				rv = 1;
+				goto release;
+			}
+
 			err = sysfs_set_str(sra, NULL, "level", c);
 			if (err) {
 				st->ss->free_super(st);  
@@ -809,17 +835,41 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 					devname, c);
 			changed = 1;
 
-			/* if raid0 was takeovered by any other personality start mdmon */
+			/* if raid0 was takeovered by any other personality start mdmon	*/
 			st = super_by_fd(fd);
-			if (st->ss->external) {
-				if ((level == 5) && (orig.level == 0))
-				{
-					int dn = devname2devnum(sra->text_version + 1);
-					if (!mdmon_running(dn)) {
-						start_mdmon(dn);
+			if (st != NULL) {
+				if (st->ss->external) {
+					/* get container */
+					int dn;
+
+					if ((level == 5) && (orig.level == 0) &&
+					    (raid_disks > 0)) {
+						/* OLCE using takeover, we have degragated array,
+						 * so target disks number has to be increased
+						 */
+						raid_disks++;
+					}
+
+					if (sra) {
+						dn = devname2devnum(sra->text_version + 1);
+						if (!mdmon_running(dn)) {
+							/* start mdmon for takeovered raid */
+							fprintf(stderr, Name " Start monitoring for  %s.\n", devname);
+
+							start_mdmon(dn);
+						}
+						/* ping monitor to get all handlers */
 						ping_monitor(devnum2devname(dn));
+					} else {
+						st->ss->free_super(st);
+						st = NULL;
+						fprintf(stderr, Name": Cannot access device %s\n", devname);
+						rv = 1;
+						goto release;
 					}
 				}
+				st->ss->free_super(st);
+				st = NULL;
 			}
 		}
 	}
diff --git a/managemon.c b/managemon.c
index f39201a..b42a00b 100644
--- a/managemon.c
+++ b/managemon.c
@@ -438,6 +438,14 @@ static void manage_member(struct mdstat_ent *mdstat,
 		struct metadata_update *updates = NULL;
 		int level_before_takeover = a->container->ss->takeover(a, &updates);
 		if (level_before_takeover != a->curr_level) {
+			/* maintain return level after reshape */
+			if (a->reshape_return_level > -1) {
+				/* check if return level can be cleaned */
+				if (a->reshape_return_level == level_before_takeover)
+					a->reshape_return_level = -1;
+			} else
+				a->reshape_return_level = level_before_takeover;
+			
 			a->container->ss->prepare_update(a->container, updates);
 			a->takeover = pending;
 			queue_metadata_update(updates);
@@ -553,6 +561,8 @@ static void manage_member(struct mdstat_ent *mdstat,
 
 		a->check_degraded = 0;
 
+		if (a->reshape_return_level <= 0)
+			goto out;
 		/* The array may not be degraded, this is just a good time
 		 * to check.
 		 */
@@ -723,6 +733,7 @@ static void manage_new(struct mdstat_ent *mdstat,
 	new->reshape_position_fd = sysfs_open(new->devnum, NULL, "reshape_position");
 	new->takeover = none;
 	new->prev_level  = -1;
+	new->reshape_return_level = -1;
 	
 	dprintf("%s: inst: %d action: %d state: %d\n", __func__, atoi(inst),
 		new->action_fd, new->info.state_fd);
diff --git a/mdmon.h b/mdmon.h
index aee68bc..f47b02e 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -43,6 +43,12 @@ struct active_array {
 	int check_degraded; /* flag set by mon, read by manage */
 	int reshape_delta_disks; /* number of delta_disks discovered by monitor, used as flag for managemon, and for adding spares */  
 	unsigned long long  reshape_new_size; /* size that has to be set during reshape filalize */
+	int reshape_return_level; 	/* level to automatically return to, after reshape 
+					 * available values
+					 * raid level                : level to automatically return to, after reshape 
+					 * negative                  : do not use 
+					 * ADD_SPARE_DO_NOT_ACTIVATE : do not activate spares 
+					 *                             for degraded arrays while adding spares */
 	
 	int devnum;
  	int prev_level, curr_level;
diff --git a/monitor.c b/monitor.c
index 3343aa3..7742202 100644
--- a/monitor.c
+++ b/monitor.c
@@ -451,6 +451,22 @@ static int read_and_act(struct active_array *a)
 				a->reshape_new_size = 0;
 				sysfs_set_num(&(a->info), NULL, "array_size", a->info.array.size);
 			}
+			/* check if we have to return to raid 0 after reshape */
+			if ((a->info.array.level == 5) && (a->reshape_return_level == 0)) {
+				/* wow - reshape Raid 0 finishes
+				 * back to raid 0 (from raid 5)
+				 */
+				char *c = NULL;
+				int err;
+				struct mdinfo *sra = &a->info;
+
+				c = map_num(pers, a->reshape_return_level);
+				if (c) {
+					err = sysfs_set_str(sra, NULL, "level", c);
+					if (err < 0) dprintf("OLCE: Monitor: Cannot reverse level to %s\n",c);
+					else dprintf("OLCE: Monitor: Level restored :)\n");
+				} else dprintf("OLCE: Monitor: cannot get level\n");
+			}
 			/* A reshape has finished.  Some disks may be in sync now. */
 			for (mdi = a->info.devs ; mdi ; mdi = mdi->next) {
 				a->container->ss->set_disk(a, mdi->disk.raid_disk,
diff --git a/super-intel.c b/super-intel.c
index afc5d0c..6693d7e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5209,6 +5209,14 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 	dprintf("imsm: activate spare: inst=%d failed=%d (%d) level=%d\n",
 		inst, failed, a->info.array.raid_disks, a->info.array.level);
 	if (imsm_check_degraded(super, dev, failed) != IMSM_T_STATE_DEGRADED) {
+		struct imsm_dev *dev = get_imsm_dev(super, inst);
+		struct imsm_map *map = get_imsm_map(dev, 0);
+				    
+		if (map->num_members+failed > a->info.array.raid_disks) {
+			/* we are not after takeover */
+			if (a->reshape_return_level == -1) 
+				return NULL;
+		}
 		if (failed == 0)
 			return NULL;
 	}
-- 
1.6.0.2

