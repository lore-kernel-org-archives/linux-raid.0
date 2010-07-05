From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 09/33] processing of domain entries made after config is
 loaded
Date: Mon, 5 Jul 2010 11:45:28 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC3F8@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C0A@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C0A@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Czarnowska, Anna
Sent: Monday, July 05, 2010 11:24 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowski, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciechanowski, Ed; dledford@redhat.com
Subject: [PATCH 09/33] processing of domain entries made after config is loaded

From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>

For each metadata type default domain is added; for each domain line without specified metadata, entry is cloned for all types of metadata.
For each domain line specific configuration data is updated with data provided by appropriate metadata handler.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 Incremental.c |    2 +-
 config.c      |  301 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 mdadm.h       |   11 ++-
 mdstat.c      |   40 +++++++-
 util.c        |   99 +++++++++++++++++++
 5 files changed, 425 insertions(+), 28 deletions(-)

diff --git a/Incremental.c b/Incremental.c index ca70a35..3501bc1 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1000,7 +1000,7 @@ int IncrementalNew(char *devname, int verbose, int export)
      char *devpath;
      int rv;

-     domain = conf_get_domain(devname);
+     domain = conf_get_domain(devname, NULL);
      if (!domain)
            return 0;
      if (action(domain) <= incremental)
diff --git a/config.c b/config.c
index 248c1c1..6c90d26 100644
--- a/config.c
+++ b/config.c
@@ -710,6 +710,13 @@ void free_domain_path_list(struct domain_path *dp_head)
      }
 }

+void free_subset(struct subset *s)
+{
+     free_domain_path_list(s->paths);
+     free(s->spare_group);
+     free(s);
+}
+
 void free_subset_list(struct subset *s)  {
      struct subset *s_tmp;
@@ -717,11 +724,7 @@ void free_subset_list(struct subset *s)
      while(s) {
            s_tmp = s;
            s = s->next;
-           if (s_tmp->paths)
-                 free_domain_path_list(s_tmp->paths);
-           if (s_tmp->spare_group)
-                 free(s_tmp->spare_group);
-           free(s_tmp);
+           free_subset(s_tmp);
      }
      free(s);
 }
@@ -730,12 +733,9 @@ void free_domain(struct domain_ent *de)  {
      free_domain_path_list(de->paths);
      free_subset_list(de->subsets);
-     if (de->spare_group)
-           free(de->spare_group);
-     if (de->table)
-           free(de->table);
-     if (de->platform)
-           free(de->platform);
+     free(de->spare_group);
+     free(de->table);
+     free(de->platform);
      free(de);
 }

@@ -845,11 +845,11 @@ void domainline(char *line)
                  for(i=0; superlist[i] && !st; i++)
                        st = superlist[i]->match_metadata_desc(w+9);

-                 if (!st) {
+                 if (!st)
                        fprintf(stderr, Name ": metadata format %s "
                              "unknown, ignored.\n", w+9);
+                 else
                        de->platform = strdup(w+9);
-                 }
            } else if (strncasecmp("spare-group=", w, 12) == 0) {
                  if (!sg_seen)
                        sg_seen = 1;
@@ -990,19 +990,51 @@ int match_domain_path(struct domain_path *path, char *devpath)
      return 0;
 }

+/* returns supertype associated with superblock described by platform
+*/ static struct supertype *get_supertype_by_name(char *platform) {
+     struct supertype *st;
+     int i;
+
+     for (i = 0; superlist[i]; i++)
+           if ((st = superlist[i]->match_metadata_desc(platform)))
+                 return st;
+
+     return NULL;
+}
+
 /* returns domain basing on path matching and superblock type (in that order).
  * If st==NULL, just match paths.
  */
-struct domain_ent *get_domain_from_devpath(char *devpath)
+struct domain_ent *get_domain_from_devpath(char *devpath, char
+*platform)
 {
      struct domain_ent *de;
+     struct supertype *st;

      if (!devpath)
            return NULL;
+     if (platform && !strncmp(platform, "external:", 9))
+           platform += 9;

      for (de = domain_list; de; de = de->next) {
-           if (match_domain_path(de->paths, devpath))
+           if (match_domain_path(de->paths, devpath)) {
+                 if (platform) {
+                       /* do not match platform descriptions directly
+                       * but use match_metadata_desc to do so */
+                       st = get_supertype_by_name(de->platform);
+                       if (!st)
+                             continue;
+                       if (st->ss->match_metadata_desc(platform)) {
+                             st->ss->free_super(st);
+                             free(st);
+                             return de;
+                       }
+                       st->ss->free_super(st);
+                       free(st);
+                 } else { /* match only path, not platform */
                        return de;
+                 }
+           }
      }
      return NULL;
 }
@@ -1141,8 +1173,7 @@ static struct subset *duplicate_subset_list(struct subset *s)
      return ss_new_head;
 }

-/* static will be enabled when function will be used in domain code */ -/*static*/ struct domain_ent *duplicate_domain(struct domain_ent *de)
+static struct domain_ent *duplicate_domain(struct domain_ent *de)
 {
      struct domain_ent *de_new = create_domain_entry();

@@ -1190,6 +1221,109 @@ fail_exit:
      return NULL;
 }

+/* duplicates de entry for all platforms available */ static void
+domain_make_platforms(struct domain_ent *de) {
+     int i;
+     struct domain_ent *de_new;
+     char *name;
+
+     if (!de)
+           return;
+
+     for (i = 0; superlist[i]; i++) {
+           name = strdup(superlist[i]->name);
+           /* fixes ss->name for match_metadata_desc for 1.x superblock */
+           if (!strcmp(name, "1.x"))
+                 name[2] = '0';
+           if (superlist[i + 1]) { /* not the last entry */
+                 if (!(de_new = duplicate_domain(de))) {
+                       free_domain_list(&domain_list);
+                       return;
+                 }
+                 free(de->platform);
+                 de->platform = strdup(name);
+                 de = de_new;
+           } else {
+                 de->platform = name;
+           }
+     }
+}
+
+/* adds "default" domain that mathes "any" data
+ * it gives consistent domain searching model for all purposes */
+static void add_default_domain(void) {
+     struct domain_ent *de;
+
+     de = create_domain_entry();
+     if (!de) {
+           free_domain_list(&domain_list);
+           return;
+     }
+
+     /* 'any' metadata */
+     de->platform = NULL;
+     /* 'any' path */
+     de->paths = NULL;
+     /* no platform domains: 'any' subset */
+     de->subsets = conf_get_any_subset();
+     /* default action: incremental */
+     de->action = incremental;
+     de->next = NULL;
+
+     /* add at the end */
+     de->next = NULL;
+     *dl_end = de;
+     dl_end = &de->next;
+}
+
+/* flag if domains are processed */
+static int processed = 0;
+
+/* Expands domain entities to maintain one domain for one platform, ie.
+ * multiplicate domain entities for those with undefined platform. Then
+ * extends them by adding platform subsets. For platforms not
+supporting
+ * platform limits, use subset matching 'any'
+ */
+static void process_domains(void)
+{
+     struct domain_ent *de;
+     struct subset *ss;
+     struct supertype *st;
+
+     if (processed)
+           return;
+
+     /* append default domain */
+     add_default_domain();
+
+     /* first step: clone domains for platform=any */
+     for (de = domain_list; de; de = de->next)
+           if (!de->platform) /* platform = any */
+                 domain_make_platforms(de);
+
+     /* second step: ask for platfrom subsets */
+     for (de = domain_list; de; de = de->next) {
+           st = get_supertype_by_name(de->platform);
+           if (!st)
+                 continue;
+           if (!force(de) && st->ss->platform_domain) {
+                 ss = st->ss->platform_domain(st);
+                 if (!ss)
+                       return;
+                 if (de->subsets)
+                       free_subset_list(de->subsets);
+                 de->subsets = ss;
+           }
+
+           /* force flag used or empty platform_domain handler */
+           if (de->subsets == NULL)
+                 de->subsets = conf_get_any_subset();
+     }
+     processed = 1;
+}
+
 int loaded = 0;

 static char *conffile = NULL;
@@ -1208,6 +1342,7 @@ void load_conffile(void)
            conffile = DefaultConfFile;

      if (strcmp(conffile, "none") == 0) {
+           process_domains();
            loaded = 1;
            return;
      }
@@ -1217,6 +1352,7 @@ void load_conffile(void)
            dl_add(list, dl_strdup("partitions"));
            devline(list);
            free_line(list);
+           process_domains();
            loaded = 1;
            return;
      }
@@ -1232,8 +1368,10 @@ void load_conffile(void)
            if (f)
                  conffile = DefaultAltConfFile;
      }
-     if (f == NULL)
+     if (f == NULL) {
+           process_domains();
            return;
+     }

      loaded = 1;
      while ((line=conf_line(f))) {
@@ -1273,6 +1411,8 @@ void load_conffile(void)

      fclose(f);

+     /* refine domain structures to simplify matching */
+     process_domains();
 /*    printf("got file\n"); */
 }

@@ -1601,7 +1741,18 @@ struct mddev_ident_s *conf_match(struct mdinfo *info, struct supertype *st)
      return match;
 }

-struct domain_ent *conf_get_domain(char *devname)
+/* It searches domain list to match path and st with devname and st.
+ * If path is NULL then any devname matches; since each domain has its
+owner
+ * supertype (st), we always require domain->st == st.
+ * If no domain_ent matches we add default domain_ent with default
+action and
+ * given supertype, path = NULL
+ * Entries are listed from most to least specific, the default domain
+are added
+ * at the end of the list.
+ * Overlapping paths are not detected nor properly served for the same
+ * supertypes. However, they may exists for different platform keywords.
+ * Since, the domains list is ordered, the first match found is returned.
+ */
+struct domain_ent *conf_get_domain(char *devname, char *platform)
 {
      char *name = strrchr(devname, '/');
      char *path;
@@ -1615,11 +1766,110 @@ struct domain_ent *conf_get_domain(char *devname)
      path = get_devpath_from_devname(name);
      if (!path)
            return NULL;
-     domain = get_domain_from_devpath(path);
+     domain = get_domain_from_devpath(path, platform);
      free(path);
      return domain;
 }

+/* matches subset according to rules below returning appropriate flag
+*/ int match_subset(struct subset *ss, char *devpath, char
+*spare_group) {
+     int found_path = 0;
+     int found_group = 0;
+
+     /* path matching */
+     if (ss->paths)
+           found_path = match_domain_path(ss->paths, devpath);
+     else
+           found_path = 1;
+
+     /* spare_group matching */
+     if (ss->spare_group) {
+           if (spare_group)
+                 if (!strcmp(ss->spare_group, spare_group))
+                       found_group = 1;
+     } else { /* ony both NULL gives match */
+           if (!spare_group)
+                 found_group = 1;
+     }
+
+     return (found_path & found_group);
+}
+
+/* Searches the subset list in domain to match:
+ * TRUE==fnpath(path, devname) and (spare_group
+==st->ss->get_spare_group(st))
+ * Therefore, one of: path or spare_group must match or subset must be "anymatch".
+ * Note:
+ * Domain->subset->spare_group == NULL means that DOMAIN line does not
+specify
+ * spare group.
+ * config_get_domain will add new entry on the subset list if
+ * st->ss->get_spare_group(st) return non-NULL value and domian. It
+means that
+ * superblock has valid spare group set (in case of IMSM, it pool id).
+ * Entries on the subset list are ordered from most to least specific.
+ *
+ * 0/ if force option on: return "anymatch" entry (should be the only
+entry on
+ * list)
+ * 1/ "anymatch" is preset for st which does not specify any subsets
+(metadata
+ * is controller and spare group agnostic).
+ * 1/ if found (match: TRUE == fnpath(path, devname) and spare_group ==
+ *   st->ss->spare_group(st) then return subset
+ * 2/ not found:
+ * if there is match in subset such as devname == fnpath(path) and
+ *   subset->spare_group == NULL
+ * Add a new subset entry with the path and subset->spare_group ==
+ *   st->ss->spare_group(st)
+ * Such an entry is added to the subset list and returned by the function.
+ */
+struct subset *conf_get_subset(char *devname, struct supertype *st,
+                        struct domain_ent *domain)
+{
+     struct subset *ss;
+     char *devpath;
+     char *spare_group = NULL;
+
+     if (!st || !domain || !devname)
+           return NULL;
+
+     devpath = get_devpath_from_devname(devname);
+     if (!devpath)
+           return NULL;
+
+     if (st->ss->get_spare_group)
+           spare_group = st->ss->get_spare_group(st);
+     for (ss = domain->subsets; ss; ss = ss->next) {
+           if (!ss->paths && !ss->spare_group) { /* anymatch */
+                 goto exit;
+           }
+           if ((match_subset(ss, devpath, spare_group)))
+                 goto exit;
+     }
+     /* subset not found. It means that subset for spare_group do not exist
+     * yet. We have to duplicate first subset with matching path and
+     * specify first copy with spare group information. */
+     if (spare_group) {
+           for (ss = domain->subsets; ss; ss = ss->next) {
+                 if (match_domain_path(ss->paths, devpath)) {
+                       struct subset *ss_new = create_subset();
+                       if (!ss_new)
+                             return NULL;
+                       if (!copy_subset(ss_new, ss)) {
+                             free(ss_new);
+                             return NULL;
+                       }
+                       ss_new->next = ss->next;
+                       ss->next = ss_new;
+                       ss->spare_group = strdup(spare_group);
+                       break;
+                 }
+           }
+     }
+exit:
+     if (spare_group)
+           free(spare_group);
+     free(devpath);
+     return ss;
+}
+
 /*
  * Return a linked list of arrays that are in the same domain as the
  * constituent device devname.  So, if we have a domain that lists ports 2 @@ -1635,20 +1885,23 @@ struct mdstat_ent *arrays_in_domain(char *devname, struct domain_ent *domain)
      struct dev_member *m;
      struct domain_ent *de;
      char *devpath, *mempath, *devpart, *mempart;
+     struct supertype *st;

      devpath = get_devpath_from_devname(devname);
      devpart = strrchr(devpath, ':');
      mdstat = mdstat_read(0, 0);
      while (mdstat) {
-           if (mdstat->metadata_version &&
-               strncmp(mdstat->metadata_version, "external:", 9) == 0 &&
+           if (is_external(mdstat->metadata_version) == 0 &&
                is_subarray(mdstat->metadata_version+9))
                  /* don't return subarrays, only containers */
                  m = NULL;
            else for (m = mdstat->members; m; m = m->next) {
                  mempath = get_devpath_from_devname(m->name);
                  mempart = strrchr(mempath, ':');
-                 de = conf_get_domain(m->name);
+                 st = dev_load_supertype(m->name);
+                 de = conf_get_domain(m->name, (char *)st->ss->name);
+                 st->ss->free_super(st);
+                 free(st);
                  if (de == domain && strcmp(mempart, devpart) == 0)
                        /* array has at least one member in our domain*/
                        break;
@@ -1673,7 +1926,7 @@ struct mdstat_ent *arrays_in_domain(char *devname, struct domain_ent *domain)

 int conf_get_domain_action(char *devname)  {
-     struct domain_ent *domain = conf_get_domain(devname);
+     struct domain_ent *domain = conf_get_domain(devname, NULL);
      if (!domain)
            return incremental;
      return domain->action;
diff --git a/mdadm.h b/mdadm.h
index a0b1ab9..0e14ba5 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -431,6 +431,8 @@ extern void mdstat_wait(int seconds);  extern void mdstat_wait_fd(int fd, const sigset_t *sigmask);  extern int mddev_busy(int devnum);  extern struct mdstat_ent *mdstat_by_component(char *name);
+extern struct mdstat_ent *mdstat_get_parent(struct mdstat_ent *ent);
+extern struct mdstat_ent *mdstat_by_devnum(struct mdstat_ent **mds, int
+devnum);

 struct map_ent {
      struct map_ent *next;
@@ -930,7 +932,9 @@ extern int same_dev(char *one, char *two);  extern int parse_auto(char *str, char *msg, int config);  extern mddev_ident_t conf_get_ident(char *dev);  extern mddev_dev_t conf_get_devs(void); -extern struct domain_ent *conf_get_domain(char *devname);
+extern struct domain_ent *conf_get_domain(char *devname, char
+*platform); extern struct subset *conf_get_subset(char *devname, struct supertype *st,
+                             struct domain_ent *domain);
 extern int conf_get_domain_action(char *devname);  extern struct mdstat_ent *arrays_in_domain(char *devname,
                                 struct domain_ent *domain);
@@ -1012,6 +1016,11 @@ extern int devname2devnum(char *name);  extern int stat2devnum(struct stat *st);  extern int fd2devnum(int fd);  extern char *get_devpath_from_devname(char *devname);
+extern char *get_array_devname(char *array); extern struct supertype
+*dev_load_supertype(char *devname); extern int
+get_active_array_domain(char *array_name, struct domain_ent **domain,
+                          struct subset **subset);
+extern int is_external(char *metadata_verison);

 static inline int dev2major(int d)
 {
diff --git a/mdstat.c b/mdstat.c
index 3bb74fa..01a126b 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -348,8 +348,7 @@ struct mdstat_ent *mdstat_by_component(char *name)
      while (mdstat) {
            struct dev_member *m;
            struct mdstat_ent *ent;
-           if (mdstat->metadata_version &&
-               strncmp(mdstat->metadata_version, "external:", 9) == 0 &&
+           if (is_external(mdstat->metadata_version) &&
                is_subarray(mdstat->metadata_version+9))
                  /* don't return subarrays, only containers */
                  ;
@@ -367,3 +366,40 @@ struct mdstat_ent *mdstat_by_component(char *name)
      }
      return NULL;
 }
+
+struct mdstat_ent *mdstat_get_parent(struct mdstat_ent *m) {
+     struct mdstat_ent *mdstat = mdstat_read(0, 0);
+
+     while (mdstat) {
+           struct mdstat_ent *ent;
+           if (is_external(mdstat->metadata_version)) {
+                 if (!is_subarray(mdstat->metadata_version + 9))
+                       if (devname2devnum(m->metadata_version + 10) ==
+                                   mdstat->devnum) {
+                             free_mdstat(mdstat->next);
+                             mdstat->next = NULL;
+                             return mdstat;
+                       }
+           }
+           ent = mdstat;
+           mdstat = mdstat->next;
+           ent->next = NULL;
+           free_mdstat(ent);
+     }
+     return NULL;
+}
+
+struct mdstat_ent *mdstat_by_devnum(struct mdstat_ent **mds, int
+devnum) {
+     struct mdstat_ent *m;
+     if (!*mds)
+           *mds = mdstat_read(0, 0);
+
+     for (m = *mds ; m ; m = m->next)
+           if (m->devnum == devnum)
+                 return m;
+
+     return NULL;
+}
+
diff --git a/util.c b/util.c
index 169f804..cf08add 100644
--- a/util.c
+++ b/util.c
@@ -1805,3 +1805,102 @@ struct partition_handler *partition_list[] = {
      NULL
 };

+struct supertype *dev_load_supertype(char *devname) {
+     struct supertype *st;
+     int fd;
+     char *devpath;
+     if (!devname)
+           return NULL;
+
+     devpath = malloc(sizeof("/dev/") + strlen(devname));
+     if (!devpath)
+           return NULL;
+
+     strcpy(devpath, "/dev/");
+     strcat(devpath, devname);
+     fd = open(devpath, O_RDONLY);
+     if (!fd) {
+           free(devpath);
+           return NULL;
+     }
+     st = guess_super(fd);
+     if (!st) {
+           free(devpath);
+           return NULL;
+     }
+     if (st->ss->load_super(st, fd, devpath)) {
+           free(devpath);
+           return NULL;
+     }
+
+     close(fd);
+     free(devpath);
+     return st;
+}
+
+/* Sets domain and subset appropriately to the domain/subset of first
+ * accessible array member. Returns !0 for failure.
+ */
+int get_active_array_domain(char *array_name, struct domain_ent **domain,
+                   struct subset **subset)
+{
+     struct mdstat_ent *mds, *me;
+     struct supertype *st;
+     struct dev_member *dm;
+     char *name;
+
+     if (!domain || !subset)
+           return 1;
+
+     name = strrchr(array_name, '/');
+     if (!name++)
+           name = array_name;
+
+     mds = mdstat_read(0, 0);
+     if (!mds) {
+           fprintf(stderr, Name " : Cannot read mdstat!.\n");
+           return 1;
+     }
+
+     for (me = mds; me; me = me->next) {
+           if (!strstr(me->dev, name))
+                 continue;
+
+           /* try to obtain domain/subset for first available member */
+           for (dm = me->members; dm; dm = dm->next) {
+                 st = dev_load_supertype(dm->name);
+                 if (!st)
+                       continue;
+                 *domain = conf_get_domain(dm->name, me->metadata_version);
+                 if (!*domain) {
+                       st->ss->free_super(st);
+                       free(st);
+                       continue;
+                 }
+
+                 *subset = conf_get_subset(dm->name, st, *domain);
+                 st->ss->free_super(st);
+                 free(st);
+
+                 if (*domain && *subset) {
+                       free_mdstat(mds);
+                       return 0;
+                 }
+           }
+     }
+     free_mdstat(mds);
+     return 1;
+}
+
+/*
+ * true if metadata_version string represents external array
+ * if NULL provided, return false
+ */
+int is_external(char *metadata_version) {
+     return metadata_version && !strncmp(metadata_version, "external:", 9);
+/*   if (!metadata_version)
+           return 0;
+     return !strncmp(metadata_version, "external:", 9);*/ }
--
1.6.4.2


