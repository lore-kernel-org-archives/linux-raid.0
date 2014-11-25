From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH] Change way of printing name of a process
Date: Tue, 25 Nov 2014 13:56:21 +0100
Message-ID: <20141125125621.27997.74172.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Sometimes mdadm prints messages with wrong name "mdmon",
and vice versa.
This patch solves this problem by changing method of determining
process name.
Now "Name" will be set in const at start of a program,
previously was hardcoded as #define.

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Grow.c        |   18 +++++++++---------
 Incremental.c |    4 ++--
 Monitor.c     |    4 ++--
 ReadMe.c      |    2 +-
 mdadm.c       |    7 ++++---
 mdadm.h       |    6 +++---
 mdmon.c       |    2 ++
 mdmon.h       |    3 +--
 super-intel.c |    2 +-
 sysfs.c       |    8 ++++----
 xmalloc.c     |   12 ++++++++----
 11 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/Grow.c b/Grow.c
index a0f7526..41b1e5d 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1919,7 +1919,7 @@ size_change_error:
 		int err;
 		err = remove_disks_for_takeover(st, sra, array.layout);
 		if (err) {
-			dprintf(Name": Array cannot be reshaped\n");
+			dprintf("%s: Array cannot be reshaped\n", Name);
 			if (cfd > -1)
 				close(cfd);
 			rv = 1;
@@ -2133,7 +2133,7 @@ static int verify_reshape_position(struct mdinfo *info, int level)
 		char *ep;
 		unsigned long long position = strtoull(buf, &ep, 0);
 
-		dprintf(Name": Read sync_max sysfs entry is: %s\n", buf);
+		dprintf("%s: Read sync_max sysfs entry is: %s\n", Name, buf);
 		if (!(ep == buf || (*ep != 0 && *ep != '\n' && *ep != ' '))) {
 			position *= get_data_disks(level,
 						   info->new_layout,
@@ -3494,8 +3494,8 @@ int reshape_container(char *container, char *devname,
 		return 1;
 	default: /* parent */
 		if (!freeze_reshape)
-			printf(Name ": multi-array reshape continues"
-			       " in background\n");
+			printf("%s: multi-array reshape continues"
+			       " in background\n", Name);
 		return 0;
 	case 0: /* child */
 		map_fork();
@@ -3557,8 +3557,8 @@ int reshape_container(char *container, char *devname,
 
 		fd = open_dev(mdstat->devnm);
 		if (fd < 0) {
-			printf(Name ": Device %s cannot be opened for reshape.",
-			       adev);
+			printf("%s: Device %s cannot be opened for reshape.",
+			       Name, adev);
 			break;
 		}
 
@@ -3573,8 +3573,8 @@ int reshape_container(char *container, char *devname,
 			 * This is possibly interim until the behaviour of
 			 * reshape_array is resolved().
 			 */
-			printf(Name ": Multiple reshape execution detected for "
-			       "device  %s.", adev);
+			printf("%s: Multiple reshape execution detected for "
+			       "device  %s.", Name, adev);
 			close(fd);
 			break;
 		}
@@ -4611,7 +4611,7 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 			st->ss->free_super(st);
 			offsets[j] = dinfo.data_offset * 512;
 		}
-		printf(Name ": restoring critical section\n");
+		printf("%s: restoring critical section\n", Name);
 
 		if (restore_stripes(fdlist, offsets,
 				    info->array.raid_disks,
diff --git a/Incremental.c b/Incremental.c
index 13b68bc..38c9989 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1710,9 +1710,9 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
 	char buf[32];
 
 	if (!id_path)
-		dprintf(Name ": incremental removal without --path <id_path> "
+		dprintf("%s: incremental removal without --path <id_path> "
 			"lacks the possibility to re-add new device in this "
-			"port\n");
+			"port\n", Name);
 
 	if (strchr(devname, '/')) {
 		pr_err("incremental removal requires a "
diff --git a/Monitor.c b/Monitor.c
index 971d2ec..7a5203c 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -381,14 +381,14 @@ static void alert(char *event, char *dev, char *disc, struct alert_info *info)
 			if (info->mailfrom)
 				fprintf(mp, "From: %s\n", info->mailfrom);
 			else
-				fprintf(mp, "From: " Name " monitoring <root>\n");
+				fprintf(mp, "From: %s monitoring <root>\n", Name);
 			fprintf(mp, "To: %s\n", info->mailaddr);
 			fprintf(mp, "Subject: %s event on %s:%s\n\n",
 				event, dev, hname);
 
 			fprintf(mp,
 				"This is an automatically generated"
-				" mail message from " Name "\n");
+				" mail message from %s\n", Name);
 			fprintf(mp, "running on %s\n\n", hname);
 
 			fprintf(mp,
diff --git a/ReadMe.c b/ReadMe.c
index 445c388..87a4916 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -30,7 +30,7 @@
 #ifndef VERS_DATE
 #define VERS_DATE "21st August 2014"
 #endif
-char Version[] = Name " - v" VERSION " - " VERS_DATE "\n";
+char Version[] = "mdadm - v" VERSION " - " VERS_DATE "\n";
 
 /*
  * File: ReadMe.c
diff --git a/mdadm.c b/mdadm.c
index c856fcd..475c71c 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -38,6 +38,7 @@ static int misc_list(struct mddev_dev *devlist,
 		     struct mddev_ident *ident,
 		     char *dump_directory,
 		     struct supertype *ss, struct context *c);
+const char Name[] = "mdadm";
 
 int main(int argc, char *argv[])
 {
@@ -771,12 +772,12 @@ int main(int argc, char *argv[])
 			if (strcmp(c.update,"?") == 0 ||
 			    strcmp(c.update, "help") == 0) {
 				outf = stdout;
-				fprintf(outf, Name ": ");
+				fprintf(outf, "%s: ", Name);
 			} else {
 				outf = stderr;
 				fprintf(outf,
-					Name ": '--update=%s' is invalid.  ",
-					c.update);
+					"%s: '--update=%s' is invalid.  ",
+					Name, c.update);
 			}
 			fprintf(outf, "Valid --update options are:\n"
 		"     'sparc2.2', 'super-minor', 'uuid', 'name', 'resync',\n"
diff --git a/mdadm.h b/mdadm.h
index fc1fd31..c8d079c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -180,6 +180,8 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 
 #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
 
+extern const char Name[];
+
 /* general information that might be extracted from a superblock */
 struct mdinfo {
 	mdu_array_info_t	array;
@@ -262,8 +264,6 @@ struct createinfo {
 	struct supertype *supertype;
 };
 
-#define Name "mdadm"
-
 enum mode {
 	ASSEMBLE=1,
 	BUILD,
@@ -1457,7 +1457,7 @@ static inline int xasprintf(char **strp, const char *fmt, ...) {
 	return ret;
 }
 
-#define pr_err(fmt ...) fprintf(stderr, Name ": " fmt)
+#define pr_err(fmt, args...) fprintf(stderr, "%s: "fmt, Name, ##args)
 #define cont_err(fmt ...) fprintf(stderr, "       " fmt)
 
 void *xmalloc(size_t len);
diff --git a/mdmon.c b/mdmon.c
index 27045a1..ee12b7c 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -67,6 +67,8 @@
 #include	"mdadm.h"
 #include	"mdmon.h"
 
+char const Name[] = "mdmon";
+
 struct active_array *discard_this;
 struct active_array *pending_discard;
 
diff --git a/mdmon.h b/mdmon.h
index 5a8e120..aa750c6 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -18,8 +18,7 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
-#undef pr_err
-#define pr_err(fmt ...) fprintf(stderr, "mdmon: " fmt)
+extern const char Name[];
 
 enum array_state { clear, inactive, suspended, readonly, read_auto,
 		   clean, active, write_pending, active_idle, bad_word};
diff --git a/super-intel.c b/super-intel.c
index 4c53019..19f6d33 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1386,7 +1386,7 @@ static int imsm_check_attributes(__u32 attributes)
 		}
 
 		if (not_supported)
-			dprintf(Name "(IMSM): Unknown attributes : %x\n", not_supported);
+			dprintf("%s (IMSM): Unknown attributes : %x\n", Name, not_supported);
 
 		ret_val = 0;
 	}
diff --git a/sysfs.c b/sysfs.c
index 9a1d856..ceab27f 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -413,8 +413,8 @@ int sysfs_set_str(struct mdinfo *sra, struct mdinfo *dev,
 	n = write(fd, val, strlen(val));
 	close(fd);
 	if (n != strlen(val)) {
-		dprintf(Name ": failed to write '%s' to '%s' (%s)\n",
-			val, fname, strerror(errno));
+		dprintf("%s: failed to write '%s' to '%s' (%s)\n",
+			Name, val, fname, strerror(errno));
 		return -1;
 	}
 	return 0;
@@ -450,8 +450,8 @@ int sysfs_uevent(struct mdinfo *sra, char *event)
 	n = write(fd, event, strlen(event));
 	close(fd);
 	if (n != (int)strlen(event)) {
-		dprintf(Name ": failed to write '%s' to '%s' (%s)\n",
-			event, fname, strerror(errno));
+		dprintf("%s: failed to write '%s' to '%s' (%s)\n",
+			Name, event, fname, strerror(errno));
 		return -1;
 	}
 	return 0;
diff --git a/xmalloc.c b/xmalloc.c
index 8d42a7c..75ae4e2 100644
--- a/xmalloc.c
+++ b/xmalloc.c
@@ -37,7 +37,8 @@ void *xmalloc(size_t len)
 	char *msg;
 	if (rv)
 		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
+	msg = ": memory allocation failure - aborting\n";
+	write(2, Name, strlen(Name));
 	exit(4+!!write(2, msg, strlen(msg)));
 }
 
@@ -47,7 +48,8 @@ void *xrealloc(void *ptr, size_t len)
 	char *msg;
 	if (rv)
 		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
+	msg =  ": memory allocation failure - aborting\n";
+	write(2, Name, strlen(Name));
 	exit(4+!!write(2, msg, strlen(msg)));
 }
 
@@ -57,7 +59,8 @@ void *xcalloc(size_t num, size_t size)
 	char *msg;
 	if (rv)
 		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
+	msg =  ": memory allocation failure - aborting\n";
+	write(2, Name, strlen(Name));
 	exit(4+!!write(2, msg, strlen(msg)));
 }
 
@@ -67,6 +70,7 @@ char *xstrdup(const char *str)
 	char *msg;
 	if (rv)
 		return rv;
-	msg = Name ": memory allocation failure - aborting\n";
+	msg =  ": memory allocation failure - aborting\n";
+	write(2, Name, strlen(Name));
 	exit(4+!!write(2, msg, strlen(msg)));
 }

