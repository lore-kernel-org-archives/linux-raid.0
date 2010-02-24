From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [mdadm PATCH 6/11] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:46:37 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65CA@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 33ca5b780daacb43a7417998e9d6eee71f5f60b0 Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:08:15 +0100
Subject: [PATCH] OLCE: OLCE implementation

Changes to be committed:
        modified:   Grow.c
        modified:   managemon.c
        modified:   mdadm.h
        modified:   mdmon.h
        modified:   monitor.c
        modified:   super-intel.c
        modified:   util.c

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Grow.c        |  225 ++++++++++++++++++++++++++++++++-----
 managemon.c   |  142 +++++++++++++++++++++++-
 mdadm.h       |    1 +
 mdmon.h       |    7 +-
 monitor.c     |  141 +++++++++++++++++++++++-
 super-intel.c |  346 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 util.c        |   32 ++++++
 7 files changed, 842 insertions(+), 52 deletions(-)

diff --git a/Grow.c b/Grow.c
index e6624d1..f332766 100644
--- a/Grow.c
+++ b/Grow.c
@@ -35,6 +35,13 @@
 #define offsetof(t,f) ((size_t)&(((t*)0)->f))
 #endif

+/**********************************************************
+ OLCE can use mre disks than there is configured curently
+       so we have to allocate more space that
+       there is required at the moment
+ ***********************************************************/
+#define OLCE_ADDITIONAL_SPACE          10
+
 int Grow_Add_device(char *devname, int fd, char *newdev)
 {
        /* Add a device to an active array.
@@ -416,7 +423,8 @@ int bsb_csum(char *buf, int len)
 static int child_grow(int afd, struct mdinfo *sra, unsigned long blocks,
                      int *fds, unsigned long long *offsets,
                      int disks, int chunk, int level, int layout, int data,
-                     int dests, int *destfd, unsigned long long *destoffsets);
+                     int dests, int *destfd, unsigned long long *destoffsets,
+                     int external);
 static int child_shrink(int afd, struct mdinfo *sra, unsigned long blocks,
                        int *fds, unsigned long long *offsets,
                        int disks, int chunk, int level, int layout, int data,
@@ -694,7 +702,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                    int devnum = fd2devnum(container_fd);
                    ping_monitor(devnum2devname(devnum));
                    close(container_fd);
-               }
+               }
        }

        /* ======= set level =========== */
@@ -779,6 +787,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                                rv = 1;/* not possible */
                                goto release;
                        }
+
                        err = sysfs_set_str(sra, NULL, "level", c);
                        if (err) {
                                st->ss->free_super(st);
@@ -800,19 +809,18 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                                        devname, c);
                        changed = 1;

-                       /* if raid0 was takeovered by any other personality start mdmon */
+                       /* if raid0 was takeovered by any other personality start mdmon */
                        st = super_by_fd(fd);
-                       if (st->ss->external) {
-                               if ((level != 0) && (orig.level == 0))
+                       if (st->ss->external) {
+                               if ((level == 5) && (orig.level == 0))
                                {
                                        int dn = devname2devnum(sra->text_version + 1);
                                        if (!mdmon_running(dn)) {
                                                start_mdmon(dn);
+                                               ping_monitor(devnum2devname(dn));
                                        }
-                                       ping_monitor(devnum2devname(dn));
                                }
                        }
-
                }
        }

@@ -1094,8 +1102,8 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                nrdisks = array.nr_disks + sra->array.spare_disks;
                /* Now we need to open all these devices so we can read/write.
                 */
-               fdlist = malloc((1+nrdisks) * sizeof(int));
-               offsets = malloc((1+nrdisks) * sizeof(offsets[0]));
+               fdlist = malloc((1+nrdisks+OLCE_ADDITIONAL_SPACE) * sizeof(int));
+               offsets = malloc((1+nrdisks+OLCE_ADDITIONAL_SPACE) * sizeof(offsets[0]));
                if (!fdlist || !offsets) {
                        fprintf(stderr, Name ": malloc failed: grow aborted\n");
                        rv = 1;
@@ -1200,16 +1208,76 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                 * sysfs.
                 */
                if (ochunk == nchunk && olayout == nlayout) {
+#define        EXTERNAL_META_STATUS_NATIVE             0
+#define        EXTERNAL_META_STATUS_OK                 EXTERNAL_META_STATUS_NATIVE + 1
+#define        EXTERNAL_META_STATUS_ERROR              EXTERNAL_META_STATUS_OK + 1
+                       int externalMetaStatus = EXTERNAL_META_STATUS_NATIVE;
+
                        array.raid_disks = ndisks;
-                       if (ioctl(fd, SET_ARRAY_INFO, &array) != 0) {
-                               rv = 1;
-                               fprintf(stderr, Name ": Cannot set device shape for %s: %s\n",
-                                       devname, strerror(errno));
-                               if (ndisks < odisks &&
-                                   get_linux_version() < 2006030)
-                                       fprintf(stderr, Name ": linux 2.6.30 or later required\n");
+                       /* update array for external meta via user space */
+                       if (st->ss->external) {
+                               struct mdinfo info;
+                               int delta_disks = 0;
+                               int container_fd = -1;
+                               int dn;
+                               struct mdinfo *sra2 = NULL;
+
+                               externalMetaStatus = EXTERNAL_META_STATUS_ERROR;
+                               sra2 =sysfs_read(fd, 0, GET_VERSION);
+                               if (sra2) {
+                                       dn = devname2devnum(sra2->text_version + 1);
+                                       container_fd = open_dev_excl(dn);
+                                       if (container_fd) {
+                                               int counter = 20;
+                                               int result = -1;
+                                               st->ss->load_super(st, container_fd, NULL);
+                                               st->ss->getinfo_super(st, &info);
+                                               close(container_fd);
+                                               delta_disks = ndisks - info.array.raid_disks;
+                                               info.array.raid_disks = ndisks;
+                                               strcpy(info.sys_name, sra2->sys_name);
+
+                                               /* loop has to be introduced
+                                                * for next volumes reshape  can occures tha array is not ready
+                                                * so we have wait a while
+                                                */
+                                               while ((result != 0) || (counter >0)) {
+                                                       result = sysfs_set_num(&info, NULL, "raid_disks", info.array.raid_disks);
+                                                       counter --;
+                                                       if (result!=0)
+                                                               sleep(1);
+                                               }

-                               break;
+                                               if (result == 0) {
+                                                       struct mdinfo * retInfo;
+                                                       retInfo = st->ss->container_content(st);
+                                                       if (retInfo != NULL)
+                                                               externalMetaStatus = EXTERNAL_META_STATUS_OK;
+                                               }
+                                       }
+                                       sysfs_free(sra2);
+                                       sra2 = NULL;
+                               }
+                       }
+
+                       if (externalMetaStatus == EXTERNAL_META_STATUS_ERROR) {
+                               /* error */
+                               fprintf(stderr, Name ": Cannot set device shape for %s: %s\n",
+                                               devname, strerror(errno));
+                               rv = 1;
+                               goto release;
+                       }
+
+                       if (externalMetaStatus == EXTERNAL_META_STATUS_NATIVE) {
+                               if (ioctl(fd, SET_ARRAY_INFO, &array) != 0) {
+                                       rv = 1;
+                                       fprintf(stderr, Name ": Cannot set device shape for %s: %s\n",
+                                               devname, strerror(errno));
+                                       if (ndisks < odisks &&
+                                               get_linux_version() < 2006030)
+                                               fprintf(stderr, Name ": linux 2.6.30 or later required\n");
+                                       break;
+                               }
                        }
                } else {
                        /* set them all just in case some old 'new_*' value
@@ -1285,7 +1353,8 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                                done = child_grow(fd, sra, stripes,
                                                  fdlist, offsets,
                                                  odisks, ochunk, array.level, olayout, odata,
-                                                 d - odisks, fdlist+odisks, offsets+odisks);
+                                                 d - odisks, fdlist+odisks, offsets+odisks,
+                                                 st->ss->external);
                        else if (odata > ndata)
                                done = child_shrink(fd, sra, stripes,
                                                    fdlist, offsets,
@@ -1316,7 +1385,9 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                                        fprintf(stderr, Name ": %s: could not set level to %s\n",
                                                devname, c);
                        }
+
                        sysfs_free(sra);
+                       sra = NULL;
                        exit(0);
                case -1:
                        fprintf(stderr, Name ": Cannot run child to monitor reshape: %s\n",
@@ -1479,7 +1550,7 @@ int wait_backup(struct mdinfo *sra,
                unsigned long long blocks, /* per device */
                unsigned long long blocks2, /* per device - hack */
                int dests, int *destfd, unsigned long long *destoffsets,
-               int part)
+               int part, int external)
 {
        /* Wait for resync to pass the section that was backed up
         * then erase the backup and allow IO
@@ -1487,12 +1558,105 @@ int wait_backup(struct mdinfo *sra,
        int fd = sysfs_get_fd(sra, NULL, "sync_completed");
        unsigned long long completed;
        int i;
+       char buf[20];
+       int retVal = 0;
+       int reshapeActivated =0;

        if (fd < 0)
                return -1;
-       sysfs_set_num(sra, NULL, "sync_max", offset + blocks + blocks2);
-       if (offset == 0)
-               sysfs_set_str(sra, NULL, "sync_action", "reshape");
+
+       if (external) {
+               if (sysfs_set_num(sra, NULL, "sync_max", 0) < 0)
+                       retVal =  -1;
+
+               if ((offset == 0) && (retVal == 0)) {
+                       if (sysfs_set_str(sra, NULL, "sync_action", "reshape")>=0) {
+                               /* wait for reconfiguration is beeing  signalled from monitor */
+                               if (sysfs_get_str(sra, NULL, "sync_completed", buf, 20) >0) {
+                                       long sync_compl = -1;
+                                       char *ep;
+                                       int counter = 0;
+
+                                       /* sync_complete == idle on error handling
+                                        * sync_complete == 0    on OK
+                                        */
+                                       sync_compl =-1;
+                                       while ((sync_compl != 0) && (retVal == 0)) {
+                                               /* got buffers, analyze
+                                                * sync completed - we are waiting for 0 only
+                                                */
+                                               if ((strlen (buf) !=0) &&
+                                                   (strlen(buf)<=2)) {
+                                                       errno = 0;
+                                                       sync_compl = strtol(buf, &ep, 10);
+                                               } else {
+                                                       /* this is not value we are interested in
+                                                        * we are still waiting
+                                                        */
+                                                       if (strncmp(buf, "none", 4) == 0) {
+                                                               /* reshape canceled */
+                                                               retVal = -101;
+                                                       }
+                                               }
+
+                                               /* now check if this action is not canceled */
+                                               if (sysfs_get_str(sra, NULL, "sync_action", buf, 20) >0) {
+                                                       /* check if md wants still perform reshape */
+                                                       if ((strncmp(buf, "reshape", strlen("reshape")) !=0) &&
+                                                          (reshapeActivated)) {
+                                                               retVal = -4;
+                                                       } else
+                                                               reshapeActivated = 1; /* I have to see reshape onec at least */
+                                               }
+
+                                               /* prepare for next loop */
+                                               if (retVal == 0) {
+                                                       /* ok no error wait a while and read next buffer */
+                                                       sleep(1);
+                                                       sysfs_get_str(sra, NULL, "sync_completed", buf, 20);
+
+                                                       /* manage timeout*/
+#define        OLCE_TIMEOUT            60
+                                                       counter ++;
+                                                       if (counter > OLCE_TIMEOUT)
+                                                               retVal = -200;
+                                               }
+
+                                       } /* while */
+                               } else
+                                       retVal = -2;
+                       } else
+                               retVal =-3;
+               }
+               if (retVal == 0) {
+                       sysfs_set_num(sra, NULL, "sync_max", offset + blocks + blocks2);
+               } else {
+                       switch (retVal) {
+                               case -1:
+                                       fprintf(stderr, Name ": Error: md finishes his job");
+                                   break;
+                               case -200:
+                                       fprintf(stderr, Name ": Error: TIMEOUT (%i sec.). . .\n",OLCE_TIMEOUT);
+                               case -2:
+                                       fprintf(stderr, Name ": Error: Cannot get synchronization with md\n");
+                                   break;
+                               case -3:
+                                       fprintf(stderr, Name ": Error: md cannot start reshape\n");
+                                   break;
+                               case -4:
+                                       fprintf(stderr, Name ": Error: Operation canceled\n");
+                                   break;
+                               default:
+                                       fprintf(stderr, Name ": Error: General operation error (%i)\n", retVal);
+                       }
+                       return retVal;
+               }
+       } else {
+               sysfs_set_num(sra, NULL, "sync_max", offset + blocks + blocks2);
+               if (offset == 0)
+                       sysfs_set_str(sra, NULL, "sync_action", "reshape");
+       }
+
        do {
                char action[20];
                fd_set rfds;
@@ -1626,7 +1790,8 @@ static void validate(int afd, int bfd, unsigned long long offset)
 static int child_grow(int afd, struct mdinfo *sra, unsigned long stripes,
                      int *fds, unsigned long long *offsets,
                      int disks, int chunk, int level, int layout, int data,
-                     int dests, int *destfd, unsigned long long *destoffsets)
+                     int dests, int *destfd, unsigned long long *destoffsets,
+                     int external)
 {
        char *buf;
        int degraded = 0;
@@ -1641,7 +1806,7 @@ static int child_grow(int afd, struct mdinfo *sra, unsigned long stripes,
        validate(afd, destfd[0], destoffsets[0]);
        wait_backup(sra, 0, stripes * chunk / 512, stripes * chunk / 512,
                    dests, destfd, destoffsets,
-                   0);
+                   0, external);
        sysfs_set_num(sra, NULL, "suspend_lo", (stripes * chunk/512) * data);
        if (buf) {
                free(buf);
@@ -1669,7 +1834,7 @@ static int child_shrink(int afd, struct mdinfo *sra, unsigned long stripes,
        sysfs_set_num(sra, NULL, "suspend_lo", 0);
        sysfs_set_num(sra, NULL, "suspend_hi", 0);
        rv = wait_backup(sra, 0, start - stripes * chunk/512, stripes * chunk/512,
-                        dests, destfd, destoffsets, 0);
+                        dests, destfd, destoffsets, 0, 0);
        if (rv < 0)
                return 0;
        grow_backup(sra, 0, stripes,
@@ -1679,7 +1844,7 @@ static int child_shrink(int afd, struct mdinfo *sra, unsigned long stripes,
                    0, &degraded, buf);
        validate(afd, destfd[0], destoffsets[0]);
        wait_backup(sra, start, stripes*chunk/512, 0,
-                   dests, destfd, destoffsets, 0);
+                   dests, destfd, destoffsets, 0, 0);
        sysfs_set_num(sra, NULL, "suspend_lo", (stripes * chunk/512) * data);
        if (buf) {
                free(buf);
@@ -1730,7 +1895,7 @@ static int child_same_size(int afd, struct mdinfo *sra, unsigned long stripes,
                if (wait_backup(sra, (start-stripes*2)*chunk/512,
                                stripes*chunk/512, 0,
                                dests, destfd, destoffsets,
-                               part) < 0)
+                               part, 0) < 0)
                        return 0;
                sysfs_set_num(sra, NULL, "suspend_lo", start*chunk/512 * data);
                if (start + stripes > size)
@@ -1747,12 +1912,12 @@ static int child_same_size(int afd, struct mdinfo *sra, unsigned long stripes,
        }
        if (wait_backup(sra, (start-stripes*2) * chunk/512, stripes * chunk/512, 0,
                        dests, destfd, destoffsets,
-                       part) < 0)
+                       part, 0) < 0)
                return 0;
        sysfs_set_num(sra, NULL, "suspend_lo", ((start-stripes)*chunk/512) * data);
        wait_backup(sra, (start-stripes) * chunk/512, tailstripes * chunk/512, 0,
                    dests, destfd, destoffsets,
-                   1-part);
+                   1-part, 0);
        sysfs_set_num(sra, NULL, "suspend_lo", (size*chunk/512) * data);
        sysfs_set_num(sra, NULL, "sync_speed_min", speed);
        if (buf) {
@@ -1918,7 +2083,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
                        goto second_fail; /* Cannot find leading superblock */

                /* Now need the data offsets for all devices. */
-               offsets = malloc(sizeof(*offsets)*info->array.raid_disks);
+               offsets = malloc(sizeof(*offsets)*(info->array.raid_disks +OLCE_ADDITIONAL_SPACE));
                if (offsets == NULL) {
                        fprintf(stderr, Name ": Failed to get memory.\n");
                        continue;
diff --git a/managemon.c b/managemon.c
index b596c77..f39201a 100644
--- a/managemon.c
+++ b/managemon.c
@@ -123,6 +123,8 @@ static void close_aa(struct active_array *aa)
        aa->info.state_fd = -1;
        close(aa->resync_start_fd);
        aa->resync_start_fd = -1;
+       close(aa->reshape_position_fd);
+       aa->reshape_position_fd = -1;
 }

 static void free_aa(struct active_array *aa)
@@ -383,6 +385,33 @@ static void manage_container(struct mdstat_ent *mdstat,
        }
 }

+
+static int reshape_add_devices(struct active_array *a, struct mdinfo *newdev, int delta_disks)
+{
+
+       int retVal = 0;
+       struct mdinfo *newd = NULL;
+
+       if (a && (delta_disks>0) && (newdev)) {
+               newdev->disk.state = (1<<MD_DISK_SYNC) | (1<<MD_DISK_ACTIVE);
+               sysfs_add_disk(&a->info, newdev, 0);
+               newd = malloc(sizeof(*newd));
+               if (newd) {
+                       *newd = *newdev;
+                       newd->next = a->info.devs;
+                       a->info.devs = newd;
+                       newd->state_fd = sysfs_open(a->devnum, newd->sys_name, "state");
+                       newd->prev_state = read_dev_state(newd->state_fd);
+                       newd->curr_state = DS_INSYNC;
+                       newd->disk.state = (1<<MD_DISK_SYNC) | (1<<MD_DISK_ACTIVE);
+                       newd->next_state = 0;
+               }
+               retVal ++;
+       }
+       return retVal;
+}
+
+
 static void manage_member(struct mdstat_ent *mdstat,
                          struct active_array *a)
 {
@@ -415,6 +444,107 @@ static void manage_member(struct mdstat_ent *mdstat,
                }
        }

+       if (a->curr_action == reshape) {
+#define  RAID_DISKS_STR_LEN 50
+#define  SYNC_MAX_STR_LEN   30
+               char raid_disks_str[RAID_DISKS_STR_LEN];
+               char sync_max_str[SYNC_MAX_STR_LEN];
+
+               if (sysfs_get_str(&(a->info), NULL,"sync_max", sync_max_str, SYNC_MAX_STR_LEN) >0) {
+                       if ((strncmp(sync_max_str, "0", 1) == 0) && ( a->reshape_delta_disks > 0 )) {
+                               /* this is reshape /hold on/ phase
+                                * we ahve add device before any action takes place
+                                * to allow manage new device also along entire managment procedure
+                                *
+                                * 1. read sysfs, if new device for teshape has to be added
+                                * 2. check reshape condition if new device has to be added
+                                * 3. if so add device to md and update meta
+                                * 4. trigger mdadm by setting sync_compl=0 in sysfs
+                                */
+                               int notificationSent = 0;
+
+                               if (sysfs_get_str(&(a->info), NULL,"raid_disks", raid_disks_str, RAID_DISKS_STR_LEN) >0) {
+                                       char *spaceLocation=NULL;
+                                       /* get it in format: new_raid_disks (old_raid_disks) */
+                                       spaceLocation = strchr (raid_disks_str, ' ');
+                                       if (spaceLocation) {
+                                               int old_raid_disks = 0;
+                                               int new_raid_disks = 0;
+                                               int delta_disks = 0;
+                                               char *endPtr;
+
+                                               *spaceLocation = '\0';
+                                               spaceLocation +=2;
+                                               *(spaceLocation + strlen(spaceLocation) -1) = '\0';
+                                               old_raid_disks = strtol(spaceLocation, &endPtr, 10);
+                                               new_raid_disks = strtol(raid_disks_str, &endPtr, 10);
+
+                                               if ((old_raid_disks == LONG_MIN)  || (old_raid_disks == LONG_MAX))
+                                                       old_raid_disks = 0;
+                                               if ((new_raid_disks == LONG_MIN) || (new_raid_disks == LONG_MAX))
+                                                       new_raid_disks = 0;
+
+                                               delta_disks = new_raid_disks - old_raid_disks;
+
+                                               if ((delta_disks>0) &&  (delta_disks == a->reshape_delta_disks) && (a->reshape_delta_disks) &&
+                                                   (new_raid_disks > 0) && (old_raid_disks > 0)) {
+                                                       /* there is something to do */
+                                                       struct metadata_update *updates = NULL;
+                                                       struct mdinfo *newdev = NULL;
+                                                       int somethingAdded = 0;
+                                                       int disksToAdd = delta_disks;
+
+                                                       /* add devices */
+                                                       somethingAdded = 0;
+                                                       while (disksToAdd) {
+                                                               newdev = a->container->ss->activate_spare(a, &updates);
+                                                               if (newdev) {
+                                                                       somethingAdded += reshape_add_devices(a, newdev, delta_disks);
+                                                                       /* prepare buffer to add next disk */
+                                                                       if (a->container->ss->prepare_update)
+                                                                               a->container->ss->prepare_update(a->container, updates);
+                                                               } else
+                                                                       dprintf("OLCE: Error: Device not added to configuration\n");
+                                                               disksToAdd--;
+                                                               /* size has matter for allocated memory for every upodate */
+                                                               a->reshape_delta_disks--;
+                                                       }
+
+                                                       /* newdev check is not needed here, we have check for somethingAdded */
+                                                       if ((somethingAdded == delta_disks) && (somethingAdded > 0)  && (updates)) {
+                                                               /* reverse updates order */
+                                                               struct metadata_update *mu = NULL;
+                                                               struct metadata_update *prev = NULL;
+
+                                                               while (updates) {
+                                                                       mu = updates;
+                                                                       updates = updates->next;
+                                                                       mu->next = prev;
+                                                                       prev = mu;
+                                                               }
+                                                               if (mu) updates = mu;
+
+                                                               /* go with update */
+                                                               queue_metadata_update(updates);
+                                                               a->check_degraded = 0;
+
+                                                               /* signal_OK */
+                                                               sysfs_set_str(&(a->info), NULL, "sync_completed", "0");
+                                                               notificationSent = 1;
+                                                       } else dprintf("OLCE: Problem in adding devices. OLCE is broken.\n");
+                                               }
+                                       }
+                               }
+
+                               if (notificationSent == 0) {
+                                       sysfs_set_str(&(a->info), NULL, "sync_action", "idle");
+                                       dprintf("OLCE: Set idle state to sync_action. OLCE aborted.\n");
+                               } else dprintf("OLCE: Set 0 to sync_completed. OLCE is OK.\n");
+                       }
+               } else sysfs_set_str(&(a->info), NULL, "sync_completed", "0");
+       }
+       a->reshape_delta_disks = 0; /* do not allow for reentry */
+
        if (a->check_degraded) {
                struct metadata_update *updates = NULL;
                struct mdinfo *newdev = NULL;
@@ -446,7 +576,7 @@ static void manage_member(struct mdstat_ent *mdstat,
                        if (sysfs_add_disk(&newa->info, d, 0) < 0) {
                                free(newd);
                                continue;
-                       }
+                       }
                        *newd = *d;
                        newd->next = newa->info.devs;
                        newa->info.devs = newd;
@@ -465,9 +595,10 @@ static void manage_member(struct mdstat_ent *mdstat,
                        d = newdev->next;
                        free(newdev);
                        newdev = d;
-               }
+               }
                free_updates(&updates);
        }
+
 }

 static int aa_ready(struct active_array *aa)
@@ -482,7 +613,10 @@ static int aa_ready(struct active_array *aa)
        if (aa->info.state_fd < 0)
                return 0;

-       if (level > 0 && (aa->action_fd < 0 || aa->resync_start_fd < 0))
+       if (level > 0 &&
+          (aa->action_fd < 0 ||
+          aa->resync_start_fd < 0 ||
+          aa->reshape_position_fd < 0))
                return 0;

        if (!aa->container)
@@ -586,8 +720,10 @@ static void manage_new(struct mdstat_ent *mdstat,
        new->resync_start_fd = sysfs_open(new->devnum, NULL, "resync_start");
        new->metadata_fd = sysfs_open(new->devnum, NULL, "metadata_version");
        new->level_fd = sysfs_open(new->devnum, NULL, "level");
+       new->reshape_position_fd = sysfs_open(new->devnum, NULL, "reshape_position");
        new->takeover = none;
        new->prev_level  = -1;
+
        dprintf("%s: inst: %d action: %d state: %d\n", __func__, atoi(inst),
                new->action_fd, new->info.state_fd);

diff --git a/mdadm.h b/mdadm.h
index bd722a0..e05a58e 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -835,6 +835,7 @@ extern char *conf_word(FILE *file, int allow_key);
 extern int conf_name_is_free(char *name);
 extern int devname_matches(char *name, char *match);
 extern struct mddev_ident_s *conf_match(struct mdinfo *info, struct supertype *st);
+extern int find_array_minor(char *text_version, int external, int *minor);

 extern void free_line(char *line);
 extern int match_oneof(char *devices, char *devname);
diff --git a/mdmon.h b/mdmon.h
index 5c2f795..aee68bc 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -30,6 +30,7 @@ struct active_array {
        struct supertype *container;
        struct active_array *next, *replaces;

+       int reshape_position_fd;
        int action_fd;
        int resync_start_fd;
        int metadata_fd; /* for monitoring rw/ro status */
@@ -37,12 +38,16 @@ struct active_array {

        enum array_state prev_state, curr_state, next_state;
        enum sync_action prev_action, curr_action, next_action;
+       unsigned long long reshape_position;

        int check_degraded; /* flag set by mon, read by manage */
-
+       int reshape_delta_disks; /* number of delta_disks discovered by monitor, used as flag for managemon, and for adding spares */
+       unsigned long long  reshape_new_size; /* size that has to be set during reshape filalize */
+
        int devnum;
        int prev_level, curr_level;
        enum takeover_stage takeover;
+       unsigned long long resync_start;
 };

 /*
diff --git a/monitor.c b/monitor.c
index c4f4015..3343aa3 100644
--- a/monitor.c
+++ b/monitor.c
@@ -114,6 +114,28 @@ static int read_level(int fd)
        int level = map_name(pers, buf);
        return level;
 }
+static unsigned long long read_reshape_position( int fd)
+{
+       char buf[40];
+       int n = read_attr(buf, 40, fd);
+       unsigned long long retVal = 0;
+
+       if (n <= 0) {
+               /* error - do nothing */
+       } else {
+               /* check if reshape position i s numeric */
+               char *ep;
+
+               retVal = strtoull(buf, &ep, 10);
+               if (ep == buf ||
+                   ((*ep != 0) && (*ep != '\n') && (*ep != ' '))) {
+                       /* error so we have to wait more */
+                       retVal =0;
+               }
+       }
+
+       return retVal;
+}

 int read_dev_state(int fd)
 {
@@ -208,21 +230,35 @@ static void signal_manager(void)
  *
  */

+extern void queue_metadata_update(struct metadata_update *mu);
+extern struct active_array *duplicate_aa(struct active_array *aa);
+extern void replace_array(struct supertype *container,
+                   struct active_array *old,
+                   struct active_array *new);
+
 static int read_and_act(struct active_array *a)
 {
        int check_degraded = 0;
        int deactivate = 0;
        struct mdinfo *mdi;
        int dirty = 0;
+       unsigned long long reshape_position = 0;

        a->next_state = bad_word;
        a->next_action = bad_action;

        a->curr_state = read_state(a->info.state_fd);
-       if (a->action_fd > 0)
-               a->curr_action = read_action(a->action_fd);
-       a->curr_level = read_level(a->level_fd);
+       if (a->action_fd > 0)
+               a->curr_action = read_action(a->action_fd);
+       a->curr_level = read_level(a->level_fd);
        a->info.resync_start = read_resync_start(a->resync_start_fd);
+       if (a->prev_level < 0) {
+               /* get level from meta */
+               a->prev_level = a->container->ss->takeover( a, NULL);
+       }
+
+       reshape_position = read_reshape_position(a->reshape_position_fd);
+
        for (mdi = a->info.devs; mdi ; mdi = mdi->next) {
                mdi->next_state = 0;
                if (mdi->state_fd >= 0) {
@@ -327,6 +363,103 @@ static int read_and_act(struct active_array *a)
                }
        }

+#define OLCE_STR_LEN                   50
+#define  RAID_DISKS_STR_LEN            50
+       if (!deactivate) {
+               /* monitor reshape position (update meta)
+                * Start reshape
+                */
+               if ((a->curr_action == reshape)) {
+                       int sent_to_manager = 0;
+                       switch (a->prev_action) {
+                               case reshape : /* continue reshape */
+                               {
+                                       if (a->reshape_position != reshape_position) {
+                                               /* uptdate meta
+                                                * where update reshape position ? propably in manager to identify request
+                                                */
+
+                                               /* a->reshape_position = reshape_position */
+                                               sysfs_set_str(&(a->info), NULL,"sync_completed","0");
+                                               /* reshape checkpointing */
+                                               /* send_to_manager = 1; */
+                                       }
+                               }
+                               break;
+
+                               default:
+                               {
+                                       char raid_disks_str[ RAID_DISKS_STR_LEN ];
+                                       /* we ahve add device before any action takes place
+                                        * to allow manage new device also along entire managment procedure
+                                        *
+                                        * 1. read sysfs, if new device for teshape has to be added
+                                        * 2. check reshape condition if new device has to be added
+                                        * 3. if so add device to md and update meta
+                                        * 4. trigger mdadm by setting sync_compl=0 in sysfs
+                                        */
+                                       if (sysfs_get_str(&(a->info), NULL, "raid_disks", raid_disks_str, RAID_DISKS_STR_LEN) >0) {
+                                               char *spaceLocation = NULL;
+                                               /* get it in format: new_raid_disks (old_raid_disks) */
+                                               spaceLocation = strchr (raid_disks_str, ' ');
+                                               if (spaceLocation) {
+                                                       int old_raid_disks = 0;
+                                                       int new_raid_disks = 0;
+                                                       int delta_disks = 0;
+                                                       char *endPtr;
+
+                                                       *spaceLocation = '\0';
+                                                       spaceLocation += 2;
+                                                       *(spaceLocation + strlen(spaceLocation) -1) = '\0';
+
+                                                       old_raid_disks = strtol(spaceLocation, &endPtr, 10);
+                                                       new_raid_disks = strtol(raid_disks_str, &endPtr, 10);
+
+                                                       if ((old_raid_disks == LONG_MIN) || (old_raid_disks == LONG_MAX))
+                                                               old_raid_disks = 0;
+                                                       if ((new_raid_disks == LONG_MIN) || (new_raid_disks == LONG_MAX))
+                                                               new_raid_disks = 0;
+
+                                                       delta_disks = new_raid_disks - old_raid_disks;
+
+                                                       if ((delta_disks > 0) &&  /* grow only */
+                                                           (new_raid_disks >0) && (old_raid_disks >0)) {
+                                                               a->reshape_delta_disks = delta_disks;
+                                                               a->reshape_position = 0;
+                                                               sent_to_manager = 1;
+                                                       } else sysfs_set_str(&(a->info), NULL,"sync_completed","0");
+                                               }
+                                       }
+                               }
+                               break;
+                       } /* switch */
+
+                       if (sent_to_manager == 1) {
+                               /* Mmanager doesnt have to be invoked for this reshape
+                                * send signal to mdadm myself
+                                */
+                               signal_manager();
+                       }
+               }
+
+               /* finalize reshape */
+               if ((a->curr_action != reshape) &&
+                   (a->prev_action == reshape)) {
+                       /* array size has to be changed */
+                       if (a->reshape_new_size > 0) {
+                               a->info.array.size = a->reshape_new_size;
+                               a->reshape_new_size = 0;
+                               sysfs_set_num(&(a->info), NULL, "array_size", a->info.array.size);
+                       }
+                       /* A reshape has finished.  Some disks may be in sync now. */
+                       for (mdi = a->info.devs ; mdi ; mdi = mdi->next) {
+                               a->container->ss->set_disk(a, mdi->disk.raid_disk,
+                                               mdi->curr_state);
+                       }
+               }
+       }
+
+
        /* Check for failures and if found:
         * 1/ Record the failure in the metadata and unblock the device.
         *    FIXME update the kernel to stop notifying on failed drives when
@@ -510,6 +643,8 @@ static int wait_and_act(struct supertype *container, int nowait)
                add_fd(&rfds, &maxfd, a->level_fd);
                if (a->action_fd > 0)
                        add_fd(&rfds, &maxfd, a->action_fd);
+               add_fd(&rfds, &maxfd, a->reshape_position_fd);
+
                for (mdi = a->info.devs ; mdi ; mdi = mdi->next)
                        add_fd(&rfds, &maxfd, mdi->state_fd);

diff --git a/super-intel.c b/super-intel.c
index bd10952..afc5d0c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -27,6 +27,7 @@
 #include <ctype.h>
 #include <dirent.h>

+
 /* MPB == Metadata Parameter Block */
 #define MPB_SIGNATURE "Intel Raid ISM Cfg Sig. "
 #define MPB_SIG_LEN (strlen(MPB_SIGNATURE))
@@ -194,6 +195,10 @@ struct bbm_log {
 static char *map_state_str[] = { "normal", "uninitialized", "degraded", "failed" };
 #endif

+
+
+
+
 static __u8 migr_type(struct imsm_dev *dev)
 {
        if (dev->vol.migr_type == MIGR_VERIFY &&
@@ -285,6 +290,7 @@ enum imsm_update_type {
        update_create_array,
        update_add_disk,
        update_takeover,
+       update_add_spare,
 };

 struct imsm_update_activate_spare {
@@ -292,6 +298,8 @@ struct imsm_update_activate_spare {
        struct dl *dl;
        int slot;
        int array;
+       int reshape_delta_disks;
+       int devnum;
        struct imsm_update_activate_spare *next;
 };

@@ -324,6 +332,7 @@ struct imsm_update_takeover {
        int sl_changed;
 };

+
 static struct supertype *match_metadata_desc_imsm(char *arg)
 {
        struct supertype *st;
@@ -405,7 +414,6 @@ struct imsm_map *get_imsm_map(struct imsm_dev *dev, int second_map)
                return NULL;
        else if (second_map) {
                void *ptr = map;
-
                return ptr + sizeof_imsm_map(map);
        } else
                return map;
@@ -490,6 +498,7 @@ static __u32 get_imsm_ord_tbl_ent(struct imsm_dev *dev, int slot)
 }

 #define ord_to_idx(ord) (((ord) << 8) >> 8)
+#define get_ord_flags(ord) (((ord) >> 8) << 8)
 static __u32 get_imsm_disk_idx(struct imsm_dev *dev, int slot)
 {
        __u32 ord = get_imsm_ord_tbl_ent(dev, slot);
@@ -507,6 +516,7 @@ static int get_imsm_disk_slot(struct imsm_map *map, int idx)
        int slot;
        __u32 ord;

+
        for (slot = 0; slot < map->num_members; slot++) {
                ord = __le32_to_cpu(map->disk_ord_tbl[slot]);
                if (ord_to_idx(ord) == idx)
@@ -1443,6 +1453,7 @@ static __u64 blocks_per_migr_unit(struct imsm_dev *dev)
        }
 }

+
 static int imsm_level_to_layout(int level)
 {
        switch (level) {
@@ -1751,6 +1762,7 @@ struct imsm_dev *reallocate_imsm_dev(struct intel_super *super,
                                                                         int array_index,
                                                                         int map0_num_members,
                                                                         int map1_num_members)
+
 {
        struct imsm_dev *newdev = NULL;
        struct imsm_dev *retVal = NULL;
@@ -1778,8 +1790,9 @@ struct imsm_dev *reallocate_imsm_dev(struct intel_super *super,
                                dv->dev = newdev;
                                retVal = newdev;
                                break;
-                       }
+               }
        }
+
        return retVal;
 }

@@ -4030,7 +4043,6 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
        /* We must have the container info already read in. */
        if (!super)
                return 0;
-
        if (!validate_geometry_imsm_orom(super, level, layout, raiddisks, chunk, verbose))
                return 0;

@@ -4409,8 +4421,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
                 * unsupported migration
                 */
                if (dev->vol.migr_state &&
-                   (migr_type(dev) == MIGR_GEN_MIGR ||
-                    migr_type(dev) == MIGR_STATE_CHANGE)) {
+                   (migr_type(dev) == MIGR_STATE_CHANGE)) {
                        fprintf(stderr, Name ": cannot assemble volume '%.16s':"
                                " unsupported migration in progress\n",
                                dev->volume);
@@ -4575,10 +4586,17 @@ static __u8 imsm_check_degraded(struct intel_super *super, struct imsm_dev *dev,
                return IMSM_T_STATE_DEGRADED;
        }
        case 5:
-               if (failed < 2)
+               switch(failed)
+               {
+                   case 0:
+                       return IMSM_T_STATE_NORMAL;
+                       break;
+                   case 1:
                        return IMSM_T_STATE_DEGRADED;
-               else
+                       break;
+                   default:
                        return IMSM_T_STATE_FAILED;
+               }
                break;
        default:
                break;
@@ -4807,7 +4825,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
        if ((dev == NULL) || (map == NULL))
                return;

-       if (n > map->num_members)
+       if (n >= map->num_members)
                fprintf(stderr, "imsm: set_disk %d out of range 0..%d\n",
                        n, map->num_members - 1);

@@ -5073,7 +5091,7 @@ static int imsm_takeover(struct active_array *a,
                fprintf(stderr, "%s: failed to allocate update buffer\n",
                                __func__);
                return -1;
-       }
+       }

        /* initialize update struct */
        mu->space = NULL;
@@ -5190,8 +5208,10 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,

        dprintf("imsm: activate spare: inst=%d failed=%d (%d) level=%d\n",
                inst, failed, a->info.array.raid_disks, a->info.array.level);
-       if (imsm_check_degraded(super, dev, failed) != IMSM_T_STATE_DEGRADED)
-               return NULL;
+       if (imsm_check_degraded(super, dev, failed) != IMSM_T_STATE_DEGRADED) {
+               if (failed == 0)
+                       return NULL;
+       }

        /* For each slot, if it is not working, find a spare */
        for (i = 0; i < a->info.array.raid_disks; i++) {
@@ -5209,7 +5229,8 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
                 * partially assimilated, finally try to activate a new
                 * spare.
                 */
-               dl = imsm_readd(super, i, a);
+               if (d) /* previously there was present member */
+                   dl = imsm_readd(super, i, a);
                if (!dl)
                        dl = imsm_add_spare(super, i, a, 0);
                if (!dl)
@@ -5290,6 +5311,16 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
                di->devs = NULL;
                u->slot = di->disk.raid_disk;
                u->array = inst;
+
+               a->reshape_new_size = 0;
+               u->reshape_delta_disks = a->reshape_delta_disks;
+               if (u->reshape_delta_disks) {
+                       u->type = update_add_spare;
+                       u->devnum = a->devnum;
+               }
+               else
+                       u->devnum = -1;
+
                u->next = u + 1;
                u++;
        }
@@ -5342,6 +5373,25 @@ static int find_free_slot(struct mdinfo *info, int prev_slot)
        return slot;
 }

+static void map_dump(char *info, struct imsm_dev *dev)
+{
+#ifdef DEBUG
+       int i;
+       struct imsm_map *map = get_imsm_map(dev, 0);
+
+       dprintf(info);
+       dprintf("\n");
+       dprintf("MAP DUMP ============================================ START\n");
+       dprintf("\tMap address: %p\n", map);
+       dprintf("\tMap count  : %i\n", map->num_members);
+       for(i=0; i<map->num_members; i++)
+       {
+               dprintf("\t\tDisk %i => %i (ord = %i)\n",i, get_imsm_disk_idx(dev, i), get_imsm_ord_tbl_ent(dev, i) );
+       }
+       dprintf("MAP DUMP ============================================ END\n");
+#endif
+}
+
 static void imsm_process_update(struct supertype *st,
                                struct metadata_update *update)
 {
@@ -5390,7 +5440,7 @@ static void imsm_process_update(struct supertype *st,
                struct dl *dl = NULL;
                int slot=-1, i;
                int num_disks = 0;
-               struct imsm_map *migr_map = get_imsm_map(dev, 1);
+                struct imsm_map *migr_map = get_imsm_map(dev, 1);

                /* count HDDs */
                for (dl = super->disks; dl; dl = dl->next) {
@@ -5528,10 +5578,265 @@ static void imsm_process_update(struct supertype *st,
                map->raid_level = u->new_level;
                super->updates_pending++;
                array->takeover = finished;
-
+
                imsm_update_version_info(super);
-               break;
+               map_dump("TAKEOVER: END Map DUMP", dev);
        }
+       break;
+       case update_add_spare:
+       {
+               /* every update is valid for adding single disk only
+                * if you want to add mmore disks, post update list
+               */
+               struct imsm_dev *newdev = NULL;
+               struct imsm_update_activate_spare *u = (void *) update->buf;
+               struct imsm_dev *dev = NULL;
+               struct imsm_map *map = NULL;
+               struct imsm_map *migr_map = NULL;
+               struct imsm_map *migr_map_backup = NULL;
+               int migr_map_size = 0;
+               struct dl *dl = NULL;
+               struct dl *dl_missing = NULL;
+               struct dl *dl2 = NULL;
+               int index = -1;
+               __u8 to_state;
+               int hdd_count = 0;
+               int hdd_missing_count = 0;
+               struct active_array *a = NULL;
+               int slot;
+               int slot_missing;
+               int missing_ord = -1;
+               int missing_index = -1;
+               int update_add_spare_status = -1;
+               int migr_state = -1;
+
+               /* verify input */
+               if (u == NULL) {
+                       fprintf(stderr, "error: IMSM: corrupted update is passed\n");
+                       goto update_add_spare_exit;
+               }
+               slot = u->slot;
+               dprintf("OLCE: USED Slot = %i\n",slot);
+
+               dev = get_imsm_dev(super, u->array);
+               if (dev == NULL) {
+                       fprintf(stderr, "error: IMSM: Cannot find requested device\n");
+                       goto update_add_spare_exit;
+               }
+               /* use first map as a base */
+               migr_state = dev->vol.migr_state;
+               dev->vol.migr_state = 0;
+
+               map = get_imsm_map(dev, 0);
+               if (map == NULL) {
+                       fprintf(stderr, "error: IMSM: Invalid map for requested device\n");
+                       goto update_add_spare_exit;
+               }
+
+               /* count HDDs */
+               for (dl = super->disks; dl; dl = dl->next) {
+                       if (dl->index >= 0)
+                               hdd_count ++;
+               }
+
+               /* count missing disks */
+               for (dl = super->missing; dl; dl = dl->next) {
+                       hdd_missing_count ++;
+               }
+
+               /* number of disks to add during one update
+                * to add more drives updates will go in series
+                */
+               u->reshape_delta_disks = 1;
+
+               newdev = reallocate_imsm_dev(super, u->array, map->num_members + u->reshape_delta_disks, map->num_members + u->reshape_delta_disks);
+               /* verify if buffer is used */
+               if (newdev == NULL) {
+                       /* new buffer not set */
+                       fprintf(stderr, "error: imsm meta update not possible due to not founding device\n");
+                       goto update_add_spare_exit;
+               }
+               /* get new pointers */
+               dev = get_imsm_dev(super, u->array);
+               map = get_imsm_map(dev, 0);
+
+               /* get/create migration map and backup it */
+               migr_map = get_imsm_map(dev, 1);
+
+               if (migr_map == NULL) {
+                       /* set migration/ no migration in progress
+                        * temporary for migrate call only use MIGR_REBUILD
+                        * later migration will be set to MIGR_GEN_MIGR
+                        * using migr_state variable
+                        */
+                       dev->vol.migr_state = MIGR_REBUILD;
+                       to_state = imsm_check_degraded(super, dev, 0);
+                       migrate(dev, to_state, dev->vol.migr_state);
+                       migr_map = get_imsm_map(dev, 1);
+                       migr_state =  MIGR_GEN_MIGR;
+                       dev->vol.migr_state = 0;
+               }
+
+               map_dump("OLCE: map dump (before changes)", dev);
+
+               /* backup migration map to shift it in memory */
+               if (migr_map) {
+                       migr_map_size = sizeof_imsm_map(migr_map);
+                       if (migr_map_size > 0) {
+                               migr_map_backup = calloc(1, migr_map_size);
+                               if (migr_map_backup)
+                                       memcpy(migr_map_backup, migr_map, migr_map_size);
+                       }
+               }
+
+               if (migr_map_backup == NULL) {
+                       fprintf(stderr, "error: imsm_add_spare (ADD_TO_MAP) "
+                                       "cannot maintain second map in metadata record\n");
+                       goto update_add_spare_exit;
+               }
+
+               /* find "my" missing hdd */
+               for (dl = super->missing; dl; dl = dl->next) {
+                       int hdd_index;
+                       int j;
+
+                       for (j=0; j < map->num_members ;j++) {
+                               hdd_index = get_imsm_disk_idx(dev, j);
+                               /* check if disk serial is equal to TAKEOVER_MISSING_DISK */
+                               if ((hdd_index == dl->index) &&
+                               (strncmp((char*)dl->disk.serial,
+                                       TAKEOVER_MISSING_DISK,
+                                       strlen(TAKEOVER_MISSING_DISK)) == 0)) {
+                                       dl_missing = dl;
+                                       slot_missing = j;
+                                       missing_index = hdd_index;
+                                       missing_ord = get_imsm_ord_tbl_ent(dev, j);
+                                       break;
+                               }
+                       }
+               }
+
+               if (hdd_missing_count > 1) {
+                       /* OLCE is not supported for more than 1 missing hdd */
+                       fprintf(stderr, "error: imsm_add_spare found %i missing disks.\n",
+                               hdd_missing_count);
+                       goto update_add_spare_exit;
+               }
+
+               /* find my hdd */
+               for (dl = super->disks; dl; dl = dl->next) {
+                       if (dl == u->dl)
+                               break;
+               }
+               if (!dl) {
+                       fprintf(stderr, "error: imsm_add_spare passed "
+                               "an unknown disk (index: %d)\n",
+                               u->dl->index);
+                       goto update_add_spare_exit;
+               }
+
+               if (dl->index == -1) {
+                       /* find first free index */
+                       for (dl2 = super->disks; dl2; dl2 = dl2->next) {
+                               if (index <= dl2->index)
+                                       index = dl2->index+1;
+                       }
+
+                       /* configure additional disk */
+                       dl->index = index;
+                       dl->disk.status |= CONFIGURED_DISK;
+                       dl->disk.status &= ~SPARE_DISK;
+               } else
+                       index = dl->index;
+
+               /* maintain missing disk (for using with takeover) */
+               if (missing_index > -1) {
+                       /* there is something in missing list */
+                       int new_missing_index;
+                       new_missing_index = index + 1;
+                       slot_missing++;
+                       if (new_missing_index > missing_index) {
+                               /* we need to shift missing index */
+                               dl_missing->index = new_missing_index;
+                               missing_index = new_missing_index;
+                               /* get flags from old ord */
+                               missing_ord =  get_ord_flags(missing_ord);
+                               /* add new index */
+                               missing_ord |= missing_index;
+                       }
+               }
+               /* map update
+                * 1'st map
+                */
+               map->num_members += u->reshape_delta_disks;
+               set_imsm_ord_tbl_ent(map, slot, dl->index);
+               /* 2'nd map */
+               if (migr_state != -1) dev->vol.migr_state = migr_state;
+               migr_state = -1;
+               /* get new location of migration map */
+               migr_map = get_imsm_map(dev, 1);
+               if ((migr_map != NULL) && (migr_map_backup != NULL)) {
+                       /* restore second map */
+                       memcpy(migr_map, migr_map_backup, migr_map_size);
+                       if (missing_ord != -1) {
+                               /* missing drive ord number has to change */
+                               set_imsm_ord_tbl_ent(migr_map, migr_map->num_members-1, missing_ord);
+                               set_imsm_ord_tbl_ent(map, map->num_members-1, missing_ord);
+                               /* update failed_disk_num in maps */
+                               map->failed_disk_num = missing_index;
+                               migr_map->failed_disk_num = missing_index;
+                       }
+                       migr_map->map_state = IMSM_T_STATE_DEGRADED;
+               }
+
+               /* manage size, if active array is known to in line with md
+                * access active array (Initialize pointer to the proper active array)
+                */
+               for (a = st->arrays; a; a = a->next) {
+                       if (a->devnum == u->devnum)
+                               break;
+               }
+
+               if (a) {
+                       unsigned long long array_blocks;
+                       unsigned long long array_blocks_current;
+                       int used_disks = 0;
+                        /* count used disks for data */
+                       switch (map->raid_level) {
+                               case 0:
+                                   used_disks = map->num_members;
+                               break;
+                               case 5:
+                                   used_disks = map->num_members - 1;
+                               break;
+                               default:
+                                       fprintf(stderr, "error : imsm_add_spare cannot perform OLCE on array other than Raid0 or Raid5.\n");
+                                       goto update_add_spare_exit;
+                       }
+                       array_blocks = map->blocks_per_member * used_disks;
+                       /* round array size down to closest MB  */
+                       array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
+                       array_blocks_current = (((unsigned long long)dev->size_high) <<32) + dev->size_low;
+
+                       if (array_blocks_current < array_blocks) {  /* grow only */
+                               dev->size_low = __cpu_to_le32((__u32) array_blocks);
+                               dev->size_high = __cpu_to_le32((__u32) (array_blocks >> 32));
+                               a->reshape_new_size = array_blocks/2;
+                       }
+               }
+               super->updates_pending++;
+               update_add_spare_status = 1; /* operatio succed - no exit with error */
+
+update_add_spare_exit:
+
+               if (migr_state != -1) {
+                       map_dump("OLCE: Final dump (before changes)", dev);
+                       dev->vol.migr_state = migr_state;
+               }
+               if (migr_map_backup) free(migr_map_backup);
+               if (update_add_spare_status < 0) return;
+       }
+       break;
        case update_activate_spare: {
                struct imsm_update_activate_spare *u = (void *) update->buf;
                struct imsm_dev *dev = get_imsm_dev(super, u->array);
@@ -5817,7 +6122,18 @@ static void imsm_prepare_update(struct supertype *st,
                update->space = NULL;
                break;
        }
+       case update_add_spare: {
+               struct imsm_update_activate_spare *u = (void *) update->buf;
+               struct imsm_dev *dev = get_imsm_dev(super, u->array);

+               /* get current size */
+               if  (u->reshape_delta_disks > 0) {
+                       len = sizeof_imsm_dev(dev, 1) + u->reshape_delta_disks*sizeof(struct imsm_disk);
+               }
+               update->space = NULL;
+               break;
+       }
+
        case update_create_array: {
                struct imsm_update_create_array *u = (void *) update->buf;
                struct intel_dev *dv;
diff --git a/util.c b/util.c
index ea74efe..36e1c4d 100644
--- a/util.c
+++ b/util.c
@@ -1665,3 +1665,35 @@ void append_metadata_update(struct supertype *st, void *buf, int len)
 unsigned int __invalid_size_argument_for_IOC = 0;
 #endif

+int find_array_minor(char *text_version, int external, int *minor)
+{
+       int i;
+       char path[PATH_MAX];
+       struct stat s;
+
+       if (minor == NULL)
+               return -2;
+
+       for (i = 127; i >= 0; i--) {
+               char buf[1024];
+
+               snprintf(path, PATH_MAX, "/sys/block/md%d/md/", i);
+               if (stat(path, &s) != -1) {
+                       strcat(path, "metadata_version");
+                       if (load_sys(path, buf))
+                               continue;
+                       if (external) {
+                               char *version = strchr(buf, ':');
+                               if (version && strcmp(version + 1, text_version))
+                                       continue;
+                       } else {
+                               if (strcmp(buf, text_version))
+                                       continue;
+                       }
+                       *minor = i;
+                       return 0;
+               }
+       }
+       return -1;
+}
+
--
1.6.0.2

