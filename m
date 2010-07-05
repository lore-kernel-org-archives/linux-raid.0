From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 03/33] Config option parsing for new DOMAIN line support.
Date: Mon, 5 Jul 2010 11:43:09 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC3DE@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C01@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C01@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Czarnowska, Anna
Sent: Monday, July 05, 2010 11:23 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowski, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciechanowski, Ed; dledford@redhat.com
Subject: [PATCH 03/33] Config option parsing for new DOMAIN line support.

From: Doug Ledford <dledford@redhat.com>

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 config.c |  260 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 mdadm.h  |   35 +++++++++
 util.c   |   43 ++++++++++
 3 files changed, 337 insertions(+), 1 deletions(-)

diff --git a/config.c b/config.c
index 20c46e9..10c10e2 100644
--- a/config.c
+++ b/config.c
@@ -75,7 +75,7 @@ char DefaultConfFile[] = CONFFILE;  char DefaultAltConfFile[] = CONFFILE2;

 enum linetype { Devices, Array, Mailaddr, Mailfrom, Program, CreateDev,
-           Homehost, AutoMode, LTEnd };
+           Homehost, AutoMode, Domain, LTEnd };
 char *keywords[] = {
      [Devices]  = "devices",
      [Array]    = "array",
@@ -85,6 +85,7 @@ char *keywords[] = {
      [CreateDev]= "create",
      [Homehost] = "homehost",
      [AutoMode] = "auto",
+     [Domain]   = "domain",
      [LTEnd]    = NULL
 };

@@ -694,6 +695,182 @@ void autoline(char *line)
      }
 }

+static struct domain_ent *domain_list = NULL;
+
+void free_domain(struct domain_ent *de) {
+     struct domain_path *dp;
+
+     while (de->paths) {
+           dp = de->paths;
+           de->paths = dp->next;
+           free(dp->path);
+           free(dp);
+     }
+     free(de);
+}
+
+void domainline(char *line)
+{
+     char *w;
+     struct domain_ent *de;
+     struct domain_path *path, *prev_path;
+     int offset, a_seen=0, m_seen=0, sg_seen=0;
+
+     de = malloc(sizeof(struct domain_ent));
+     if (!de) {
+           fprintf(stderr, Name ": unable to allocate memory for domain "
+                 "entry\n");
+           return;
+     }
+     de->paths = NULL;
+     de->spare_group = NULL;
+     de->action = incremental;
+     de->st = NULL;
+     de->next = NULL;
+
+     for (w=dl_next(line); w!=line; w=dl_next(w)) {
+           if (strncasecmp("path=", w, 5) == 0) {
+                 path = malloc(sizeof(struct domain_path));
+                 if (!path) {
+                       fprintf(stderr, Name ": unable to allocate "
+                             "memory for domain path\n");
+                       free_domain(de);
+                       return;
+                 }
+                 path->path = strdup(w+5);
+                 if (!path->path) {
+                       fprintf(stderr, Name ": unable to allocate "
+                             "memory for domain path\n");
+                       free_domain(de);
+                       return;
+                 }
+                 path->next = de->paths;
+                 de->paths = path;
+           } else if (strncasecmp("action=", w, 7) == 0) {
+                 if (!a_seen)
+                       a_seen = 1;
+                 else {
+                       fprintf(stderr, Name ": only one action= entry "
+                             "allowed per domain line, ignoring\n");
+                       continue;
+                 }
+                 offset = 7;
+                 if (strncasecmp("force-", w+offset, 6) == 0)
+                       offset = 13;
+                 if (strncasecmp("ign", w+offset, 3) == 0)
+                       de->action = ignore;
+                 else if (strncasecmp("inc", w+offset, 3) == 0)
+                       de->action = incremental;
+                 else if (strncasecmp("spa", w+offset, 3) == 0)
+                       de->action = spare;
+                 else if (strncasecmp("gro", w+offset, 3) == 0)
+                       de->action = grow;
+                 else if (strncasecmp("par", w+offset, 3) == 0)
+                       de->action = partition;
+                 if (offset == 13)
+                       de->action |= force;
+           } else if (strncasecmp("metadata=", w, 9) == 0) {
+                 int i;
+                 if (!m_seen)
+                       m_seen = 1;
+                 else {
+                       fprintf(stderr, Name ": only one metadata= "
+                             "entry allowed per domain line, "
+                             "ignoring\n");
+                       continue;
+                 }
+                 /* style of metadata on the devices. */
+
+                 for(i=0; superlist[i] && !de->st; i++)
+                       de->st = superlist[i]->match_metadata_desc(w+9);
+
+                 if (!de->st)
+                       fprintf(stderr, Name ": metadata format %s "
+                             "unknown, ignored.\n", w+9);
+           } else if (strncasecmp("spare-group=", w, 12) == 0) {
+                 if (!sg_seen)
+                       sg_seen = 1;
+                 else {
+                       fprintf(stderr, Name ": only one spare-group= "
+                             "entry allowed per domain line, "
+                             "ignoring\n");
+                       continue;
+                 }
+                 de->spare_group = strdup(w+12);
+                 if (!de->spare_group) {
+                       fprintf(stderr, Name ": failed to allocate "
+                             "memory for spare_group\n");
+                       free_domain(de);
+                       return;
+                 }
+           } else {
+                 fprintf(stderr, Name ": unrecognized option %s on "
+                       "domain line\n", w);
+           }
+     }
+     /* Some sanity checks now that all the options are parsed */
+     if ((de->action & force) &&
+         ((de->action & action_mask) <= incremental)) {
+           fprintf(stderr, Name ": force makes no sense with ignore or "
+                 "incremental, removing.\n");
+           de->action &= action_mask;
+     }
+     if (de->spare_group && de->action <= incremental) {
+           fprintf(stderr, Name ": defined a spare group when we aren't "
+                 "allowed to add any spares, removing spare group.\n");
+           free(de->spare_group);
+           de->spare_group = NULL;
+     }
+     if ((de->action & action_mask) == partition) {
+           for (prev_path = NULL, path = de->paths; path; )
+                 if ((strstr(path->path, "part") != NULL) ||
+                     (path->path[strlen(path->path) - 1] == '*')) {
+                       fprintf(stderr, Name ": partition method only "
+                             "allowed on whole disks, not on "
+                             "partitions\n");
+                       fprintf(stderr, Name ": bad path=%s\n",
+                             path->path);
+                       if (prev_path) {
+                             prev_path->next = path->next;
+                             free(path->path);
+                             free(path);
+                             path = prev_path->next;
+                       } else {
+                             de->paths = path->next;
+                             free(path->path);
+                             free(path);
+                             path = de->paths;
+                       }
+                 } else {
+                       prev_path = path;
+                       path = path->next;
+                 }
+           if (de->paths == NULL) {
+                 /* We freed all the paths, kill this domain */
+                 fprintf(stderr, Name ": no valid paths in domain, "
+                       "freeing.\n");
+                 free_domain(de);
+                 return;
+           }
+     }
+     de->next = domain_list;
+     domain_list = de;
+}
+
+struct domain_ent *get_domain_from_devpath(char *devpath) {
+     struct domain_ent *de;
+     struct domain_path *path;
+
+     for (de = domain_list; de; de = de->next)
+           for (path = de->paths; path; path = path->next)
+                 if (fnmatch(path->path, devpath, 0) == 0)
+                       return de;
+     return NULL;
+}
+
+
 int loaded = 0;

 static char *conffile = NULL;
@@ -766,6 +943,9 @@ void load_conffile(void)
            case AutoMode:
                  autoline(line);
                  break;
+           case Domain:
+                 domainline(line);
+                 break;
            default:
                  fprintf(stderr, Name ": Unknown keyword %s\n", line);
            }
@@ -1101,3 +1281,81 @@ struct mddev_ident_s *conf_match(struct mdinfo *info, struct supertype *st)
      }
      return match;
 }
+
+struct domain_ent *conf_get_domain(char *devname) {
+     char *name = strrchr(devname, '/');
+     char *path;
+     struct domain_ent *domain;
+
+     load_conffile();
+     if (!domain_list)
+           return NULL;
+     if (!name++)
+           name = devname;
+     path = get_devpath_from_devname(name);
+     if (!path)
+           return NULL;
+     domain = get_domain_from_devpath(path);
+     free(path);
+     return domain;
+}
+
+/*
+ * Return a linked list of arrays that are in the same domain as the
+ * constituent device devname.  So, if we have a domain that lists
+ports 2
+ * through 6 on the main SATA controller in a machine, and we plug in a
+ * new drive on port 6, we want to know what actual up and running
+arrays,
+ * as listed via /proc/mdstat, are also in the same domain.  We will
+use
+ * this information to determine what array we might add our new device
+ * to either as a replacement drive or as a hot spare.
+ */
+struct mdstat_ent *arrays_in_domain(char *devname, struct domain_ent
+*domain) {
+     struct mdstat_ent *me, *mdstat, *array_list = NULL;
+     struct dev_member *m;
+     struct domain_ent *de;
+     char *devpath, *mempath, *devpart, *mempart;
+
+     devpath = get_devpath_from_devname(devname);
+     devpart = strrchr(devpath, ':');
+     mdstat = mdstat_read(0, 0);
+     while (mdstat) {
+           if (mdstat->metadata_version &&
+               strncmp(mdstat->metadata_version, "external:", 9) == 0 &&
+               is_subarray(mdstat->metadata_version+9))
+                 /* don't return subarrays, only containers */
+                 m = NULL;
+           else for (m = mdstat->members; m; m = m->next) {
+                 mempath = get_devpath_from_devname(m->name);
+                 mempart = strrchr(mempath, ':');
+                 de = conf_get_domain(m->name);
+                 if (de == domain && strcmp(mempart, devpart) == 0)
+                       /* array has at least one member in our domain*/
+                       break;
+                 free(mempath);
+           }
+           if (m) {
+                 free(mempath);
+                 me = mdstat;
+                 mdstat = mdstat->next;
+                 me->next = array_list;
+                 array_list = me;
+           } else {
+                 me = mdstat;
+                 mdstat = mdstat->next;
+                 me->next = NULL;
+                 free_mdstat(me);
+           }
+     }
+     free(devpath);
+     return array_list;
+}
+
+int conf_get_domain_action(char *devname) {
+     struct domain_ent *domain = conf_get_domain(devname);
+     if (!domain)
+           return incremental;
+     return domain->action;
+}
diff --git a/mdadm.h b/mdadm.h
index d15e73e..4d5a630 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -277,6 +277,36 @@ enum special_options {
      DetailPlatform,
 };

+enum domain_actions {
+     ignore,
+     incremental,
+     partition, /* only use on whole devices in order to put a standard
+                 partition table on them, which will invoke new udev
+                 calls for the partitions, and then we will do other
+                 appropriate things with the partitions */
+     spare,
+     grow,
+     action_mask=511,
+     force=512, /* so we can bitwise & this with actions to signify we
+                 should forcibly take over drives even if they have
+                 other metadata on them */
+};
+
+struct domain_ent {
+     char              *spare_group; /* only set this in monitor mode
+                                   when we know what arrays we
+                                   are watching and can reconcile
+                                   them to domains by checking
+                                   constituent device paths */
+     struct domain_path {
+           char              *path;
+           struct domain_path      *next;
+     }                 *paths;
+     int               action;
+     struct supertype  *st;
+     struct domain_ent *next;
+};
+
 /* structures read from config file */
 /* List of mddevice names and identifiers
  * Identifiers can be:
@@ -854,6 +884,10 @@ extern int same_dev(char *one, char *two);  extern int parse_auto(char *str, char *msg, int config);  extern mddev_ident_t conf_get_ident(char *dev);  extern mddev_dev_t conf_get_devs(void);
+extern struct domain_ent *conf_get_domain(char *devname); extern int
+conf_get_domain_action(char *devname); extern struct mdstat_ent
+*arrays_in_domain(char *devname,
+                                struct domain_ent *domain);
 extern int conf_test_dev(char *devname);  extern int conf_test_metadata(const char *version, int is_homehost);  extern struct createinfo *conf_get_create_info(void); @@ -930,6 +964,7 @@ extern char *devnum2devname(int num);  extern int devname2devnum(char *name);  extern int stat2devnum(struct stat *st);  extern int fd2devnum(int fd);
+extern char *get_devpath_from_devname(char *devname);

 static inline int dev2major(int d)
 {
diff --git a/util.c b/util.c
index 8315200..1793b68 100644
--- a/util.c
+++ b/util.c
@@ -1679,3 +1679,46 @@ void append_metadata_update(struct supertype *st, void *buf, int len)  unsigned int __invalid_size_argument_for_IOC = 0;  #endif

+/*
+ * Resolve from a device name, such as /dev/sdb2, to a device path,
+such
+ * as pci-0000:00:1f.2-scsi-1:0:0:0-part2 which can then be used to
+match
+ * against paths in DOMAIN lines from the config file  */ char
+*get_devpath_from_devname(char *devname) {
+     char *name = strrchr(devname, '/'), *link;
+     DIR *by_path;
+     struct dirent *ent;
+     char symlink[PATH_MAX] = "/dev/disk/by-path/";
+     char *symlinkp, target[PATH_MAX];
+     int read;
+
+     if (!name++)
+           name = devname;
+     if ((by_path = opendir("/dev/disk/by-path")) == NULL) {
+           fprintf(stderr, Name ": unable to open /dev/disk/by-path, "
+                 "domain lookups not possible\n");
+           return NULL;
+     }
+     symlinkp = &symlink[0] + strlen(symlink);
+     while ((ent = readdir(by_path)) != NULL) {
+           if (ent->d_type != DT_LNK)
+                 continue;
+           strncpy(symlinkp, ent->d_name,
+                 sizeof(symlink) - (symlinkp - &symlink[0]));
+           read = readlink(symlink, target, sizeof(target));
+           if (read < 0)
+                 continue;
+           /* Have to null terminate the return */
+           target[read] = 0;
+           link = strrchr(target, '/');
+           if (!link++)
+                 link = target;
+           if (strcmp(name, link) == 0) {
+                 closedir(by_path);
+                 return strdup(ent->d_name);
+           }
+     }
+     closedir(by_path);
+     return NULL;
+}
--
1.6.4.2


