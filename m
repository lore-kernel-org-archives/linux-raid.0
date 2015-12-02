From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 02/17] mdadm: allow a /dev/disk/by-slot as domain path descriptor
Date: Tue, 1 Dec 2015 16:25:18 -0800
Message-ID: <1449015933-255689-3-git-send-email-songliubraving@fb.com>
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

In a POLICY line let 'slot=' statements define a domain by
/dev/disk/by-slot and take precedence over 'path=' (/dev/disk/by-path)
definitions.

Also support writing udev rules for slot paths.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 mdadm.h  |  2 +-
 policy.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 69 insertions(+), 15 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 5d5e97f..167ca0c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1126,7 +1126,7 @@ struct pol_rule {
 };
 
 extern char rule_policy[], rule_part[];
-extern char rule_path[], rule_type[];
+extern char rule_path[], rule_slot[], rule_type[];
 extern char type_part[], type_disk[];
 
 extern void policyline(char *line, char *type);
diff --git a/policy.c b/policy.c
index 064d349..960a37e 100644
--- a/policy.c
+++ b/policy.c
@@ -189,16 +189,17 @@ struct dev_policy *pol_find(struct dev_policy *pol, char *name)
 	return pol;
 }
 
-static char *disk_path(struct mdinfo *disk)
+static char *__disk_path(struct mdinfo *disk, const char *path_prefix, int null_ok)
 {
 	struct stat stb;
 	int prefix_len;
 	DIR *by_path;
-	char symlink[PATH_MAX] = "/dev/disk/by-path/";
+	char symlink[PATH_MAX];
 	char nm[PATH_MAX];
 	struct dirent *ent;
 	int rv;
 
+	strcpy(symlink, path_prefix);
 	by_path = opendir(symlink);
 	if (by_path) {
 		prefix_len = strlen(symlink);
@@ -219,6 +220,9 @@ static char *disk_path(struct mdinfo *disk)
 		}
 		closedir(by_path);
 	}
+	closedir(by_path);
+	if (null_ok)
+		return NULL;
 	/* A NULL path isn't really acceptable - use the devname.. */
 	sprintf(symlink, "/sys/dev/block/%d:%d", disk->disk.major, disk->disk.minor);
 	rv = readlink(symlink, nm, sizeof(nm)-1);
@@ -232,6 +236,15 @@ static char *disk_path(struct mdinfo *disk)
 	return xstrdup("unknown");
 }
 
+static char *disk_path(struct mdinfo *disk)
+{
+	char *path = __disk_path(disk, "/dev/disk/by-slot/", 1);
+
+	if (!path)
+		return __disk_path(disk, "/dev/disk/by-path/", 0);
+	return path;
+}
+
 char type_part[] = "part";
 char type_disk[] = "disk";
 static char *disk_type(struct mdinfo *disk)
@@ -246,6 +259,13 @@ static char *disk_type(struct mdinfo *disk)
 		return type_disk;
 }
 
+static int rule_is_path(struct rule *rule)
+{
+	if (rule->name == rule_path || rule->name == rule_slot)
+		return 1;
+	return 0;
+}
+
 static int pol_match(struct rule *rule, char *path, char *type)
 {
 	/* check if this rule matches on path and type */
@@ -253,7 +273,7 @@ static int pol_match(struct rule *rule, char *path, char *type)
 	int typeok = 0;
 
 	while (rule) {
-		if (rule->name == rule_path) {
+		if (rule_is_path(rule)) {
 			if (pathok == 0)
 				pathok = -1;
 			if (path && fnmatch(rule->value, path, 0) == 0)
@@ -403,6 +423,7 @@ void pol_add(struct dev_policy **pol,
 /*
  * disk_policy() gathers policy information for the
  * disk described in the given mdinfo (disk.{major,minor}).
+ * prefer 'by-slot' over 'by-path'
  */
 struct dev_policy *disk_policy(struct mdinfo *disk)
 {
@@ -432,6 +453,7 @@ struct dev_policy *devid_policy(int dev)
  */
 
 char rule_path[] = "path";
+char rule_slot[] = "slot";
 char rule_type[] = "type";
 
 char rule_policy[] = "policy";
@@ -470,7 +492,8 @@ void policyline(char *line, char *type)
 	pr->type = type;
 	pr->rule = NULL;
 	for (w = dl_next(line); w != line ; w = dl_next(w)) {
-		if (try_rule(w, rule_path, &pr->rule))
+		if (try_rule(w, rule_slot, &pr->rule)
+		    || try_rule(w, rule_path, &pr->rule))
 			config_rules_has_path = 1;
 		else if (! try_rule(w, rule_type, &pr->rule) &&
 			 ! try_rule(w, pol_metadata, &pr->rule) &&
@@ -793,31 +816,59 @@ char *find_rule(struct rule *rule, char *rule_type)
 	return NULL;
 }
 
+/* prefer 'slot' rules over plain 'path' rules */
+static struct rule *find_path_rule(struct rule *rule)
+{
+	struct rule *path_rule = NULL;
+
+	while (rule) {
+		if (rule->name == rule_slot)
+			return rule;
+		if (!path_rule && rule->name == rule_path)
+			path_rule = rule;
+		rule = rule->next;
+	}
+
+	return path_rule;
+}
+
 #define UDEV_RULE_FORMAT \
 "ACTION==\"add\", SUBSYSTEM==\"block\", " \
-"ENV{DEVTYPE}==\"%s\", ENV{ID_PATH}==\"%s\", " \
+"ENV{DEVTYPE}==\"%s\", ENV{%s}==\"%s\", " \
 "RUN+=\"" BINDIR "/mdadm --incremental $env{DEVNAME}\"\n"
 
 #define UDEV_RULE_FORMAT_NOTYPE \
 "ACTION==\"add\", SUBSYSTEM==\"block\", " \
-"ENV{ID_PATH}==\"%s\", " \
+"ENV{%s}==\"%s\", " \
 "RUN+=\"" BINDIR "/mdadm --incremental $env{DEVNAME}\"\n"
 
+
+
 /* Write rule in the rule file. Use format from UDEV_RULE_FORMAT */
 int write_rule(struct rule *rule, int fd, int force_part)
 {
 	char line[1024];
-	char *pth = find_rule(rule, rule_path);
+	struct rule *path_rule = find_path_rule(rule);
 	char *typ = find_rule(rule, rule_type);
-	if (!pth)
+	char *slot_path, *pth;
+
+	if (!path_rule)
 		return -1;
 
+	pth = path_rule->value;
+	if (path_rule->name == rule_slot)
+		slot_path = "ID_SLOT";
+	else
+		slot_path = "ID_PATH";
+
 	if (force_part)
 		typ = type_part;
 	if (typ)
-		snprintf(line, sizeof(line) - 1, UDEV_RULE_FORMAT, typ, pth);
+		snprintf(line, sizeof(line) - 1, UDEV_RULE_FORMAT,
+			 typ, slot_path, pth);
 	else
-		snprintf(line, sizeof(line) - 1, UDEV_RULE_FORMAT_NOTYPE, pth);
+		snprintf(line, sizeof(line) - 1, UDEV_RULE_FORMAT_NOTYPE,
+			 slot_path, pth);
 	return write(fd, line, strlen(line)) == (int)strlen(line);
 }
 
@@ -829,6 +880,7 @@ int generate_entries(int fd)
 {
 	struct pol_rule *loop, *dup;
 	char *loop_value, *dup_value;
+	struct rule *rule;
 	int duplicate;
 
 	for (loop = config_rules; loop; loop = loop->next) {
@@ -841,18 +893,20 @@ int generate_entries(int fd)
 		loop_value = find_rule(loop->rule, pol_act);
 		if (!loop_value || map_act(loop_value) < act_spare_same_slot)
 			continue;
-		loop_value = find_rule(loop->rule, rule_path);
-		if (!loop_value)
+		rule = find_path_rule(loop->rule);
+		if (!rule)
 			continue;
+		loop_value = rule->value;
 		for (dup = config_rules; dup != loop; dup = dup->next) {
 			if (dup->type != rule_policy && loop->type != rule_part)
 				continue;
 			dup_value = find_rule(dup->rule, pol_act);
 			if (!dup_value || map_act(dup_value) < act_spare_same_slot)
 				continue;
-			dup_value = find_rule(dup->rule, rule_path);
-			if (!dup_value)
+			rule = find_path_rule(dup->rule);
+			if (!rule)
 				continue;
+			dup_value = rule->value;
 			if (strcmp(loop_value, dup_value) == 0) {
 				duplicate = 1;
 				break;
-- 
2.4.6

