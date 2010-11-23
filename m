From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 04/21] FIX: Use MDADM_EXPERIMENTAL environment variable
Date: Tue, 23 Nov 2010 13:40:09 +0100
Message-ID: <20101123124009.17770.77913.stgit@gklab-170-024.igk.intel.com>
References: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Instead 'EXPERIMENTAL' compilation flag, use 'MDADM_EXPERIMENTAL'
environment variable to enable features.
Function experimental was put to util.c for reuse.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/mdadm.h       |    1 +
 mdadm/mdadm/super-intel.c |   18 ++----------------
 mdadm/mdadm/util.c        |   10 ++++++++++
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/mdadm/mdadm/mdadm.h b/mdadm/mdadm/mdadm.h
index c722475..844c354 100644
--- a/mdadm/mdadm/mdadm.h
+++ b/mdadm/mdadm/mdadm.h
@@ -970,6 +970,7 @@ extern int read_attr(char *buf, int len, int fd);
 extern int read_dev_state(int fd);
 extern int find_array_minor(char *text_version, int external, int *minor);
 extern int find_array_minor2(char *text_version, int external, int *minor);
+extern inline int experimental(void);
 
 extern void free_line(char *line);
 extern int match_oneof(char *devices, char *devname);
diff --git a/mdadm/mdadm/super-intel.c b/mdadm/mdadm/super-intel.c
index b58eb5f..1005595 100644
--- a/mdadm/mdadm/super-intel.c
+++ b/mdadm/mdadm/super-intel.c
@@ -195,16 +195,6 @@ struct bbm_log {
 static char *map_state_str[] = { "normal", "uninitialized", "degraded", "failed" };
 #endif
 
-static inline int experimental(void)
-{
-#ifdef EXPERIMENTAL
-	return 1;
-#else
-	fprintf(stderr, Name "(IMSM): To use this feature EXPERIMENTAL compilation flag has to be used.\n");
-	return 0;
-#endif
-}
-
 #define UNIT_SRC_NORMAL     0   /* Source data for curr_migr_unit must
 				 *  be recovered using srcMap */
 #define UNIT_SRC_IN_CP_AREA 1   /* Source data for curr_migr_unit has
@@ -7253,10 +7243,8 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	dprintf("\tfor level      : %i\n", level);
 	dprintf("\tfor raid_disks : %i\n", raid_disks);
 
-	if (experimental() == 0) {
-		dprintf("imsm: Error: Operation not supported without EXPERIMENTAL compilaton flag.\n");
+	if (experimental() == 0)
 		return ret_val;
-	}
 
 	snprintf(buf, PATH_MAX, "/dev/md%i", st->devnum);
 	fd = open(buf , O_RDONLY | O_DIRECT);
@@ -8192,10 +8180,8 @@ int imsm_manage_reshape(struct supertype *st, char *backup)
 
 	dprintf("imsm: manage_reshape() called\n");
 
-	if (experimental() == 0) {
-		dprintf("imsm: Error: Operation not supported without EXPERIMENTAL compilaton flag.\n");
+	if (experimental() == 0)
 		return ret_val;
-	}
 
 	/* verify reshape conditions
 	 * for single vlolume reshape exit only and reuse Grow_reshape() code
diff --git a/mdadm/mdadm/util.c b/mdadm/mdadm/util.c
index 58ba6f0..d176ec0 100644
--- a/mdadm/mdadm/util.c
+++ b/mdadm/mdadm/util.c
@@ -2010,3 +2010,13 @@ int find_array_minor2(char *text_version, int external, int *minor)
 	}
 	return result;
 }
+
+inline int experimental(void)
+{
+	if (check_env("MDADM_EXPERIMENTAL"))
+		return 1;
+	else {
+		fprintf(stderr, Name "(IMSM): To use this feature MDADM_EXPERIMENTAL enviroment variable has to defined.\n");
+		return 0;
+	}
+}

