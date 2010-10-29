From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 17/17] Policy is aware of metadata disk's controller domains.
Date: Fri, 29 Oct 2010 15:28:26 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FDA@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From 4c66bae1c8ee1e7cf1af0bba786ab25fda0680d4 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Mon, 8 Nov 2010 01:48:45 +0100
Subject: [PATCH 17/17] Policy is aware of metadata disk's controller domains.

Platform (metadata) domain let the metadata handlers differentiate
disk domains based on controllers that the disk belongs to.
Platform domain is sub-domain inside user specified domain
in mdadm.conf configuration files inheriting all parameters from it.
The metadata domain name is used disk domain matching functions.
The disk with the same metadata domain name belong to the same metadata
domain.

New metadata handler is added that retrieves platform domain string based
on disk path:
const char *(*get_disk_controller_domain)(const char *path);

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 mdadm.h       |   18 ++++++++-
 policy.c      |  128 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 super-intel.c |   37 ++++++++++++++++-
 3 files changed, 170 insertions(+), 13 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index b540cba..20ce1be 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -683,6 +683,21 @@ extern struct superswitch {
 	 */
 	struct mdinfo *(*activate_spare)(struct active_array *a,
 					 struct metadata_update **updates);
+	/*
+	 * Return statically allocated string that represents metadata specific
+	 * controller domain of the disk. The domain is used in disk domain
+	 * matching functions. Disks belong to the same domain if the they have
+	 * the same domain from mdadm.conf and belong the same metadata domain.
+	 * Returning NULL or not providing this handler means that metadata
+	 * does not distinguish the differences between disks that belong to
+	 * different controllers. They are in the domain specified by
+	 * configuration file (mdadm.conf).
+	 * In case when the metadata has the notion of domains based on disk
+	 * it shall return NULL for disks that do not belong to the controller
+	 * the supported domains. Such disks will form another domain and won't
+	 * be mixed with supported ones.
+	 */
+	const char *(*get_disk_controller_domain)(const char *path);
 
 	int swapuuid; /* true if uuid is bigending rather than hostendian */
 	int external;
@@ -774,7 +789,7 @@ struct dev_policy {
 	char *value;
 };
 
-extern char pol_act[], pol_domain[], pol_metadata[], pol_auto[];
+extern char pol_act[], pol_domain[], pol_metadata[], pol_auto[], pol_path[];
 
 /* iterate over the sublist starting at list, having the same
  * 'name' as 'list', and matching the given metadata (Where
@@ -836,6 +851,7 @@ extern int disk_action_allows(struct mdinfo *disk, const char *metadata,
 struct domainlist {
 	struct domainlist *next;
 	char *dom;
+	char *internal;
 };
 
 extern int domain_test(struct domainlist *dom, struct dev_policy *pol,
diff --git a/policy.c b/policy.c
index dae8e44..daee52a 100644
--- a/policy.c
+++ b/policy.c
@@ -27,6 +27,13 @@
 #include <fnmatch.h>
 #include <ctype.h>
 #include "dlink.h"
+
+static const char *get_platform_domain(const char *metadata, const char *path);
+static int dom_less(struct domainlist *dom, char *dom_name,
+		    const char *internal);
+static int dom_equal(struct domainlist *dom, char *domain,
+		     const char *internal);
+static void dev_policy_entry_free(struct dev_policy *p);
 /*
  * Policy module for mdadm.
  * A policy statement about a device lists a set of values for each
@@ -165,7 +172,7 @@ static void pol_dedup(struct dev_policy *pol)
 		if (pol_lesseq(pol->next, pol)) {
 			struct dev_policy *tmp = pol->next;
 			pol->next = tmp->next;
-			free(tmp);
+			dev_policy_entry_free(tmp);
 		} else
 			pol = pol->next;
 	}
@@ -258,7 +265,7 @@ static int pol_match(struct rule *rule, char *path, char *type)
 	return pathok >= 0 && typeok >= 0;
 }
 
-static void pol_merge(struct dev_policy **pol, struct rule *rule)
+ static void pol_merge(struct dev_policy **pol, struct rule *rule)
 {
 	/* copy any name assignments from rule into pol */
 	struct rule *r;
@@ -360,6 +367,16 @@ struct dev_policy *path_policy(char *path, char *type)
 			}
 		rules = rules->next;
 	}
+	/* add path information */
+	if (path && pol) {
+		char *disk_path;
+		disk_path = strdup(path);
+		if (disk_path == NULL) {
+			dev_policy_entry_free(pol);
+			return NULL;
+		}
+		pol_new(&pol, pol_path, disk_path, NULL);
+	}
 	pol_sort(&pol);
 	pol_dedup(pol);
 	return pol;
@@ -407,10 +424,12 @@ char rule_type[] = "type";
 char rule_policy[] = "policy";
 char rule_part[] = "part-policy";
 
+
 char pol_metadata[] = "metadata";
 char pol_act[] = "action";
 char pol_domain[] = "domain";
 char pol_auto[] = "auto";
+char pol_path[] = "path";
 
 static int try_rule(char *w, char *name, struct rule **rp)
 {
@@ -502,13 +521,20 @@ void policy_free(void)
 	config_rules_has_path = 0;
 }
 
+static void dev_policy_entry_free(struct dev_policy *p)
+{
+	if (p->name == pol_path)
+		free(p->value);
+	free(p);
+}
+
 void dev_policy_free(struct dev_policy *p)
 {
 	struct dev_policy *t;
 	while (p) {
 		t = p;
 		p = p->next;
-		free(t);
+		dev_policy_entry_free(t);
 	}
 }
 
@@ -571,39 +597,114 @@ int disk_action_allows(struct mdinfo *disk, const char *metadata, enum policy_ac
  * We keep the list of domains in a sorted linked list
  * As dev policies are already sorted, this is fairly easy to manage.
  */
-
-static struct domainlist **domain_merge_one(struct domainlist **domp, char *domain)
+static struct domainlist **domain_merge_one(struct domainlist **domp,
+					    char *domain, const char *internal)
 {
 	/* merge a domain name into a sorted list and return the
 	 * location of the insertion or match
 	 */
 	struct domainlist *dom = *domp;
 
-	while (dom && strcmp(dom->dom, domain) < 0) {
+	while (dom && dom_less(dom, domain, internal)) {
 		domp = &dom->next;
 		dom = *domp;
 	}
-	if (dom == NULL || strcmp(dom->dom, domain) != 0) {
+	if (dom == NULL ||
+	    (!dom_equal(dom, domain, internal))) {
 		dom = malloc(sizeof(*dom));
 		dom->next = *domp;
 		dom->dom = domain;
+		dom->internal = (char *) internal;
 		*domp = dom;
 	}
 	return domp;
 }
 
+/*
+ * Get platform internal domain string based on disk path.
+ * Platform domain let the metadata handlers differenciate
+ * disk domains based on controllers that the disk belongs to.
+ * Platform domain is sub-domain inside user specified
+ * domain in config files inherinting all parameters from it.
+ * The platform domain strings are not released by policy code.
+ * NULL handler means that the metadata does not supprt internal
+ * domains (disk's controller is irrelevant for it)
+ */
+static const char *get_platform_domain(const char *metadata, const char *path)
+{
+	struct superswitch *super;
+	super = version_to_superswitch((char *)metadata);
+	if (!super ||
+	    (super->get_disk_controller_domain == NULL) ||
+	    !path)
+		return NULL;
+	return super->get_disk_controller_domain(path);
+}
+
+#if (DEBUG)
+void dump_policy(struct dev_policy *policy)
+{
+	while (policy) {
+		dprintf("policy: %p name: %s value: %s metadata: %s\n",
+			policy,
+			policy->name,
+			policy->value,
+			policy->metadata);
+		policy = policy->next;
+	}
+}
+#endif
+
 void domain_merge(struct domainlist **domp, struct dev_policy *pollist,
-			 const char *metadata)
+		  const char *metadata)
 {
 	/* Add to 'domp' all the domains in pol that apply to 'metadata'
 	 * which are not already in domp
 	 */
+	const char *internal = NULL;
 	struct dev_policy *pol;
+	struct dev_policy *pathpol = NULL;
+
+	pathpol = pol_find(pollist, pol_path);
+	if (pathpol && pathpol->value)
+		internal = get_platform_domain(metadata, pathpol->value);
+#if (DEBUG)
+	if (pathpol)
+		dump_policy(pathpol);
+#endif
 	pollist = pol_find(pollist, pol_domain);
 	pol_for_each(pol, pollist, metadata)
-		domp = domain_merge_one(domp, pol->value);
+		domp = domain_merge_one(domp, pol->value, internal);
 }
 
+/*
+ * Domain comparition function:
+ * Order: a = (dom->dom, dom->internal),  b = (dom_name, internal)
+ * a < b if (dom->dom < dom_name) or
+ *          (dom->dom == domian) and (dom->internal < internal)
+ * NULL string is less then any string.
+ */
+static int dom_less(struct domainlist *dom, char *dom_name,
+		    const char *internal)
+{
+	int domtest;
+
+	domtest = strcmp(dom->dom, dom_name);
+	return ((domtest < 0) ||
+		((domtest == 0) &&
+		 (((dom->internal == NULL) && (internal != NULL)) ||
+		  ((internal != NULL) &&
+		   (strcmp(dom->internal, internal) < 0)))));
+}
+
+static int dom_equal(struct domainlist *dom, char *domain, const char* internal)
+{
+	return ((strcmp(dom->dom, domain) == 0) &&
+		(((dom->internal == NULL) && (internal == NULL)) ||
+		 (dom->internal && internal &&
+		  (strcmp(dom->internal, internal) == 0))));
+ }
+
 int domain_test(struct domainlist *dom, struct dev_policy *pol,
 		const char *metadata)
 {
@@ -614,13 +715,18 @@ int domain_test(struct domainlist *dom, struct dev_policy *pol,
 	 */
 	int found_any = 0;
 	struct dev_policy *p;
+	struct dev_policy *pathpol = NULL;
+	const char *internal = NULL;
 
+	pathpol = pol_find(pol, pol_path);
+	if (pathpol)
+		internal = get_platform_domain(metadata, pathpol->value);
 	pol = pol_find(pol, pol_domain);
 	pol_for_each(p, pol, metadata) {
 		found_any = 1;
-		while (dom && strcmp(dom->dom, p->value) < 0)
+		while (dom && dom_less(dom, p->value, internal))
 			dom = dom->next;
-		if (!dom || strcmp(dom->dom, p->value) != 0)
+		if (!dom || !dom_equal(dom, p->value, internal))
 			return 0;
 	}
 	return found_any;
diff --git a/super-intel.c b/super-intel.c
index 4062872..38c9c59 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5735,6 +5735,41 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned ind
 }
 #endif /* MDASSEMBLE */
 
+static char disk_by_path[] = "/dev/disk/by-path/";
+
+static const char *imsm_get_disk_controller_domain(const char *path)
+{
+	struct sys_dev *list, *hba = NULL;
+	char disk_path[PATH_MAX];
+	int ahci = 0;
+	char *dpath = NULL;
+
+	list = find_driver_devices("pci", "ahci");
+	for (hba = list; hba; hba = hba->next)
+		if (devpath_to_vendor(hba->path) == 0x8086)
+			break;
+
+	if (hba) {
+		struct stat st;
+
+		strncpy(disk_path, disk_by_path, PATH_MAX - 1);
+		strncat(disk_path, path, PATH_MAX - strlen(disk_path) - 1);
+		if (stat(disk_path, &st) == 0) {
+			dpath = devt_to_devpath(st.st_rdev);
+			if (dpath)
+				ahci = path_attached_to_hba(dpath, hba->path);
+		}
+	}
+	dprintf("path: %s(%s) hba: %s attached: %d\n",
+		path, dpath, (hba) ? hba->path : "NULL", ahci);
+	free_sys_dev(&list);
+	if (ahci)
+		return "ahci";
+	else
+		return NULL;
+}
+
+
 struct superswitch super_imsm = {
 #ifndef	MDASSEMBLE
 	.examine_super	= examine_super_imsm,
@@ -5770,7 +5805,7 @@ struct superswitch super_imsm = {
 	.match_metadata_desc = match_metadata_desc_imsm,
 	.container_content = container_content_imsm,
 	.default_layout = imsm_level_to_layout,
-
+	.get_disk_controller_domain = imsm_get_disk_controller_domain,
 	.external	= 1,
 	.name = "imsm",
 
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

