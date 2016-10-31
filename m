From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 2/8] imsm: write bad block log on metadata sync
Date: Mon, 31 Oct 2016 15:50:48 +0100
Message-ID: <1477925454-16809-2-git-send-email-tomasz.majchrzak@intel.com>
References: <1477925454-16809-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477925454-16809-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Pre-allocate memory for largest possible bad block sectionwhen monitor
is being opened to avoid a need for memory allocation on metadata sync.

If memory for a structure has been allocated in mpb buffer but it hasn't
been used yet, it will be taken by next buffer grow, leading to
insufficient memory on metadata flush. Start tracking such memory and
take it into calculation when growing a buffer. Also assert has been
added to debug mode to warn when more metadata has been written than
memory allocated.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 super-intel.c | 49 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 4 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5d6d534..0591c55 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -81,7 +81,8 @@
 					MPB_ATTRIB_RAID1           | \
 					MPB_ATTRIB_RAID10          | \
 					MPB_ATTRIB_RAID5           | \
-					MPB_ATTRIB_EXP_STRIPE_SIZE)
+					MPB_ATTRIB_EXP_STRIPE_SIZE | \
+					MPB_ATTRIB_BBM)
 
 /* Define attributes that are unused but not harmful */
 #define MPB_ATTRIB_IGNORED		(MPB_ATTRIB_NEVER_USE)
@@ -361,6 +362,7 @@ struct intel_super {
 		array, it indicates that mdmon is allowed to clean migration
 		record */
 	size_t len; /* size of the 'buf' allocation */
+	size_t extra_space; /* extra space in 'buf' that is not used yet */
 	void *next_buf; /* for realloc'ing buf from the manager */
 	size_t next_len;
 	int updates_pending; /* count of pending updates for mdmon */
@@ -420,6 +422,7 @@ enum imsm_update_type {
 	update_takeover,
 	update_general_migration_checkpoint,
 	update_size_change,
+	update_prealloc_badblocks_mem,
 };
 
 struct imsm_update_activate_spare {
@@ -508,6 +511,10 @@ struct imsm_update_add_remove_disk {
 	enum imsm_update_type type;
 };
 
+struct imsm_update_prealloc_bb_mem {
+	enum imsm_update_type type;
+};
+
 static const char *_sys_dev_type[] = {
 	[SYS_DEV_UNKNOWN] = "Unknown",
 	[SYS_DEV_SAS] = "SAS",
@@ -3250,6 +3257,8 @@ static size_t disks_to_mpb_size(int disks)
 	size += (4 - 2) * sizeof(struct imsm_map);
 	/* 4 possible disk_ord_tbl's */
 	size += 4 * (disks - 1) * sizeof(__u32);
+	/* maximum bbm log */
+	size += sizeof(struct bbm_log);
 
 	return size;
 }
@@ -3710,6 +3719,8 @@ static int parse_raid_devices(struct intel_super *super)
 		super->len = len;
 	}
 
+	super->extra_space += space_needed;
+
 	return 0;
 }
 
@@ -4844,6 +4855,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 		super->anchor = mpb_new;
 		mpb->mpb_size = __cpu_to_le32(size_new);
 		memset(mpb_new + size_old, 0, size_round - size_old);
+		super->len = size_round;
 	}
 	super->current_vol = idx;
 
@@ -5382,6 +5394,7 @@ static int write_super_imsm(struct supertype *st, int doclose)
 	__u32 mpb_size = sizeof(struct imsm_super) - sizeof(struct imsm_disk);
 	int num_disks = 0;
 	int clear_migration_record = 1;
+	__u32 bbm_log_size;
 
 	/* 'generation' is incremented everytime the metadata is written */
 	generation = __le32_to_cpu(mpb->generation_num);
@@ -5419,9 +5432,23 @@ static int write_super_imsm(struct supertype *st, int doclose)
 		if (is_gen_migration(dev2))
 			clear_migration_record = 0;
 	}
-	mpb_size += __le32_to_cpu(mpb->bbm_log_size);
+
+	bbm_log_size = get_imsm_bbm_log_size(super->bbm_log);
+
+	if (bbm_log_size) {
+		memcpy((void *)mpb + mpb_size, super->bbm_log, bbm_log_size);
+		mpb->attributes |= MPB_ATTRIB_BBM;
+	} else
+		mpb->attributes &= ~MPB_ATTRIB_BBM;
+
+	super->anchor->bbm_log_size = __cpu_to_le32(bbm_log_size);
+	mpb_size += bbm_log_size;
 	mpb->mpb_size = __cpu_to_le32(mpb_size);
 
+#ifdef DEBUG
+	assert(super->len == 0 || mpb_size <= super->len);
+#endif
+
 	/* recalculate checksum */
 	sum = __gen_imsm_checksum(mpb);
 	mpb->check_sum = __cpu_to_le32(sum);
@@ -7104,6 +7131,7 @@ static int imsm_open_new(struct supertype *c, struct active_array *a,
 {
 	struct intel_super *super = c->sb;
 	struct imsm_super *mpb = super->anchor;
+	struct imsm_update_prealloc_bb_mem u;
 
 	if (atoi(inst) >= mpb->num_raid_devs) {
 		pr_err("subarry index %d, out of range\n", atoi(inst));
@@ -7112,6 +7140,10 @@ static int imsm_open_new(struct supertype *c, struct active_array *a,
 
 	dprintf("imsm: open_new %s\n", inst);
 	a->info.container_member = atoi(inst);
+
+	u.type = update_prealloc_badblocks_mem;
+	imsm_update_metadata_locally(c, &u, sizeof(u));
+
 	return 0;
 }
 
@@ -8854,6 +8886,9 @@ static void imsm_process_update(struct supertype *st,
 		}
 		break;
 	}
+	case update_prealloc_badblocks_mem: {
+		break;
+	}
 	default:
 		pr_err("error: unsuported process update type:(type: %d)\n",	type);
 	}
@@ -9094,6 +9129,11 @@ static int imsm_prepare_update(struct supertype *st,
 	case update_add_remove_disk:
 		/* no update->len needed */
 		break;
+	case update_prealloc_badblocks_mem: {
+		super->extra_space += sizeof(struct bbm_log) -
+			get_imsm_bbm_log_size(super->bbm_log);
+		break;
+	}
 	default:
 		return 0;
 	}
@@ -9104,12 +9144,13 @@ static int imsm_prepare_update(struct supertype *st,
 	else
 		buf_len = super->len;
 
-	if (__le32_to_cpu(mpb->mpb_size) + len > buf_len) {
+	if (__le32_to_cpu(mpb->mpb_size) + super->extra_space + len > buf_len) {
 		/* ok we need a larger buf than what is currently allocated
 		 * if this allocation fails process_update will notice that
 		 * ->next_len is set and ->next_buf is NULL
 		 */
-		buf_len = ROUND_UP(__le32_to_cpu(mpb->mpb_size) + len, 512);
+		buf_len = ROUND_UP(__le32_to_cpu(mpb->mpb_size) +
+				   super->extra_space + len, 512);
 		if (super->next_buf)
 			free(super->next_buf);
 
-- 
1.8.3.1

