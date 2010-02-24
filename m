From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [mdadm PATCH 5/11] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:46:24 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65C9@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 72e05b9f60069bf65e844f310f4f552829cc67b6 Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:07:28 +0100
Subject: [PATCH] OLCE: Prepare takeover for OLCE

Changes to be committed:
	modified:   managemon.c
	modified:   super-intel.c

To prepare takeover for OLCE:
 - write IMSM meta function has to calculate number of changed devices
 - takeover function will retutn not 0/1 value but raid level that is result of takeover
 - some changes in process_update() in takeover case

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 managemon.c   |    5 +-
 super-intel.c |  166 ++++++++++++++++++++++++++++++++++-----------------------
 2 files changed, 103 insertions(+), 68 deletions(-)

diff --git a/managemon.c b/managemon.c
index a1b6a0b..b596c77 100644
--- a/managemon.c
+++ b/managemon.c
@@ -407,11 +407,12 @@ static void manage_member(struct mdstat_ent *mdstat,
 	/* Takeover procedure */
 	if ((a->takeover == requested) && (a->container)) {
 		struct metadata_update *updates = NULL;
-		if (a->container->ss->takeover(a, &updates)) {
+		int level_before_takeover = a->container->ss->takeover(a, &updates);
+		if (level_before_takeover != a->curr_level) {
 			a->container->ss->prepare_update(a->container, updates);
 			a->takeover = pending;
 			queue_metadata_update(updates);
-		}		
+		}
 	}
 
 	if (a->check_degraded) {
diff --git a/super-intel.c b/super-intel.c
index 9e82f0c..bd10952 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3599,6 +3599,8 @@ static int write_super_imsm(struct supertype *st, int doclose)
 	__u32 sum;
 	int spares = 0;
 	int i, buflen;
+	int num_disks = 0;
+
 	__u32 mpb_size = sizeof(struct imsm_super) - sizeof(struct imsm_disk);
 
 	/* 'generation' is incremented everytime the metadata is written */
@@ -3612,20 +3614,28 @@ static int write_super_imsm(struct supertype *st, int doclose)
 	if (mpb->orig_family_num == 0)
 		mpb->orig_family_num = mpb->family_num;
 
-	mpb_size += sizeof(struct imsm_disk) * mpb->num_disks;
 	for (d = super->disks; d; d = d->next) {
 		if (d->index == -1)
 			spares++;
-		else
+		else {
 			mpb->disk[d->index] = d->disk;
+			num_disks++;
+		}
 	}
-	for (d = super->missing; d; d = d->next)
+	for (d = super->missing; d; d = d->next) {
 		mpb->disk[d->index] = d->disk;
+		num_disks++;
+	}
+	mpb->num_disks= num_disks;
+	mpb_size += sizeof(struct imsm_disk) * mpb->num_disks;
 
 	for (i = 0; i < mpb->num_raid_devs; i++) {
 		struct imsm_dev *dev = __get_imsm_dev(mpb, i);
-		imsm_copy_dev(dev, get_imsm_dev(super, i));
-		mpb_size += sizeof_imsm_dev(dev, 0);
+		struct imsm_dev *dev2 = get_imsm_dev(super, i);
+		if ((dev) && (dev2)) {
+			imsm_copy_dev(dev, dev2);
+			mpb_size += sizeof_imsm_dev(dev, 0);
+		}
 	}
 	mpb_size += __le32_to_cpu(mpb->bbm_log_size);
 	mpb->mpb_size = __cpu_to_le32(mpb_size);
@@ -4357,7 +4367,8 @@ static void update_recovery_start(struct imsm_dev *dev, struct mdinfo *array)
 		}
 
 	units = __le32_to_cpu(dev->vol.curr_migr_unit);
-	rebuild->recovery_start = units * blocks_per_migr_unit(dev);
+	if (rebuild)
+		rebuild->recovery_start = units * blocks_per_migr_unit(dev);
 }
 
 
@@ -5013,28 +5024,37 @@ static int imsm_takeover(struct active_array *a,
 	struct imsm_map *map = get_imsm_map(dev, 0);
 	struct metadata_update *mu;
 	struct imsm_update_takeover *u;
-	struct mdinfo *di, *mdi, *newdi;	
+	struct mdinfo *di, *mdi, *newdi;
 	struct mdinfo info;
 	struct dl *dl;
 	size_t len;
 	int slot, i;
+	int current_vol = super->current_vol;
+
 
 	/* First check if actual takeover occured */
 	super->current_vol = a->info.container_member;
 	getinfo_super_imsm(a->container, &info);
+	super->current_vol = current_vol;
 
-	if (info.array.level == a->curr_level)
-	{
-		/* no raid level was actually changed */
-		fprintf(stderr, "Takeover started but no raid level was changed!\n");
-		return 0;
+	if (info.array.level == a->curr_level) {
+		/* no raid level was changed */
+		return  a->curr_level;
 	}
 
-	/* Read sysfs devs */
+	/* check if updates pointer is valid
+	 * if not this means this is requrest to return level stored in meta
+	 */
+	if (updates == NULL)
+		return info.array.level;
+
+	/* Read sysfs devs
+	 * Update slot numbers...
+	 */
 	mdi = sysfs_read(-1, a->devnum, GET_DEVS|SKIP_GONE_DEVS);
 	if (!mdi) {
 		fprintf(stderr, "Could not read sysfs!\n");
-		return 0;
+		return -1;
 	}
 
 	/* allocate memory for update struct */
@@ -5047,12 +5067,12 @@ static int imsm_takeover(struct active_array *a,
 			mu = NULL;
 			fprintf(stderr, "%s: failed to allocate update buffer\n",
 					__func__);
-			return 0;
+			return -1;
 		}
 	} else {
 		fprintf(stderr, "%s: failed to allocate update buffer\n",
 				__func__);
-		return 0;
+		return -1;
 	}
 			
 	/* initialize update struct */
@@ -5116,7 +5136,7 @@ static int imsm_takeover(struct active_array *a,
 	}
 	
 	*updates = mu;
-	return 1;
+	return  info.array.level;
 }
 
 
@@ -5310,10 +5330,8 @@ static int find_free_slot(struct mdinfo *info, int prev_slot)
 	   that is beyond prev_slot argument */
 	do {
 		tmp_info = info;
-		while (tmp_info)
-		{
-			if (tmp_info->disk.raid_disk == slot)
-			{
+		while (tmp_info) {
+			if (tmp_info->disk.raid_disk == slot) {
 				/* current slot is occupied */
 				slot++;
 				break;
@@ -5371,6 +5389,16 @@ static void imsm_process_update(struct supertype *st,
 		struct mdinfo *d;
 		struct dl *dl = NULL;
 		int slot=-1, i;
+		int num_disks = 0;
+		struct imsm_map *migr_map = get_imsm_map(dev, 1);
+
+		/* count HDDs */
+		for (dl = super->disks; dl; dl = dl->next) {
+			if (dl->index >= 0)
+				num_disks ++;
+		}
+		for (dl = super->missing; dl; dl = dl->next)
+			num_disks ++;
 
 		/* Initialize pointer to the proper active array */
 		for (array = st->arrays; array; array = array -> next)
@@ -5383,7 +5411,11 @@ static void imsm_process_update(struct supertype *st,
 			fprintf(stderr, "error: could not find any active array!\n");
 			return;
 		}	
-	
+
+		/* make sure that takeover works on first map copy */
+		if (migr_map) 
+			dev->vol.migr_state = 0; 
+
 		if (u->delta_disks > 0) { 
 			/* we'll be adding missing disks: Raid0->Raid5 or Raid0->Raid10 *
 			 * First, reallocate Dev due to new map disks entries */
@@ -5400,13 +5432,13 @@ static void imsm_process_update(struct supertype *st,
 			/* Refresh pointers */
 			dev = get_imsm_dev(super, u->array);
 			map = get_imsm_map(dev, 0);
-			
+
 			/* Add missing disk */
 			if (super->missing) {
 				fprintf(stderr, "error: there are already missing disks. Takeover failed!\n");
 				break;
 			}
-			
+
 			/* Update slots in the raid map */
 			for (i = 0; i < u->sl_changed; i++) {
 				int idx;
@@ -5417,62 +5449,66 @@ static void imsm_process_update(struct supertype *st,
 
 			/* Now create new devices representing missing disks */
 			slot=-1;
+
+#define TAKEOVER_MISSING_DISK "MISSING_DISK"
 			for (i = 0; i < u->delta_disks; i++) {
-			    dl = malloc(sizeof(*dl));
-				if (!dl) {
-					fprintf(stderr, Name": could not allocate raid device\n");
-					return;
-				} 
-			    dl->major = dl->minor = 0;
-			    dl->fd = -1;
-			    dl->devname = strdup("missing");
-			    dl->index = mpb->num_disks;
-			    sprintf((char*)dl->disk.serial, "MISSING_DISK%d", i);
-			    dl->disk.total_blocks = -1;
-			    dl->disk.scsi_id = -1;
-			    dl->disk.status = FAILED_DISK;
-			    dl->disk.owner_cfg_num = 0;
-			    dl->e = NULL;
-			    dl->next = super->missing; 
-			    super->missing = dl;
-
-			    /* Set slot for missing disk */
-			    slot = find_free_slot(d, slot); 
-
-			    set_imsm_ord_tbl_ent(map, slot, dl->index | IMSM_ORD_REBUILD);
-			    dl->raiddisk = slot; 
-
-			    /* Increase number of disks */
-			    mpb->num_disks++;
+				dl = malloc(sizeof(*dl));
+					if (!dl) {
+						fprintf(stderr, Name": could not allocate raid device\n");
+						return;
+					} 
+				dl->major = dl->minor = 0;
+				dl->fd = -1;
+				dl->devname = strdup("missing");
+				dl->index = num_disks;
+				sprintf((char*)dl->disk.serial, TAKEOVER_MISSING_DISK"%d", i);
+				dl->disk.total_blocks = -1;
+				dl->disk.scsi_id = -1;
+				dl->disk.status = FAILED_DISK;
+				dl->disk.owner_cfg_num = 0;
+				dl->e = NULL;
+				dl->next = super->missing;
+				super->missing = dl;
+
+				/* Set slot for missing disk */
+				slot = find_free_slot(d, slot); 
+
+				set_imsm_ord_tbl_ent(map, slot, dl->index | IMSM_ORD_REBUILD);
+				dl->raiddisk = slot; 
+
+				/* Increase number of disks */
+				map->num_members ++;
+				num_disks++;
 			}
 			
 			/* Update map */
-			map->num_members += u->delta_disks;
 			map->failed_disk_num = dl->index;
 			map->map_state = IMSM_T_STATE_DEGRADED;
 		}
 		if (u->delta_disks < 0)
 		{ 
-			/* we'll be adding missing disks: Raid5->Raid0 or Raid10->Raid0 */
-			int missing_disks = 0;
-			
+			int count = 0;
 			dl = super->missing;
 			
 			/* Count missing drives */
 			while(dl) {
-				missing_disks--;
+				count--;
 				dl = dl->next;
 			}
-			if (missing_disks != (u->delta_disks)) {
-			    fprintf(stderr, "error: incorrect missing drive number for takeover: %d\n",
-						    missing_disks);
-			    break;
+			if (count != (u->delta_disks)) {
+			        fprintf(stderr, "error: incorrect missing drive number for takeover: %d\n",
+						count);
+			break;
 			}
-
+			slot = 0;
+			/* removing missing disk*/
 			while (super->missing) {
+				/* get and relink missing disks */
 				dl = super->missing;
 				super->missing = dl->next;
 				__free_imsm_disk(dl);
+				/* map is smaller now */
+				map->num_members --;
 			}
 
 			/* Update slots in the raid map */
@@ -5481,12 +5517,10 @@ static void imsm_process_update(struct supertype *st,
 				idx = get_imsm_ord_tbl_ent(dev, u->sl_changes[i].prev_slot);
 				/* now after slot changes */
 				set_imsm_ord_tbl_ent(map, u->sl_changes[i].new_slot, idx);
-			}		    
+			}
 
-			/* Update mpb */
-			mpb->num_disks += u->delta_disks;
-			map->num_members += u->delta_disks;
-			map->failed_disk_num = 0;
+			/* Update Map */
+			map->failed_disk_num = ~0;
 			map->map_state = IMSM_T_STATE_NORMAL;
 		}
  		
@@ -5783,7 +5817,7 @@ static void imsm_prepare_update(struct supertype *st,
 		update->space = NULL;
 		break;
 	}
-		
+
 	case update_create_array: {
 		struct imsm_update_create_array *u = (void *) update->buf;
 		struct intel_dev *dv;
-- 
1.6.0.2

