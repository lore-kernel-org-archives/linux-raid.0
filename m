From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 07/33] add general domain/subset lists manipulation routines
Date: Mon, 5 Jul 2010 11:44:56 +0100
Message-ID: <66C59AD0932712458090B447266D638CD8CEC3F1@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C07@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C07@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Czarnowska, Anna
Sent: Monday, July 05, 2010 11:24 AM
To: Neil Brown
Cc: linux-raid@vger.kernel.org; Czarnowska, Anna; Hawrylewicz Czarnowski, Przemyslaw; Labun, Marcin; Neubauer, Wojciech; Williams, Dan J; Ciechanowski, Ed; dledford@redhat.com
Subject: [PATCH 07/33] add general domain/subset lists manipulation routines

From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>

set of utilities to create/maintain data structures:
* create (with special 'match any' subset)
* free
* duplicate/copy
for domain_ent, domain_path and subset structures.

Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 config.c |  307 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 mdadm.h  |   16 +++-
 2 files changed, 299 insertions(+), 24 deletions(-)

diff --git a/config.c b/config.c
index b429968..248c1c1 100644
--- a/config.c
+++ b/config.c
@@ -696,44 +696,95 @@ void autoline(char *line)  }

 static struct domain_ent *domain_list = NULL;
+static struct domain_ent **dl_end = &domain_list;

-void free_domain(struct domain_ent *de)
+void free_domain_path_list(struct domain_path *dp_head)
 {
      struct domain_path *dp;

-     while (de->paths) {
-           dp = de->paths;
-           de->paths = dp->next;
+     while (dp_head) {
+           dp = dp_head;
+           dp_head = dp->next;
            free(dp->path);
            free(dp);
      }
+}
+
+void free_subset_list(struct subset *s) {
+     struct subset *s_tmp;
+
+     while(s) {
+           s_tmp = s;
+           s = s->next;
+           if (s_tmp->paths)
+                 free_domain_path_list(s_tmp->paths);
+           if (s_tmp->spare_group)
+                 free(s_tmp->spare_group);
+           free(s_tmp);
+     }
+     free(s);
+}
+
+void free_domain(struct domain_ent *de) {
+     free_domain_path_list(de->paths);
+     free_subset_list(de->subsets);
      if (de->spare_group)
            free(de->spare_group);
      if (de->table)
            free(de->table);
+     if (de->platform)
+           free(de->platform);
      free(de);
 }

-void domainline(char *line)
+void free_domain_list(struct domain_ent **de_head)
 {
-     char *w;
-     struct domain_ent *de;
-     struct domain_path *path, *prev_path;
-     int offset, a_seen=0, m_seen=0, sg_seen=0, p_seen=0, t_seen=0;
+     struct domain_ent *de_tmp;
+
+     while(*de_head) {
+           de_tmp = *de_head;
+           *de_head = (*de_head)->next;
+           free_domain(de_tmp);
+     }
+     *de_head = NULL;
+}
+
+/* creates single domain entry filled with default values */ struct
+domain_ent *create_domain_entry(void) {
+     struct domain_ent *de = malloc(sizeof(struct domain_ent));

-     de = malloc(sizeof(struct domain_ent));
      if (!de) {
            fprintf(stderr, Name ": unable to allocate memory for domain "
-                 "entry\n");
-           return;
+                            "entry\n");
+           return NULL;
      }
      de->paths = NULL;
      de->spare_group = NULL;
+     de->subsets = NULL;
      de->handler = NULL;
      de->table = NULL;
      de->action = incremental;
-     de->st = NULL;
+     de->platform = NULL;
      de->next = NULL;
+
+     return de;
+}
+
+void domainline(char *line)
+{
+     char *w;
+     struct domain_ent *de;
+     struct domain_path *path, *prev_path;
+     int offset, a_seen=0, m_seen=0, sg_seen=0, p_seen=0, t_seen=0;
+
+     de = create_domain_entry();
+     if (!de) {
+           free_domain_list(&domain_list);
+           return;
+     }

      for (w=dl_next(line); w!=line; w=dl_next(w)) {
            if (strncasecmp("path=", w, 5) == 0) { @@ -741,6 +792,7 @@ void domainline(char *line)
                  if (!path) {
                        fprintf(stderr, Name ": unable to allocate "
                              "memory for domain path\n");
+                       free_domain_list(&domain_list);
                        free_domain(de);
                        return;
                  }
@@ -748,6 +800,7 @@ void domainline(char *line)
                  if (!path->path) {
                        fprintf(stderr, Name ": unable to allocate "
                              "memory for domain path\n");
+                       free_domain_list(&domain_list);
                        free_domain(de);
                        return;
                  }
@@ -777,6 +830,7 @@ void domainline(char *line)
                  if (offset == 13)
                        de->action |= force;
            } else if (strncasecmp("metadata=", w, 9) == 0) {
+                 struct supertype *st;
                  int i;
                  if (!m_seen)
                        m_seen = 1;
@@ -788,12 +842,14 @@ void domainline(char *line)
                  }
                  /* style of metadata on the devices. */

-                 for(i=0; superlist[i] && !de->st; i++)
-                       de->st = superlist[i]->match_metadata_desc(w+9);
+                 for(i=0; superlist[i] && !st; i++)
+                       st = superlist[i]->match_metadata_desc(w+9);

-                 if (!de->st)
+                 if (!st) {
                        fprintf(stderr, Name ": metadata format %s "
                              "unknown, ignored.\n", w+9);
+                       de->platform = strdup(w+9);
+                 }
            } else if (strncasecmp("spare-group=", w, 12) == 0) {
                  if (!sg_seen)
                        sg_seen = 1;
@@ -807,6 +863,7 @@ void domainline(char *line)
                  if (!de->spare_group) {
                        fprintf(stderr, Name ": failed to allocate "
                              "memory for spare_group\n");
+                       free_domain_list(&domain_list);
                        free_domain(de);
                        return;
                  }
@@ -829,6 +886,7 @@ void domainline(char *line)
                  if (!h) {
                        fprintf(stderr, Name ": failed to recognize "
                              "program %s\n", w+8);
+                       free_domain_list(&domain_list);
                        free_domain(de);
                        return;
                  }
@@ -846,6 +904,7 @@ void domainline(char *line)
                  if (!de->table) {
                        fprintf(stderr, Name ": failed to allocate "
                              "memory for table\n");
+                       free_domain_list(&domain_list);
                        free_domain(de);
                        return;
                  }
@@ -894,38 +953,242 @@ void domainline(char *line)
                  /* We freed all the paths, kill this domain */
                  fprintf(stderr, Name ": no valid paths in domain, "
                        "freeing.\n");
+                 free_domain_list(&domain_list);
                  free_domain(de);
                  return;
            }
            if (!de->table || !de->handler) {
                  fprintf(stderr, Name ": partition action requires "
                        "both a table and program setting.\n");
+                 free_domain_list(&domain_list);
                  free_domain(de);
                  return;
            }
            if (de->handler->validate(de)) {
                  fprintf(stderr, Name ": partition table file failed "
                        "validation.\n");
+                 free_domain_list(&domain_list);
                  free_domain(de);
                  return;
            }
      }
-     de->next = domain_list;
-     domain_list = de;
+     de->subsets = NULL;
+     de->next = NULL;
+     *dl_end = de;
+     dl_end = &de->next;
 }

+/* matches given path with domain_path structure */ int
+match_domain_path(struct domain_path *path, char *devpath) {
+     if (!path) /* empty path means "*" */
+           return 1;
+     for (; path; path = path->next)
+           if (path->path)
+                 if (fnmatch(path->path, devpath, 0) == 0)
+                       return 1;
+     return 0;
+}
+
+/* returns domain basing on path matching and superblock type (in that order).
+ * If st==NULL, just match paths.
+ */
 struct domain_ent *get_domain_from_devpath(char *devpath)  {
      struct domain_ent *de;
-     struct domain_path *path;

-     for (de = domain_list; de; de = de->next)
-           for (path = de->paths; path; path = path->next)
-                 if (fnmatch(path->path, devpath, 0) == 0)
+     if (!devpath)
+           return NULL;
+
+     for (de = domain_list; de; de = de->next) {
+           if (match_domain_path(de->paths, devpath))
                        return de;
+     }
      return NULL;
 }

+/* returns subset record created to indicate "match any" subset
+ * ie. paths and spare_group equal NULL */ struct subset
+*conf_get_any_subset(void) {
+     struct subset *s = malloc(sizeof(*s));
+     if (!s) {
+           fprintf(stderr, Name ": unable to allocate memory for domain "
+                                  "entry\n");
+           return NULL;
+     }
+     s->paths = NULL;
+     s->spare_group = NULL;
+     s->next = NULL;
+     return s;
+}
+
+static struct domain_path *create_domain_path(void) {
+     struct domain_path *dp = malloc(sizeof(*dp));
+
+     if (!dp) {
+           fprintf(stderr, Name ": unable to allocate memory for domain "
+                       "path entry\n");
+           return NULL;
+     }
+     dp->path = NULL;
+     dp->next = NULL;
+
+     return dp;
+}
+
+static struct domain_path *duplicate_domain_path_list(struct
+domain_path *s) {
+     struct domain_path *dp, *dp_new;
+     struct domain_path *dp_new_head = NULL;
+     struct domain_path **dp_end = NULL;
+
+     for (dp = s; dp; dp = dp->next) {
+           dp_new = create_domain_path();
+           if (!dp_new) {
+                 free_domain_path_list(dp_new_head);
+                 return NULL;
+           }
+
+           if (!dp_new_head) {
+                 dp_new_head = dp_new;
+           }
+
+           if (dp->path) {
+                 dp_new->path = strdup(dp->path);
+                 if (!dp_new->path) {
+                       free_domain_path_list(dp_new_head);
+                       return NULL;
+                 }
+           }
+           if (dp_end)
+                 *dp_end = dp_new;
+
+           dp_end = &dp_new->next;
+     }
+
+     return dp_new_head;
+}
+
+static struct subset *create_subset(void) {
+     struct subset *ss = malloc(sizeof(*ss));
+
+     if (!ss) {
+           fprintf(stderr, Name ": unable to allocate memory for subset "
+                            "entry\n");
+           return NULL;
+     }
+     ss->paths = NULL;
+     ss->spare_group = NULL;
+     ss->next = NULL;
+
+     return ss;
+}
+
+static struct subset *copy_subset(struct subset *s_new, struct subset
+*s) {
+     if (!s_new || !s)
+           return NULL;
+
+     if (s->paths) {
+           s_new->paths = duplicate_domain_path_list(s->paths);
+           if (!s_new->paths) {
+                 free(s_new);
+                 return NULL;
+           }
+     }
+
+     if (s->spare_group) {
+           s_new->spare_group = strdup(s->spare_group);
+           if (!s_new->spare_group) {
+                 free_domain_path_list(s_new->paths);
+                 free(s_new);
+                 return NULL;
+           }
+     }
+     s_new->next = NULL;
+
+     return s_new;
+}
+
+static struct subset *duplicate_subset_list(struct subset *s) {
+     struct subset *ss, *ss_new, *ss_new_head = NULL;
+     struct subset **ss_end = NULL;
+
+     for (ss = s; ss; ss = ss->next) {
+           ss_new = create_subset();
+           if (!ss_new) {
+                 free_subset_list(ss_new_head);
+                 return NULL;
+           }
+           if (!ss_new_head)
+                 ss_new_head = ss_new;
+
+           if (!copy_subset(ss_new, ss)) {
+                 free(ss_new);
+                 free_subset_list(ss_new_head);
+                 return NULL;
+           }
+
+           if (ss_end)
+                 *ss_end = ss_new;
+           ss_end = &ss_new->next;
+     }
+
+     return ss_new_head;
+}
+
+/* static will be enabled when function will be used in domain code */
+/*static*/ struct domain_ent *duplicate_domain(struct domain_ent *de) {
+     struct domain_ent *de_new = create_domain_entry();
+
+     if (!de_new)
+           return NULL;
+
+     if (de->paths) {
+           de_new->paths = duplicate_domain_path_list(de->paths);
+           if (!de_new->paths)
+                 goto fail_exit;
+     }
+     if (de->spare_group) {
+           de_new->spare_group = strdup(de->spare_group);
+           if (!de_new->spare_group)
+                 goto fail_exit;
+     }
+     de_new->handler = de->handler;
+     if (de->table) {
+           de_new->table = strdup(de->table);
+           if (!de_new->table)
+                 goto fail_exit;
+     }
+     if (de->subsets) {
+           de_new->subsets = duplicate_subset_list(de->subsets);
+           if (!de_new->subsets)
+                 goto fail_exit;
+     }
+
+     de_new->action = de->action;
+     if (de_new->platform) {
+           de_new->platform = strdup(de->platform);
+           if (!de_new->platform)
+                 goto fail_exit;
+     }
+
+     de_new->next = de->next;
+     de->next = de_new;
+
+     return de_new;
+fail_exit:
+     free(de_new->table);
+     free(de_new->spare_group);
+     free_domain_path_list(de_new->paths);
+     free(de_new);
+     return NULL;
+}

 int loaded = 0;

diff --git a/mdadm.h b/mdadm.h
index 509ee9f..7b950f8 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -312,12 +312,23 @@ struct domain_ent {
                                     are watching and can reconcile
                                     them to domains by checking
                                     constituent device paths */
-     struct domain_path {
+     struct domain_path {                /* user defined path(s) to choose
+                                    * domain boundaries */
            char              *path;
            struct domain_path      *next;
      }                 *paths;
+     struct subset {                    /* platform dependent limits. They
+                                   * can be either implicit platform
+                                   * confinements or those from
+                                   * metadata fields as pool id used
+                                   * in IMSM */
+           struct domain_path      *paths;
+           char        *spare_group;
+           struct subset     *next;
+     } *subsets;
+
      int               action;
-     struct supertype  *st;
+     char              *platform;
      struct domain_ent *next;
      struct partition_handler      *handler; /* only used when action is
                                   partition, this is the program @@ -913,6 +924,7 @@ extern struct domain_ent *conf_get_domain(char *devname);  extern int conf_get_domain_action(char *devname);  extern struct mdstat_ent *arrays_in_domain(char *devname,
                                 struct domain_ent *domain);
+extern struct subset *conf_get_any_subset(void);
 extern int conf_test_dev(char *devname);  extern int conf_test_metadata(const char *version, int is_homehost);  extern struct createinfo *conf_get_create_info(void);
--
1.6.4.2


