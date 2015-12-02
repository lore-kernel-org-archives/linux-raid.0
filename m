From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 15/17] SCSIMODE: configuration file support for mode page settings.
Date: Tue, 1 Dec 2015 16:25:31 -0800
Message-ID: <1449015933-255689-16-git-send-email-songliubraving@fb.com>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, Dan Williams <djbw@fb.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: Dan Williams <djbw@fb.com>

Before a a drive is incorporated into an array we want to be sure that settings
like write-cache-disable and error-recovery-response are set consistently for
each drive in the array.  Add a "SCSIMODE" configuration parameter that:

1/ identifies the disks to apply the policy to by domain name.  When
   domain= is specified multiple times the scsi mode page settings are
   applied to the union of those domains.

2/ Modifies the mode page bytes identified by a tuple of (page, subpage,
   byte).  For now only the '=' operator is supported to assign the
   entire byte.

      _____ page
     /   __ subpage
     | /  _ byte
     | | /
     v v v
     x.y.z=val

Example disable the write cache on all drives in domain0 and domain1:
SCSIMODE domain=domain0 domain=domain1
     # disable write cache
     8.0.2=0
     # enable automatic read/write re-assignment
     1.0.2=0xc0

For multi-byte values specifying something like:
     8.0.0=0
     8.0.1=0
     8.0.2=0
     8.0.3=0
...will result in one write to mode-page-8.  Settings to the same page
are aggregated and the values are set in specified order within a page.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Incremental.c |   9 +++
 Makefile      |   2 +-
 config.c      | 191 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 mdadm.h       |   1 +
 4 files changed, 201 insertions(+), 2 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 781d27d..88a945a 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -194,6 +194,15 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 	policy = disk_policy(&dinfo);
 	have_target = policy_check_path(&dinfo, &target_array);
 
+	/* before taking any action on the disk check if we need to modify settings */
+	if (conf_apply_scsimode(&dinfo, policy) != 0) {
+		if (c->verbose >= 0)
+			pr_err("%s failed to apply scsi mode settings\n",
+			       devname);
+		rv = 2;
+		goto out;
+	}
+
 	if (st == NULL && (st = guess_super_type(dfd, guess_array)) == NULL) {
 		if (c->verbose >= 0)
 			pr_err("no recognisable superblock on %s.\n",
diff --git a/Makefile b/Makefile
index 009073c..3a5f28d 100644
--- a/Makefile
+++ b/Makefile
@@ -143,7 +143,7 @@ SRCS =  $(patsubst %.o,%.c,$(OBJS))
 INCL = mdadm.h part.h bitmap.h
 
 MON_OBJS = mdmon.o monitor.o managemon.o util.o maps.o mdstat.o sysfs.o \
-	policy.o lib.o \
+	policy.o lib.o config.o mapfile.o \
 	Kill.o sg_io.o dlink.o ReadMe.o super-intel.o \
 	super-mbr.o super-gpt.o \
 	super-ddf.o sha1.o crc32.o msg.o bitmap.o xmalloc.o \
diff --git a/config.c b/config.c
index d06928b..f1ab62b 100644
--- a/config.c
+++ b/config.c
@@ -24,6 +24,7 @@
 
 #include	"mdadm.h"
 #include	"dlink.h"
+#include	"sg_io.h"
 #include	<dirent.h>
 #include	<glob.h>
 #include	<fnmatch.h>
@@ -77,7 +78,8 @@ char DefaultAltConfFile[] = CONFFILE2;
 char DefaultAltConfDir[] = CONFFILE2 ".d";
 
 enum linetype { Devices, Array, Mailaddr, Mailfrom, Program, CreateDev,
-		Homehost, HomeCluster, AutoMode, Policy, PartPolicy, Enclosures, LTEnd };
+		Homehost, HomeCluster, AutoMode, Policy, PartPolicy, Enclosures,
+		ScsiMode, LTEnd };
 char *keywords[] = {
 	[Devices]  = "devices",
 	[Array]    = "array",
@@ -91,6 +93,7 @@ char *keywords[] = {
 	[Policy]   = "policy",
 	[PartPolicy]="part-policy",
 	[Enclosures] = "enclosure",
+	[ScsiMode] = "scsimode",
 	[LTEnd]    = NULL
 };
 
@@ -123,6 +126,22 @@ struct conf_enclosure {
 	char *id;
 } *edevlist = NULL;
 
+struct conf_scsimode {
+	struct conf_scsimode *next;
+	int strict;
+	struct mode_domain {
+		struct mode_domain *next;
+		char *name;
+	} *domains;
+	struct mode_setting {
+		struct mode_setting *next;
+		int page;
+		int subpage;
+		int byte;
+		unsigned char val;
+	} *settings;
+} *scsimodelist;
+
 struct mddev_dev *load_partitions(void)
 {
 	FILE *f = fopen("/proc/partitions", "r");
@@ -535,6 +554,99 @@ static void enclosureline(char *line)
 	}
 }
 
+static void scsimodeline(char *line)
+{
+	char *w;
+	struct conf_scsimode *mode = xmalloc(sizeof(*mode));
+	struct mode_setting **s_pos = &mode->settings;
+
+	mode->domains = NULL;
+	mode->settings = NULL;
+	mode->strict = 0;
+	for (w = dl_next(line); w != line; w = dl_next(w)) {
+		if (strncasecmp(w, "domain=", 7) == 0) {
+			struct mode_domain *d = xmalloc(sizeof(*d));
+
+			d->name = xstrdup(w+7);
+			d->next = mode->domains;
+			mode->domains = d;
+		} else if (strncasecmp(w, "strict", 6) == 0) {
+			mode->strict = 1;
+		} else {
+			char *start, *end;
+			char sep[] = "..=";
+			int fields[4];
+			size_t i;
+
+			start = w;
+			for (i = 0; i < sizeof(sep); i++) {
+				fields[i] = strtoul(start, &end, 0);
+				if (end && end > start && *end == sep[i]) {
+					start = end+1;
+				} else
+					break;
+			}
+
+			if (i < sizeof(sep))
+				pr_err("unrecognized format for SCSIMODE line: %s\n", w);
+			else {
+				struct mode_setting *s = xmalloc(sizeof(*s));
+				struct mode_setting *insert;
+
+				s->page = fields[0];
+				s->subpage = fields[1];
+				s->byte = fields[2];
+				s->val = fields[3];
+
+				/* keep pages adjacent, as we will apply
+				 * entire pages at a time
+				 */
+				for (insert = mode->settings; insert; insert = insert->next) {
+					if (insert->next == NULL)
+						break;
+					if (insert->next->page == s->page &&
+					    insert->next->subpage == s->subpage)
+						continue;
+					if (insert->page == s->page &&
+					    insert->subpage == s->subpage)
+						break;
+				}
+
+				if (insert) {
+					s->next = insert->next;
+					insert->next = s;
+				} else {
+					s->next = NULL;
+					while (*s_pos)
+						s_pos = &(*s_pos)->next;
+					*s_pos = s;
+					s_pos = &s->next;
+				}
+			}
+		}
+	}
+
+	if (mode->domains && mode->settings) {
+		mode->next = scsimodelist;
+		scsimodelist = mode;
+	} else {
+		struct mode_domain *d;
+		struct mode_setting *s;
+
+		while (mode->domains) {
+			d = mode->domains->next;
+			free(mode->domains);
+			mode->domains = d;
+		}
+		while (mode->settings) {
+			s = mode->settings->next;
+			free(mode->settings);
+			mode->settings = s;
+		}
+		free(mode);
+	}
+}
+
 static char *alert_email = NULL;
 void mailline(char *line)
 {
@@ -757,6 +869,9 @@ void conf_file(FILE *f)
 		case Enclosures:
 			enclosureline(line);
 			break;
+		case ScsiMode:
+			scsimodeline(line);
+			break;
 		case Mailaddr:
 			mailline(line);
 			break;
@@ -1259,6 +1374,80 @@ struct mddev_ident *conf_match(struct supertype *st,
 	return match;
 }
 
+static int apply_mode(struct mdinfo *info, struct mode_setting *settings)
+{
+	struct mode_setting *s = settings;
+	struct scsi_mode_sense_data data;
+	__u8 mode_buf[512];
+	int errors = 0;
+
+	for (s = settings; s; s = s->next) {
+		__u8 *mode_page;
+		char devt[22];
+		int fd, rc;
+
+		sprintf(devt, "%d:%d",
+			info->disk.major,
+			info->disk.minor);
+		fd = dev_open(devt, O_RDWR);
+
+		rc = scsi_mode_sense(fd, s->page, s->subpage, &data,
+				     mode_buf, sizeof(mode_buf));
+		mode_page = to_mode_page(mode_buf, &data);
+		for (;;) {
+
+			mode_page[s->byte] = s->val;
+			if (s->next &&
+			    s->next->page == s->page &&
+			    s->next->subpage == s->subpage)
+				s = s->next;
+			else
+				break;
+		}
+		if (rc == 0)
+			rc = scsi_mode_select(fd, 1, 1, &data, mode_buf);
+		if (rc)
+			errors++;
+		close(fd);
+	}
+
+	return errors;
+}
+
+int conf_apply_scsimode(struct mdinfo *info, struct dev_policy *pol)
+{
+	struct conf_scsimode *mode;
+	int err = 0;
+
+	load_conffile();
+
+	pol = pol_find(pol, pol_domain);
+	if (!scsimodelist || !pol)
+		return 0;
+
+	for (mode = scsimodelist; mode; mode = mode->next) {
+		struct mode_domain *domain = mode->domains;
+		struct dev_policy *p;
+		int found = 0;
+
+		for (domain = mode->domains; domain; domain = domain->next) {
+			pol_for_each(p, pol, NULL) {
+				if (strcmp(p->value, domain->name) == 0) {
+					err += apply_mode(info, mode->settings);
+					found = 1;
+					break;
+				}
+			}
+			if (found)
+				break;
+		}
+		if (mode->strict && err)
+			return err;
+	}
+
+	return 0;
+}
+
 int conf_verify_devnames(struct mddev_ident *array_list)
 {
 	struct mddev_ident *a1, *a2;
diff --git a/mdadm.h b/mdadm.h
index 4f6c733..e0b1a07 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1376,6 +1376,7 @@ extern struct mddev_ident *conf_match(struct supertype *st,
 				      struct mdinfo *info,
 				      char *devname,
 				      int verbose, int *rvp);
+extern int conf_apply_scsimode(struct mdinfo *info, struct dev_policy *pol);
 extern int experimental(void);
 
 extern void free_line(char *line);
-- 
2.4.6

