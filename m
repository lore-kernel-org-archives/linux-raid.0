From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 34/35] Incremental for bare disks, checking routine +
 integration
Date: Mon, 16 Aug 2010 11:04:33 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8FA25@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From b418084ae2f1eaaa509ec4584c56395653a45a91 Mon Sep 17 00:00:00 2001
From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Date: Wed, 14 Jul 2010 16:50:09 +0200
Subject: [PATCH 34/35] Incremental for bare disks, checking routine + integration

The idea of this patch is to allow adding of bare device to the container
if device is plugged into the same port as recently removed device.
Function 'bare_disk_match_array' has been added to look for special 'cookie'
file (named after udev's path-id of device) containing the
uuid of valid array. If it is found, container device name is returned.
This container is used with Manage_subdevs() add, to add device.
As in udev add rule /dev/by-path/... links are not yet available, use
command line parameter --path to provide path-id in udev rule.
---
 Incremental.c       |  205 ++++++++++++++++++++++++++++++++++++++++----------
 Manage.c            |   53 +++++++------
 config.c            |   22 ++++--
 mdadm.c             |    4 +-
 mdadm.h             |    9 ++-
 udev-early-md.rules |    2 +-
 6 files changed, 217 insertions(+), 78 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 9d63a86..6737642 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -29,16 +29,91 @@
  */

 #include       "mdadm.h"
+#include       <sys/types.h>
+#include       <dirent.h>

 static int count_active(struct supertype *st, int mdfd, char **availp,
                        struct mdinfo *info);
 static void find_reject(int mdfd, struct supertype *st, struct mdinfo *sra,
                        int number, __u64 events, int verbose,
                        char *array_name);
-static int IncrementalNewPart(char *devname, int verbose, int export,
-                             struct domain_ent *domain);
-static int IncrementalNewDisk(char *devname, int verbose, int export,
-                             struct domain_ent *domain);
+static int IncrementalNewPart(char *devname, char *devpath, int verbose,
+                             int export, struct domain_ent *domain);
+static int IncrementalNewDisk(char *devname, char *devpath, int verbose,
+                             int export, struct domain_ent *domain);
+
+
+
+/* finds cookie file with matching path. If found, returns device name
+ * either for this array (native) or its parent container (external)
+ */
+char *bare_disk_match_array(char *devname, char *devpath, int fd,
+                           struct supertype **st)
+{
+       char cookie_path[PATH_MAX];
+       FILE *cookie;
+       char *mdname = NULL;
+       struct map_ent *map, *ment;
+
+       if (!devname || !devpath)
+               return NULL;
+
+       map_read(&map);
+       if (!map)
+               return NULL;
+
+       snprintf(cookie_path, PATH_MAX, FAILED_SLOTS "/%s", devpath);
+       if ((cookie = fopen(cookie_path, "r")) == NULL) {
+               fprintf(stderr, Name " : Cannot open %s cookie. "
+                                    "Bare disk spare action disabled\n.",
+                       cookie_path);
+               return NULL;
+       }
+
+       /*
+        * find first active array using list instde 'cookie' file
+        */
+       while(fgets(cookie_path, PATH_MAX, cookie)) {
+               int uuid[4];
+               if (sscanf(cookie_path, "%08x:%08x:%08x:%08x", &uuid[0], &uuid[1],
+                          &uuid[2], &uuid[3]) != 4)
+                       continue;
+               ment = map_by_uuid(&map, uuid);
+               if (ment) /* found active array */
+                       break;
+       }
+       if (ment) {
+               struct map_ent *parent = NULL;
+               char *md_path;
+               int mdfd;
+               if (is_subarray(ment->metadata)) {
+                       parent = map_get_parent(ment);
+                       if (!parent) {
+                               fprintf(stderr, Name " : Cannot find parent "
+                                               "container for array %s\n.",
+                                       ment->path);
+                               goto cleanup;
+                       }
+                       md_path = strdup(parent->path);
+                       map_free(parent);
+               } else {
+                       md_path = strdup(parent->path);
+               }
+               mdfd = open_mddev(md_path, 0);
+               if (mdfd < 0)
+                       goto cleanup;
+               *st = guess_super(mdfd);
+               close(mdfd);
+               if (!*st)
+                       goto cleanup;
+               mdname = md_path;
+       }
+
+cleanup:
+       fclose(cookie);
+       map_free(map);
+       return mdname;
+}

 int Incremental(char *devname, int verbose, int runstop,
                struct supertype *st, char *homehost, int require_homehost,
@@ -1056,23 +1131,36 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
  * have a domain that says not to partition the device, so we will either
  * use the whole disk or the partition directly.
  */
-static int IncrementalNewPart(char *devname, int verbose, int export,
-                             struct domain_ent *domain)
+static int IncrementalNewPart(char *devname, char *devpath, int verbose,
+                             int export, struct domain_ent *domain)
 {
        struct mdstat_ent *mdstat, *md;
        struct stat stb;
        int dfd;
+       struct supertype *st = NULL;
+       char *mdname;
+       int mdfd;
+       int rv = 0;
+       struct mddev_dev_s devlist;

-       mdstat = arrays_in_domain(devname, domain);
+       mdstat = arrays_in_domain(devname, devpath, domain);
        for (md = mdstat; md; md = md->next)
                printf(Name ": %s\n", md->dev);
+
+       /* any arrays for this domain? */
+       if (!mdstat) {
+               fprintf(stderr, Name " : no arrays in this domain.\n");
+               return 1;
+       }
        /* We've finished with the easy tests that allow us to kick drives
         * out without touching actual physical media, now we need to start
         * the slower checks.
         */
        dfd = dev_open_check(devname, O_RDONLY|O_EXCL, &stb);
-       if (dfd < 0)
+       if (dfd < 0) {
+               fprintf(stderr, Name ": cannot open %s exclusively.\n", devname);
                return 1;
+       }
        if (guess_super(dfd) != NULL) {
                /* This won't happen with our udev rules, but someone might
                 * try this by hand, make them use normal incremental mode
@@ -1090,7 +1178,37 @@ static int IncrementalNewPart(char *devname, int verbose, int export,
         * or 0xff.
         */

-       return 0;
+       /* for bare action, check if 'cookie' exists for this device,
+        * temporarily get metadata from matching array and invoke standard
+        * Incremental with bare=1
+        */
+       if (conf_get_domain_action(domain) == same_port_bare &&
+           !strstr(devname, "part") && printf("%s\n", devpath)>0 &&
+           (mdname = bare_disk_match_array(devname, devpath, dfd, &st)) &&
+           !strcmp(st->ss->name, domain->platform)) {
+               free(st);
+               mdfd = open_mddev(mdname, 0);
+               if (!mdfd) {
+                       fprintf(stderr, Name ": cannot open array device %s.\n", mdname);
+                       close(dfd);
+                       return 1;
+               }
+               close(dfd);
+               memset(&devlist, 0, sizeof(devlist));
+               devlist.devname = devname;
+               devlist.disposition = 'a';
+               devlist.skip_domain = 1;
+               rv = Manage_subdevs(mdname, mdfd, &devlist, 0);
+               if (!rv && export)
+                       printf("MD_OWNED=1");
+               free(mdname);
+               mdname = NULL;
+               close(mdfd);
+               return rv;
+       }
+       free(mdname);
+       close(dfd);
+       return 1;
 }

 /*
@@ -1101,8 +1219,8 @@ static int IncrementalNewPart(char *devname, int verbose, int export,
  * repartition devs with stuff already on them only if the force option
  * is present on our domain.
  */
-static int IncrementalNewDisk(char *devname, int verbose, int export,
-                             struct domain_ent *domain)
+static int IncrementalNewDisk(char *devname, char *devpath, int verbose,
+                             int export, struct domain_ent *domain)
 {
        struct stat stb;
        int dfd, rv;
@@ -1121,7 +1239,7 @@ static int IncrementalNewDisk(char *devname, int verbose, int export,

        if (domain->handler->check_table(dfd, verbose, export, domain) == 0) {
                close(dfd);
-               return 0;
+               return 1;
        }
        /*
         * OK, at this point we have a valid block device without a
@@ -1152,37 +1270,42 @@ static int IncrementalNewDisk(char *devname, int verbose, int export,
  * device we may need to partition it and set it up for the partitions to
  * be added to various arrays later on in the hot plug process.
  */
-int IncrementalNew(char *devname, int verbose, int export)
+int IncrementalNew(char *devname, char *path, int verbose, int export)
 {
        struct domain_ent *domain;
-       char *devpath;
-       int rv;
-
-       domain = conf_get_domain(devname, NULL);
-       if (!domain)
-               return 0;
-       if (action(domain) <= incremental)
-               /* Nothing to do.  We only get called in the case that there
-                * is no current superblock on the device in question, and
-                * since our matching domain says we should either ignore or
-                * use devices incrementally, they have to already have a
-                * superblock.  Since we don't, we're done.
-                */
-               return 0;
-       devpath = get_devpath_from_devname(devname);
-       if (strstr(devpath, "part") || action(domain) != partition)
-               /* We are on a partition, not a whole disk, or we are on a
-                * whole disk but we want to use the whole disk instead
-                * of partitioning it */
-               rv = IncrementalNewPart(devname, verbose, export, domain);
-       else
-               /* Only use this if we are dealing with a disk that would
-                * need partitioned.  This will get called even when our
-                * disk actually already belongs to all the right arrays
-                * and there is nothing to be done, so only do work here
-                * if we really need to */
-               rv = IncrementalNewDisk(devname, verbose, export, domain);
-       free(devpath);
+       int rv = 1;
+       int i;
+
+       for (i = 0; superlist[i]; i++) {
+               domain = get_domain_from_devpath(path, (char *)superlist[i]->name);
+               /* domain = conf_get_domain(devname, (char *)superlist[i]->name);*/
+               if (!domain) {
+                       fprintf(stderr, Name ": cannot obtain domain for %s\n", devname);
+                       return 1;
+               }
+               if (action(domain) <= incremental)
+                       /* Nothing to do.  We only get called in the case that there
+                       * is no current superblock on the device in question, and
+                       * since our matching domain says we should either ignore or
+                       * use devices incrementally, they have to already have a
+                       * superblock.  Since we don't, we're done.
+                       */
+                       continue;
+               if (strstr(path, "part") || action(domain) != partition)
+                       /* We are on a partition, not a whole disk, or we are on a
+                       * whole disk but we want to use the whole disk instead
+                       * of partitioning it */
+                       rv = IncrementalNewPart(devname, path, verbose, export, domain);
+               else
+                       /* Only use this if we are dealing with a disk that would
+                       * need partitioned.  This will get called even when our
+                       * disk actually already belongs to all the right arrays
+                       * and there is nothing to be done, so only do work here
+                       * if we really need to */
+                       rv = IncrementalNewDisk(devname, path, verbose, export, domain);
+               if (!rv)
+                       break;
+       }
        return rv;
 }

diff --git a/Manage.c b/Manage.c
index e733c2d..714fea4 100644
--- a/Manage.c
+++ b/Manage.c
@@ -539,31 +539,36 @@ int Manage_subdevs(char *devname, int fd,

                        st = dup_super(tst);

-                       devdomain = conf_get_domain(dv->devname,
-                                                   (char *)st->ss->name);
-                       if (!devdomain) {
-                               fprintf(stderr, Name " : Cannot determine domain "
-                                                    " of device: %s\n", dv->devname);
-                               close(tfd);
-                               free(st);
-                               return 1;
-                       }
-                       devsubset = conf_get_subset(dv->devname, st, devdomain);
-                       if (!devsubset) {
-                               fprintf(stderr, Name " : Cannot determine subset "
-                                                    " of device: %s\n", dv->devname);
-                               close(tfd);
-                               free(st);
-                               return 1;
-                       }
-                       if (arrdomain != devdomain ||
-                           arrsubset != devsubset) {
-                               fprintf(stderr, Name " : Domain/subdomain of "
-                                                    "disk differs of arrays'.");
-                               close(tfd);
-                               free(st);
-                               return 1;
+                       /* domain links are not available before udev finishes
+                        * especially for temporary devices */
+                       if (!devlist->skip_domain) {
+                               devdomain = conf_get_domain(dv->devname,
+                                                       (char *)st->ss->name);
+                               if (!devdomain) {
+                                       fprintf(stderr, Name " : Cannot determine domain "
+                                                       " of device: %s\n", dv->devname);
+                                       close(tfd);
+                                       free(st);
+                                       return 1;
+                               }
+                               devsubset = conf_get_subset(dv->devname, st, devdomain);
+                               if (!devsubset) {
+                                       fprintf(stderr, Name " : Cannot determine subset "
+                                                       " of device: %s\n", dv->devname);
+                                       close(tfd);
+                                       free(st);
+                                       return 1;
+                               }
+                               if (arrdomain != devdomain ||
+                               arrsubset != devsubset) {
+                                       fprintf(stderr, Name " : Domain/subdomain of "
+                                                       "disk differs of arrays'.");
+                                       close(tfd);
+                                       free(st);
+                                       return 1;
+                               }
                        }
+
                        if (array.not_persistent==0)
                                st->ss->load_super(st, tfd, NULL);

diff --git a/config.c b/config.c
index 5829182..26e9910 100644
--- a/config.c
+++ b/config.c
@@ -827,6 +827,9 @@ void domainline(char *line)
                                de->action = grow;
                        else if (strncasecmp("par", w+offset, 3) == 0)
                                de->action = partition;
+                       else if (strncasecmp("bar", w+offset, 3) == 0 ||
+                                strncasecmp("sam", w+offset, 3) == 0)
+                               de->action = same_port_bare;
                        if (offset == 13)
                                de->action |= force;
                } else if (strncasecmp("metadata=", w, 9) == 0) {
@@ -1046,7 +1049,7 @@ struct domain_ent *get_domain_from_devpath(char *devpath, char *platform)
                                st = get_supertype_by_name(de->platform);
                                if (!st)
                                        continue;
-
+
                                if (match_platform(st, platform)) {
                                        st->ss->free_super(st);
                                        free(st);
@@ -1902,15 +1905,20 @@ exit:
  * this information to determine what array we might add our new device
  * to either as a replacement drive or as a hot spare.
  */
-struct mdstat_ent *arrays_in_domain(char *devname, struct domain_ent *domain)
+struct mdstat_ent *arrays_in_domain(char *devname, char *devpath,
+                                   struct domain_ent *domain)
 {
        struct mdstat_ent *me, *mdstat, *array_list = NULL;
        struct dev_member *m;
        struct domain_ent *de;
-       char *devpath, *mempath, *devpart, *mempart;
+       char *mempath, *devpart, *mempart;
        struct supertype *st;
+       int freepath = devpath ? 0 : 1;

-       devpath = get_devpath_from_devname(devname);
+       fprintf(stderr, "%s entry\n", __FUNCTION__);
+
+       if (!devpath)
+               devpath = get_devpath_from_devname(devname);
        devpart = strrchr(devpath, ':');
        mdstat = mdstat_read(0, 0);
        while (mdstat) {
@@ -1943,13 +1951,13 @@ struct mdstat_ent *arrays_in_domain(char *devname, struct domain_ent *domain)
                        free_mdstat(me);
                }
        }
-       free(devpath);
+       if (freepath)
+               free(devpath);
        return array_list;
 }

-int conf_get_domain_action(char *devname)
+int conf_get_domain_action(struct domain_ent *domain)
 {
-       struct domain_ent *domain = conf_get_domain(devname, NULL);
        if (!domain)
                return incremental;
        return domain->action;
diff --git a/mdadm.c b/mdadm.c
index 8d7e901..078a342 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1575,8 +1575,8 @@ int main(int argc, char *argv[])
                        rv = IncrementalRemove(devlist->devname, remove_path, verbose-quiet);
                        free(remove_path);
                } else if (new_disk > 0)
-                       rv = IncrementalNew(devlist->devname, verbose-quiet,
-                                           export);
+                       rv = IncrementalNew(devlist->devname, remove_path,
+                                           verbose - quiet, export);
                else
                        rv = Incremental(devlist->devname, verbose-quiet,
                                         runstop, ss, homehost,
diff --git a/mdadm.h b/mdadm.h
index 316dec2..468f9c1 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -296,6 +296,7 @@ enum domain_actions {
                      appropriate things with the partitions */
        spare,
        grow,
+       same_port_bare,
        action_mask=511,
        force=512, /* so we can bitwise & this with actions to signify we
                      should forcibly take over drives even if they have
@@ -405,6 +406,7 @@ typedef struct mddev_dev_s {
        char writemostly;       /* 1 for 'set writemostly', 2 for 'clear writemostly' */
        char re_add;
        char used;              /* set when used */
+       char skip_domain;       /* do not check domains, effective for add */
        struct mdinfo *content; /* If devname is a container, this might list
                                 * the remaining member arrays. */
        struct mddev_dev_s *next;
@@ -909,7 +911,7 @@ extern int Incremental_container(struct supertype *st, char *devname,
 extern void RebuildMap(void);
 extern int IncrementalScan(int verbose);
 extern int IncrementalRemove(char *devname, char *path, int verbose);
-extern int IncrementalNew(char *devname, int verbose, int export);
+extern int IncrementalNew(char *devname, char *path, int verbose, int export);
 extern int CreateBitmap(char *filename, int force, char uuid[16],
                        unsigned long chunksize, unsigned long daemon_sleep,
                        unsigned long write_behind,
@@ -942,11 +944,12 @@ extern int same_dev(char *one, char *two);
 extern int parse_auto(char *str, char *msg, int config);
 extern mddev_ident_t conf_get_ident(char *dev);
 extern mddev_dev_t conf_get_devs(void);
+extern struct domain_ent *get_domain_from_devpath(char *devpath, char *platform);
 extern struct domain_ent *conf_get_domain(char *devname, char *platform);
 extern struct subset *conf_get_subset(char *devname, struct supertype *st,
                                      struct domain_ent *domain);
-extern int conf_get_domain_action(char *devname);
-extern struct mdstat_ent *arrays_in_domain(char *devname,
+extern int conf_get_domain_action(struct domain_ent *domain);
+extern struct mdstat_ent *arrays_in_domain(char *devname, char *devpath,
                                           struct domain_ent *domain);
 extern struct subset *conf_get_any_subset(void);
 extern int conf_test_dev(char *devname);
diff --git a/udev-early-md.rules b/udev-early-md.rules
index 176ad61..4de2128 100644
--- a/udev-early-md.rules
+++ b/udev-early-md.rules
@@ -16,7 +16,7 @@ ENV{ID_FS_TYPE}=="linux_raid_member", GOTO="md_end"
 # do something with this device if it determines that it should own it.
 # That allows us to program in whatever smarts are needed into mdadm,
 # but at the expense of running mdadm on every blk device add|change event :-(
-IMPORT{program}="/sbin/mdadm -I --new-device $tempnode"
+IMPORT{program}="/sbin/mdadm -IYg $tempnode --path $env{ID_PATH}"
 ENV{MD_OWNED}!="?*", GOTO="md_end"
 # We owned the device, so have udev reset the database info in case we
 # changed it
--
1.6.4.2

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

