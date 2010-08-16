From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 05/35] Partition action support in DOMAIN line
Date: Mon, 16 Aug 2010 10:42:34 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9BC@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From 6e51735e927e6dd32fc22f00feb9708fe7291d6e Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 28 May 2010 14:32:26 +0200
Subject: [PATCH 05/35] Partition action support in DOMAIN line

Add the table and program options for partition action and make them
a requirement.
Stub entries for making partition handling be done via an indirection
layer so we can easily support different partitioning methods required
for different platforms.
Modify config parsing and domain struct to use a partition handler
entry instead of just a program name.

    Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 Incremental.c |   17 ++++++++++++---
 config.c      |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 mdadm.h       |   20 +++++++++++++++++++
 util.c        |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 150 insertions(+), 5 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index d1d9ee1..ca70a35 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -947,7 +947,7 @@ static int IncrementalNewDisk(char *devname, int verbose, int export,
 			      struct domain_ent *domain)
 {
 	struct stat stb;
-	int dfd;
+	int dfd, rv;
 
 	dfd = dev_open_check(devname, O_RDONLY|O_EXCL, &stb);
 	if (dfd < 0) 
@@ -960,16 +960,25 @@ static int IncrementalNewDisk(char *devname, int verbose, int export,
 		close(dfd);
 		return 1;
 	}
+
+	if (domain->handler->check_table(dfd, verbose, export, domain) == 0) {
+		close(dfd);
+		return 0;
+	}
 	/*
 	 * OK, at this point we have a valid block device without a
-	 * superblock.  If we aren't in force mode, then don't use the
+	 * superblock, the partition table doesn't match, and we are a
+	 * partition domain.  If we aren't in force mode, then don't use the
 	 * device unless it's "clean", meaning no filesystems, no lvm,
 	 * no anything.  The requirement here is that both the first and
 	 * last 4k of the device must be one of three patterns: 0x00, 0x5a,
 	 * or 0xff.
 	 */
-
-	return 0;
+	if (check_clean(dfd) || force(domain)) {
+		rv = domain->handler->write_table(dfd, verbose, export, domain);
+	}
+	close(dfd);
+	return rv;
 }
 
 /*
diff --git a/config.c b/config.c
index bd80cd6..b429968 100644
--- a/config.c
+++ b/config.c
@@ -707,6 +707,10 @@ void free_domain(struct domain_ent *de)
 		free(dp->path);
 		free(dp);
 	}
+	if (de->spare_group)
+		free(de->spare_group);
+	if (de->table)
+		free(de->table);
 	free(de);
 }
 
@@ -715,7 +719,7 @@ void domainline(char *line)
 	char *w;
 	struct domain_ent *de;
 	struct domain_path *path, *prev_path;
-	int offset, a_seen=0, m_seen=0, sg_seen=0;
+	int offset, a_seen=0, m_seen=0, sg_seen=0, p_seen=0, t_seen=0;
 
 	de = malloc(sizeof(struct domain_ent));
 	if (!de) {
@@ -725,6 +729,8 @@ void domainline(char *line)
 	}
 	de->paths = NULL;
 	de->spare_group = NULL;
+	de->handler = NULL;
+	de->table = NULL;
 	de->action = incremental;
 	de->st = NULL;
 	de->next = NULL;
@@ -804,6 +810,45 @@ void domainline(char *line)
 				free_domain(de);
 				return;
 			}
+		} else if (strncasecmp("program=", w, 8) == 0) {
+			int i = 0;
+			struct partition_handler *h = partition_list[i];
+			if (!p_seen)
+				p_seen = 1;
+			else {
+				fprintf(stderr, Name ": only one program= "
+					"entry allowed per domain line, "
+					"ignoring\n");
+				continue;
+			}
+			while(h) {
+				if (strncasecmp(w+8, h->match, strlen(h->match)) == 0)
+					break;
+				h = partition_list[++i];
+			}
+			if (!h) {
+				fprintf(stderr, Name ": failed to recognize "
+					"program %s\n", w+8);
+				free_domain(de);
+				return;
+			}
+			de->handler = h;
+		} else if (strncasecmp("table=", w, 6) == 0) {
+			if (!t_seen)
+				t_seen = 1;
+			else {
+				fprintf(stderr, Name ": only one table= "
+					"entry allowed per domain line, "
+					"ignoring\n");
+				continue;
+			}
+			de->table = strdup(w+6);
+			if (!de->table) {
+				fprintf(stderr, Name ": failed to allocate "
+					"memory for table\n");
+				free_domain(de);
+				return;
+			}
 		} else {
 			fprintf(stderr, Name ": unrecognized option %s on "
 				"domain line\n", w);
@@ -852,6 +897,18 @@ void domainline(char *line)
 			free_domain(de);
 			return;
 		}
+		if (!de->table || !de->handler) {
+			fprintf(stderr, Name ": partition action requires "
+				"both a table and program setting.\n");
+			free_domain(de);
+			return;
+		}
+		if (de->handler->validate(de)) {
+			fprintf(stderr, Name ": partition table file failed "
+				"validation.\n");
+			free_domain(de);
+			return;
+		}
 	}
 	de->next = domain_list;
 	domain_list = de;
diff --git a/mdadm.h b/mdadm.h
index 3862853..509ee9f 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -295,6 +295,17 @@ enum domain_actions {
 #define action(domain) ((domain)->action & action_mask)
 #define force(domain) ((domain)->action & force)
 
+struct domain_ent;
+
+extern struct partition_handler {
+	char			*match; /* string we match in mdadm.conf */
+	int 			(*validate)(struct domain_ent *domain);
+	int 			(*check_table)(int dfd, int verbose, int export,
+					       struct domain_ent *domain);
+	int			(*write_table)(int dfd, int verbose, int export,
+					       struct domain_ent *domain);
+} *partition_list[];
+
 struct domain_ent {
 	char			*spare_group; /* only set this in monitor mode
 						 when we know what arrays we
@@ -308,6 +319,14 @@ struct domain_ent {
 	int			action;
 	struct supertype	*st;
 	struct domain_ent	*next;
+	struct partition_handler	*handler; /* only used when action is
+					     partition, this is the program
+					     to call to actually partition
+					     the drive */
+	char			*table; /* This is the location of a file to
+					   pass to the partition program,
+					   used both for setting and checking
+					   the partitions on drives */
 };
 
 /* structures read from config file */
@@ -876,6 +895,7 @@ extern int parse_layout_faulty(char *layout);
 extern int check_ext2(int fd, char *name);
 extern int check_reiser(int fd, char *name);
 extern int check_raid(int fd, char *name);
+extern int check_clean(int fd);
 extern int check_partitions(int fd, char *dname, unsigned long long freesize);
 
 extern int get_mdp_major(void);
diff --git a/util.c b/util.c
index b93e21d..169f804 100644
--- a/util.c
+++ b/util.c
@@ -536,6 +536,35 @@ int check_raid(int fd, char *name)
 	return 1;
 }
 
+int check_clean(int dfd)
+{
+	void *head, *tail, *pattern;
+	int i=0, head_clean=0, tail_clean=0;
+	unsigned char patterns[]={0x00,0x5a,0xff};
+
+	head = malloc(4096);
+	tail = malloc(4096);
+	pattern = malloc(4096);
+	if (!head || !tail || !pattern)
+		return 0;
+	if (lseek(dfd, 0, SEEK_SET) == -1)
+		return 0;
+	if (read(dfd, head, 4096) != 4096)
+		return 0;
+	if (lseek(dfd, -4096, SEEK_END) == -1)
+		return 0;
+	if (read(dfd, tail, 4096) != 4096)
+		return 0;
+	while (i < 3) {
+		memset(pattern, patterns[i++], 4096);
+		if (memcmp(head, pattern, 4096) == 0)
+			head_clean++;
+		if (memcmp(tail, pattern, 4096) == 0)
+			tail_clean++;
+	}
+	return (head_clean && tail_clean);
+}
+
 int ask(char *mesg)
 {
 	char *add = "";
@@ -1746,3 +1775,33 @@ char *get_devpath_from_devname(char *devname)
 	closedir(by_path);
 	return NULL;
 }
+
+static int sfdisk_validate(struct domain_ent *domain)
+{
+	return 0;
+}
+
+static int sfdisk_check_table(int dfd, int verbose, int export,
+			      struct domain_ent *domain)
+{
+	return 0;
+}
+
+static int sfdisk_write_table(int dfd, int verbose, int export,
+			      struct domain_ent *domain)
+{
+	return 0;
+}
+
+static struct partition_handler sfdisk_handler = {
+	.match		= "sfdisk",
+	.validate	= sfdisk_validate,
+	.check_table	= sfdisk_check_table,
+	.write_table	= sfdisk_write_table,
+};
+
+struct partition_handler *partition_list[] = {
+	&sfdisk_handler,
+	NULL
+};
+
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

