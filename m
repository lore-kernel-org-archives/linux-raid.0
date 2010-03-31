From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 1/2] imsm: delete subarray functionality
Date: Wed, 31 Mar 2010 21:50:40 +0100
Message-ID: <66C59AD0932712458090B447266D638CD3C7EAF4@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Kill subarray deletes metadata references to array identified
by name, uuid or member index. Target array must not be assembled
before an attempt to delete.

The patch adds --kill-subarray switch (no short form) with optional
parameter to specify member index. Instead one can use -N <name> or
-u <uuid> to choose array.

mdadm --kill-subarray[=member-id | -N <name> | -u <uuid> \
<container-or-devlist>

<container-or-devlist> is either container device or list of devices.
In the second case, if the container with given array is active,
the list of disk devices MUST be complete ie. must contain all valid
container devices. If container is managed by mdmon metadata modification
is made via mdmon. Patch contains routines to check conditions mentioned
above, so delete array routine is invoked on proper set of devices
or action is rejected.

Patch also adds some utilities to simple sysfs manipulation and
to allow locking of map file during updates.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Kill.c        |   58 +++++++++++
 Makefile      |    4 +-
 ReadMe.c      |    1 +
 mapfile.c     |   31 ++++--
 mdadm.c       |   14 +++
 mdadm.h       |   34 +++++++
 mdstat.c      |   86 ++++++++++++++++-
 super-intel.c |  152 +++++++++++++++++++++++++++++-
 sysfs.c       |   21 ++++
 util.c        |  293 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 10 files changed, 678 insertions(+), 16 deletions(-)

diff --git a/Kill.c b/Kill.c
index e738978..e5d5dcb 100644
--- a/Kill.c
+++ b/Kill.c
@@ -79,3 +79,61 @@ int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl)
        close(fd);
        return rv;
 }
+
+
+int Kill_Subarray(mddev_dev_t devlist, int force, int quiet, struct mddev_ident_s *ident)
+{
+       int     rv;
+       struct array_dev_list *dl = NULL;
+       int i, found;
+       struct mdinfo info;
+
+       if ((dl = check_devices(devlist, force, quiet, "imsm")) == NULL) {
+               return 1;
+       }
+
+       while(dl) {
+               for (i = 0, found = 0, rv = 0; rv == 0; i++) {
+                       snprintf(dl->st->subarray, sizeof(dl->st->subarray) - 1, "%d", i);
+                       rv = dl->st->ss->load_super(dl->st, dl->fd, NULL);
+                       if (rv)
+                               break;
+
+                       dl->st->ss->getinfo_super(dl->st, &info);
+                       /* match based on subarray number, name or uuid */
+                       if ((ident->member_index != -1 && i == ident->member_index) ||
+                           (ident->name[0] && !strncmp(info.name, ident->name, sizeof(info.name))) ||
+                           (ident->uuid_set && same_uuid(info.uuid, ident->uuid, dl->st->ss->swapuuid))) {
+                               if (dl->st->loaded_container) {
+                                       struct map_ent *map;
+                                       int devname;
+                                       map_read(&map);
+                                       if (!find_array_minor(info.text_version, map, &devname)) {
+                                               fprintf(stderr, Name ": Attempting to modify properties of array, which is active.\n    Stop array and try again\n");
+                                               map_free(map);
+                                               return -1;
+                                       }
+                                       map_free(map);
+                               }
+                               rv = dl->st->ss->delete_subarray(dl->st, dl->fd);
+                               found = 1;
+                               break;
+                       }
+               }
+
+               if (!found) {
+                       if (!quiet)
+                               fprintf(stderr, Name ": Could not find array with given identifier\n");
+                       rv = 1;
+               }
+
+               if (!quiet && rv && found)
+                       fprintf(stderr, Name ": Failed to delete\n");
+
+               dl = dl->next;
+       }
+       free_array_dev_list(dl);
+
+       return rv;
+}
+
diff --git a/Makefile b/Makefile
index 1035ea8..1eb3e4b 100644
--- a/Makefile
+++ b/Makefile
@@ -96,12 +96,12 @@ SRCS =  mdadm.c config.c mdstat.c  ReadMe.c util.c Manage.c Assemble.c Build.c \

 MON_OBJS = mdmon.o monitor.o managemon.o util.o mdstat.o sysfs.o config.o \
        Kill.o sg_io.o dlink.o ReadMe.o super0.o super1.o super-intel.o \
-       super-ddf.o sha1.o crc32.o msg.o bitmap.o \
+       super-ddf.o sha1.o crc32.o msg.o bitmap.o mdopen.o mapfile.o \
        platform-intel.o probe_roms.o

 MON_SRCS = mdmon.c monitor.c managemon.c util.c mdstat.c sysfs.c config.c \
        Kill.c sg_io.c dlink.c ReadMe.c super0.c super1.c super-intel.c \
-       super-ddf.c sha1.c crc32.c msg.c bitmap.c \
+       super-ddf.c sha1.c crc32.c msg.c bitmap.c mdopen.c mapfile.c \
        platform-intel.c probe_roms.c

 STATICSRC = pwgr.c
diff --git a/ReadMe.c b/ReadMe.c
index 9d5a211..b27b002 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -104,6 +104,7 @@ struct option long_options[] = {
     {"grow",      0, 0, 'G'},
     {"incremental",0,0, 'I'},
     {"zero-superblock", 0, 0, 'K'}, /* deliberately no a short_option */
+    {"zero-subarray", 2, 0, 'L'}, /* also deliberately no a short_option */
     {"query",    0, 0, 'Q'},
     {"examine-bitmap", 0, 0, 'X'},
     {"auto-detect", 0, 0, AutoDetect},
diff --git a/mapfile.c b/mapfile.c
index 366ebe3..fe885c5 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -197,18 +197,15 @@ void map_free(struct map_ent *map)
        }
 }

-int map_update(struct map_ent **mpp, int devnum, char *metadata,
-              int *uuid, char *path)
+void map_do_update(struct map_ent **mpp, int devnum, char *metadata,
+                 int *uuid, char *path)
 {
-       struct map_ent *map, *mp;
-       int rv;
+       struct map_ent *mp;

-       if (mpp && *mpp)
-               map = *mpp;
-       else
-               map_read(&map);
+       if (!mpp)
+               return;

-       for (mp = map ; mp ; mp=mp->next)
+       for (mp = *mpp ; mp ; mp=mp->next)
                if (mp->devnum == devnum) {
                        strcpy(mp->metadata, metadata);
                        memcpy(mp->uuid, uuid, 16);
@@ -217,7 +214,21 @@ int map_update(struct map_ent **mpp, int devnum, char *metadata,
                        break;
                }
        if (!mp)
-               map_add(&map, devnum, metadata, uuid, path);
+               map_add(mpp, devnum, metadata, uuid, path);
+}
+
+int map_update(struct map_ent **mpp, int devnum, char *metadata,
+              int *uuid, char *path)
+{
+       struct map_ent *map;
+       int rv;
+
+       if (mpp && *mpp)
+               map = *mpp;
+       else
+               map_read(&map);
+
+       map_do_update(&map, devnum, metadata, uuid, path);
        if (mpp)
                *mpp = NULL;
        rv = map_write(map);
diff --git a/mdadm.c b/mdadm.c
index d5e34c0..65cc4b5 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -124,6 +124,7 @@ int main(int argc, char *argv[])
        ident.name[0] = 0;
        ident.container = NULL;
        ident.member = NULL;
+       ident.member_index = -1;

        while ((option_index = -1) ,
               (opt=getopt_long(argc, argv,
@@ -209,6 +210,8 @@ int main(int argc, char *argv[])
                case 'E':
                case 'X':
                case 'Q': newmode = MISC; break;
+               case 'L': if (optarg)
+                       ident.member_index = atoi(optarg);
                case 'R':
                case 'S':
                case 'o':
@@ -574,6 +577,7 @@ int main(int argc, char *argv[])
                        /* now for the Assemble options */
                case O(CREATE,'u'): /* uuid of array */
                case O(ASSEMBLE,'u'): /* uuid of array */
+               case O(MISC,'u'):
                        if (ident.uuid_set) {
                                fprintf(stderr, Name ": uuid cannot be set twice.  "
                                        "Second value %s.\n", optarg);
@@ -589,6 +593,7 @@ int main(int argc, char *argv[])

                case O(CREATE,'N'):
                case O(ASSEMBLE,'N'):
+               case O(MISC,'N'):
                        if (ident.name[0]) {
                                fprintf(stderr, Name ": name cannot be set twice.   "
                                        "Second value %s.\n", optarg);
@@ -620,6 +625,7 @@ int main(int argc, char *argv[])
                        continue;

                case O(ASSEMBLE,'U'): /* update the superblock */
+               case O(MISC,'U'): /* update the superblock */
                        if (update) {
                                fprintf(stderr, Name ": Can only update one aspect of superblock, both %s and %s given.\n",
                                        update, optarg);
@@ -799,6 +805,7 @@ int main(int argc, char *argv[])
                case O(MISC,'D'):
                case O(MISC,'E'):
                case O(MISC,'K'):
+               case O(MISC,'L'):
                case O(MISC,'R'):
                case O(MISC,'S'):
                case O(MISC,'X'):
@@ -907,6 +914,7 @@ int main(int argc, char *argv[])
                case O(INCREMENTAL, 'r'):
                        rebuild_map = 1;
                        continue;
+
                }
                /* We have now processed all the valid options. Anything else is
                 * an error
@@ -1293,6 +1301,12 @@ int main(int argc, char *argv[])
                                     SparcAdjust, ss, homehost);
                } else if (devmode == DetailPlatform) {
                        rv = Detail_Platform(ss ? ss->ss : NULL, ss ? scan : 1, verbose);
+               } else if (devmode == 'L') {
+                       if (!ident.uuid_set && !ident.name[0] && ident.member_index == -1) {
+                               fprintf(stderr, Name ": Name, Uuid or Member Index must be set for --zero-subarray.\n");
+                               exit(2);
+                       }
+                       rv = Kill_Subarray(devlist, force, quiet, &ident);
                } else {
                        if (devlist == NULL) {
                                if ((devmode=='D' || devmode == Waitclean) && scan) {
diff --git a/mdadm.h b/mdadm.h
index 362b66b..f5e239c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -310,6 +310,7 @@ typedef struct mddev_ident_s {
                                 * of some other entry.
                                 */
        char    *member;        /* subarray within a container */
+       int     member_index;   /* subarray index within a container */

        struct mddev_ident_s *next;
        union {
@@ -350,6 +351,10 @@ struct mdstat_ent {
        int             raid_disks;
        int             chunk_size;
        char *          metadata_version;
+       struct dev_member {
+               char *name;
+               struct dev_member *next;
+       } *members;
        struct mdstat_ent *next;
 };

@@ -358,6 +363,7 @@ extern void free_mdstat(struct mdstat_ent *ms);
 extern void mdstat_wait(int seconds);
 extern void mdstat_wait_fd(int fd, const sigset_t *sigmask);
 extern int mddev_busy(int devnum);
+extern int mdstat_check_active(char *devname);

 struct map_ent {
        struct map_ent *next;
@@ -367,6 +373,8 @@ struct map_ent {
        int     bad;
        char    *path;
 };
+extern void map_do_update(struct map_ent **map, int devnum, char *metadata,
+                         int uuid[4], char *path);
 extern int map_update(struct map_ent **mpp, int devnum, char *metadata,
                      int uuid[4], char *path);
 extern struct map_ent *map_by_uuid(struct map_ent **map, int uuid[4]);
@@ -412,6 +420,7 @@ extern int sysfs_attr_match(const char *attr, const char *str);
 extern int sysfs_match_word(const char *word, char **list);
 extern int sysfs_set_str(struct mdinfo *sra, struct mdinfo *dev,
                         char *name, char *val);
+extern int sysfs_set_str_simple(char *fname, char *val);
 extern int sysfs_set_num(struct mdinfo *sra, struct mdinfo *dev,
                         char *name, unsigned long long val);
 extern int sysfs_uevent(struct mdinfo *sra, char *event);
@@ -586,6 +595,7 @@ extern struct superswitch {
        void (*locate_bitmap)(struct supertype *st, int fd);
        int (*write_bitmap)(struct supertype *st, int fd);
        void (*free_super)(struct supertype *st);
+       int (*delete_subarray)(struct supertype *st, int fd);

        /* validate_geometry is called with an st returned by
         * match_metadata_desc.
@@ -713,6 +723,20 @@ extern void get_one_disk(int mdfd, mdu_array_info_t *ainf,
                         mdu_disk_info_t *disk);
 void wait_for(char *dev, int fd);

+/*
+ * Array dynamic list holds the most important data to remember
+ * during the validation of the devices passed to some metadata
+ * manipulation functions (eg. kill subarray).
+ */
+struct array_dev_list {
+       int major;
+       int minor;
+       int found; /* mark here if disk is found in command line */
+       int fd; /* file descriptor of opened device*/
+       struct supertype *st; /* supertype record obtained from this device */
+       struct array_dev_list *next; /* next item */
+};
+
 #if __GNUC__ < 3
 struct stat64;
 #endif
@@ -801,6 +825,7 @@ extern int Monitor(mddev_dev_t devlist,
                   int dosyslog, int test, char *pidfile, int increments);

 extern int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl);
+extern int Kill_Subarray(mddev_dev_t devlist, int force, int quiet, struct mddev_ident_s *ident);
 extern int Wait(char *dev);
 extern int WaitClean(char *dev, int sock, int verbose);

@@ -918,6 +943,15 @@ extern char *devnum2devname(int num);
 extern int devname2devnum(char *name);
 extern int stat2devnum(struct stat *st);
 extern int fd2devnum(int fd);
+char *dev2devname(int maj, int min, char *buf);
+
+extern int find_array_minor(char *text_version, struct map_ent *map, int *minor);
+extern int validate_super(struct supertype *st, char *name, int quiet, char *meta_type);
+extern struct array_dev_list *get_devs_from_container(char *name, struct supertype **st);
+extern struct array_dev_list *array_dev_list_add(struct array_dev_list **dl, int maj, int min, struct supertype *st);
+extern void free_array_dev_list(struct array_dev_list *dl);
+extern struct array_dev_list *check_find_devices(mddev_dev_t devlist, int force, int quiet, struct mddev_ident_s *ident, char *meta_type, int *index, int *mon_managed);
+extern struct array_dev_list *check_devices(mddev_dev_t devlist, int force, int quiet, char *meta_type);

 static inline int dev2major(int d)
 {
diff --git a/mdstat.c b/mdstat.c
index 4a9f370..bb6179d 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -83,6 +83,45 @@
 #include       <sys/select.h>
 #include       <ctype.h>

+static void free_member_devnames(struct dev_member **m)
+{
+       struct dev_member *t;
+       if (!*m)
+               return;
+       while(*m) {
+               t = *m;
+               *m = (*m)->next;
+               if (t->name)
+                       free(t->name);
+               free(t);
+       }
+       *m = NULL;
+}
+
+static struct dev_member *add_member_devname(struct dev_member **m, char *name)
+{
+       struct dev_member *new;
+       char *t;
+
+       if (!m || !name)
+               return NULL;
+
+       new = malloc(sizeof(*new));
+       if (!new)
+               return NULL;
+       if ((t = strchr(name, '[')) == NULL)
+       {
+               /* not a device */
+               free(new);
+               return *m;
+       }
+       new->name = strndup(name, t - name);
+       new->next = *m;
+       *m = new;
+
+       return new;
+}
+
 void free_mdstat(struct mdstat_ent *ms)
 {
        while (ms) {
@@ -91,6 +130,7 @@ void free_mdstat(struct mdstat_ent *ms)
                if (ms->level) free(ms->level);
                if (ms->pattern) free(ms->pattern);
                if (ms->metadata_version) free(ms->metadata_version);
+               if (ms->members) free_member_devnames(&ms->members);
                t = ms;
                ms = ms->next;
                free(t);
@@ -159,6 +199,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
                ent->raid_disks = 0;
                ent->chunk_size = 0;
                ent->devcnt = 0;
+               ent->members = NULL;

                ent->dev = strdup(line);
                ent->devnum = devnum;
@@ -170,15 +211,21 @@ struct mdstat_ent *mdstat_read(int hold, int start)
                                ent->active = 1;
                        else if (strcmp(w, "inactive")==0)
                                ent->active = 0;
-                       else if (ent->active >=0 &&
+                       else if (ent->active > 0 &&
                                 ent->level == NULL &&
                                 w[0] != '(' /*readonly*/) {
                                ent->level = strdup(w);
                                in_devs = 1;
                        } else if (in_devs && strcmp(w, "blocks")==0)
                                in_devs = 0;
-                       else if (in_devs) {
+                       else if (in_devs || (ent->active == 0 && w[0] != '(' &&
+                                w[l - 1] == ')')) {
+                               if (isdigit(w[0]))
+                                       continue;
+                               in_devs = 1;
                                ent->devcnt++;
+                               if (!add_member_devname(&ent->members, w))
+                                       free_member_devnames(&ent->members);
                                if (strncmp(w, "md", 2)==0) {
                                        /* This has an md device as a component.
                                         * If that device is already in the
@@ -310,3 +357,38 @@ int mddev_busy(int devnum)
        free_mdstat(mdstat);
        return me != NULL;
 }
+
+/*
+ * Finds name of the active array holding this device
+ * @param[in]  devname         name of member device
+ * @param[out] devname         name of array
+ *
+ * @return                     found (0), or
+ *                             not found, failure (1)
+ */
+
+int mdstat_check_active(char *devname)
+{
+       struct mdstat_ent *mdstat = mdstat_read(0, 0);
+       struct mdstat_ent *ent;
+       char *name;
+
+       if (!devname)
+               return 1;
+       name = strrchr(devname, '/');
+       if (name++ == NULL)
+               return 1;
+
+       for (ent = mdstat; ent; ent = ent->next) {
+               struct dev_member *m;
+               if (ent->active) /* only containers */
+                       continue;
+               for (m = ent->members; m; m = m->next) {
+                       if (!strcmp(m->name, name)) {
+                               strcpy(devname, ent->dev);
+                               return 0;
+                       }
+               }
+       }
+       return 1;
+}
diff --git a/super-intel.c b/super-intel.c
index a196ca3..1b54df8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -283,6 +283,7 @@ enum imsm_update_type {
        update_activate_spare,
        update_create_array,
        update_add_disk,
+       update_kill_subarray,
 };

 struct imsm_update_activate_spare {
@@ -1421,10 +1422,14 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 {
        struct intel_super *super = st->sb;
        struct imsm_dev *dev = get_imsm_dev(super, super->current_vol);
-       struct imsm_map *map = get_imsm_map(dev, 0);
+       struct imsm_map *map;
        struct dl *dl;
        char *devname;

+       if (!dev)
+               return;
+       map = get_imsm_map(dev, 0);
+
        for (dl = super->disks; dl; dl = dl->next)
                if (dl->raiddisk == info->disk.raid_disk)
                        break;
@@ -3450,6 +3455,143 @@ static int write_init_super_imsm(struct supertype *st)
 }
 #endif

+struct imsm_vol_modify_data
+{
+       enum imsm_update_type type;
+       int index;
+};
+
+int delete_subarray_imsm(struct supertype *st, int fd)
+{
+       struct intel_super *super = st->sb;
+       struct imsm_super *mpb = super ? super->anchor : NULL;
+       int container_index;
+       int rv = 0;
+
+       if (!mpb)
+               return 1;
+
+       container_index = super->current_vol;
+
+       if (!st->arrays && mdmon_running(st->container_dev)) {
+               /* delegate mdmon to do this job */
+               struct imsm_vol_modify_data *u;
+
+               u = malloc(sizeof(*u));
+               if (!u)
+                       return 3;
+
+               u->type = update_kill_subarray;
+               u->index = container_index;
+
+               st->update_tail = &st->updates;
+               append_metadata_update(st, u, sizeof(*u));
+
+               flush_metadata_updates(st);
+
+               return 0;
+       }
+
+       /* First case: 2 volumes */
+       if (mpb->num_raid_devs > 1) {
+               struct map_ent *map;
+               struct intel_dev *dp;
+               struct intel_dev *d = super->devlist->next;
+
+               if (super->devlist->index == container_index) {
+                       struct intel_dev *t = super->devlist;
+                       super->devlist = super->devlist->next;
+                       free(t->dev);
+                       free(t);
+               } else
+                       super->devlist->index--;
+
+               dp = super->devlist;
+               while(d) {
+                       if (d->index == container_index) {
+                               struct intel_dev *t = d;
+                               dp->next = d->next;
+                               d = d->next;
+                               free(t->dev);
+                               free(t);
+                       } else {
+                               if (d->index > container_index)
+                                       d->index--;
+                               dp = d;
+                               d = d->next;
+                       }
+               }
+
+               mpb->num_raid_devs--;
+               if (!st->loaded_container)
+                       super->disks->fd = fd;
+               rv = write_super_imsm(super, 0);
+
+               /* if necessary re-index all container members */
+               if (st->loaded_container && container_index < mpb->num_raid_devs) {
+                       struct map_ent *m;
+                       map_read(&map);
+                       map_lock(&map);
+                       for (m = map; m; m = m->next) {
+                               char *ind = strrchr(m->metadata, '/');
+                               if (ind++) { /* array */
+                                       int index = atoi(ind);
+                                       if (index > container_index) { /* change needed */
+                                               char path[PATH_MAX];
+                                               char buf[1024];
+                                               struct mdinfo info_new;
+                                               *ind = '0' + --index;
+                                               /* sysfs */
+                                               snprintf(path, sizeof(path), "/sys/block/md%d/md/metadata_version", m->devnum);
+                                               snprintf(buf, sizeof(buf), "external:%s", m->metadata);
+                                               if (sysfs_set_str_simple(path, buf)) {
+                                                       rv = 1;
+                                                       break;
+                                               }
+                                               /* map */
+                                               strcpy(path, m->path);
+                                               super->current_vol = index;
+                                               getinfo_super_imsm_volume(st, &info_new);
+                                               map_do_update(&map, m->devnum,
+                                                             info_new.text_version,
+                                                             info_new.uuid, path);
+                                       }
+                               }
+                       }
+                       map_write(map);
+                       map_unlock(&map);
+                       map_free(map);
+               }
+
+                if (!rv && st->arrays) {
+                        if (st->arrays->info.container_member == container_index) {
+                                struct active_array *t = st->arrays;
+                                st->arrays = st->arrays->next;
+                                free(t);
+                        } else {
+                               struct active_array *ap = st->arrays;
+                               struct active_array *a = st->arrays->next;
+                               while(a) {
+                                       if (a->info.container_member == container_index) {
+                                               struct active_array *t = a;
+                                               ap->next = a->next;
+                                               a = a->next;
+                                               free(t);
+                                       } else {
+                                               ap = a;
+                                               a = a->next;
+                                       }
+                               }
+                        }
+                }
+       } else { /* second case: 1 volume */
+               struct dl *d;
+               for (d = super->disks; d; d = d->next)
+                       rv |= Kill(d->devname, NULL, 0, 1, 1);
+       }
+       return rv;
+}
+
 static int store_super_imsm(struct supertype *st, int fd)
 {
        struct intel_super *super = st->sb;
@@ -5078,6 +5220,13 @@ static void imsm_process_update(struct supertype *st,
                }

                break;
+       case update_kill_subarray: {
+               struct imsm_vol_modify_data *u = (void *)update->buf;
+
+               super->current_vol = u->index;
+               st->ss->delete_subarray(st, -1);
+               break;
+       }
        }
 }

@@ -5226,6 +5375,7 @@ struct superswitch super_imsm = {
        .detail_super   = detail_super_imsm,
        .brief_detail_super = brief_detail_super_imsm,
        .write_init_super = write_init_super_imsm,
+       .delete_subarray = delete_subarray_imsm,
        .validate_geometry = validate_geometry_imsm,
        .add_to_super   = add_to_super_imsm,
        .detail_platform = detail_platform_imsm,
diff --git a/sysfs.c b/sysfs.c
index ebf9d8a..a2353d9 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -413,6 +413,27 @@ int sysfs_set_str(struct mdinfo *sra, struct mdinfo *dev,
        return 0;
 }

+int sysfs_set_str_simple(char *fname, char *val)
+{
+       int n;
+       int fd;
+
+       if (!fname || !val)
+               return 1;
+
+       fd = open(fname, O_WRONLY | O_NONBLOCK);
+       if (fd < 0)
+               return -1;
+       n = write(fd, val, strlen(val));
+       close(fd);
+       if (n != strlen(val)) {
+               dprintf(Name ": failed to write '%s' to '%s' (%s)\n",
+                       val, fname, strerror(errno));
+               return -1;
+       }
+       return 0;
+}
+
 int sysfs_set_num(struct mdinfo *sra, struct mdinfo *dev,
                  char *name, unsigned long long val)
 {
diff --git a/util.c b/util.c
index d292a66..f1d30f3 100644
--- a/util.c
+++ b/util.c
@@ -1494,6 +1494,27 @@ int fd2devnum(int fd)
        return NoMdDev;
 }

+char *dev2devname(int maj, int min, char *buf)
+{
+       char path[37];
+       char link[200];
+       char *cp;
+       int n;
+
+       sprintf(path, "/sys/dev/block/%d:%d", maj,
+               min);
+       n = readlink(path, link, sizeof(link)-1);
+       if (n <= 0)
+               return NULL;
+       link[n] = 0;
+       cp = strrchr(link, '/');
+       if (cp) {
+               strcpy(buf, cp + 1);
+               return buf;
+       }
+       return NULL;
+}
+
 char *pid_dir = VAR_RUN;

 int mdmon_pid(int devnum)
@@ -1502,7 +1523,11 @@ int mdmon_pid(int devnum)
        char pid[10];
        int fd;
        int n;
-       sprintf(path, "%s/%s.pid", pid_dir, devnum2devname(devnum));
+       char *devname = devnum2devname(devnum);
+
+       sprintf(path, "%s/%s.pid", pid_dir, devname);
+       free(devname);
+
        fd = open(path, O_RDONLY | O_NOATIME, 0);

        if (fd < 0)
@@ -1645,3 +1670,269 @@ void append_metadata_update(struct supertype *st, void *buf, int len)
 unsigned int __invalid_size_argument_for_IOC = 0;
 #endif

+/* Function finds device minor of the device located in map file */
+int find_array_minor(char *text_version, struct map_ent *map, int *minor)
+{
+       if (!text_version || !minor)
+               return -1;
+
+       while (map)
+       {
+               if (!strcmp(map->metadata, text_version)) {
+                       *minor = map->devnum;
+                       return 0;
+               }
+               map = map->next;
+       }
+       return -1;
+}
+
+int validate_super(struct supertype *st, char *name, int quiet, char *meta_type)
+{
+       if (st == NULL) {
+               if (!quiet && name)
+                       fprintf(stderr, Name ": Unrecognised md component device - %s\n", name);
+               return 1;
+       }
+
+       if (meta_type && strcmp(st->ss->name, meta_type)) {
+               if (!quiet)
+                       fprintf(stderr, Name ": Subarray delete not supported for '%s' superblock\n",
+                               st->ss->name);
+               return 1;
+       }
+
+       return 0;
+}
+
+void free_array_dev_list(struct array_dev_list *dl)
+{
+       struct array_dev_list *t;
+       while(dl) {
+               t = dl;
+               dl = dl->next;
+               if (t->st)
+                       t->st->ss->free_super(t->st);
+               free(t->st);
+               if (t->fd != -1)
+                       close(t->fd);
+               free(t);
+       }
+}
+
+struct array_dev_list *array_dev_list_add(struct array_dev_list **dl, int maj, int min, struct supertype *st)
+{
+       struct array_dev_list *temp;
+
+       if (!dl)
+               return NULL;
+
+       temp = malloc(sizeof(*temp));
+       if (!temp) {
+               free_array_dev_list(*dl);
+               return NULL;
+       }
+       temp->next = *dl;
+       temp->major = maj;
+       temp->minor = min;
+       temp->found = 0;
+       temp->fd = -1;
+       temp->st = st;
+
+       *dl = temp;
+       return *dl;
+}
+
+struct array_dev_list *get_devs_from_container(char *name, struct supertype **st)
+{
+       int fd;
+       struct array_dev_list *dl = NULL;
+       struct mdinfo *mdi, *devs;
+
+       if (!st || !name)
+               return NULL;
+
+       if ((fd = open_mddev(name, 0)) == -1)
+               return NULL;
+
+       (*st) = guess_super(fd);
+
+       if (validate_super(*st, name, 0, NULL)) {
+               close(fd);
+               *st = NULL;
+               return NULL;
+       }
+
+       if ((*st)->ss->load_super(*st, fd, name)) {
+               *st = NULL;
+               close(fd);
+               return NULL;
+       }
+
+       mdi = sysfs_read(fd, 0, GET_DEVS);
+       if (!mdi) {
+               close(fd);
+               return NULL;
+       }
+
+       for (devs = mdi->devs; devs; devs = devs->next) {
+               if (devs->disk.state & (1 << MD_DISK_FAULTY))
+                       continue;
+               if (!array_dev_list_add(&dl, devs->disk.major, devs->disk.minor, NULL)) {
+                       close(fd);
+                       (*st)->ss->free_super(*st);
+                       *st = NULL;
+                       sysfs_free(mdi);
+                       return NULL;
+               }
+       }
+       close(fd);
+       sysfs_free(mdi);
+       return dl;
+}
+
+struct array_dev_list *check_devices(mddev_dev_t devlist, int force, int quiet, char *meta_type)
+{
+       int     fd;
+       struct supertype *st, *cst = NULL, *ref = NULL;
+       char    path[256];
+       char    container_devname[255];
+       mddev_dev_t dv;
+       int     active_container = 0;
+       struct array_dev_list *dl = NULL, *d;
+
+       if (!devlist)
+               return NULL;
+
+       container_devname[0] = '\0';
+
+       for (dv = devlist; dv; dv = dv->next) {
+               fd = open(dv->devname, O_RDWR|(force ? O_NONBLOCK : 0));
+               if (fd < 0) {
+                       if (!quiet)
+                               fprintf(stderr, Name ": Couldn't open %s for read/write\n",
+                                       dv->devname);
+                       free_array_dev_list(dl);
+                       close(fd);
+                       return NULL;
+               }
+               st = guess_super(fd);
+
+               if (validate_super(st, dv->devname, quiet, "imsm")) {
+                       free_array_dev_list(dl);
+                       close(fd);
+                       return NULL;
+               }
+
+               if (st->ss->load_super(st, fd, dv->devname)) {
+                       if (!quiet)
+                               fprintf(stderr, Name ": Could not load superblock on %s\n", dv->devname);
+                       free_array_dev_list(dl);
+                       close(fd);
+                       return NULL;
+               }
+               /* this device is a container */
+               if (st->loaded_container) { /* check if other devices passed */
+                       if (ref || dv->next) {
+                               fprintf(stderr, Name ": Container device should be the only one provided\n");
+                               free_array_dev_list(dl);
+                               close(fd);
+                               return NULL;
+                       }
+                       active_container = 1;
+                       strncpy(container_devname, dv->devname, sizeof(container_devname));
+                       cst = st;
+                       break;
+               } else {
+                       /* so find active container comprises this device */
+                       strcpy(path, dv->devname);
+
+                       if (!mdstat_check_active(path)) {
+                               active_container = 1;
+                               if (container_devname[0]) {
+                                       char *tmp = strrchr(container_devname, '/');
+                                       if (!tmp++) {
+                                               fprintf(stderr, Name ": Container device path is invalid\n");
+                                               free_array_dev_list(dl);
+                                               close(fd);
+                                               return NULL;
+                                       }
+                                       if (strcmp(tmp, path)) {
+                                               fprintf(stderr, Name ": Given devices does not belong to the same container\n");
+                                               free_array_dev_list(dl);
+                                               close(fd);
+                                               return NULL;
+                                       }
+                               }
+                               else
+                                       snprintf(container_devname, sizeof(container_devname), "/dev/%s", path);
+                               if (!dl)
+                                       dl = get_devs_from_container(container_devname, &cst);
+
+                               /* and get valid container disk members */
+                               for (d = dl; d; d = d->next) {
+                                       struct stat stat;
+                                       if (fstat(fd, &stat) == -1) {
+                                               close(fd);
+                                               free_array_dev_list(dl);
+                                               return NULL;
+                                       }
+                                       if (d->major == MAJOR(stat.st_rdev) && d->minor == MINOR(stat.st_rdev)) {
+                                               d->found = 1;
+                                               d->st = st;
+                                               d->fd = fd;
+                                               break;
+                                       }
+                               }
+                       } else {
+                               struct mdinfo i;
+                               st->ss->getinfo_super(st, &i);
+                               array_dev_list_add(&dl, i.disk.major, i.disk.minor, st);
+                               dl->fd = fd;
+                               continue;
+                       }
+                       close(fd);
+               }
+
+               if (!ref) {
+                       ref = st;
+                       close(fd);
+                       continue;
+               }
+               if (st->ss->compare_super(st, ref)) {
+                       free_array_dev_list(dl);
+                       close(fd);
+                       fprintf(stderr, Name ": Given devices does not belong to the same array\n");
+                       return NULL;
+               }
+       }
+
+       if (active_container) {
+               for (d = dl; d; d = d->next) {
+                       if (!d->found)
+                               break;
+               }
+               if (d) {
+                       free_array_dev_list(dl);
+                       fprintf(stderr, Name ": Array containing given devices is active. Please provide full set of drives\n");
+                       return NULL;
+               }
+       }
+
+       /* For case of active container, use container's supertype data
+        */
+       if (cst)
+       {
+               free_array_dev_list(dl);
+               dl = NULL;
+               array_dev_list_add(&dl, -1, -1, cst);
+               if ((dl->fd = open_mddev(container_devname, 0)) == -1) {
+                       free_array_dev_list(dl);
+                       fprintf(stderr, Name ": Could not reopen container device\n");
+                       return NULL;
+               }
+       }
+
+       return dl;
+}
+
--
1.6.4.2

