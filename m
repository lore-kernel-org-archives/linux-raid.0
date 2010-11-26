From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 18/53] Treat feature as experimental
Date: Fri, 26 Nov 2010 09:06:08 +0100
Message-ID: <20101126080608.5221.55622.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Due to fact that IMSM Windows compatibility was not tested yet, feature has to be treated as experimental until compatibility verification will be performed.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm.h       |    1 +
 super-intel.c |    4 ++++
 util.c        |   10 ++++++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 64b32cc..bf3c1d3 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -890,6 +890,7 @@ extern char *conf_word(FILE *file, int allow_key);
 extern int conf_name_is_free(char *name);
 extern int devname_matches(char *name, char *match);
 extern struct mddev_ident_s *conf_match(struct mdinfo *info, struct supertype *st);
+extern inline int experimental(void);
 
 extern void free_line(char *line);
 extern int match_oneof(char *devices, char *devname);
diff --git a/super-intel.c b/super-intel.c
index 2434fa1..f092ccc 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5780,6 +5780,10 @@ int imsm_reshape_super(struct supertype *st, long long size, int level,
 	int fd = -1;
 	char buf[PATH_MAX];
 
+
+	if (experimental() == 0)
+		return ret_val;
+
 	snprintf(buf, PATH_MAX, "/dev/md%i", st->devnum);
 	fd = open(buf , O_RDONLY | O_DIRECT);
 	if (fd < 0) {
diff --git a/util.c b/util.c
index 8739278..f220792 100644
--- a/util.c
+++ b/util.c
@@ -1859,3 +1859,13 @@ void append_metadata_update(struct supertype *st, void *buf, int len)
 unsigned int __invalid_size_argument_for_IOC = 0;
 #endif
 
+inline int experimental(void)
+{
+	if (check_env("MDADM_EXPERIMENTAL"))
+		return 1;
+	else {
+		fprintf(stderr, Name "(IMSM): To use this feature MDADM_EXPERIMENTAL enviroment variable has to defined.\n");
+		return 0;
+	}
+}
+

