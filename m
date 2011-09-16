From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 04/14] Add continue option to grow command
Date: Fri, 16 Sep 2011 13:54:17 +0200
Message-ID: <20110916115417.5201.51789.stgit@gklab-128-013.igk.intel.com>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com
List-Id: linux-raid.ids

To allow for reshape continuation, 'continue' option is added
to grow command. It is not possible to check, if any existing mdadm
instance is going to take ownership on blocked md array or it is
orphaned/interrupted reshape.
To resolve this problem grow command with continue option,
is allowed when current mdadm instance is only one in the system.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 ReadMe.c |    1 +
 mdadm.c  |   17 ++++++++++++++++-
 mdadm.h  |    2 ++
 util.c   |   37 +++++++++++++++++++++++++++++++++++++
 4 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/ReadMe.c b/ReadMe.c
index b658841..f0dc0d9 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -190,6 +190,7 @@ struct option long_options[] = {
     {"backup-file", 1,0, BackupFile},
     {"invalid-backup",0,0,InvalidBackup},
     {"array-size", 1, 0, 'Z'},
+    {"continue", 0, 0, Continue},
 
     /* For Incremental */
     {"rebuild-map", 0, 0, RebuildMapOpt},
diff --git a/mdadm.c b/mdadm.c
index 4b817ab..f30534a 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -74,6 +74,7 @@ int main(int argc, char *argv[])
 	int export = 0;
 	int assume_clean = 0;
 	char *symlinks = NULL;
+	int grow_continue = 0;
 	/* autof indicates whether and how to create device node.
 	 * bottom 3 bits are style.  Rest (when shifted) are number of parts
 	 * 0  - unset
@@ -988,7 +989,21 @@ int main(int argc, char *argv[])
 			}
 			backup_file = optarg;
 			continue;
-
+		case O(GROW, Continue):
+			/* Continuer broken grow
+			 * To be sure that continuation is allowed check
+			 * if there is only one (current) mdadm instance
+			 */
+			grow_continue = count_mdadms();
+			fprintf(stderr, Name ": %i mdadm instance(s) found\n",
+				grow_continue);
+			if (grow_continue != 1) {
+				fprintf(stderr, Name ": Grow continuation "
+					"requires single mdadm instance "
+					"running.\n");
+				exit(2);
+			}
+			continue;
 		case O(ASSEMBLE, InvalidBackup):
 			/* Acknowledge that the backupfile is invalid, but ask
 			 * to continue anyway
diff --git a/mdadm.h b/mdadm.h
index 9035e67..7e3a618 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -313,6 +313,7 @@ enum special_options {
 	RebuildMapOpt,
 	InvalidBackup,
 	UdevRules,
+	Continue,
 };
 
 /* structures read from config file */
@@ -1162,6 +1163,7 @@ extern char *human_size_brief(long long bytes);
 extern void print_r10_layout(int layout);
 
 extern int initramfs_is_in_use(void);
+extern int count_mdadms(void);
 #define INITRAMFS_IS_IN_USE		1
 #define INITRAMFS_NOT_USED		0
 
diff --git a/util.c b/util.c
index 7186f3f..5077c2f 100644
--- a/util.c
+++ b/util.c
@@ -1790,3 +1790,40 @@ int initramfs_is_in_use(void)
 
 	return ret_val;
 }
+
+int count_mdadms(void)
+{
+	int ret_val = 0;
+	DIR *dirp;
+	struct dirent *d_entry;
+	int fd;
+
+	dirp = opendir("/proc");
+	if (!dirp)
+		return -1;
+
+	while ((d_entry = readdir(dirp)) != NULL) {
+		char p[PATH_MAX];
+
+		if (!strcmp(d_entry->d_name, ".") ||
+			!strcmp(d_entry->d_name, "..") ||
+			!strcmp(d_entry->d_name, "self"))
+			continue;
+		errno = 0;
+		fd = (int)strtol(d_entry->d_name, NULL, 10);
+		if (errno)
+			continue;
+		sprintf(p, "/proc/%s/cmdline", d_entry->d_name);
+		fd = open(p, O_RDONLY);
+		if (fd < 0)
+			continue;
+		if (read(fd, p, PATH_MAX) > 0) {
+			if (strcmp(p, "mdadm") == 0)
+				ret_val++;
+		}
+		close(fd);
+	}
+	closedir(dirp);
+
+	return ret_val;
+}

