From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 1/3] mdadm: Enable takeover for external metadata.
Date: Fri, 29 Jan 2010 14:54:49 +0000
Message-ID: <F2A46F4A087B8547923AD59C289DC90E01D1622A@irsmsx002.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids


Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 Grow.c        |   17 +++-
 managemon.c   |   16 +++-
 mdadm.h       |    3 +
 mdmon.h       |    4 +
 monitor.c     |   51 ++++++++-
 super-intel.c |  344 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 426 insertions(+), 9 deletions(-)

diff --git a/Grow.c b/Grow.c
index d8d91cb..d00b980 100644
--- a/Grow.c
+++ b/Grow.c
@@ -540,7 +540,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                        "       Please use a newer kernel\n");
                return 1;
        }
-       sra = sysfs_read(fd, 0, GET_LEVEL);
+       sra = sysfs_read(fd, 0, GET_LEVEL | GET_VERSION);
        frozen = freeze_array(sra);
        if (frozen < 0) {
                fprintf(stderr, Name ": %s is performing resync/recovery and cannot"
@@ -581,7 +581,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                if (size == 0)
                        size = array.size;
        }
-
+
        /* ======= set level =========== */
        if (level != UnSet && level != array.level) {
                /* Trying to change the level.
@@ -682,6 +682,19 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                                fprintf(stderr, Name " level of %s changed to %s\n",
                                        devname, c);
                        changed = 1;
+
+                       /* if raid0 was takeovered by any other personality start mdmon */
+                       st = super_by_fd(fd);
+                       if (st->ss->external) {
+                               if ((level != 0) && (orig.level == 0))
+                               {
+                                       int dn = devname2devnum(sra->text_version + 1);
+                                       if (!mdmon_running(dn)) {
+                                               start_mdmon(dn);
+                                       }
+                                       ping_monitor(devnum2devname(dn));
+                               }
+                       }
                }
        }

diff --git a/managemon.c b/managemon.c
index e335077..86816c4 100644
--- a/managemon.c
+++ b/managemon.c
@@ -382,6 +382,16 @@ static void manage_member(struct mdstat_ent *mdstat,
        a->info.array.chunk_size = mdstat->chunk_size;
        // MORE

+       /* Takeover procedure */
+       if ((a->takeover == requested) && (a->container)) {
+               struct metadata_update *updates = NULL;
+               if (a->container->ss->takeover(a, &updates)) {
+                       a->container->ss->prepare_update(a->container, updates);
+                       a->takeover = pending;
+                       queue_metadata_update(updates);
+               }
+       }
+
        if (a->check_degraded) {
                struct metadata_update *updates = NULL;
                struct mdinfo *newdev = NULL;
@@ -479,7 +489,7 @@ static void manage_new(struct mdstat_ent *mdstat,
                return;

        mdi = sysfs_read(-1, mdstat->devnum,
-                        GET_LEVEL|GET_CHUNK|GET_DISKS|GET_COMPONENT|
+                        GET_LEVEL|GET_LAYOUT|GET_CHUNK|GET_DISKS|GET_COMPONENT|
                         GET_DEGRADED|GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE);

        new = malloc(sizeof(*new));
@@ -546,6 +556,10 @@ static void manage_new(struct mdstat_ent *mdstat,
        new->info.state_fd = sysfs_open(new->devnum, NULL, "array_state");
        new->resync_start_fd = sysfs_open(new->devnum, NULL, "resync_start");
        new->metadata_fd = sysfs_open(new->devnum, NULL, "metadata_version");
+       new->level_fd = sysfs_open(new->devnum, NULL, "level");
+       new->takeover = none;
+       new->prev_level  = -1;
+
        dprintf("%s: inst: %d action: %d state: %d\n", __func__, atoi(inst),
                new->action_fd, new->info.state_fd);

diff --git a/mdadm.h b/mdadm.h
index 836c64d..bd722a0 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -613,6 +613,9 @@ extern struct superswitch {
        void (*prepare_update)(struct supertype *st,
                               struct metadata_update *update);

+       int (*takeover)(struct active_array *a,
+                           struct metadata_update **updates);
+
        /* activate_spare will check if the array is degraded and, if it
         * is, try to find some spare space in the container.
         * On success, it add appropriate updates (For process_update) to
diff --git a/mdmon.h b/mdmon.h
index 4494085..5c2f795 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -23,6 +23,7 @@ enum array_state { clear, inactive, suspended, readonly, read_auto,

 enum sync_action { idle, reshape, resync, recover, check, repair, bad_action };

+enum takeover_stage { none, requested, pending, finished };

 struct active_array {
        struct mdinfo info;
@@ -32,6 +33,7 @@ struct active_array {
        int action_fd;
        int resync_start_fd;
        int metadata_fd; /* for monitoring rw/ro status */
+       int level_fd;

        enum array_state prev_state, curr_state, next_state;
        enum sync_action prev_action, curr_action, next_action;
@@ -39,6 +41,8 @@ struct active_array {
        int check_degraded; /* flag set by mon, read by manage */

        int devnum;
+       int prev_level, curr_level;
+       enum takeover_stage takeover;
 };

 /*
diff --git a/monitor.c b/monitor.c
index 81fef49..ea87f5f 100644
--- a/monitor.c
+++ b/monitor.c
@@ -100,6 +100,17 @@ static enum sync_action read_action( int fd)
        return (enum sync_action) sysfs_match_word(buf, sync_actions);
 }

+static int read_level(int fd)
+{
+       char buf[20];
+       int n = read_attr(buf, 20, fd);
+
+       if (n <= 0)
+               return -1;
+       int level = map_name(pers, buf);
+       return level;
+}
+
 int read_dev_state(int fd)
 {
        char buf[60];
@@ -204,7 +215,9 @@ static int read_and_act(struct active_array *a)
        a->next_action = bad_action;

        a->curr_state = read_state(a->info.state_fd);
-       a->curr_action = read_action(a->action_fd);
+       if (a->action_fd > 0)
+               a->curr_action = read_action(a->action_fd);
+       a->curr_level = read_level(a->level_fd);
        a->info.resync_start = read_resync_start(a->resync_start_fd);
        for (mdi = a->info.devs; mdi ; mdi = mdi->next) {
                mdi->next_state = 0;
@@ -214,6 +227,31 @@ static int read_and_act(struct active_array *a)
                }
        }

+       /* takeover operation was finished */
+       if (a->takeover == finished) {
+               /* end up with raid0, stop the monitor */
+               if (a->curr_level == 0)
+                       deactivate = 1;
+               /* update current level */
+               a->info.array.level = a->curr_level;
+               a->takeover = none;
+       }
+
+       if (a->takeover == none) {
+               /* check for raid level change */
+               if (a->curr_level != a->prev_level)     {
+                       /* start takeover procedure */
+                       a->takeover = requested;
+               }
+               if ((a->curr_level == 0) && (a->prev_level != 0)) {
+                       /* Raid level was changed to raid0
+                          so close unsupported sysfs handles */
+                       if (a->action_fd > 0)
+                               close(a->action_fd);
+                       a->action_fd = -1;
+               }
+       }
+
        if (a->curr_state <= inactive &&
            a->prev_state > inactive) {
                /* array has been stopped */
@@ -347,9 +385,14 @@ static int read_and_act(struct active_array *a)
        }
        dprintf(" )\n");

+       /* Takeover started. Signal manager. */
+       if (a->takeover == requested) {
+               signal_manager();
+       }
+
        /* move curr_ to prev_ */
+       a->prev_level = a->curr_level;
        a->prev_state = a->curr_state;
-
        a->prev_action = a->curr_action;

        for (mdi = a->info.devs; mdi ; mdi = mdi->next) {
@@ -460,7 +503,9 @@ static int wait_and_act(struct supertype *container, int nowait)
                }

                add_fd(&rfds, &maxfd, a->info.state_fd);
-               add_fd(&rfds, &maxfd, a->action_fd);
+               add_fd(&rfds, &maxfd, a->level_fd);
+               if (a->action_fd > 0)
+                       add_fd(&rfds, &maxfd, a->action_fd);
                for (mdi = a->info.devs ; mdi ; mdi = mdi->next)
                        add_fd(&rfds, &maxfd, mdi->state_fd);

diff --git a/super-intel.c b/super-intel.c
index fcf438c..1bb721e 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -284,6 +284,7 @@ enum imsm_update_type {
        update_activate_spare,
        update_create_array,
        update_add_disk,
+       update_takeover,
 };

 struct imsm_update_activate_spare {
@@ -308,6 +309,21 @@ struct imsm_update_add_disk {
        enum imsm_update_type type;
 };

+struct slot_change {
+       int prev_slot;
+       int new_slot;
+};
+
+struct imsm_update_takeover {
+       enum imsm_update_type type;
+       int array;
+       int devnum;
+       int new_level;
+       int delta_disks;
+       struct slot_change sl_changes[IMSM_MAX_DEVICES];
+       int sl_changed;
+};
+
 static struct supertype *match_metadata_desc_imsm(char *arg)
 {
        struct supertype *st;
@@ -1698,6 +1714,42 @@ static void imsm_copy_dev(struct imsm_dev *dest, struct imsm_dev *src)
        memcpy(dest, src, sizeof_imsm_dev(src, 0));
 }

+struct imsm_dev *reallocate_imsm_dev(struct intel_super *super,
+                                                                        int array_index,
+                                                                        int map0_num_members,
+                                                                        int map1_num_members)
+{
+       struct imsm_dev *newdev = NULL;
+       struct imsm_dev *retVal = NULL;
+       struct intel_dev *dv = NULL;
+       int memNeeded;
+
+       if (super) {
+               /* Calculate space needed for imsm_dev with a single map */
+               memNeeded = sizeof(struct imsm_dev) + sizeof(__u32) * (map0_num_members - 1);
+               /* Check if we need second map */
+               if (map1_num_members > 0)
+                       memNeeded += sizeof(struct imsm_map) + sizeof(__u32) * (map1_num_members - 1);
+
+               newdev = malloc(memNeeded);
+               if (!newdev) {
+                       fprintf(stderr, "error: imsm meta update not possible due to no memory conditions\n");
+                       return NULL;
+               }
+               /* Find our device */
+               for (dv = super->devlist; dv; dv = dv->next)
+                       if (dv->index == array_index) {
+                               /* Copy imsm_dev into the new buffer */
+                               imsm_copy_dev(newdev, dv->dev);
+                               free(dv->dev);
+                               dv->dev = newdev;
+                               retVal = newdev;
+                               break;
+                       }
+       }
+       return retVal;
+}
+
 static int compare_super_imsm(struct supertype *st, struct supertype *tst)
 {
        /*
@@ -2056,7 +2108,7 @@ static int parse_raid_devices(struct intel_super *super)
                len_migr = sizeof_imsm_dev(dev_iter, 1);
                if (len_migr > len)
                        space_needed += len_migr - len;
-
+
                dv = malloc(sizeof(*dv));
                if (!dv)
                        return 1;
@@ -2065,6 +2117,7 @@ static int parse_raid_devices(struct intel_super *super)
                        free(dv);
                        return 1;
                }
+
                imsm_copy_dev(dev_new, dev_iter);
                dv->dev = dev_new;
                dv->index = i;
@@ -3007,7 +3060,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
        map->blocks_per_member = __cpu_to_le32(info_to_blocks_per_member(info));
        map->blocks_per_strip = __cpu_to_le16(info_to_blocks_per_strip(info));
        map->failed_disk_num = ~0;
-       map->map_state = info->level ? IMSM_T_STATE_UNINITIALIZED :
+       map->map_state = info->level ? IMSM_T_STATE_UNINITIALIZED :
                                       IMSM_T_STATE_NORMAL;
        map->ddf = 1;

@@ -4076,7 +4129,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st)

                this = malloc(sizeof(*this));
                if (!this) {
-                       fprintf(stderr, Name ": failed to allocate %lu bytes\n",
+                       fprintf(stderr, Name ": failed to allocate %u bytes\n",
                                sizeof(*this));
                        break;
                }
@@ -4637,6 +4690,121 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
        return dl;
 }

+
+static int imsm_takeover(struct active_array *a,
+                        struct metadata_update **updates)
+{
+       struct intel_super *super = a->container->sb;
+       struct imsm_dev *dev = get_imsm_dev(super, a->info.container_member);
+       struct imsm_map *map = get_imsm_map(dev, 0);
+       struct metadata_update *mu;
+       struct imsm_update_takeover *u;
+       struct mdinfo *di, *mdi, *newdi;
+       struct mdinfo info;
+       struct dl *dl;
+       size_t len;
+       int slot, i;
+
+       /* First check if actual takeover occured */
+       super->current_vol = a->info.container_member;
+       getinfo_super_imsm(a->container, &info);
+
+       if (info.array.level == a->curr_level)
+       {
+               /* no raid level was actually changed */
+               fprintf(stderr, "Takeover started but no raid level was changed!\n");;
+               return 0;
+       }
+
+       /* Read sysfs devs */
+       mdi = sysfs_read(-1, a->devnum, GET_DEVS|SKIP_GONE_DEVS);
+       if (!mdi) {
+               fprintf(stderr, "Could not read sysfs!\n");;
+               return 0;
+       }
+
+       /* allocate memory for update struct */
+       len = sizeof(*u);
+       mu = malloc(sizeof(*mu));
+       if (mu) {
+               mu->buf = malloc(len);
+               if (mu->buf == NULL) {
+                       free(mu);
+                       fprintf(stderr, "%s: failed to allocate update buffer\n",
+                                       __func__);
+                       return 0;
+               }
+       } else {
+               fprintf(stderr, "%s: failed to allocate update buffer\n",
+                               __func__);
+               return 0;
+       }
+
+       /* initialize update struct */
+       mu->space = NULL;
+       mu->len = len;
+       mu->next = *updates;
+       u = (struct imsm_update_takeover*) mu->buf;
+       u->type = update_takeover;
+       u->array = a->info.container_member;
+       u->devnum = a->devnum;
+       u->new_level = a->curr_level;
+
+       /* now itarate through devices to detect any slot changes */
+       i = 0;
+       for (dl = super->disks; dl; dl = dl->next) {
+               for (newdi = mdi->devs; newdi; newdi = newdi->next)
+               {
+                       if ((dl->major == newdi->disk.major) &&
+                           (dl->minor == newdi->disk.minor)) {
+
+                               slot = get_imsm_disk_slot(map, dl->index);
+                               if (newdi->disk.raid_disk != slot)
+                           {
+                                       /* slot change detected, add the change to update struct */
+                                       u->sl_changes[i].prev_slot = slot;
+                                       u->sl_changes[i].new_slot = newdi->disk.raid_disk;
+                                       i++;
+                           }
+                               /* Update current mdadm device list */
+                               for(di = a->info.devs; di; di = di -> next)
+                           {
+                                       if ((di->disk.major == newdi->disk.major) &&
+                                               (di->disk.minor == newdi->disk.minor)) {
+                                               di->disk.raid_disk = newdi->disk.raid_disk;
+                                       }
+                           }
+                               break;
+                       }
+               }
+       }
+       /* how many slot changes */
+       u->sl_changed = i;
+
+       /* depending on raid level change, set delta disks */
+       u->delta_disks = 0;
+       if ((info.array.level == 0) && (a->curr_level == 5)) {
+               /* level changed: raid0 -> raid5 */
+               u->delta_disks = 1;
+       }
+       if ((info.array.level == 5) && (a->curr_level == 0)) {
+               /* level changed: raid5 -> raid0 */
+               u->delta_disks = -1;
+       }
+       if ((info.array.level == 10) && (a->curr_level == 0)) {
+               /* level changed: raid10 -> raid0 */
+               u->delta_disks = -2;
+       }
+       if ((info.array.level == 0) && (a->curr_level == 10)) {
+               /* level changed: raid0 -> raid10 */
+               u->delta_disks = 2;
+       }
+
+       *updates = mu;
+       return 1;
+}
+
+
 static struct mdinfo *imsm_activate_spare(struct active_array *a,
                                          struct metadata_update **updates)
 {
@@ -4807,6 +4975,29 @@ static int disks_overlap(struct intel_super *super, int idx, struct imsm_update_

 static void imsm_delete(struct intel_super *super, struct dl **dlp, int index);

+static int find_free_slot(struct mdinfo *info, int prev_slot)
+{
+       struct mdinfo* tmp_info;
+       int slot = prev_slot + 1;
+
+       /* iterate throuth mdinfo devs and find first free slot
+          that is beyond prev_slot argument */
+       do {
+               tmp_info = info;
+               while (tmp_info)
+               {
+                       if (tmp_info->disk.raid_disk == slot)
+                       {
+                               /* current slot is occupied */
+                               slot++;
+                               break;
+                       }
+                       tmp_info = tmp_info->next;
+               }
+       } while (tmp_info);
+       return slot;
+}
+
 static void imsm_process_update(struct supertype *st,
                                struct metadata_update *update)
 {
@@ -4841,6 +5032,137 @@ static void imsm_process_update(struct supertype *st,
        mpb = super->anchor;

        switch (type) {
+
+       case update_takeover: {
+               struct imsm_update_takeover *u = (void *) update->buf;
+               struct imsm_dev *dev = get_imsm_dev(super, u->array);
+               struct imsm_map *map = get_imsm_map(dev, 0);
+               struct active_array *array;
+               struct mdinfo *d;
+               struct dl *dl = NULL;
+               int slot=-1, i;
+
+               /* Initialize pointer to the proper active array */
+               for (array = st->arrays; array; array = array -> next)
+                       if (array->devnum == u->devnum) {
+                               d = array->info.devs;
+                               break;
+                       }
+
+               if (!array) {
+                       fprintf(stderr, "error: could not find any active array!\n");
+                       return;
+               }
+
+               if (u->delta_disks > 0) {
+                       /* we'll be adding missing disks: Raid0->Raid5 or Raid0->Raid10 *
+                        * First, reallocate Dev due to new map disks entries */
+                       struct imsm_dev *newdev = NULL;
+                       newdev = reallocate_imsm_dev(super, u->array,
+                                                                                map->num_members + u->delta_disks,
+                                                                                0);
+                       if (newdev == NULL)
+                       {
+                               fprintf(stderr, "error: could not reallocate dev structure!\n");
+                               return;
+                       }
+
+                       /* Refresh pointers */
+                       dev = get_imsm_dev(super, u->array);
+                       map = get_imsm_map(dev, 0);
+
+                       /* Add missing disk */
+                       if (super->missing) {
+                               fprintf(stderr, "error: there are already missing disks. Takeover failed!\n");
+                               break;
+                       }
+
+                       /* Update slots in the raid map */
+                       for (i = 0; i < u->sl_changed; i++) {
+                               int idx;
+                               idx = get_imsm_ord_tbl_ent(dev, u->sl_changes[i].prev_slot);
+                               /* now after slot changes */
+                               set_imsm_ord_tbl_ent(map, u->sl_changes[i].new_slot, idx);
+                       }
+
+                       /* Now create new devices representing missing disks */
+                       slot=-1;
+                       for (i = 0; i < u->delta_disks; i++) {
+                           dl = malloc(sizeof(*dl));
+                               if (!dl) {
+                                       fprintf(stderr, Name": could not allocate raid device\n");
+                                       return;
+                               }
+                           dl->major = dl->minor = 0;
+                           dl->fd = -1;
+                           dl->devname = strdup("missing");
+                               dl->index = mpb->num_disks;
+                           sprintf((char*)dl->disk.serial, "MISSING_DISK%d", i);
+                           dl->disk.total_blocks = -1;
+                           dl->disk.scsi_id = -1;
+                           dl->disk.status = FAILED_DISK;
+                           dl->disk.owner_cfg_num = 0;
+                           dl->e = NULL;
+                           dl->next = super->missing;
+                           super->missing = dl;
+                           /* Set slot for missing disk */
+                           slot = find_free_slot(d, slot);
+                           set_imsm_ord_tbl_ent(map, slot, dl->index | IMSM_ORD_REBUILD);
+                           dl->raiddisk = slot;
+                           /* Increase number of disks */
+                           mpb->num_disks++;
+                       }
+
+                       /* Update map */
+                       map->num_members += u->delta_disks;
+                       map->failed_disk_num = dl->index;
+                       map->map_state = IMSM_T_STATE_DEGRADED;
+               }
+
+               if (u->delta_disks < 0)
+               {
+                       /* we'll be adding missing disks: Raid5->Raid0 or Raid10->Raid0 */
+                       int missing_disks = 0;
+                       dl = super->missing;
+
+                       /* Count missing drives */
+                       while(dl) {
+                               missing_disks--;
+                               dl = dl->next;
+                       }
+                   if (missing_disks != (u->delta_disks)) {
+                       fprintf(stderr, "error: incorrect missing drive number for takeover: %d\n",
+                                               missing_disks);
+                       break;
+                   }
+                   /* removing missing disk */
+                   while (super->missing) {
+                               dl = super->missing;
+                               super->missing = dl->next;
+                               __free_imsm_disk(dl);
+                   }
+                   /* Update slots in the raid map */
+                   for (i = 0; i < u->sl_changed; i++) {
+                               int idx;
+                               idx = get_imsm_ord_tbl_ent(dev, u->sl_changes[i].prev_slot);
+                               /* now after slot changes */
+                               set_imsm_ord_tbl_ent(map, u->sl_changes[i].new_slot, idx);
+                       }
+                   /* Update mpb */
+                   mpb->num_disks += u->delta_disks;
+                   map->num_members += u->delta_disks;
+                   map->failed_disk_num = 0;
+                   map->map_state = IMSM_T_STATE_NORMAL;
+               }
+
+               /* Update raid level */
+               map->raid_level = u->new_level;
+               super->updates_pending++;
+               array->takeover = finished;
+
+               imsm_update_version_info(super);
+               break;
+       }
        case update_activate_spare: {
                struct imsm_update_activate_spare *u = (void *) update->buf;
                struct imsm_dev *dev = get_imsm_dev(super, u->array);
@@ -5096,6 +5418,20 @@ static void imsm_prepare_update(struct supertype *st,
        size_t len = 0;

        switch (type) {
+
+       case update_takeover: {
+               struct imsm_update_takeover *u = (void *) update->buf;
+               struct imsm_dev *dev = get_imsm_dev(super, u->array);
+
+               /* calculate the new size for imsm dev */
+               len = sizeof_imsm_dev(dev, 1);
+               if (u->delta_disks > 0)
+                       len += u->delta_disks * sizeof(struct imsm_disk);
+
+               update->space = NULL;
+               break;
+       }
+
        case update_create_array: {
                struct imsm_update_create_array *u = (void *) update->buf;
                struct intel_dev *dv;
@@ -5258,5 +5594,7 @@ struct superswitch super_imsm = {
        .activate_spare = imsm_activate_spare,
        .process_update = imsm_process_update,
        .prepare_update = imsm_prepare_update,
+       .takeover = imsm_takeover,
+
 #endif /* MDASSEMBLE */
 };
--
1.6.3.3



