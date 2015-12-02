From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 11/17] policy: enable enclosure names for domain definitions
Date: Tue, 1 Dec 2015 16:25:27 -0800
Message-ID: <1449015933-255689-12-git-send-email-songliubraving@fb.com>
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

The argument to "slot=" in a POLICY line can either be a path glob
relative to /dev/disk/by-slot, or an enclosure name.

In other words, now an enclosure name can be used as a domain boundary:
mdadm --detail-platform --enclosure --brief >> /etc/mdadm.conf
cat /etc/mdadm.conf
ENCLOSURE enclosure0 id=0x5f80f41f1d6a60ff
ENCLOSURE enclosure1 id=0x5f80f41f1d6e80ff
echo "POLICY domain=domain0 slot=enclosure0" >> /etc/mdadm.conf

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 config.c | 26 ++++++++++++++++++++++++++
 mdadm.h  |  1 +
 policy.c | 18 +++++++++++++++---
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/config.c b/config.c
index 6ea5dd1..d06928b 100644
--- a/config.c
+++ b/config.c
@@ -1045,6 +1045,32 @@ void conf_put_enclosure_devs(struct mddev_dev *devs)
 	}
 }
 
+/* this succeeds whether the enclosure is currently attached or not, just
+ * translates enclosure names to ids from the configuration file
+ */
+int conf_get_enclosure_glob(const char *slot_val, char *buf, int len)
+{
+	struct conf_enclosure *e;
+
+	load_conffile();
+	for (e = edevlist; e; e = e->next) {
+		/* slot=<enclosure_name> */
+		if (strcmp(e->name, slot_val) == 0 &&
+		    snprintf(buf, len, "enclosure-%s-slot*", e->id) < len)
+			return 1;
+
+		/* slot=enclosure-<enclosure_name>[-<slot-glob>] */
+		if (snprintf(buf, len, "enclosure-%s", e->name) < len &&
+		    strncmp(slot_val, buf, strlen(buf)) == 0 &&
+		    snprintf(buf, len, "enclosure-%s%s", e->id,
+			     &slot_val[strlen(buf)]) < len)
+			return 1;
+	}
+
+	/* slot= is already a glob */
+	return 0;
+}
+
 int conf_test_dev(char *devname)
 {
 	struct conf_dev *cd;
diff --git a/mdadm.h b/mdadm.h
index f318f1d..4f6c733 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1353,6 +1353,7 @@ extern struct mddev_ident *conf_get_ident(char *dev);
 extern struct mddev_dev *conf_get_devs(void);
 extern struct mddev_dev *conf_get_enclosure_devs(char *id);
 extern void conf_put_enclosure_devs(struct mddev_dev *devs);
+extern int conf_get_enclosure_glob(const char *slot_val, char *buf, int len);
 extern int conf_test_dev(char *devname);
 extern int conf_test_metadata(const char *version, struct dev_policy *pol, int is_homehost);
 extern struct createinfo *conf_get_create_info(void);
diff --git a/policy.c b/policy.c
index 6afafad..0558351 100644
--- a/policy.c
+++ b/policy.c
@@ -274,9 +274,17 @@ static int pol_match(struct rule *rule, char *path, char *type)
 
 	while (rule) {
 		if (rule_is_path(rule)) {
+			char *value = rule->value;
+			char enc_desc[256];
+
+			if (rule->name == rule_slot &&
+			    conf_get_enclosure_glob(value, enc_desc,
+						    sizeof(enc_desc)))
+			    value = enc_desc;
+
 			if (pathok == 0)
 				pathok = -1;
-			if (path && fnmatch(rule->value, path, 0) == 0)
+			if (path && fnmatch(value, path, 0) == 0)
 				pathok = 1;
 		}
 		if (rule->name == rule_type) {
@@ -848,6 +856,7 @@ static struct rule *find_path_rule(struct rule *rule)
 int write_rule(struct rule *rule, int fd, int force_part)
 {
 	char line[1024];
+	char enc_desc[256];
 	struct rule *path_rule = find_path_rule(rule);
 	char *typ = find_rule(rule, rule_type);
 	char *slot_path, *pth;
@@ -856,9 +865,12 @@ int write_rule(struct rule *rule, int fd, int force_part)
 		return -1;
 
 	pth = path_rule->value;
-	if (path_rule->name == rule_slot)
+	if (path_rule->name == rule_slot) {
+		if (conf_get_enclosure_glob(path_rule->value, enc_desc,
+					    sizeof(enc_desc)))
+			pth = enc_desc;
 		slot_path = "ID_SLOT";
-	else
+	} else
 		slot_path = "ID_PATH";
 
 	if (force_part)
-- 
2.4.6

