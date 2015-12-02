From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 10/17] config: ENCLOSURE keyword and enclosure device list expansion
Date: Tue, 1 Dec 2015 16:25:26 -0800
Message-ID: <1449015933-255689-11-git-send-email-songliubraving@fb.com>
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

Parse the output of "--detail-platform --brief --enclosure" to generate
a mapping of of enclosure names to enclosure ids.

When a single sub-device name is specified try to interpret it as an
enclosure id/name and grab the device list from the enclosure to scsi
device mapping.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 config.c    | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 enclosure.c | 27 +++++++++++++++++++++++++
 mdadm.c     | 53 +++++++++++++++++++++++++++++++------------------
 mdadm.h     |  2 ++
 4 files changed, 128 insertions(+), 20 deletions(-)

diff --git a/config.c b/config.c
index c58c8fe..6ea5dd1 100644
--- a/config.c
+++ b/config.c
@@ -77,7 +77,7 @@ char DefaultAltConfFile[] = CONFFILE2;
 char DefaultAltConfDir[] = CONFFILE2 ".d";
 
 enum linetype { Devices, Array, Mailaddr, Mailfrom, Program, CreateDev,
-		Homehost, HomeCluster, AutoMode, Policy, PartPolicy, LTEnd };
+		Homehost, HomeCluster, AutoMode, Policy, PartPolicy, Enclosures, LTEnd };
 char *keywords[] = {
 	[Devices]  = "devices",
 	[Array]    = "array",
@@ -90,6 +90,7 @@ char *keywords[] = {
 	[AutoMode] = "auto",
 	[Policy]   = "policy",
 	[PartPolicy]="part-policy",
+	[Enclosures] = "enclosure",
 	[LTEnd]    = NULL
 };
 
@@ -116,6 +117,12 @@ struct conf_dev {
 	char *name;
 } *cdevlist = NULL;
 
+struct conf_enclosure {
+	struct conf_enclosure *next;
+	char *name;
+	char *id;
+} *edevlist = NULL;
+
 struct mddev_dev *load_partitions(void)
 {
 	FILE *f = fopen("/proc/partitions", "r");
@@ -506,6 +513,28 @@ void arrayline(char *line)
 	}
 }
 
+static void enclosureline(char *line)
+{
+	char *name = NULL, *id = NULL;
+	char *w;
+
+	for (w = dl_next(line); w != line; w = dl_next(w)) {
+		if (strchr(w, '=') == NULL)
+			name = w;
+		if (strncasecmp(w, "id=", 3) == 0)
+			id = w+3;
+	}
+
+	if (name && id) {
+		struct conf_enclosure *e = xmalloc(sizeof(*e));
+
+		e->name = xstrdup(name);
+		e->id = xstrdup(id);
+		e->next = edevlist;
+		edevlist = e;
+	}
+}
+
 static char *alert_email = NULL;
 void mailline(char *line)
 {
@@ -725,6 +754,9 @@ void conf_file(FILE *f)
 		case Array:
 			arrayline(line);
 			break;
+		case Enclosures:
+			enclosureline(line);
+			break;
 		case Mailaddr:
 			mailline(line);
 			break;
@@ -981,6 +1013,38 @@ struct mddev_dev *conf_get_devs()
 	return dlist;
 }
 
+extern struct mddev_dev *enclosure_get_devs(char *id);
+
+struct mddev_dev *conf_get_enclosure_devs(char *enclosure_id)
+{
+	struct conf_enclosure *e;
+	struct mddev_dev *dv;
+
+	load_conffile();
+
+	for (e = edevlist; e; e = e->next)
+		if (strcmp(e->name, enclosure_id) == 0)
+			break;
+
+	dv = enclosure_get_devs(e ? e->id : enclosure_id);
+	if (!e && !dv && strncmp("encl", enclosure_id, 4) == 0)
+		pr_err("No enclosure name '%s' defined in configuration file\n",
+		       enclosure_id);
+	return dv;
+}
+
+void conf_put_enclosure_devs(struct mddev_dev *devs)
+{
+	while (devs) {
+		struct mddev_dev *next;
+
+		next = devs->next;
+		free(devs->devname);
+		free(devs);
+		devs = next;
+	}
+}
+
 int conf_test_dev(char *devname)
 {
 	struct conf_dev *cd;
diff --git a/enclosure.c b/enclosure.c
index bb5e88e..9c569ea 100644
--- a/enclosure.c
+++ b/enclosure.c
@@ -242,6 +242,33 @@ static struct enclosure *parse_enclosures(void)
 	return enc_list;
 }
 
+/* return a mddev_dev for each populated slot in an enclosure */
+struct mddev_dev *enclosure_get_devs(char *id)
+{
+	struct enclosure *enclosure = parse_enclosures(), *e;
+	struct mddev_dev *dlist = NULL, **pos = &dlist;
+	struct slot *s;
+
+	for (e = enclosure; e; e = e->next)
+		if (strcmp(e->id, id) == 0)
+			break;
+
+	for (s = e ? e->slot : NULL; s; s = s->next) {
+		struct mddev_dev *d;
+
+		if (!s->devname)
+			continue;
+		d = xcalloc(1, sizeof(*d));
+		xasprintf(&d->devname, "/dev/%s", s->devname);
+		*pos = d;
+		pos = &d->next;
+	}
+	free_enclosure(enclosure);
+
+	return dlist;
+
+}
+
 static int detail_platform_enclosure(int verbose, int enumerate, char *enclosure_name)
 {
 	struct enclosure *enclosure = parse_enclosures();
diff --git a/mdadm.c b/mdadm.c
index 7eeeb4f..066fb35 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -298,16 +298,23 @@ int main(int argc, char *argv[])
 			/* If first option is a device, don't force the mode yet */
 			if (opt == 1) {
 				if (devs_found == 0) {
-					dv = xmalloc(sizeof(*dv));
-					dv->devname = optarg;
-					dv->disposition = devmode;
-					dv->writemostly = writemostly;
-					dv->used = 0;
-					dv->next = NULL;
-					*devlistend = dv;
-					devlistend = &dv->next;
-
-					devs_found++;
+					dv = conf_get_enclosure_devs(optarg);
+					if (!dv) {
+						dv = xmalloc(sizeof(*dv));
+						dv->devname = optarg;
+						dv->next = NULL;
+					}
+
+					for (; dv; dv = dv->next) {
+						dv->disposition = devmode;
+						dv->writemostly = writemostly;
+						dv->used = 0;
+						*devlistend = dv;
+						devlistend = &dv->next;
+
+						devs_found++;
+					}
+
 					continue;
 				}
 				/* No mode yet, and this is the second device ... */
@@ -354,16 +361,24 @@ int main(int argc, char *argv[])
 				pr_err("Must give -a/--add for devices to add: %s\n", optarg);
 				exit(2);
 			}
-			dv = xmalloc(sizeof(*dv));
-			dv->devname = optarg;
-			dv->disposition = devmode;
-			dv->writemostly = writemostly;
-			dv->used = 0;
-			dv->next = NULL;
-			*devlistend = dv;
-			devlistend = &dv->next;
 
-			devs_found++;
+			dv = conf_get_enclosure_devs(optarg);
+			if (!dv) {
+				dv = xmalloc(sizeof(*dv));
+				dv->devname = optarg;
+				dv->next = NULL;
+			}
+
+			for (; dv; dv = dv->next) {
+				dv->disposition = devmode;
+				dv->writemostly = writemostly;
+				dv->used = 0;
+				*devlistend = dv;
+				devlistend = &dv->next;
+
+				devs_found++;
+			}
+
 			continue;
 		}
 
diff --git a/mdadm.h b/mdadm.h
index 7ac0b95..f318f1d 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1351,6 +1351,8 @@ extern void enable_fds(int devices);
 extern int parse_auto(char *str, char *msg, int config);
 extern struct mddev_ident *conf_get_ident(char *dev);
 extern struct mddev_dev *conf_get_devs(void);
+extern struct mddev_dev *conf_get_enclosure_devs(char *id);
+extern void conf_put_enclosure_devs(struct mddev_dev *devs);
 extern int conf_test_dev(char *devname);
 extern int conf_test_metadata(const char *version, struct dev_policy *pol, int is_homehost);
 extern struct createinfo *conf_get_create_info(void);
-- 
2.4.6

