From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [mdadm PATCH 2/11] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:45:55 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65C6@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From a5fc015d5cdbe58c448ff52d3c244e6a77b1d46e Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:05:26 +0100
Subject: [PATCH] OLCE: Before OLCE code cleanup and add checks

Changes to be committed:
        modified:   Assemble.c
        modified:   Create.c
        modified:   Detail.c
        modified:   Grow.c
        modified:   Incremental.c
        modified:   Manage.c
        modified:   Monitor.c
        modified:   config.c
        modified:   dlink.c
        modified:   managemon.c
        modified:   mapfile.c
        modified:   mdmon.c
        modified:   mdopen.c
        modified:   mdstat.c
        modified:   monitor.c
        modified:   msg.c
        modified:   platform-intel.c
        modified:   restripe.c
        modified:   super-intel.c
        modified:   sysfs.c
        modified:   util.c

This patch combines changes that are not directly
related to OLCE and can be categorized as improvement.
Summary:
 - Add checks on functions entry
 - set released pointers to NULL
 - Fixed some memory leaks
 - Fixed some issues found by Klocwork

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 Assemble.c       |   14 ++-
 Create.c         |   10 +-
 Detail.c         |   11 +-
 Grow.c           |   46 ++++++-
 Incremental.c    |   28 +++-
 Manage.c         |   76 +++++++-----
 Monitor.c        |   23 +++-
 config.c         |   49 +++++---
 dlink.c          |   17 ++-
 managemon.c      |  131 ++++++++++++--------
 mapfile.c        |   23 +++-
 mdmon.c          |    7 +-
 mdopen.c         |    4 +-
 mdstat.c         |   24 +++-
 monitor.c        |    4 +
 msg.c            |   10 ++-
 platform-intel.c |    9 +-
 restripe.c       |   12 ++-
 super-intel.c    |  372 +++++++++++++++++++++++++++++++++++++-----------------
 sysfs.c          |   60 ++++++----
 util.c           |  155 ++++++++++++++---------
 21 files changed, 729 insertions(+), 356 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 014d644..d4398b6 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -144,7 +144,7 @@ int Assemble(struct supertype *st, char *mddev,
                               * recent as everything else in the array.
                               */
                struct mdinfo i;
-       } *devices;
+       } *devices = NULL;
        int *best = NULL; /* indexed by raid_disk */
        unsigned int bestcnt = 0;
        int devcnt = 0;
@@ -547,7 +547,8 @@ int Assemble(struct supertype *st, char *mddev,
                            chosen_name);
        if (mdfd < 0) {
                st->ss->free_super(st);
-               free(devices);
+               if (devices) free(devices);
+               devices = NULL;
                if (auto_assem)
                        goto try_again;
                return 1;
@@ -573,7 +574,8 @@ int Assemble(struct supertype *st, char *mddev,
                close(mdfd);
                mdfd = -3;
                st->ss->free_super(st);
-               free(devices);
+               if (devices) free(devices);
+               devices = NULL;
                if (auto_assem)
                        goto try_again;
                return 1;
@@ -1282,9 +1284,11 @@ int assemble_container_content(struct supertype *st, int mdfd,
                        close(mdfd);
                        return 1;
                }
-       if (sra)
+       if (sra) {
                sysfs_free(sra);
-
+               sra = NULL;
+       }
+
        for (dev = content->devs; dev; dev = dev->next)
                if (sysfs_add_disk(content, dev, 1) == 0)
                        working++;
diff --git a/Create.c b/Create.c
index 7714828..2fde319 100644
--- a/Create.c
+++ b/Create.c
@@ -109,7 +109,7 @@ int Create(struct supertype *st, char *mddev,
        int container_fd = -1;
        int need_mdmon = 0;
        unsigned long long bitmapsize;
-       struct mdinfo info, *infos;
+       struct mdinfo info, *infos = NULL;
        int did_default = 0;
        int do_default_layout = 0;
        unsigned long safe_mode_delay = 0;
@@ -434,7 +434,7 @@ int Create(struct supertype *st, char *mddev,
                warn = 1;
        }

-       if (st->ss->detail_platform && st->ss->detail_platform(0, 1) != 0) {
+       if (st && st->ss->detail_platform && st->ss->detail_platform(0, 1) != 0) {
                if (runstop != 1 || verbose >= 0)
                        fprintf(stderr, Name ": %s unable to enumerate platform support\n"
                                "    array may not be compatible with hardware/firmware\n",
@@ -628,7 +628,7 @@ int Create(struct supertype *st, char *mddev,
                        fprintf(stderr, Name ": Creating array inside "
                                "%s container %s\n",
                                mdi?mdi->text_version:"managed", path);
-                       sysfs_free(mdi);
+                       if (mdi) sysfs_free(mdi);
                } else
                        fprintf(stderr, Name ": Defaulting to version"
                                " %s metadata\n", info.text_version);
@@ -850,14 +850,14 @@ int Create(struct supertype *st, char *mddev,
                                map_update(&map, st->container_dev,
                                           info_new.text_version,
                                           info_new.uuid, path);
-                               free(path);
+                               if (path) free(path);
                        }
                        map_unlock(&map);

                        flush_metadata_updates(st);
                }
        }
-       free(infos);
+       if (infos) free(infos);
        st->ss->free_super(st);

        if (level == LEVEL_CONTAINER) {
diff --git a/Detail.c b/Detail.c
index ba07c83..7f6460c 100644
--- a/Detail.c
+++ b/Detail.c
@@ -37,7 +37,7 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
        int fd = open(dev, O_RDONLY);
        int vers;
        mdu_array_info_t array;
-       mdu_disk_info_t *disks;
+       mdu_disk_info_t *disks = NULL;
        int next;
        int d;
        time_t atime;
@@ -51,7 +51,7 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
        struct supertype *st = NULL;
        int max_disks = MD_SB_DISKS; /* just a default */
        struct mdinfo info;
-       struct mdinfo *sra;
+       struct mdinfo *sra = NULL;
        char *member = NULL;
        char *container = NULL;

@@ -413,7 +413,7 @@ This is pretty boring
                        printf("  Member Arrays :");

                        while (dir && (de = readdir(dir)) != NULL) {
-                               char path[200];
+                               char path[512];
                                char vbuf[1024];
                                int nlen = strlen(sra->sys_name);
                                int dn;
@@ -550,7 +550,10 @@ This is pretty boring
                    1, avail, avail_disks))
                rv = 2;

-       free(disks);
+       if (disks) {
+               free(disks);
+               disks = NULL;
+       }
 out:
        close(fd);
        return rv;
diff --git a/Grow.c b/Grow.c
index aa6c3b3..9db851b 100644
--- a/Grow.c
+++ b/Grow.c
@@ -541,7 +541,10 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                return 1;
        }
        sra = sysfs_read(fd, 0, GET_VERSION | GET_LEVEL | GET_DEVS | GET_STATE);
-       frozen = freeze_array(sra);
+       if (sra)
+               frozen = freeze_array(sra);
+       else
+               frozen = -1;
        if (frozen < 0) {
                fprintf(stderr, Name ": %s is performing resync/recovery and cannot"
                        " be reshaped\n", devname);
@@ -778,6 +781,8 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                        }
                        err = sysfs_set_str(sra, NULL, "level", c);
                        if (err) {
+                               st->ss->free_super(st);
+                               st = NULL;
                                fprintf(stderr, Name ": %s: could not set level to %s\n",
                                        devname, c);
                                rv = 1;
@@ -807,6 +812,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                                        ping_monitor(devnum2devname(dn));
                                }
                        }
+
                }
        }

@@ -932,6 +938,11 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                 */
                st = super_by_fd(fd);

+               if (!st) {
+                       fprintf(stderr, Name ": cannot handle arrays with superblock version %d\n", array.major_version);
+                       return 1;
+               }
+
                /*
                 * There are three possibilities.
                 * 1/ The array will shrink.
@@ -1305,6 +1316,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                                        fprintf(stderr, Name ": %s: could not set level to %s\n",
                                                devname, c);
                        }
+                       sysfs_free(sra);
                        exit(0);
                case -1:
                        fprintf(stderr, Name ": Cannot run child to monitor reshape: %s\n",
@@ -1326,8 +1338,11 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                if (c && sysfs_set_str(sra, NULL, "level", c) == 0)
                        fprintf(stderr, Name ": aborting level change\n");
        }
-       if (sra)
+       if (sra) {
                unfreeze_array(sra, frozen);
+               sysfs_free(sra);
+       }
+
        return rv;
 }

@@ -1622,7 +1637,10 @@ static int child_grow(int afd, struct mdinfo *sra, unsigned long stripes,
                    dests, destfd, destoffsets,
                    0);
        sysfs_set_num(sra, NULL, "suspend_lo", (stripes * chunk/512) * data);
-       free(buf);
+       if (buf) {
+               free(buf);
+               buf = NULL;
+       }
        /* FIXME this should probably be numeric */
        sysfs_set_str(sra, NULL, "sync_max", "max");
        return 1;
@@ -1657,7 +1675,10 @@ static int child_shrink(int afd, struct mdinfo *sra, unsigned long stripes,
        wait_backup(sra, start, stripes*chunk/512, 0,
                    dests, destfd, destoffsets, 0);
        sysfs_set_num(sra, NULL, "suspend_lo", (stripes * chunk/512) * data);
-       free(buf);
+       if (buf) {
+               free(buf);
+               buf = NULL;
+       }
        /* FIXME this should probably be numeric */
        sysfs_set_str(sra, NULL, "sync_max", "max");
        return 1;
@@ -1728,7 +1749,10 @@ static int child_same_size(int afd, struct mdinfo *sra, unsigned long stripes,
                    1-part);
        sysfs_set_num(sra, NULL, "suspend_lo", (size*chunk/512) * data);
        sysfs_set_num(sra, NULL, "sync_speed_min", speed);
-       free(buf);
+       if (buf) {
+               free(buf);
+               buf = NULL;
+       }
        return 1;
 }

@@ -1889,6 +1913,11 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt

                /* Now need the data offsets for all devices. */
                offsets = malloc(sizeof(*offsets)*info->array.raid_disks);
+               if (offsets == NULL) {
+                       fprintf(stderr, Name ": Failed to get memory.\n");
+                       continue;
+               }
+
                for(j=0; j<info->array.raid_disks; j++) {
                        if (fdlist[j] < 0)
                                continue;
@@ -2071,7 +2100,6 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
                         GET_COMPONENT|GET_DEVS|GET_OFFSET|GET_STATE|
                         GET_CACHE);

-
        if (ndata == odata)
                while (blocks * 32 < sra->component_size &&
                       blocks < 16*1024*2)
@@ -2101,6 +2129,12 @@ int Grow_continue(int mdfd, struct supertype *st, struct mdinfo *info,
        backup_offsets[0] = 8 * 512;
        fds = malloc(odisks * sizeof(fds[0]));
        offsets = malloc(odisks * sizeof(offsets[0]));
+
+       if ((fds == NULL) || (offsets == NULL)) {
+               fprintf(stderr, Name ": malloc failed: grow aborted\n");
+               return 1;
+       }
+
        for (d=0; d<odisks; d++)
                fds[d] = -1;

diff --git a/Incremental.c b/Incremental.c
index 8c686f7..ded593e 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -84,10 +84,10 @@ int Incremental(char *devname, int verbose, int runstop,
        int rv;
        struct map_ent *mp, *map = NULL;
        int dfd, mdfd;
-       char *avail;
+       char *avail = NULL;
        int active_disks;
        int trustworthy = FOREIGN;
-       char *name_to_use;
+       char *name_to_use = NULL;;
        mdu_array_info_t ainf;

        struct createinfo *ci = conf_get_create_info();
@@ -334,6 +334,7 @@ int Incremental(char *devname, int verbose, int runstop,
                }
                info.array.working_disks = 1;
                sysfs_free(sra);
+               sra = NULL;
                /* 6/ Make sure /var/run/mdadm.map contains this array. */
                map_update(&map, fd2devnum(mdfd),
                           info.text_version,
@@ -441,7 +442,10 @@ int Incremental(char *devname, int verbose, int runstop,
                   info.array.layout, info.array.state & 1,
                   avail, active_disks) == 0 ||
            (runstop < 0 && active_disks < info.array.raid_disks)) {
-               free(avail);
+               if (avail) {
+                       free(avail);
+                       avail = NULL;
+               }
                if (verbose >= 0)
                        fprintf(stderr, Name
                             ": %s attached to %s, not enough to start (%d).\n",
@@ -450,7 +454,10 @@ int Incremental(char *devname, int verbose, int runstop,
                close(mdfd);
                return 0;
        }
-       free(avail);
+       if (avail) {
+               free(avail);
+               avail = NULL;
+       }

        /* 7b/ if yes, */
        /* - if number of OK devices match expected, or -R and there */
@@ -736,7 +743,7 @@ static char *container2devname(char *devname)
                mp = map_by_uuid(&map, uuid);
                if (mp)
                        mdname = devnum2devname(mp->devnum);
-               map_free(map);
+               if (map) map_free(map);
        }

        return mdname;
@@ -782,7 +789,7 @@ int Incremental_container(struct supertype *st, char *devname, int verbose,
                        } else
                                array_list = NULL;
                        for(; array_list ; array_list = array_list->next) {
-                               char *dn;
+                               char *dn = NULL;
                                if (array_list->member == NULL ||
                                    array_list->container == NULL)
                                        continue;
@@ -797,10 +804,17 @@ int Incremental_container(struct supertype *st, char *devname, int verbose,
                                if (strncmp(dn, ra->text_version+1,
                                            strlen(dn)) != 0 ||
                                    ra->text_version[strlen(dn)+1] != '/') {
+                                       if (dn) {
+                                               free(dn);
+                                               dn = NULL;
+                                       }
+                                       continue;
+                               }
+                               if (dn) {
                                        free(dn);
+                                       dn = NULL;
                                        continue;
                                }
-                               free(dn);
                                /* we have a match */
                                match = array_list;
                                if (verbose>0)
diff --git a/Manage.c b/Manage.c
index 749fa7c..0b991d0 100644
--- a/Manage.c
+++ b/Manage.c
@@ -85,7 +85,7 @@ int Manage_ro(char *devname, int fd, int readonly)
                        sysfs_set_str(mdi, NULL, "metadata_version", vers);

                        cp = strchr(vers+10, '/');
-                       if (*cp)
+                       if (cp && *cp)
                                *cp = 0;
                        ping_monitor(vers+10);
                }
@@ -123,12 +123,12 @@ static void remove_devices(int devnum, char *path)
         * partition suffixes - which link to those names.
         */
        char base[40];
-       char *path2;
+       char *path2 = NULL;
        char link[1024];
        int n;
        int part;
-       char *be;
-       char *pe;
+       char *be = NULL;
+       char *pe = NULL;

        if (devnum >= 0)
                sprintf(base, "/dev/md%d", devnum);
@@ -137,15 +137,17 @@ static void remove_devices(int devnum, char *path)
        be = base + strlen(base);
        if (path) {
                path2 = malloc(strlen(path)+20);
-               strcpy(path2, path);
-               pe = path2 + strlen(path2);
+               if (path2) {
+                       strcpy(path2, path);
+                       pe = path2 + strlen(path2);
+               }
        } else
                path2 = path = NULL;

        for (part = 0; part < 16; part++) {
                if (part) {
                        sprintf(be, "p%d", part);
-                       if (path) {
+                       if ((path) && (pe)) {
                                if (isdigit(pe[-1]))
                                        sprintf(pe, "p%d", part);
                                else
@@ -154,14 +156,15 @@ static void remove_devices(int devnum, char *path)
                }
                /* FIXME test if really is md device ?? */
                unlink(base);
-               if (path) {
+               if ((path) && (path2)) {
                        n = readlink(path2, link, sizeof(link));
                        if (n && strlen(base) == n &&
                            strncmp(link, base, n) == 0)
                                unlink(path2);
                }
        }
-       free(path2);
+       if (path2)
+               free(path2);
 }


@@ -356,7 +359,7 @@ int Manage_subdevs(char *devname, int fd,

        for (dv = devlist, j=0 ; dv; dv = next, j = jnext) {
                unsigned long long ldsize;
-               char dvname[20];
+               char dvname[30];
                char *dnprintable = dv->devname;
                int err;

@@ -637,29 +640,32 @@ int Manage_subdevs(char *devname, int fd,
                                 * to fill.
                                 */
                                char *used = malloc(array.raid_disks);
-                               memset(used, 0, array.raid_disks);
-                               for (j=0; j< tst->max_devs; j++) {
-                                       mdu_disk_info_t disc2;
-                                       disc2.number = j;
-                                       if (ioctl(fd, GET_DISK_INFO, &disc2))
-                                               continue;
-                                       if (disc2.major==0 && disc2.minor==0)
-                                               continue;
-                                       if (disc2.state & 8) /* removed */
-                                               continue;
-                                       if (disc2.raid_disk < 0)
-                                               continue;
-                                       if (disc2.raid_disk > array.raid_disks)
-                                               continue;
-                                       used[disc2.raid_disk] = 1;
-                               }
-                               for (j=0 ; j<array.raid_disks; j++)
-                                       if (!used[j]) {
-                                               disc.raid_disk = j;
-                                               disc.state |= (1<<MD_DISK_SYNC);
-                                               break;
+                               if (used) {
+                                       memset(used, 0, array.raid_disks);
+                                       for (j=0; j< tst->max_devs; j++) {
+                                               mdu_disk_info_t disc2;
+                                               disc2.number = j;
+                                               if (ioctl(fd, GET_DISK_INFO, &disc2))
+                                                       continue;
+                                               if (disc2.major==0 && disc2.minor==0)
+                                                       continue;
+                                               if (disc2.state & 8) /* removed */
+                                                       continue;
+                                               if (disc2.raid_disk < 0)
+                                                       continue;
+                                               if (disc2.raid_disk > array.raid_disks)
+                                                       continue;
+                                               used[disc2.raid_disk] = 1;
                                        }
-                               free(used);
+                                       for (j=0 ; j<array.raid_disks; j++)
+                                               if (!used[j]) {
+                                                       disc.raid_disk = j;
+                                                       disc.state |= (1<<MD_DISK_SYNC);
+                                                       break;
+                                               }
+                                       free(used);
+                                       used = NULL;
+                               }
                        }
                        if (dv->writemostly == 1)
                                disc.state |= (1 << MD_DISK_WRITEMOSTLY);
@@ -706,8 +712,10 @@ int Manage_subdevs(char *devname, int fd,
                                        close(container_fd);
                                        return 1;
                                }
+
                                ping_monitor(devnum2devname(devnum));
                                sysfs_free(sra);
+                               sra = NULL;
                                close(container_fd);
                        } else if (ioctl(fd, ADD_NEW_DISK, &disc)) {
                                fprintf(stderr, Name ": add new device failed for %s as %d: %s\n",
@@ -779,8 +787,10 @@ int Manage_subdevs(char *devname, int fd,
                                                            "state", "remove");
                                else
                                        err = -1;
-                               if (sra)
+                               if (sra) {
                                        sysfs_free(sra);
+                                       sra = NULL;
+                               }
                        }
                        if (err) {
                                fprintf(stderr, Name ": hot remove failed "
diff --git a/Monitor.c b/Monitor.c
index b0802f8..4d0fd8f 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -152,7 +152,7 @@ int Monitor(mddev_dev_t devlist,
        if (devlist == NULL) {
                mddev_ident_t mdlist = conf_get_ident(NULL);
                for (; mdlist; mdlist=mdlist->next) {
-                       struct state *st;
+                       struct state *st = NULL;
                        if (mdlist->devname == NULL)
                                continue;
                        if (strcasecmp(mdlist->devname, "<ignore>") == 0)
@@ -164,6 +164,7 @@ int Monitor(mddev_dev_t devlist,
                                st->devname = strdup(mdlist->devname);
                        else {
                                st->devname = malloc(8+strlen(mdlist->devname)+1);
+                               if (st->devname == NULL) continue;
                                strcpy(strcpy(st->devname, "/dev/md/"),
                                       mdlist->devname);
                        }
@@ -206,7 +207,7 @@ int Monitor(mddev_dev_t devlist,

        while (! finished) {
                int new_found = 0;
-               struct state *st;
+               struct state *st = NULL;

                if (mdstat)
                        free_mdstat(mdstat);
@@ -330,8 +331,10 @@ int Monitor(mddev_dev_t devlist,
                                        alert("RebuildFinished", dev, cnt, mailaddr, mailfrom, alert_cmd, dosyslog);
                                } else
                                        alert("RebuildFinished", dev, NULL, mailaddr, mailfrom, alert_cmd, dosyslog);
-                               if (sra)
+                               if (sra) {
                                        free(sra);
+                                       sra = NULL;
+                               }
                        }

                        if (mse)
@@ -428,8 +431,14 @@ int Monitor(mddev_dev_t devlist,
                                                /* no such array */
                                                if (fd >=0) close(fd);
                                                put_md_name(st->devname);
-                                               free(st->devname);
-                                               free(st);
+                                               if (st) {
+                                                       if (st->devname) {
+                                                               free(st->devname);
+                                                               st->devname = NULL;
+                                                       }
+                                                       free(st);
+                                                       st = NULL;
+                                               }
                                                continue;
                                        }
                                        close(fd);
@@ -455,7 +464,7 @@ int Monitor(mddev_dev_t devlist,
                        if (st->active < st->raid &&
                            st->spare == 0 &&
                            st->spare_group != NULL) {
-                               struct state *st2;
+                               struct state *st2 = NULL;
                                for (st2=statelist ; st2 ; st2=st2->next)
                                        if (st2 != st &&
                                            st2->spare > 0 &&
@@ -481,7 +490,7 @@ int Monitor(mddev_dev_t devlist,
                                                }
                                                if (dev > 0) {
                                                        struct mddev_dev_s devlist;
-                                                       char devname[20];
+                                                       char devname[30];
                                                        devlist.next = NULL;
                                                        devlist.used = 0;
                                                        devlist.re_add = 0;
diff --git a/config.c b/config.c
index 07a12dc..06e5d5f 100644
--- a/config.c
+++ b/config.c
@@ -120,7 +120,7 @@ char *conf_word(FILE *file, int allow_key)
        int c;
        int quote;
        int wordfound = 0;
-       char *word = malloc(wsize);
+       char *word = calloc(1,wsize);

        if (!word) abort();

@@ -215,12 +215,17 @@ char *conf_line(FILE *file)

 void free_line(char *line)
 {
+
        char *w;
-       for (w=dl_next(line); w != line; w=dl_next(line)) {
-               dl_del(w);
-               dl_free(w);
+
+       if (line) {
+               for (w=dl_next(line); (w != line) && (w); w=dl_next(line)) {
+                       dl_del(w);
+                       dl_free(w);
+               }
+               dl_free(line);
        }
-       dl_free(line);
+
 }


@@ -254,11 +259,13 @@ mddev_dev_t load_partitions(void)
                name = map_dev(major, minor, 1);
                if (!name)
                        continue;
-               d = malloc(sizeof(*d));
-               d->devname = strdup(name);
-               d->next = rv;
-               d->used = 0;
-               d->content = NULL;
+               d = calloc(1,sizeof(*d));
+               if (d) {
+                       d->devname = strdup(name);
+                       d->next = rv;
+                       d->used = 0;
+                       d->content = NULL;
+               }
                rv = d;
        }
        fclose(f);
@@ -279,11 +286,12 @@ mddev_dev_t load_containers(void)
                if (ent->metadata_version &&
                    strncmp(ent->metadata_version, "external:", 9) == 0 &&
                    !is_subarray(&ent->metadata_version[9])) {
-                       d = malloc(sizeof(*d));
+                       d = calloc( 1, sizeof(*d));
                        if (!d)
                                continue;
                        if (asprintf(&d->devname, "/dev/%s", ent->dev) < 0) {
                                free(d);
+                               d = NULL;
                                continue;
                        }
                        d->next = rv;
@@ -429,10 +437,12 @@ void devline(char *line)
        for (w=dl_next(line); w != line; w=dl_next(w)) {
                if (w[0] == '/' || strcasecmp(w, "partitions") == 0 ||
                    strcasecmp(w, "containers") == 0) {
-                       cd = malloc(sizeof(*cd));
-                       cd->name = strdup(w);
-                       cd->next = cdevlist;
-                       cdevlist = cd;
+                       cd = calloc(1, sizeof(*cd));
+                       if (cd) {
+                               cd->name = strdup(w);
+                               cd->next = cdevlist;
+                               cdevlist = cd;
+                       }
                } else {
                        fprintf(stderr, Name ": unreconised word on DEVICE line: %s\n",
                                w);
@@ -600,7 +610,7 @@ void arrayline(char *line)
            (mis.container == NULL || mis.member == NULL))
                fprintf(stderr, Name ": ARRAY line %s has no identity information.\n", mis.devname);
        else {
-               mi = malloc(sizeof(*mi));
+               mi = calloc(1, sizeof(*mi));
                *mi = mis;
                mi->devname = mis.devname ? strdup(mis.devname) : NULL;
                mi->next = NULL;
@@ -721,6 +731,7 @@ void load_conffile(void)
                dl_add(list, dl_strdup("partitions"));
                devline(list);
                free_line(list);
+               list = NULL;
                loaded = 1;
                return;
        }
@@ -770,6 +781,7 @@ void load_conffile(void)
                        fprintf(stderr, Name ": Unknown keyword %s\n", line);
                }
                free_line(line);
+               line = NULL;
        }

        fclose(f);
@@ -839,7 +851,9 @@ mddev_dev_t conf_get_devs()
                mddev_dev_t t = dlist;
                dlist = dlist->next;
                free(t->devname);
+               t->devname = NULL;
                free(t);
+               t = NULL;
        }

        load_conffile();
@@ -862,7 +876,7 @@ mddev_dev_t conf_get_devs()
        }
        if (flags & GLOB_APPEND) {
                for (i=0; i<globbuf.gl_pathc; i++) {
-                       mddev_dev_t t = malloc(sizeof(*t));
+                       mddev_dev_t t = calloc(1,sizeof(*t));
                        t->devname = strdup(globbuf.gl_pathv[i]);
                        t->next = dlist;
                        t->used = 0;
@@ -871,6 +885,7 @@ mddev_dev_t conf_get_devs()
 /*     printf("one dev is %s\n", t->devname);*/
                }
                globfree(&globbuf);
+
        }

        return dlist;
diff --git a/dlink.c b/dlink.c
index d734281..f99cb1d 100644
--- a/dlink.c
+++ b/dlink.c
@@ -22,8 +22,16 @@ void *dl_head()

 void dl_free(void *v)
 {
-    struct __dl_head *vv  = v;
-    free(vv-1);
+       struct __dl_head *vv;
+
+       if (v) {
+               vv  = v;
+               vv = vv-1;
+               if (vv) {
+                       free(vv);
+                       (vv) = NULL;
+               }
+       }
 }

 void dl_init(void *v)
@@ -75,5 +83,8 @@ char *dl_strndup(char *s, int l)

 char *dl_strdup(char *s)
 {
-    return dl_strndup(s, (int)strlen(s));
+    if (s)
+       return dl_strndup(s, (int)strlen(s));
+    else
+       return NULL;
 }
diff --git a/managemon.c b/managemon.c
index 86816c4..a1b6a0b 100644
--- a/managemon.c
+++ b/managemon.c
@@ -113,13 +113,16 @@ static void close_aa(struct active_array *aa)
        struct mdinfo *d;

        for (d = aa->info.devs; d; d = d->next) {
-               close(d->recovery_fd);
                close(d->state_fd);
+               d->state_fd = -1;
        }

        close(aa->action_fd);
+       aa->action_fd = -1;
        close(aa->info.state_fd);
+       aa->info.state_fd = -1;
        close(aa->resync_start_fd);
+       aa->resync_start_fd = -1;
 }

 static void free_aa(struct active_array *aa)
@@ -128,14 +131,24 @@ static void free_aa(struct active_array *aa)
         * by a clone.  ->container will be set for a clone
         */
        dprintf("%s: devnum: %d\n", __func__, aa->devnum);
-       if (!aa->container)
-               close_aa(aa);
-       while (aa->info.devs) {
-               struct mdinfo *d = aa->info.devs;
-               aa->info.devs = d->next;
-               free(d);
+
+       if (aa) {
+               if (!aa->container)
+                       close_aa(aa);
+
+               while (aa->info.devs) {
+                       struct mdinfo *d = aa->info.devs;
+                       if (d) {
+                               aa->info.devs = d->next;
+                               free(d);
+                               d = NULL;
+                       }
+               }
+
+               free(aa);
+               aa = NULL;
        }
-       free(aa);
+
 }

 static struct active_array *duplicate_aa(struct active_array *aa)
@@ -143,24 +156,28 @@ static struct active_array *duplicate_aa(struct active_array *aa)
        struct active_array *newa = malloc(sizeof(*newa));
        struct mdinfo **dp1, **dp2;

-       *newa = *aa;
-       newa->next = NULL;
-       newa->replaces = NULL;
-       newa->info.next = NULL;
+       if (newa) {
+               *newa = *aa;
+               newa->next = NULL;
+               newa->replaces = NULL;
+               newa->info.next = NULL;

-       dp2 = &newa->info.devs;
+               dp2 = &newa->info.devs;

-       for (dp1 = &aa->info.devs; *dp1; dp1 = &(*dp1)->next) {
-               struct mdinfo *d;
-               if ((*dp1)->state_fd < 0)
-                       continue;
+               for (dp1 = &aa->info.devs; *dp1; dp1 = &(*dp1)->next) {
+                       struct mdinfo *d;
+                       if ((*dp1)->state_fd < 0)
+                               continue;

-               d = malloc(sizeof(*d));
-               *d = **dp1;
-               *dp2 = d;
-               dp2 = & d->next;
-       }
+                       d = malloc(sizeof(*d));
+                       if (d) {
+                               *d = **dp1;
+                               *dp2 = d;
+                               dp2 = & d->next;
+                       }
+               }
        *dp2 = NULL;
+       }

        return newa;
 }
@@ -248,7 +265,7 @@ static void queue_metadata_update(struct metadata_update *mu)
 static void add_disk_to_container(struct supertype *st, struct mdinfo *sd)
 {
        int dfd;
-       char nm[20];
+       char nm[30];
        struct supertype *st2;
        struct metadata_update *update = NULL;
        struct mdinfo info;
@@ -275,20 +292,23 @@ static void add_disk_to_container(struct supertype *st, struct mdinfo *sd)
         * array
         */
        st2 = dup_super(st);
-       if (st2->ss->load_super(st2, dfd, NULL) == 0) {
-               st2->ss->getinfo_super(st, &info);
-               if (st->ss->compare_super(st, st2) == 0 &&
-                   info.disk.raid_disk >= 0) {
-                       /* Looks like a good member of array.
-                        * Just accept it.
-                        * mdadm will incorporate any parts into
-                        * active arrays.
-                        */
-                       st2->ss->free_super(st2);
-                       return;
+
+       if (st2 != NULL) {
+               if (st2->ss->load_super(st2, dfd, NULL) == 0) {
+                       st2->ss->getinfo_super(st, &info);
+                       if (st->ss->compare_super(st, st2) == 0 &&
+                           info.disk.raid_disk >= 0) {
+                               /* Looks like a good member of array.
+                                * Just accept it.
+                                * mdadm will incorporate any parts into
+                                * active arrays.
+                                */
+                               st2->ss->free_super(st2);
+                               return;
+                       }
                }
+               st2->ss->free_super(st2);
        }
-       st2->ss->free_super(st2);

        st->update_tail = &update;
        st->ss->add_to_super(st, &dk, dfd, NULL);
@@ -335,6 +355,7 @@ static void manage_container(struct mdstat_ent *mdstat,
                                cd = *cdp;
                                *cdp = (*cdp)->next;
                                free(cd);
+                               cd = NULL;
                        } else
                                cdp = &(*cdp)->next;
                }
@@ -357,6 +378,7 @@ static void manage_container(struct mdstat_ent *mdstat,
                        }
                }
                sysfs_free(mdi);
+               mdi = NULL;
                container->devcnt = mdstat->devcnt;
        }
 }
@@ -491,14 +513,18 @@ static void manage_new(struct mdstat_ent *mdstat,
        mdi = sysfs_read(-1, mdstat->devnum,
                         GET_LEVEL|GET_LAYOUT|GET_CHUNK|GET_DISKS|GET_COMPONENT|
                         GET_DEGRADED|GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE);
-
+
        new = malloc(sizeof(*new));

        if (!new || !mdi) {
-               if (mdi)
+               if (mdi) {
                        sysfs_free(mdi);
-               if (new)
+                       mdi = NULL;
+               }
+               if (new) {
                        free(new);
+                       new = NULL;
+               }
                return;
        }
        memset(new, 0, sizeof(*new));
@@ -536,8 +562,10 @@ static void manage_new(struct mdstat_ent *mdstat,
                        newd->prev_state = read_dev_state(newd->state_fd);
                        newd->curr_state = newd->prev_state;
                } else {
-                       if (newd)
+                       if (newd) {
                                free(newd);
+                               newd = NULL;
+                       }

                        failed++;
                        if (failed > new->info.array.failed_disks) {
@@ -559,12 +587,12 @@ static void manage_new(struct mdstat_ent *mdstat,
        new->level_fd = sysfs_open(new->devnum, NULL, "level");
        new->takeover = none;
        new->prev_level  = -1;
-
        dprintf("%s: inst: %d action: %d state: %d\n", __func__, atoi(inst),
                new->action_fd, new->info.state_fd);

        sysfs_free(mdi);
-
+       mdi = NULL;
+
        /* if everything checks out tell the metadata handler we want to
         * manage this instance
         */
@@ -642,14 +670,16 @@ static void handle_message(struct supertype *container, struct metadata_update *
                free_mdstat(mdstat);
        } else if (!sigterm) {
                mu = malloc(sizeof(*mu));
-               mu->len = msg->len;
-               mu->buf = msg->buf;
-               msg->buf = NULL;
-               mu->space = NULL;
-               mu->next = NULL;
-               if (container->ss->prepare_update)
-                       container->ss->prepare_update(container, mu);
-               queue_metadata_update(mu);
+               if (mu) {
+                       mu->len = msg->len;
+                       mu->buf = msg->buf;
+                       msg->buf = NULL;
+                       mu->space = NULL;
+                       mu->next = NULL;
+                       if (container->ss->prepare_update)
+                               container->ss->prepare_update(container, mu);
+                       queue_metadata_update(mu);
+               }
        }
 }

@@ -701,7 +731,8 @@ void do_manager(struct supertype *container)
        proc_fd = open("/proc/mounts", O_RDONLY);

        do {
-
+               check_update_queue(container);
+
                if (exit_now)
                        exit(0);

diff --git a/mapfile.c b/mapfile.c
index ed59db5..3bf0dab 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -121,8 +121,10 @@ int map_lock(struct map_ent **melp)
                        return -1;
                }
        }
-       if (*melp)
+       if (*melp) {
                map_free(*melp);
+               *melp = NULL;
+       }
        map_read(melp);
        return 0;
 }
@@ -189,8 +191,12 @@ void map_free(struct map_ent *map)
        while (map) {
                struct map_ent *mp = map;
                map = mp->next;
-               free(mp->path);
+               if (mp->path) {
+                       free(mp->path);
+                       mp->path = NULL;
+               }
                free(mp);
+               mp = NULL;
        }
 }

@@ -209,7 +215,7 @@ int map_update(struct map_ent **mpp, int devnum, char *metadata,
                if (mp->devnum == devnum) {
                        strcpy(mp->metadata, metadata);
                        memcpy(mp->uuid, uuid, 16);
-                       free(mp->path);
+                       if (mp->path) free(mp->path);
                        mp->path = path ? strdup(path) : NULL;
                        break;
                }
@@ -218,7 +224,7 @@ int map_update(struct map_ent **mpp, int devnum, char *metadata,
        if (mpp)
                *mpp = NULL;
        rv = map_write(map);
-       map_free(map);
+       if (map) map_free(map);
        return rv;
 }

@@ -232,8 +238,12 @@ void map_delete(struct map_ent **mapp, int devnum)
        for (mp = *mapp; mp; mp = *mapp) {
                if (mp->devnum == devnum) {
                        *mapp = mp->next;
-                       free(mp->path);
+                       if (mp->path) {
+                               free(mp->path);
+                               mp->path = NULL;
+                       }
                        free(mp);
+                       mp = NULL;
                } else
                        mapp = & mp->next;
        }
@@ -458,13 +468,16 @@ void RebuildMap(void)
                        break;
                }
                sysfs_free(sra);
+               sra = NULL;
        }
        map_write(map);
        map_free(map);
+       map = NULL;
        for (md = mdstat ; md ; md = md->next) {
                struct mdinfo *sra = sysfs_read(-1, md->devnum, GET_VERSION);
                sysfs_uevent(sra, "change");
                sysfs_free(sra);
+               sra = NULL;
        }
        free_mdstat(mdstat);
 }
diff --git a/mdmon.c b/mdmon.c
index 0ec4259..5813e21 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -64,8 +64,8 @@
 #include       "mdadm.h"
 #include       "mdmon.h"

-struct active_array *discard_this;
-struct active_array *pending_discard;
+struct active_array *discard_this = NULL;
+struct active_array *pending_discard = NULL;

 int mon_tid, mgr_tid;

@@ -125,7 +125,7 @@ static int test_pidfile(char *devname)
 int make_pidfile(char *devname, int o_excl)
 {
        char path[100];
-       char pid[10];
+       char pid[20];
        int fd;
        int n;

@@ -477,6 +477,7 @@ int mdmon(char *devname, int devnum, int scan, char *switchroot)
                container->devs = cd;
        }
        sysfs_free(mdi);
+       mdi = NULL;

        /* SIGUSR is sent between parent and child.  So both block it
         * and enable it only with pselect.
diff --git a/mdopen.c b/mdopen.c
index 21baf5d..b3b0cf6 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -43,7 +43,7 @@ void make_parts(char *dev, int cnt)
        int odig = odig; /* quiet gcc -Os unitialized warning */
        int i;
        int nlen = strlen(dev) + 20;
-       char *name;
+       char *name = NULL;
        int dig = isdigit(dev[strlen(dev)-1]);
        char orig[1024];
        char sym[1024];
@@ -94,7 +94,7 @@ void make_parts(char *dev, int cnt)
                if (err == 0 && stat(name, &stb2) == 0)
                        add_dev(name, &stb2, 0, NULL);
        }
-       free(name);
+       if (name) free(name);
 }


diff --git a/mdstat.c b/mdstat.c
index 4d2f473..d7045a7 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -87,13 +87,26 @@ void free_mdstat(struct mdstat_ent *ms)
 {
        while (ms) {
                struct mdstat_ent *t;
-               if (ms->dev) free(ms->dev);
-               if (ms->level) free(ms->level);
-               if (ms->pattern) free(ms->pattern);
-               if (ms->metadata_version) free(ms->metadata_version);
+               if (ms->dev) {
+                       free(ms->dev);
+                       ms->dev=NULL;
+               }
+               if (ms->level) {
+                       free(ms->level);
+                       ms->level = NULL;
+               }
+               if (ms->pattern) {
+                       free(ms->pattern);
+                       ms->pattern = NULL;
+               }
+               if (ms->metadata_version) {
+                       free(ms->metadata_version);
+                       ms->metadata_version = NULL;
+               }
                t = ms;
                ms = ms->next;
                free(t);
+               t = NULL;
        }
 }

@@ -102,7 +115,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 {
        FILE *f;
        struct mdstat_ent *all, *rv, **end, **insert_here;
-       char *line;
+       char *line = NULL;

        if (hold && mdstat_fd != -1) {
                lseek(mdstat_fd, 0L, 0);
@@ -148,6 +161,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
                if (!ent) {
                        fprintf(stderr, Name ": malloc failed reading /proc/mdstat.\n");
                        free_line(line);
+                       line = NULL;
                        break;
                }
                ent->dev = ent->level = ent->pattern= NULL;
diff --git a/monitor.c b/monitor.c
index ea87f5f..c4f4015 100644
--- a/monitor.c
+++ b/monitor.c
@@ -17,10 +17,14 @@
  * this program; if not, write to the Free Software Foundation, Inc.,
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif

 #include "mdadm.h"
 #include "mdmon.h"
 #include <sys/syscall.h>
+#include <sys/socket.h>
 #include <sys/select.h>
 #include <signal.h>

diff --git a/msg.c b/msg.c
index 8d52b94..1e23b01 100644
--- a/msg.c
+++ b/msg.c
@@ -111,14 +111,20 @@ int receive_message(int fd, struct metadata_update *msg, int tmo)
                        return -1;
                rv = recv_buf(fd, msg->buf, len, tmo);
                if (rv < 0) {
-                       free(msg->buf);
+                       if (msg->buf) {
+                               free(msg->buf);
+                               msg->buf = NULL;
+                       }
                        return -1;
                }
        } else
                msg->buf = NULL;
        rv = recv_buf(fd, &magic, 4, tmo);
        if (rv < 0 || magic != end_magic) {
-               free(msg->buf);
+               if (msg->buf) {
+                       free(msg->buf);
+                       msg->buf = NULL;
+               }
                return -1;
        }
        msg->len = len;
diff --git a/platform-intel.c b/platform-intel.c
index 30f7914..e853a10 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -35,7 +35,10 @@ void free_sys_dev(struct sys_dev **list)
                struct sys_dev *next = (*list)->next;

                if ((*list)->path)
+               {
                        free((*list)->path);
+                       (*list)->path = NULL;
+               }
                free(*list);
                *list = next;
        }
@@ -44,8 +47,8 @@ void free_sys_dev(struct sys_dev **list)
 struct sys_dev *find_driver_devices(const char *bus, const char *driver)
 {
        /* search sysfs for devices driven by 'driver' */
-       char path[292];
-       char link[256];
+       char path[1024];
+       char link[1024];
        char *c;
        DIR *driver_dir;
        struct dirent *de;
@@ -206,7 +209,7 @@ const struct imsm_orom *find_imsm_orom(void)

 char *devt_to_devpath(dev_t dev)
 {
-       char device[46];
+       char device[50];

        sprintf(device, "/sys/dev/block/%d:%d/device", major(dev), minor(dev));
        return canonicalize_file_name(device);
diff --git a/restripe.c b/restripe.c
index f673206..7d8809b 100644
--- a/restripe.c
+++ b/restripe.c
@@ -573,10 +573,14 @@ int restore_stripes(int *dest, unsigned long long *offsets,
        }
        if (stripe_buf == NULL || stripes == NULL || blocks == NULL
            || zero == NULL) {
-               free(stripe_buf);
-               free(stripes);
-               free(blocks);
-               free(zero);
+               if (stripe_buf)
+                       free(stripe_buf);
+               if (stripes)
+                       free(stripes);
+               if (blocks)
+                       free(blocks);
+               if (zero)
+                       free(zero);
                return -2;
        }
        for (i=0; i<raid_disks; i++)
diff --git a/super-intel.c b/super-intel.c
index be7fac9..9e82f0c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -633,23 +633,35 @@ static __u32 imsm_reserved_sectors(struct intel_super *super, struct dl *dl)
        rv = __le32_to_cpu(dl->disk.total_blocks) - e[i].start;

        free(e);
+       e=NULL;

        return rv;
 }

 static int is_spare(struct imsm_disk *disk)
 {
-       return (disk->status & SPARE_DISK) == SPARE_DISK;
+       if (disk)
+               return (disk->status & SPARE_DISK) == SPARE_DISK;
+       else
+               return 0;
 }

 static int is_configured(struct imsm_disk *disk)
 {
-       return (disk->status & CONFIGURED_DISK) == CONFIGURED_DISK;
+       if (disk)
+               return (disk->status & CONFIGURED_DISK) == CONFIGURED_DISK;
+       else
+               return 0;
+
 }

 static int is_failed(struct imsm_disk *disk)
 {
-       return (disk->status & FAILED_DISK) == FAILED_DISK;
+       if (disk)
+               return (disk->status & FAILED_DISK) == FAILED_DISK;
+       else
+               return 0;
+
 }

 #ifndef MDASSEMBLE
@@ -936,7 +948,10 @@ static int imsm_enumerate_ports(const char *hba_path, int port_count, int host_b
                                fprintf(stderr, Name ": failed to read device type for %s\n",
                                        path);
                        err = 2;
-                       free(device);
+                       if (device) {
+                               free(device);
+                               device = NULL;
+                       }
                        break;
                }
                type = strtoul(buf, NULL, 10);
@@ -980,8 +995,11 @@ static int imsm_enumerate_ports(const char *hba_path, int port_count, int host_b
                                }
                } else
                        buf[0] = '\0';
-               free(device);
-
+               if (device) {
+                       free(device);
+                       device = NULL;
+               }
+
                /* chop device path to 'host%d' and calculate the port number */
                c = strchr(&path[hba_len], '/');
                if (!c) {
@@ -1024,11 +1042,15 @@ static int imsm_enumerate_ports(const char *hba_path, int port_count, int host_b
                                printf("()\n");
                }
                close(fd);
+               if (path) {
+                       free(path);
+                       path = NULL;
+               }
+       }
+       if (path) {
                free(path);
                path = NULL;
        }
-       if (path)
-               free(path);
        if (dir)
                closedir(dir);
        if (err == 0) {
@@ -1077,13 +1099,13 @@ static int detail_platform_imsm(int verbose, int enumerate_only)
        if (!hba) {
                if (verbose)
                        fprintf(stderr, Name ": unable to find active ahci controller\n");
-               free_sys_dev(&list);
+               if (list) free_sys_dev(&list);
                return 2;
        } else if (verbose)
                fprintf(stderr, Name ": found Intel SATA AHCI Controller\n");
        hba_path = hba->path;
        hba->path = NULL;
-       free_sys_dev(&list);
+       if (list) free_sys_dev(&list);

        orom = find_imsm_orom();
        if (!orom) {
@@ -1191,7 +1213,9 @@ static void uuid_from_super_imsm(struct supertype *st, int uuid[4])
         * Hopefully these are all constant.
         */
        struct intel_super *super = st->sb;
-
+
+       if (super==NULL) return;
+
        char buf[20];
        struct sha1_ctx ctx;
        struct imsm_dev *dev = NULL;
@@ -1537,6 +1561,7 @@ static void fixup_container_spare_uuid(struct mdinfo *inf)
                        if (_sst) {
                                memcpy(inf->uuid, array_list->uuid, sizeof(int[4]));
                                free(_sst);
+                               _sst = NULL;
                                break;
                        }
                }
@@ -1548,10 +1573,14 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info)
        struct intel_super *super = st->sb;
        struct imsm_disk *disk;

-       if (super->current_vol >= 0) {
-               getinfo_super_imsm_volume(st, info);
-               return;
+       if (super) {
+               if (super->current_vol >= 0) {
+                       getinfo_super_imsm_volume(st, info);
+                       return;
+               }
        }
+       else
+               return;

        /* Set raid_disks to zero so that Assemble will always pull in valid
         * spares
@@ -1703,8 +1732,12 @@ static void free_devlist(struct intel_super *super)

        while (super->devlist) {
                dv = super->devlist->next;
-               free(super->devlist->dev);
+               if (super->devlist->dev) {
+                       free(super->devlist->dev);
+                       super->devlist->dev = NULL;
+               }
                free(super->devlist);
+               super->devlist = NULL;
                super->devlist = dv;
        }
 }
@@ -1723,7 +1756,7 @@ struct imsm_dev *reallocate_imsm_dev(struct intel_super *super,
        struct imsm_dev *retVal = NULL;
        struct intel_dev *dv = NULL;
        int memNeeded;
-
+
        if (super) {
                /* Calculate space needed for imsm_dev with a single map */
                memNeeded = sizeof(struct imsm_dev) + sizeof(__u32) * (map0_num_members - 1);
@@ -1814,6 +1847,7 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst)
                        dev = malloc(sizeof_imsm_dev(get_imsm_dev(sec, i), 1));
                        if (!dev) {
                                free(dv);
+                               dv = NULL;
                                break;
                        }
                        dv->dev = dev;
@@ -1964,11 +1998,12 @@ __serial_to_disk(__u8 *serial, struct imsm_super *mpb, int *idx)

        for (i = 0; i < mpb->num_disks; i++) {
                struct imsm_disk *disk = __get_imsm_disk(mpb, i);
-
-               if (serialcmp(disk->serial, serial) == 0) {
-                       if (idx)
-                               *idx = i;
-                       return disk;
+               if (disk) {
+                       if (serialcmp(disk->serial, serial) == 0) {
+                               if (idx)
+                                       *idx = i;
+                               return disk;
+                       }
                }
        }

@@ -2115,9 +2150,9 @@ static int parse_raid_devices(struct intel_super *super)
                dev_new = malloc(len_migr);
                if (!dev_new) {
                        free(dv);
+                       dv = NULL;
                        return 1;
                }
-
                imsm_copy_dev(dev_new, dev_iter);
                dv->dev = dev_new;
                dv->index = i;
@@ -2137,7 +2172,7 @@ static int parse_raid_devices(struct intel_super *super)

                memcpy(buf, super->buf, super->len);
                memset(buf + super->len, 0, len - super->len);
-               free(super->buf);
+               if (super->buf) free(super->buf);
                super->buf = buf;
                super->len = len;
        }
@@ -2194,6 +2229,7 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
                                Name ": Cannot read anchor block on %s: %s\n",
                                devname, strerror(errno));
                free(anchor);
+               anchor = NULL;
                return 1;
        }

@@ -2202,6 +2238,7 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
                        fprintf(stderr,
                                Name ": no IMSM anchor on %s\n", devname);
                free(anchor);
+               anchor = NULL;
                return 2;
        }

@@ -2213,12 +2250,14 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
                                Name ": unable to allocate %zu byte mpb buffer\n",
                                super->len);
                free(anchor);
+               anchor = NULL;
                return 2;
        }
        memcpy(super->buf, anchor, 512);

        sectors = mpb_sectors(anchor) - 1;
        free(anchor);
+       anchor = NULL;
        if (!sectors) {
                check_sum = __gen_imsm_checksum(super->anchor);
                if (check_sum != __le32_to_cpu(super->anchor->check_sum)) {
@@ -2288,28 +2327,36 @@ load_and_parse_mpb(int fd, struct intel_super *super, char *devname, int keep_fd

 static void __free_imsm_disk(struct dl *d)
 {
-       if (d->fd >= 0)
-               close(d->fd);
-       if (d->devname)
-               free(d->devname);
-       if (d->e)
-               free(d->e);
-       free(d);
-
+       if (d) {
+               if (d->fd >= 0)
+                       close(d->fd);
+               if (d->devname) {
+                       free(d->devname);
+                       d->devname = NULL;
+               }
+               if (d->e) {
+                       free(d->e);
+                       d->e = NULL;
+               }
+               free(d);
+               d = NULL;
+       }
 }
+
 static void free_imsm_disks(struct intel_super *super)
 {
        struct dl *d;
-
-       while (super->disks) {
-               d = super->disks;
-               super->disks = d->next;
-               __free_imsm_disk(d);
-       }
-       while (super->missing) {
-               d = super->missing;
-               super->missing = d->next;
-               __free_imsm_disk(d);
+       if (super) {
+               while (super->disks) {
+                       d = super->disks;
+                       super->disks = d->next;
+                       __free_imsm_disk(d);
+               }
+               while (super->missing) {
+                       d = super->missing;
+                       super->missing = d->next;
+                       __free_imsm_disk(d);
+               }
        }

 }
@@ -2317,29 +2364,39 @@ static void free_imsm_disks(struct intel_super *super)
 /* free all the pieces hanging off of a super pointer */
 static void __free_imsm(struct intel_super *super, int free_disks)
 {
-       if (super->buf) {
-               free(super->buf);
-               super->buf = NULL;
-       }
-       if (free_disks)
-               free_imsm_disks(super);
-       free_devlist(super);
-       if (super->hba) {
-               free((void *) super->hba);
-               super->hba = NULL;
+       if (super) {
+               if (super->buf) {
+                       free(super->buf);
+                       super->buf = NULL;
+               }
+               if (free_disks)
+                       free_imsm_disks(super);
+               free_devlist(super);
+               if (super->hba) {
+                       free((void *) super->hba);
+                       super->hba = NULL;
+               }
        }
 }

 static void free_imsm(struct intel_super *super)
 {
-       __free_imsm(super, 1);
-       free(super);
+       if (super) {
+               __free_imsm(super, 1);
+               free(super);
+               super = NULL;
+
+       }
 }

 static void free_super_imsm(struct supertype *st)
 {
-       struct intel_super *super = st->sb;
+       struct intel_super *super;

+       if (!st)
+               return;
+
+       super = st->sb;
        if (!super)
                return;

@@ -2721,7 +2778,6 @@ imsm_thunderdome(struct intel_super **super_list, int len)
  out:
        while (disk_list) {
                struct intel_disk *idisk = disk_list;
-
                disk_list = disk_list->next;
                free(idisk);
        }
@@ -3033,6 +3089,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
        dev = malloc(sizeof(*dev) + sizeof(__u32) * (info->raid_disks - 1));
        if (!dev) {
                free(dv);
+               dv = NULL;
                fprintf(stderr, Name": could not allocate raid device\n");
                return 0;
        }
@@ -3128,7 +3185,7 @@ static int init_super_imsm(struct supertype *st, mdu_array_info_t *info,

        super = alloc_super(1);
        if (super && posix_memalign(&super->buf, 512, mpb_size) != 0) {
-               free(super);
+               if (super) free(super);
                super = NULL;
        }
        if (!super) {
@@ -3268,6 +3325,7 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
                fprintf(stderr,
                        Name ": failed to retrieve scsi serial, aborting\n");
                free(dd);
+               dd = NULL;
                abort();
        }

@@ -3356,7 +3414,7 @@ static int make_mpb_imsm_compatible(struct supertype *st, struct imsm_super *mpb
        __u32 sum;
        int i, bytes_to_copy, spares = 0;
        struct dl *d;
-
+
        /* Make sure that there is missing disk */
        if (super->missing == NULL)
          return -1;
@@ -3376,7 +3434,6 @@ static int make_mpb_imsm_compatible(struct supertype *st, struct imsm_super *mpb

        /* Iterate through the imsm devices */
        for (i = 0; i < mpb->num_raid_devs; i++) {
-
                struct imsm_dev *dev = __get_imsm_dev(mpb, i);
                imsm_copy_dev(dev, get_imsm_dev(super, i));

@@ -3430,7 +3487,6 @@ static int make_mpb_imsm_compatible(struct supertype *st, struct imsm_super *mpb
 static int is_mpb_imsm_compatible(struct supertype *st, struct imsm_super *mpb)
 {
     int i;
-
        /* Iterate through the imsm devices */
     for (i = 0; i < mpb->num_raid_devs; i++) {
                struct imsm_dev *dev;
@@ -3444,6 +3500,9 @@ static int is_mpb_imsm_compatible(struct supertype *st, struct imsm_super *mpb)
                        if (a->info.container_member == i)
                                break;
                }
+               if (a == NULL) {
+                       return 0;
+               }
                /* Get first map */
                map = get_imsm_map(dev, 0);
                if ((map->raid_level == 5) && (a->info.array.layout == ALGORITHM_PARITY_N))     {
@@ -3565,7 +3624,6 @@ static int write_super_imsm(struct supertype *st, int doclose)

        for (i = 0; i < mpb->num_raid_devs; i++) {
                struct imsm_dev *dev = __get_imsm_dev(mpb, i);
-
                imsm_copy_dev(dev, get_imsm_dev(super, i));
                mpb_size += sizeof_imsm_dev(dev, 0);
        }
@@ -3823,7 +3881,7 @@ static unsigned long long merge_extents(struct intel_super *super, int sum_exten
        unsigned long reserve;

        if (!e)
-               return 0;
+               return ~0ULL; /* error */

        /* coalesce and sort all extents. also, check to see if we need to
         * reserve space between member arrays
@@ -3865,6 +3923,7 @@ static unsigned long long merge_extents(struct intel_super *super, int sum_exten
                i++;
        } while (e[i-1].size);
        free(e);
+       e = NULL;

        if (maxsize == 0)
                return 0;
@@ -3872,17 +3931,18 @@ static unsigned long long merge_extents(struct intel_super *super, int sum_exten
        /* FIXME assumes volume at offset 0 is the first volume in a
         * container
         */
+
        if (start_extent > 0)
                reserve = IMSM_RESERVED_SECTORS; /* gap between raid regions */
        else
                reserve = 0;

        if (maxsize < reserve)
-               return 0;
+               return ~0ULL;

        super->create_offset = ~((__u32) 0);
        if (start + reserve > super->create_offset)
-               return 0; /* start overflows create_offset */
+               return ~0ULL; /* start overflows create_offset */
        super->create_offset = start + reserve;

        return maxsize - reserve;
@@ -3954,7 +4014,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
        struct dl *dl;
        unsigned long long pos = 0;
        unsigned long long maxsize;
-       struct extent *e;
+       struct extent *e = NULL;
        int i;

        /* We must have the container info already read in. */
@@ -3999,6 +4059,7 @@ static int validate_geometry_imsm_volume(struct supertype *st, int level,
                        if (found)
                                dcnt++;
                        free(e);
+                       e = NULL;
                }
                if (dcnt < raiddisks) {
                        if (verbose)
@@ -4311,10 +4372,15 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
         *  and create appropriate device mdinfo.
         */
        struct intel_super *super = st->sb;
-       struct imsm_super *mpb = super->anchor;
+       struct imsm_super *mpb = NULL;
        struct mdinfo *rest = NULL;
        int i;

+       if (super)
+               mpb = super->anchor;
+       else
+               return NULL;
+
        /* do not assemble arrays that might have bad blocks */
        if (imsm_bbm_log_size(super->anchor)) {
                fprintf(stderr, Name ": BBM log found in metadata. "
@@ -4385,7 +4451,6 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
                                this->resync_start = MaxSector;
                        if (skip)
                                continue;
-
                        info_d = calloc(1, sizeof(*info_d));
                        if (!info_d) {
                                fprintf(stderr, Name ": failed to allocate disk"
@@ -4397,10 +4462,11 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
                                        free(info_d);
                                        info_d = d;
                                }
-                               free(this);
+                               if (this) free(this);
                                this = rest;
                                break;
                        }
+                       memset(info_d, 0, sizeof(*info_d));
                        info_d->next = this->devs;
                        this->devs = info_d;

@@ -4605,14 +4671,34 @@ static void mark_missing(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
  */
 static int imsm_set_array_state(struct active_array *a, int consistent)
 {
-       int inst = a->info.container_member;
-       struct intel_super *super = a->container->sb;
-       struct imsm_dev *dev = get_imsm_dev(super, inst);
-       struct imsm_map *map = get_imsm_map(dev, 0);
-       int failed = imsm_count_failed(super, dev);
-       __u8 map_state = imsm_check_degraded(super, dev, failed);
+       int inst = 0;
+       struct intel_super *super = NULL;
+       struct imsm_dev *dev;
+       struct imsm_map *map;
+       int failed;
+       __u8 map_state;
        __u32 blocks_per_unit;

+       if (!a)
+           return consistent;
+
+       if (a->container) {
+               super = a->container->sb;
+               if (!super)
+                   return consistent;
+       }
+       else
+           return consistent;
+
+       inst = a->info.container_member;
+       dev = get_imsm_dev(super, inst);
+
+       if (dev == NULL)
+               return consistent;
+
+       map = get_imsm_map(dev, 0);
+       failed = imsm_count_failed(super, dev);
+       map_state = imsm_check_degraded(super, dev, failed);
        /* before we activate this array handle any missing disks */
        if (consistent == 2 && super->missing) {
                struct dl *dl;
@@ -4688,13 +4774,27 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 static void imsm_set_disk(struct active_array *a, int n, int state)
 {
        int inst = a->info.container_member;
-       struct intel_super *super = a->container->sb;
-       struct imsm_dev *dev = get_imsm_dev(super, inst);
-       struct imsm_map *map = get_imsm_map(dev, 0);
+       struct intel_super *super = NULL;
+       struct imsm_dev *dev;
+       struct imsm_map *map;
        struct imsm_disk *disk;
        int failed;
        __u32 ord;
        __u8 map_state;
+
+       if (a->container) {
+               super = a->container->sb;
+               if (super == NULL)
+                       return;
+       }
+       else
+           return;
+
+       dev = get_imsm_dev(super, inst);
+       map = get_imsm_map(dev, 0);
+
+       if ((dev == NULL) || (map == NULL))
+               return;

        if (n > map->num_members)
                fprintf(stderr, "imsm: set_disk %d out of range 0..%d\n",
@@ -4702,7 +4802,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)

        if (n < 0)
                return;
-
+
        dprintf("imsm: set_disk %d:%x\n", n, state);

        ord = get_imsm_ord_tbl_ent(dev, n);
@@ -4891,6 +4991,7 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
                }

                free(ex);
+               ex = NULL;
                if (i < mpb->num_raid_devs) {
                        dprintf("%x:%x does not have %u to %u available\n",
                                dl->major, dl->minor, array_start, array_end);
@@ -4925,14 +5026,14 @@ static int imsm_takeover(struct active_array *a,
        if (info.array.level == a->curr_level)
        {
                /* no raid level was actually changed */
-               fprintf(stderr, "Takeover started but no raid level was changed!\n");;
+               fprintf(stderr, "Takeover started but no raid level was changed!\n");
                return 0;
        }

        /* Read sysfs devs */
        mdi = sysfs_read(-1, a->devnum, GET_DEVS|SKIP_GONE_DEVS);
        if (!mdi) {
-               fprintf(stderr, "Could not read sysfs!\n");;
+               fprintf(stderr, "Could not read sysfs!\n");
                return 0;
        }

@@ -4943,6 +5044,7 @@ static int imsm_takeover(struct active_array *a,
                mu->buf = malloc(len);
                if (mu->buf == NULL) {
                        free(mu);
+                       mu = NULL;
                        fprintf(stderr, "%s: failed to allocate update buffer\n",
                                        __func__);
                        return 0;
@@ -5032,20 +5134,31 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
         * container.
         */

-       struct intel_super *super = a->container->sb;
+       struct intel_super *super = NULL;
        int inst = a->info.container_member;
-       struct imsm_dev *dev = get_imsm_dev(super, inst);
-       struct imsm_map *map = get_imsm_map(dev, 0);
+       struct imsm_dev *dev;
+       struct imsm_map *map;
        int failed = a->info.array.raid_disks;
        struct mdinfo *rv = NULL;
        struct mdinfo *d;
        struct mdinfo *di;
        struct metadata_update *mu;
-       struct dl *dl;
+       struct dl *dl = NULL;
        struct imsm_update_activate_spare *u;
        int num_spares = 0;
        int i;

+       if (a->container) {
+               super = a->container->sb;
+               if (super == NULL)
+                       return NULL;
+       }
+       else
+               return NULL;
+
+       dev = get_imsm_dev(super, inst);
+       map = get_imsm_map(dev, 0);
+
        for (d = a->info.devs ; d ; d = d->next) {
                if ((d->curr_state & DS_FAULTY) &&
                        d->state_fd >= 0)
@@ -5222,10 +5335,15 @@ static void imsm_process_update(struct supertype *st,
         *      present in all member arrays then also clear the SPARE_DISK
         *      flag
         */
-       struct intel_super *super = st->sb;
+       struct intel_super *super;
        struct imsm_super *mpb;
        enum imsm_update_type type = *(enum imsm_update_type *) update->buf;

+       if ((st == NULL) || (update == NULL)) {
+               return;
+       }
+
+       super = st->sb;
        /* update requires a larger buf but the allocation failed */
        if (super->next_len && !super->next_buf) {
                super->next_len = 0;
@@ -5234,7 +5352,7 @@ static void imsm_process_update(struct supertype *st,

        if (super->next_buf) {
                memcpy(super->next_buf, super->buf, super->len);
-               free(super->buf);
+               if (super->buf) free(super->buf);
                super->len = super->next_len;
                super->buf = super->next_buf;

@@ -5245,7 +5363,6 @@ static void imsm_process_update(struct supertype *st,
        mpb = super->anchor;

        switch (type) {
-
        case update_takeover: {
                struct imsm_update_takeover *u = (void *) update->buf;
                struct imsm_dev *dev = get_imsm_dev(super, u->array);
@@ -5261,7 +5378,7 @@ static void imsm_process_update(struct supertype *st,
                                d = array->info.devs;
                                break;
                        }
-
+
                if (!array) {
                        fprintf(stderr, "error: could not find any active array!\n");
                        return;
@@ -5309,19 +5426,22 @@ static void imsm_process_update(struct supertype *st,
                            dl->major = dl->minor = 0;
                            dl->fd = -1;
                            dl->devname = strdup("missing");
-                               dl->index = mpb->num_disks;
+                           dl->index = mpb->num_disks;
                            sprintf((char*)dl->disk.serial, "MISSING_DISK%d", i);
                            dl->disk.total_blocks = -1;
                            dl->disk.scsi_id = -1;
                            dl->disk.status = FAILED_DISK;
                            dl->disk.owner_cfg_num = 0;
                            dl->e = NULL;
-                           dl->next = super->missing;
+                           dl->next = super->missing;
                            super->missing = dl;
+
                            /* Set slot for missing disk */
                            slot = find_free_slot(d, slot);
+
                            set_imsm_ord_tbl_ent(map, slot, dl->index | IMSM_ORD_REBUILD);
-                           dl->raiddisk = slot;
+                           dl->raiddisk = slot;
+
                            /* Increase number of disks */
                            mpb->num_disks++;
                        }
@@ -5331,48 +5451,50 @@ static void imsm_process_update(struct supertype *st,
                        map->failed_disk_num = dl->index;
                        map->map_state = IMSM_T_STATE_DEGRADED;
                }
-
                if (u->delta_disks < 0)
                {
                        /* we'll be adding missing disks: Raid5->Raid0 or Raid10->Raid0 */
                        int missing_disks = 0;
+
                        dl = super->missing;
-
+
                        /* Count missing drives */
                        while(dl) {
                                missing_disks--;
                                dl = dl->next;
                        }
-                   if (missing_disks != (u->delta_disks)) {
-                       fprintf(stderr, "error: incorrect missing drive number for takeover: %d\n",
-                                               missing_disks);
-                       break;
-                   }
-                   /* removing missing disk */
-                   while (super->missing) {
+                       if (missing_disks != (u->delta_disks)) {
+                           fprintf(stderr, "error: incorrect missing drive number for takeover: %d\n",
+                                                   missing_disks);
+                           break;
+                       }
+
+                       while (super->missing) {
                                dl = super->missing;
                                super->missing = dl->next;
                                __free_imsm_disk(dl);
-                   }
-                   /* Update slots in the raid map */
-                   for (i = 0; i < u->sl_changed; i++) {
+                       }
+
+                       /* Update slots in the raid map */
+                       for (i = 0; i < u->sl_changed; i++) {
                                int idx;
                                idx = get_imsm_ord_tbl_ent(dev, u->sl_changes[i].prev_slot);
                                /* now after slot changes */
                                set_imsm_ord_tbl_ent(map, u->sl_changes[i].new_slot, idx);
                        }
-                   /* Update mpb */
-                   mpb->num_disks += u->delta_disks;
-                   map->num_members += u->delta_disks;
-                   map->failed_disk_num = 0;
-                   map->map_state = IMSM_T_STATE_NORMAL;
+
+                       /* Update mpb */
+                       mpb->num_disks += u->delta_disks;
+                       map->num_members += u->delta_disks;
+                       map->failed_disk_num = 0;
+                       map->map_state = IMSM_T_STATE_NORMAL;
                }
-
+
                /* Update raid level */
                map->raid_level = u->new_level;
                super->updates_pending++;
                array->takeover = finished;
-
+
                imsm_update_version_info(super);
                break;
        }
@@ -5583,7 +5705,14 @@ static void imsm_process_update(struct supertype *st,
                 */
                if (update->space) {
                        dv = update->space;
-                       free(dv->dev);
+                       if (dv)
+                       {
+                               if (dv->dev)
+                               {
+                                       free(dv->dev);
+                                       dv->dev = NULL;
+                               }
+                       }
                }
                break;
        }
@@ -5624,25 +5753,35 @@ static void imsm_prepare_update(struct supertype *st,
         * integrated by the monitor thread without worrying about live pointers
         * in the manager thread.
         */
-       enum imsm_update_type type = *(enum imsm_update_type *) update->buf;
-       struct intel_super *super = st->sb;
-       struct imsm_super *mpb = super->anchor;
+       enum imsm_update_type type;
+       struct intel_super *super;
+       struct imsm_super *mpb;
        size_t buf_len;
        size_t len = 0;

-       switch (type) {
+       if (update)
+               type = *(enum imsm_update_type *) update->buf;
+       else return;

+       if (st)
+               super = st->sb;
+       else return;
+
+       if (super)
+               mpb = super->anchor;
+       else return;
+
+       switch (type) {
        case update_takeover: {
                struct imsm_update_takeover *u = (void *) update->buf;
                struct imsm_dev *dev = get_imsm_dev(super, u->array);
-
                /* calculate the new size for imsm dev */
                len = sizeof_imsm_dev(dev, 1);
                if (u->delta_disks > 0)
                        len += u->delta_disks * sizeof(struct imsm_disk);

                update->space = NULL;
-               break;
+               break;
        }

        case update_create_array: {
@@ -5665,6 +5804,7 @@ static void imsm_prepare_update(struct supertype *st,
                                update->space = dv;
                        else {
                                free(dv);
+                               dv = NULL;
                                update->space = NULL;
                        }
                }
diff --git a/sysfs.c b/sysfs.c
index ebf9d8a..cb57bff 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -51,6 +51,7 @@ void sysfs_free(struct mdinfo *sra)
                        struct mdinfo *d = sra->devs;
                        sra->devs = d->next;
                        free(d);
+                       d = NULL;
                }
                free(sra);
                sra = sra2;
@@ -104,8 +105,8 @@ struct mdinfo *sysfs_read(int fd, int devnum, unsigned long options)
        char buf[PATH_MAX];
        char *base;
        char *dbase;
-       struct mdinfo *sra;
-       struct mdinfo *dev;
+       struct mdinfo *sra = NULL;
+       struct mdinfo *dev = NULL;
        DIR *dir = NULL;
        struct dirent *de;

@@ -123,6 +124,7 @@ struct mdinfo *sysfs_read(int fd, int devnum, unsigned long options)
        base = fname + strlen(fname);

        sra->devs = NULL;
+       sra->next = NULL;
        if (options & GET_VERSION) {
                strcpy(base, "metadata_version");
                if (load_sys(fname, buf))
@@ -134,12 +136,12 @@ struct mdinfo *sysfs_read(int fd, int devnum, unsigned long options)
                } else if (strncmp(buf, "external:", 9) == 0) {
                        sra->array.major_version = -1;
                        sra->array.minor_version = -2;
-                       strcpy(sra->text_version, buf+9);
+                       strncpy(sra->text_version, buf+9, 50);
                } else {
                        sscanf(buf, "%d.%d",
                               &sra->array.major_version,
                               &sra->array.minor_version);
-                       strcpy(sra->text_version, buf);
+                       strncpy(sra->text_version, buf, 50);
                }
        }
        if (options & GET_LEVEL) {
@@ -244,7 +246,8 @@ struct mdinfo *sysfs_read(int fd, int devnum, unsigned long options)
                dev = malloc(sizeof(*dev));
                if (!dev)
                        goto abort;
-
+               memset(dev, 0, sizeof(*dev));
+
                /* Always get slot, major, minor */
                strcpy(dbase, "slot");
                if (load_sys(fname, buf)) {
@@ -256,6 +259,7 @@ struct mdinfo *sysfs_read(int fd, int devnum, unsigned long options)
                            errno != ENAMETOOLONG) {
                                /* ...yup device is gone */
                                free(dev);
+                               dev = NULL;
                                continue;
                        } else {
                                /* slot is unreadable but 'block' link
@@ -263,6 +267,7 @@ struct mdinfo *sysfs_read(int fd, int devnum, unsigned long options)
                                 * so abort
                                 */
                                free(dev);
+                               dev = NULL;
                                goto abort;
                        }

@@ -274,6 +279,7 @@ struct mdinfo *sysfs_read(int fd, int devnum, unsigned long options)
                strcpy(dbase, "block/dev");
                if (load_sys(fname, buf)) {
                        free(dev);
+                       dev = NULL;
                        if (options & SKIP_GONE_DEVS)
                                continue;
                        else
@@ -287,6 +293,7 @@ struct mdinfo *sysfs_read(int fd, int devnum, unsigned long options)
                        if (load_sys(fname, buf) == 0 &&
                            strncmp(buf, "offline", 7) == 0) {
                                free(dev);
+                               dev = NULL;
                                continue;
                        }
                }
@@ -394,7 +401,7 @@ unsigned long long get_component_size(int fd)
 int sysfs_set_str(struct mdinfo *sra, struct mdinfo *dev,
                  char *name, char *val)
 {
-       char fname[50];
+       char fname[60];
        int n;
        int fd;

@@ -440,7 +447,7 @@ int sysfs_uevent(struct mdinfo *sra, char *event)
 int sysfs_get_fd(struct mdinfo *sra, struct mdinfo *dev,
                       char *name)
 {
-       char fname[50];
+       char fname[60];
        int fd;

        sprintf(fname, "/sys/block/%s/md/%s/%s",
@@ -586,9 +593,12 @@ int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd, int resume)
                return -1;
        nm[rv] = '\0';
        dname = strrchr(nm, '/');
-       if (dname) dname++;
-       strcpy(sd->sys_name, "dev-");
-       strcpy(sd->sys_name+4, dname);
+       if (dname) {
+               dname++;
+               strcpy(sd->sys_name, "dev-");
+               strcpy(sd->sys_name+4, dname);
+       }
+       else return -1;

        /* test write to see if 'recovery_start' is available */
        if (resume && sd->recovery_start < MaxSector &&
@@ -712,18 +722,24 @@ int sysfs_disk_to_scsi_id(int fd, __u32 *id)
        c1 = strchr(de->d_name, ':');
        c1++;
        c2 = strchr(c1, ':');
-       *c2 = '\0';
-       *id = strtol(c1, NULL, 10) << 24; /* host */
-       c1 = c2 + 1;
-       c2 = strchr(c1, ':');
-       *c2 = '\0';
-       *id |= strtol(c1, NULL, 10) << 16; /* channel */
-       c1 = c2 + 1;
-       c2 = strchr(c1, ':');
-       *c2 = '\0';
-       *id |= strtol(c1, NULL, 10) << 8; /* lun */
-       c1 = c2 + 1;
-       *id |= strtol(c1, NULL, 10); /* id */
+       if (c2) {
+               *c2 = '\0';
+               *id = strtol(c1, NULL, 10) << 24; /* host */
+               c1 = c2 + 1;
+               c2 = strchr(c1, ':');
+               if (c2) {
+                       *c2 = '\0';
+                       *id |= strtol(c1, NULL, 10) << 16; /* channel */
+                       c1 = c2 + 1;
+                       c2 = strchr(c1, ':');
+                       if (c2) {
+                               *c2 = '\0';
+                               *id |= strtol(c1, NULL, 10) << 8; /* lun */
+                               c1 = c2 + 1;
+                               *id |= strtol(c1, NULL, 10); /* id */
+                       }
+               }
+       }

        return 0;
 }
diff --git a/util.c b/util.c
index 5feec43..ea74efe 100644
--- a/util.c
+++ b/util.c
@@ -244,12 +244,16 @@ int parse_layout_faulty(char *layout)
        int ln = strcspn(layout, "0123456789");
        char *m = strdup(layout);
        int mode;
-       m[ln] = 0;
-       mode = map_name(faultylayout, m);
-       if (mode == UnSet)
-               return -1;
+
+       if (m) {
+               m[ln] = 0;
+               mode = map_name(faultylayout, m);
+               if (mode == UnSet)
+                       return -1;

-       return mode | (atoi(layout+ln)<< ModeShift);
+               return mode | (atoi(layout+ln)<< ModeShift);
+       } else
+               return -1;
 }
 #endif

@@ -579,15 +583,19 @@ int add_dev(const char *name, const struct stat *stb, int flag, struct FTW *s)

        if ((stb->st_mode&S_IFMT)== S_IFBLK) {
                char *n = strdup(name);
-               struct devmap *dm = malloc(sizeof(*dm));
-               if (strncmp(n, "/dev/./", 7)==0)
-                       strcpy(n+4, name+6);
-               if (dm) {
-                       dm->major = major(stb->st_rdev);
-                       dm->minor = minor(stb->st_rdev);
-                       dm->name = n;
-                       dm->next = devlist;
-                       devlist = dm;
+               struct devmap *dm = NULL;
+
+               if (n != NULL) {
+                       dm = malloc(sizeof(*dm));
+                       if (strncmp(n, "/dev/./", 7)==0)
+                               strcpy(n+4, name+6);
+                       if (dm) {
+                               dm->major = major(stb->st_rdev);
+                               dm->minor = minor(stb->st_rdev);
+                               dm->name = n;
+                               dm->next = devlist;
+                               devlist = dm;
+                       }
                }
        }
        return 0;
@@ -633,8 +641,12 @@ char *map_dev(int major, int minor, int create)
                while(devlist) {
                        struct devmap *d = devlist;
                        devlist = d->next;
-                       free(d->name);
+                       if (d->name) {
+                               free(d->name);
+                               d->name = NULL;
+                       }
                        free(d);
+                       d = NULL;
                }
                if (lstat(dev, &stb)==0 &&
                    S_ISLNK(stb.st_mode))
@@ -803,6 +815,7 @@ static int mdp_major = -1;
                if (have_devices && strcmp(w, "mdp")==0)
                        mdp_major = last_num;
                free(w);
+               w = NULL;
        }
        fclose(fl);
        return mdp_major;
@@ -917,7 +930,7 @@ int dev_open(char *dev, int flags)

 int open_dev(int devnum)
 {
-       char buf[20];
+       char buf[30];

        sprintf(buf, "%d:%d", dev2major(devnum), dev2minor(devnum));
        return dev_open(buf, O_RDWR);
@@ -925,7 +938,7 @@ int open_dev(int devnum)

 int open_dev_excl(int devnum)
 {
-       char buf[20];
+       char buf[30];
        int i;

        sprintf(buf, "%d:%d", dev2major(devnum), dev2minor(devnum));
@@ -987,7 +1000,7 @@ struct supertype *super_by_fd(int fd)
        struct supertype *st = NULL;
        struct mdinfo *sra;
        char *verstr;
-       char version[20];
+       char version[30];
        int i;
        char *subarray = NULL;

@@ -1016,7 +1029,8 @@ struct supertype *super_by_fd(int fd)
                if (subarray)
                        *subarray++ = '\0';
                devnum = devname2devnum(dev);
-               subarray = strdup(subarray);
+               if (subarray)
+                       subarray = strdup(subarray);
                if (sra)
                        sysfs_free(sra);
                sra = sysfs_read(-1, devnum, GET_VERSION);
@@ -1030,13 +1044,17 @@ struct supertype *super_by_fd(int fd)
                st = superlist[i]->match_metadata_desc(verstr);

        if (sra)
+       {
                sysfs_free(sra);
+               sra = NULL;
+       }
        if (st) {
                st->sb = NULL;
                if (subarray) {
                        strncpy(st->subarray, subarray, 32);
                        st->subarray[31] = 0;
                        free(subarray);
+                       subarray = NULL;
                } else
                        st->subarray[0] = 0;
        }
@@ -1076,32 +1094,35 @@ struct supertype *guess_super(int fd)
        int i;

        st = malloc(sizeof(*st));
-       for (i=0 ; superlist[i]; i++) {
-               int rv;
-               ss = superlist[i];
-               memset(st, 0, sizeof(*st));
-               rv = ss->load_super(st, fd, NULL);
-               if (rv == 0) {
-                       struct mdinfo info;
-                       st->ss->getinfo_super(st, &info);
-                       if (bestsuper == -1 ||
-                           besttime < info.array.ctime) {
-                               bestsuper = i;
-                               besttime = info.array.ctime;
+       if (st)
+       {
+               for (i=0 ; superlist[i]; i++) {
+                       int rv;
+                       ss = superlist[i];
+                       memset(st, 0, sizeof(*st));
+                       rv = ss->load_super(st, fd, NULL);
+                       if (rv == 0) {
+                               struct mdinfo info;
+                               st->ss->getinfo_super(st, &info);
+                               if (bestsuper == -1 ||
+                                   besttime < info.array.ctime) {
+                                       bestsuper = i;
+                                       besttime = info.array.ctime;
+                               }
+                               ss->free_super(st);
                        }
-                       ss->free_super(st);
                }
-       }
-       if (bestsuper != -1) {
-               int rv;
-               memset(st, 0, sizeof(*st));
-               rv = superlist[bestsuper]->load_super(st, fd, NULL);
-               if (rv == 0) {
-                       superlist[bestsuper]->free_super(st);
-                       return st;
+               if (bestsuper != -1) {
+                       int rv;
+                       memset(st, 0, sizeof(*st));
+                       rv = superlist[bestsuper]->load_super(st, fd, NULL);
+                       if (rv == 0) {
+                               superlist[bestsuper]->free_super(st);
+                               return st;
+                       }
                }
+               free(st);
        }
-       free(st);
        return NULL;
 }

@@ -1337,7 +1358,7 @@ int add_disk(int mdfd, struct supertype *st,
        /* Add a device to an array, in one of 2 ways. */
        int rv;
 #ifndef MDASSEMBLE
-       if (st->ss->external) {
+       if ((st!=NULL) && (st->ss->external)) {
                if (info->disk.state & (1<<MD_DISK_SYNC))
                        info->recovery_start = MaxSector;
                else
@@ -1350,9 +1371,11 @@ int add_disk(int mdfd, struct supertype *st,
                                        break;
                        if (sd2 == NULL) {
                                sd2 = malloc(sizeof(*sd2));
-                               *sd2 = *info;
-                               sd2->next = sra->devs;
-                               sra->devs = sd2;
+                               if (sd2 != NULL) {
+                                       *sd2 = *info;
+                                       sd2->next = sra->devs;
+                                       sra->devs = sd2;
+                               }
                        }
                }
        } else
@@ -1404,10 +1427,10 @@ unsigned long long min_recovery_start(struct mdinfo *array)
 char *devnum2devname(int num)
 {
        char name[100];
-       if (num >= 0)
-               sprintf(name, "md%d", num);
+       if (num > 0)
+               snprintf(name, 100, "md%d", num);
        else
-               sprintf(name, "md_d%d", -1-num);
+               snprintf(name, 100, "md_d%d", -1-num);
        return strdup(name);
 }

@@ -1424,11 +1447,12 @@ int devname2devnum(char *name)

 int stat2devnum(struct stat *st)
 {
-       char path[30];
+       char path[50];
        char link[200];
        char *cp;
        int n;

+    if (st)
        if ((S_IFMT & st->st_mode) == S_IFBLK) {
                if (major(st->st_rdev) == MD_MAJOR)
                        return minor(st->st_rdev);
@@ -1580,11 +1604,20 @@ __u32 random32(void)
 int flush_metadata_updates(struct supertype *st)
 {
        int sfd;
+
+       if (!st) {
+               return -1;
+       }
+
        if (!st->updates) {
                st->update_tail = NULL;
                return -1;
        }

+       if (!st->container_dev) {
+               return -1;
+       }
+
        sfd = connect_monitor(devnum2devname(st->container_dev));
        if (sfd < 0)
                return -1;
@@ -1595,8 +1628,14 @@ int flush_metadata_updates(struct supertype *st)

                send_message(sfd, mu, 0);
                wait_reply(sfd, 0);
-               free(mu->buf);
-               free(mu);
+               if (mu->buf) {
+                       free(mu->buf);
+                       mu->buf = NULL;
+               }
+               if (mu) {
+                       free(mu);
+                       mu = NULL;
+               }
        }
        ack(sfd, 0);
        wait_reply(sfd, 0);
@@ -1610,12 +1649,14 @@ void append_metadata_update(struct supertype *st, void *buf, int len)

        struct metadata_update *mu = malloc(sizeof(*mu));

-       mu->buf = buf;
-       mu->len = len;
-       mu->space = NULL;
-       mu->next = NULL;
-       *st->update_tail = mu;
-       st->update_tail = &mu->next;
+       if (mu) {
+               mu->buf = buf;
+               mu->len = len;
+               mu->space = NULL;
+               mu->next = NULL;
+               *st->update_tail = mu;
+               st->update_tail = &mu->next;
+       }
 }
 #endif /* MDASSEMBLE */

--
1.6.0.2

