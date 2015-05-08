From: gqjiang@suse.com
Subject: [PATCH V2 03/11] home-cluster while creating an array
Date: Fri,  8 May 2015 16:50:21 +0800
Message-ID: <1431075029-5484-4-git-send-email-gqjiang@suse.com>
References: <1431075029-5484-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431075029-5484-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

From: Guoqing Jiang <gqjiang@suse.com>

The home-cluster is stored in the bitmap super block of the
array. The device can be assembled on a cluster with the
cluster name same as the one recorded in the bitmap.

If home-cluster is not specified, this is auto-detected using
dlopen corosync cmap library.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 Create.c   |  1 +
 Makefile   |  1 +
 ReadMe.c   |  1 +
 config.c   | 27 ++++++++++++++++++++++++++-
 mdadm.8.in |  6 ++++++
 mdadm.c    | 25 +++++++++++++++++++++++++
 mdadm.h    |  5 +++++
 util.c     | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/Create.c b/Create.c
index e4577af..9663dc4 100644
--- a/Create.c
+++ b/Create.c
@@ -532,6 +532,7 @@ int Create(struct supertype *st, char *mddev,
 		warn = 1;
 	}
 	st->nodes = c->nodes;
+	st->cluster_name = c->homecluster;
 
 	if (warn) {
 		if (c->runstop!= 1) {
diff --git a/Makefile b/Makefile
index a7d8c5c..431f08b 100644
--- a/Makefile
+++ b/Makefile
@@ -101,6 +101,7 @@ endif
 # If you want a static binary, you might uncomment these
 # LDFLAGS = -static
 # STRIP = -s
+LDLIBS=-ldl
 
 INSTALL = /usr/bin/install
 DESTDIR =
diff --git a/ReadMe.c b/ReadMe.c
index 30c569d..c6286ae 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -141,6 +141,7 @@ struct option long_options[] = {
     {"symlinks",  1, 0,  Symlinks},
     {"data-offset",1, 0, DataOffset},
     {"nodes",1, 0, Nodes},
+    {"home-cluster",1, 0, ClusterName},
 
     /* For assemble */
     {"uuid",      1, 0, 'u'},
diff --git a/config.c b/config.c
index 7342c42..21b6afd 100644
--- a/config.c
+++ b/config.c
@@ -77,7 +77,7 @@ char DefaultAltConfFile[] = CONFFILE2;
 char DefaultAltConfDir[] = CONFFILE2 ".d";
 
 enum linetype { Devices, Array, Mailaddr, Mailfrom, Program, CreateDev,
-		Homehost, AutoMode, Policy, PartPolicy, LTEnd };
+		Homehost, HomeCluster, AutoMode, Policy, PartPolicy, LTEnd };
 char *keywords[] = {
 	[Devices]  = "devices",
 	[Array]    = "array",
@@ -86,6 +86,7 @@ char *keywords[] = {
 	[Program]  = "program",
 	[CreateDev]= "create",
 	[Homehost] = "homehost",
+	[HomeCluster] = "homecluster",
 	[AutoMode] = "auto",
 	[Policy]   = "policy",
 	[PartPolicy]="part-policy",
@@ -562,6 +563,21 @@ void homehostline(char *line)
 	}
 }
 
+static char *home_cluster = NULL;
+void homeclusterline(char *line)
+{
+	char *w;
+
+	for (w=dl_next(line); w != line ; w=dl_next(w)) {
+		if (home_cluster == NULL) {
+			if (strcasecmp(w, "<none>")==0)
+				home_cluster = xstrdup("");
+			else
+				home_cluster = xstrdup(w);
+		}
+	}
+}
+
 char auto_yes[] = "yes";
 char auto_no[] = "no";
 char auto_homehost[] = "homehost";
@@ -724,6 +740,9 @@ void conf_file(FILE *f)
 		case Homehost:
 			homehostline(line);
 			break;
+		case HomeCluster:
+			homeclusterline(line);
+			break;
 		case AutoMode:
 			autoline(line);
 			break;
@@ -884,6 +903,12 @@ char *conf_get_homehost(int *require_homehostp)
 	return home_host;
 }
 
+char *conf_get_homecluster(void)
+{
+	load_conffile();
+	return home_cluster;
+}
+
 struct createinfo *conf_get_create_info(void)
 {
 	load_conffile();
diff --git a/mdadm.8.in b/mdadm.8.in
index 9c1497e..56d9bcc 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -415,6 +415,12 @@ This functionality is currently only provided by
 and
 .BR \-\-monitor .
 
+.TP
+.B \-\-home\-cluster=
+specifies the cluster name for the md device. The md device can be assembled
+only on the cluster which matches the name specified. If this option is not
+provided, mdadm tried to detect the cluster name automatically.
+
 .SH For create, build, or grow:
 
 .TP
diff --git a/mdadm.c b/mdadm.c
index 031383d..4f9bd9b 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -596,6 +596,13 @@ int main(int argc, char *argv[])
 				exit(2);
 			}
 			continue;
+		case O(CREATE, ClusterName):
+			c.homecluster = optarg;
+			if (strlen(c.homecluster) > 64) {
+				pr_err("Cluster name too big.\n");
+				exit(ERANGE);
+			}
+			continue;
 		case O(CREATE,'x'): /* number of spare (eXtra) disks */
 			if (s.sparedisks) {
 				pr_err("spare-devices set twice: %d and %s\n",
@@ -1276,6 +1283,18 @@ int main(int argc, char *argv[])
 		c.require_homehost = 0;
 	}
 
+	if (c.homecluster == NULL && (c.nodes > 0)) {
+		c.homecluster = conf_get_homecluster();
+		if (c.homecluster == NULL)
+			rv = get_cluster_name(&c.homecluster);
+		if (rv == 0) {
+			c.homehost = xstrdup(c.homecluster);
+			/* Add a : to differentiate between a host
+			 * and a cluster */
+			strcat(c.homehost, ":");
+		}
+	}
+
 	if (c.backup_file && data_offset != INVALID_SECTORS) {
 		pr_err("--backup-file and --data-offset are incompatible\n");
 		exit(2);
@@ -1407,6 +1426,12 @@ int main(int argc, char *argv[])
 				rv = 1;
 				break;
 			}
+			if (c.homecluster) {
+				pr_err("--home-cluster argument is incompatible with --bitmap=%s.\n",
+					s.bitmap_file);
+				rv = 1;
+				break;
+			}
 		}
 
 		if (s.write_behind && !s.bitmap_file) {
diff --git a/mdadm.h b/mdadm.h
index 9d55801..f56d9d6 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -345,6 +345,7 @@ enum special_options {
 	Restore,
 	Action,
 	Nodes,
+	ClusterName,
 };
 
 enum prefix_standard {
@@ -420,6 +421,7 @@ struct context {
 	int	invalid_backup;
 	char	*action;
 	int	nodes;
+	char	*homecluster;
 };
 
 struct shape {
@@ -1032,6 +1034,7 @@ struct supertype {
 	int devcnt;
 	int retry_soon;
 	int nodes;
+	char *cluster_name;
 
 	struct mdinfo *devs;
 
@@ -1308,6 +1311,7 @@ extern char *conf_get_mailaddr(void);
 extern char *conf_get_mailfrom(void);
 extern char *conf_get_program(void);
 extern char *conf_get_homehost(int *require_homehostp);
+extern char *conf_get_homecluster(void);
 extern char *conf_line(FILE *file);
 extern char *conf_word(FILE *file, int allow_key);
 extern void print_quoted(char *str);
@@ -1416,6 +1420,7 @@ extern char *stat2devnm(struct stat *st);
 extern char *fd2devnm(int fd);
 
 extern int in_initrd(void);
+extern int get_cluster_name(char **name);
 
 #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
 #define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
diff --git a/util.c b/util.c
index cc98d3b..ed9a745 100644
--- a/util.c
+++ b/util.c
@@ -34,6 +34,8 @@
 #include	<ctype.h>
 #include	<dirent.h>
 #include	<signal.h>
+#include	<dlfcn.h>
+#include	<corosync/cmap.h>
 
 /*
  * following taken from linux/blkpg.h because they aren't
@@ -1976,3 +1978,51 @@ void reopen_mddev(int mdfd)
 	if (fd >= 0 && fd != mdfd)
 		dup2(fd, mdfd);
 }
+
+int get_cluster_name(char **cluster_name)
+{
+        void *lib_handle = NULL;
+        int rv = -1;
+
+        cmap_handle_t handle;
+        static int (*initialize)(cmap_handle_t *handle);
+        static int (*get_string)(cmap_handle_t handle,
+                        const char *string,
+                        char **name);
+        static int (*finalize)(cmap_handle_t handle);
+
+
+        lib_handle = dlopen("libcmap.so.4", RTLD_NOW | RTLD_LOCAL);
+        if (!lib_handle)
+                return rv;
+
+        initialize = dlsym(lib_handle, "cmap_initialize");
+        if (!initialize)
+                goto out;
+
+        get_string = dlsym(lib_handle, "cmap_get_string");
+        if (!get_string)
+                goto out;
+
+        finalize = dlsym(lib_handle, "cmap_finalize");
+        if (!finalize)
+                goto out;
+
+        rv = initialize(&handle);
+        if (rv != CS_OK)
+                goto out;
+
+        rv = get_string(handle, "totem.cluster_name", cluster_name);
+        if (rv != CS_OK) {
+                free(*cluster_name);
+                rv = -1;
+                goto name_err;
+        }
+
+        rv = 0;
+name_err:
+        finalize(handle);
+out:
+        dlclose(lib_handle);
+        return rv;
+}
-- 
1.7.12.4

