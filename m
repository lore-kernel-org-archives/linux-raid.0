From: Neil Brown <neilb@suse.de>
Subject: Re: A policy frame work for mdadm (incorporating domains and
 hotplug and such)
Date: Thu, 8 Jul 2010 17:58:39 +1000
Message-ID: <20100708175839.4b3b349e@notabene.brown>
References: <66C59AD0932712458090B447266D638CD69A3E95@irsmsx504.ger.corp.intel.com>
	<20100512070231.17342f29@notabene.brown>
	<4BE9D7DC.6000306@intel.com>
	<20100512132624.7a189995@notabene.brown>
	<4BEAF416.5050509@intel.com>
	<66C59AD0932712458090B447266D638CD6A81248@irsmsx504.ger.corp.intel.com>
	<4BEC941A.8070508@intel.com>
	<905EDD02F158D948B186911EB64DB3D11E33E9DE@irsmsx503.ger.corp.intel.com>
	<66C59AD0932712458090B447266D638CD6D80FFF@irsmsx504.ger.corp.intel.com>
	<A9DE54D0CD747C4CB06DCE5B6FA2246FDA55FA48@irsmsx504.ger.corp.intel.com>
	<20100629113727.197a2002@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D11F5235D9@irsmsx503.ger.corp.intel.com>
	<4C2B97E3.2080309@intel.com>
	<20100701165007.4d0d51f7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100701165007.4d0d51f7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Healey, Douglas D" <douglas.d.healey@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 1 Jul 2010 16:50:07 +1000
Neil Brown <neilb@suse.de> wrote:

> So this is how I want these things to work, and this is what I'm going to be
> coding.  I should have the basic framework in place early next week (assuming
> no major interruptions) at which point I'll make the code available.

As one might expect there was a fairly significant interruption, so I didn't
get as far as I hoped.

Below is my current code, which compiles but is otherwise untested.

This is just the infrastructure for reading, manipulating, and checking
policy.

The next big step is implementing 'mbr' and 'gpt' metadata types (for
partitioning) and making sure I can make that idea work.
Then I need to generate a domain list given an array, and write code
to compare domain lists.

Then we should be able to start connecting the policy framework with the code
that will make use of the policy.

NeilBrown

Add policy framework.

From: NeilBrown <neilb@suse.de>

---
 Makefile |   10 +
 config.c |   10 +
 mdadm.h  |   59 ++++++++
 policy.c |  471 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 544 insertions(+), 6 deletions(-)
 create mode 100644 policy.c

diff --git a/Makefile b/Makefile
index 3af1665..11181e7 100644
--- a/Makefile
+++ b/Makefile
@@ -87,26 +87,26 @@ MAN4DIR = $(MANDIR)/man4
 MAN5DIR = $(MANDIR)/man5
 MAN8DIR = $(MANDIR)/man8
 
-OBJS =  mdadm.o config.o mdstat.o  ReadMe.o util.o Manage.o Assemble.o Build.o \
+OBJS =  mdadm.o config.o policy.o mdstat.o  ReadMe.o util.o Manage.o Assemble.o Build.o \
 	Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o Query.o \
 	Incremental.o \
 	mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
 	restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o \
 	platform-intel.o probe_roms.o
 
-SRCS =  mdadm.c config.c mdstat.c  ReadMe.c util.c Manage.c Assemble.c Build.c \
+SRCS =  mdadm.c config.c policy.c mdstat.c  ReadMe.c util.c Manage.c Assemble.c Build.c \
 	Create.c Detail.c Examine.c Grow.c Monitor.c dlink.c Kill.c Query.c \
 	Incremental.c \
 	mdopen.c super0.c super1.c super-ddf.c super-intel.c bitmap.c \
 	restripe.c sysfs.c sha1.c mapfile.c crc32.c sg_io.c msg.c \
 	platform-intel.c probe_roms.c
 
-MON_OBJS = mdmon.o monitor.o managemon.o util.o mdstat.o sysfs.o config.o \
+MON_OBJS = mdmon.o monitor.o managemon.o util.o mdstat.o sysfs.o config.o policy.o \
 	Kill.o sg_io.o dlink.o ReadMe.o super0.o super1.o super-intel.o \
 	super-ddf.o sha1.o crc32.o msg.o bitmap.o \
 	platform-intel.o probe_roms.o
 
-MON_SRCS = mdmon.c monitor.c managemon.c util.c mdstat.c sysfs.c config.c \
+MON_SRCS = mdmon.c monitor.c managemon.c util.c mdstat.c sysfs.c config.c policy.c \
 	Kill.c sg_io.c dlink.c ReadMe.c super0.c super1.c super-intel.c \
 	super-ddf.c sha1.c crc32.c msg.c bitmap.c \
 	platform-intel.c probe_roms.c
@@ -114,7 +114,7 @@ MON_SRCS = mdmon.c monitor.c managemon.c util.c mdstat.c sysfs.c config.c \
 STATICSRC = pwgr.c
 STATICOBJS = pwgr.o
 
-ASSEMBLE_SRCS := mdassemble.c Assemble.c Manage.c config.c dlink.c util.c \
+ASSEMBLE_SRCS := mdassemble.c Assemble.c Manage.c config.c policy.c dlink.c util.c \
 	super0.c super1.c super-ddf.c super-intel.c sha1.c crc32.c sg_io.c mdstat.c \
 	platform-intel.c probe_roms.c sysfs.c
 ASSEMBLE_AUTO_SRCS := mdopen.c
diff --git a/config.c b/config.c
index 20c46e9..995b41d 100644
--- a/config.c
+++ b/config.c
@@ -75,7 +75,7 @@ char DefaultConfFile[] = CONFFILE;
 char DefaultAltConfFile[] = CONFFILE2;
 
 enum linetype { Devices, Array, Mailaddr, Mailfrom, Program, CreateDev,
-		Homehost, AutoMode, LTEnd };
+		Homehost, AutoMode, Policy, PartPolicy, LTEnd };
 char *keywords[] = {
 	[Devices]  = "devices",
 	[Array]    = "array",
@@ -85,6 +85,8 @@ char *keywords[] = {
 	[CreateDev]= "create",
 	[Homehost] = "homehost",
 	[AutoMode] = "auto",
+	[Policy]   = "policy",
+	[PartPolicy]="part-policy",
 	[LTEnd]    = NULL
 };
 
@@ -766,6 +768,12 @@ void load_conffile(void)
 		case AutoMode:
 			autoline(line);
 			break;
+		case Policy:
+			policyline(line, rule_policy);
+			break;
+		case PartPolicy:
+			policyline(line, rule_part);
+			break;
 		default:
 			fprintf(stderr, Name ": Unknown keyword %s\n", line);
 		}
diff --git a/mdadm.h b/mdadm.h
index d15e73e..f7e6548 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -724,6 +724,65 @@ extern void get_one_disk(int mdfd, mdu_array_info_t *ainf,
 			 mdu_disk_info_t *disk);
 void wait_for(char *dev, int fd);
 
+/*
+ * Data structures for policy management.
+ * Each device can have a policy structure that lists
+ * various name/value pairs each possibly with a metadata associated.
+ * The policy list is sorted by name/value/metadata
+ */
+struct dev_policy {
+	struct dev_policy *next;
+	char *name;	/* None of these strings are allocated.  They are
+			 * all just references to strings which are known
+			 * to exist elsewhere.
+			 * name and metadata can be compared by address equality.
+			 */
+	char *metadata;
+	char *value;
+};
+
+extern char pol_act[], pol_domain[], pol_metadata[];
+
+/* iterate over the sublist starting at list, having the same
+ * 'name' as 'list', and matching the given metadata (Where
+ * NULL matches anything
+ */
+#define pol_for_each(item, list, metadata)				\
+	for (item = list;						\
+	     item && item->name == list->name;				\
+	     item = item->next)						\
+		if (!(!metadata || !item->metadata || metadata == item->metadata)) \
+			; else
+
+/*
+ * policy records read from mdadm are largely just name-value pairs.
+ * The names are constants, not strdupped
+ */
+struct pol_rule {
+	struct pol_rule *next;
+	char *type;	/* rule_policy or rule_part */
+	struct rule {
+		struct rule *next;
+		char *name;
+		char *value;
+		char *dups; /* duplicates of 'value' with a partNN appended */
+	} *rule;
+};
+
+extern char rule_policy[], rule_part[];
+extern char rule_path[], rule_type[];
+
+extern void policyline(char *line, char *type);
+
+enum policy_action {
+	act_default,
+	act_include,
+	act_re_add,
+	act_spare,
+	act_force_spare,
+	act_err
+};
+
 #if __GNUC__ < 3
 struct stat64;
 #endif
diff --git a/policy.c b/policy.c
new file mode 100644
index 0000000..7019d11
--- /dev/null
+++ b/policy.c
@@ -0,0 +1,471 @@
+/*
+ * mdadm - manage Linux "md" devices aka RAID arrays.
+ *
+ * Copyright (C) 2001-2009 Neil Brown <neilb@suse.de>
+ *
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ *    Author: Neil Brown
+ *    Email: <neilb@suse.de>
+ */
+
+#include "mdadm.h"
+#include <dirent.h>
+#include <fnmatch.h>
+#include <ctype.h>
+#include "dlink.h"
+/*
+ * Policy module for mdadm.
+ * A policy statement about a device lists a set of values for each
+ * of a set of names.  Each value can have a metadata type as context.
+ *
+ * names include:
+ *   action - the actions that can be taken on hot-plug
+ *   domain - the domain(s) that the device is part of
+ *
+ * Policy information is extracted from various sources, but
+ * particularly from a set of policy rules in mdadm.conf
+ */
+
+void pol_new(struct dev_policy **pol, char *name, char *val, char *metadata)
+{
+	struct dev_policy *n = malloc(sizeof(*n));
+	n->name = name;
+	n->value = val;
+	n->metadata = metadata;
+	n->next = *pol;
+	*pol = n;
+}
+
+int pol_lesseq(struct dev_policy *a, struct dev_policy *b)
+{
+	int cmp;
+
+	if (a->name < b->name)
+		return 1;
+	if (a->name > b->name)
+		return 0;
+
+	cmp = strcmp(a->value, b->value);
+	if (cmp < 0)
+		return 1;
+	if (cmp > 0)
+		return 0;
+
+	return (a->metadata <= b->metadata);
+}
+
+void pol_sort(struct dev_policy **pol)
+{
+	/* sort policy list in *pol by name/metadata/value
+	 * using merge sort
+	 */
+
+	struct dev_policy *pl[2];
+	pl[0] = *pol;
+	pl[1] = NULL;
+
+	do {
+		struct dev_policy **plp[2], *p[2];
+		int curr = 0;
+		struct dev_policy nul = { NULL };
+		struct dev_policy *prev = &nul;
+		int next = 0;
+
+		/* p[] are the two lists that we are merging.
+		 * plp[] are the ends of the two lists we create
+		 * from the merge.
+		 * 'curr' is which of plp[] that we are currently
+		 *   adding items to.
+		 * 'next' is which if p[] we will take the next
+		 *   item from.
+		 * 'prev' is that last value, which was placed in
+		 * plp[curr].
+		 */
+		plp[0] = &pl[0];
+		plp[1] = &pl[1];
+		p[0] = pl[0];
+		p[1] = pl[1];
+
+		/* take least of p[0] and p[1]
+		 * if it is larger than prev, add to
+		 * plp[curr], else swap curr then add
+		 */
+		while (p[0] || p[1]) {
+			if (p[next] == NULL ||
+			    (p[1-next] != NULL &&
+			     !(pol_lesseq(prev, p[1-next])
+			       ^pol_lesseq(p[1-next], p[next])
+			       ^pol_lesseq(p[next], prev)))
+				)
+				next = 1 - next;
+
+			if (!pol_lesseq(prev, p[next]))
+				curr = 1 - curr;
+
+			*plp[curr] = prev = p[next];
+			plp[curr] = &p[next]->next;
+			p[next] = p[next]->next;
+		}
+		*plp[0] = NULL;
+		*plp[1] = NULL;
+	} while (pl[0] && pl[1]);
+	if (pl[0])
+		*pol = pl[0];
+	else
+		*pol = pl[1];
+}
+
+void pol_dedup(struct dev_policy *pol)
+{
+	/* This is a sorted list - remove duplicates. */
+	while (pol && pol->next) {
+		if (pol_lesseq(pol->next, pol)) {
+			struct dev_policy *tmp = pol->next;
+			pol->next = tmp->next;
+			free(tmp);
+		} else
+			pol = pol->next;
+	}
+}
+
+#if 0
+struct dev_policy *pol_dup(struct dev_policy *pol)
+{
+	struct dev_policy *rv = NULL;
+	struct dev_policy **ep = &rv;
+
+	while (pol) {
+		pol_new(ep, pol->name, pol->val, pol->metadata);
+		ep = &(*ep)->next;
+		pol = pol->next;
+	}
+	return rv;
+}
+#endif
+
+/*
+ * pol_find finds the first entry in the policy
+ * list to match name.
+ * If it returns non-NULL there is at least one
+ * value, but how many can only be found by
+ * iterating through the list.
+ */
+struct dev_policy *pol_find(struct dev_policy *pol, char *name)
+{
+	while (pol && pol->name < name)
+		pol = pol->next;
+
+	if (!pol || pol->name != name)
+		return NULL;
+	return pol;
+}
+
+char *path_from_fd(int fd)
+{
+	struct stat stb1, stb2;
+	int prefix_len;
+	DIR *by_path;
+	char symlink[PATH_MAX] = "/dev/disk/by_path/";
+	struct dirent *ent;
+
+	fstat(fd, &stb1);
+
+	by_path = opendir(symlink);
+	if (!by_path)
+		return NULL;
+	prefix_len = strlen(symlink);
+
+	while ((ent = readdir(by_path)) != NULL) {
+		if (ent->d_type != DT_LNK)
+			continue;
+		strncpy(symlink + prefix_len,
+			ent->d_name,
+			sizeof(symlink) - prefix_len);
+		if (stat(symlink, &stb2) < 0)
+			continue;
+		if ((stb1.st_mode & S_IFMT) !=
+		    (stb2.st_mode & S_IFMT))
+			continue;
+		if (stb1.st_rdev != stb2.st_rdev)
+			continue;
+		closedir(by_path);
+		return strdup(ent->d_name);
+	}
+	closedir(by_path);
+	return NULL;
+}
+
+char type_part[] = "part";
+char type_disk[] = "disk";
+char *type_from_fd(int fd)
+{
+	if (test_partition(fd))
+		return type_part;
+	else
+		return type_disk;
+}
+
+int pol_match(struct rule *rule, char *path, char *type)
+{
+	/* check if this rule matches on path and type */
+	int pathok = 0; /* 0 == no path, 1 == match, -1 == no match yet */
+	int typeok = 0;
+
+	while (rule) {
+		if (rule->name == rule_path) {
+			if (pathok == 0)
+				pathok = -1;
+			if (fnmatch(rule->value, path, 0) == 0)
+				pathok = 1;
+		}
+		if (rule->name == rule_type) {
+			if (typeok == 0)
+				typeok = -1;
+			if (strcmp(rule->value, type) == 0)
+				typeok = 1;
+		}
+		rule = rule->next;
+	}
+	return pathok >= 0 && typeok >= 0;
+}
+
+void pol_merge(struct dev_policy **pol, struct rule *rule)
+{
+	/* copy any name assignments from rule into pol */
+	struct rule *r;
+	char *metadata = NULL;
+	for (r = rule; r ; r = r->next)
+		if (r->name == pol_metadata)
+			metadata = r->value;
+
+	for (r = rule; r ; r = r->next)
+		if (r->name == pol_act ||
+		    r->name == pol_domain)
+			pol_new(pol, r->name, r->value, metadata);
+}
+
+static int path_has_part(char *path, char **part)
+{
+	/* check if path ends with "-partNN" and
+	 * if it does, place a pointer to "-pathNN"
+	 * in 'part'.
+	 */
+	int l = strlen(path);
+	while (l > 1 && isdigit(path[l-1]))
+		l--;
+	if (l < 5 || strncmp(path+l-5, "-part", 5) != 0)
+		return 0;
+	*part = path+l-4;
+	return 1;
+}
+
+void pol_merge_part(struct dev_policy **pol, struct rule *rule, char *part)
+{
+	/* copy any name assignments from rule into pol, appending
+	 * -part to any domain.  The string with -part appended is
+	 * stored with the rule so it has a lifetime to match
+	 * the rule.
+	 */
+	struct rule *r;
+	char *metadata = NULL;
+	for (r = rule; r ; r = r->next)
+		if (r->name == pol_metadata)
+			metadata = r->value;
+
+	for (r = rule; r ; r = r->next) {
+		if (r->name == pol_act)
+			pol_new(pol, r->name, r->value, metadata);
+		else if (r->name == pol_domain) {
+			char *dom;
+			int len;
+			if (r->dups == NULL)
+				r->dups = dl_head();
+			len = strlen(r->value);
+			for (dom = dl_next(r->dups); dom != r->dups; dom = dl_next(dom))
+				if (strcmp(dom+len+1, part)== 0)
+					break;
+			if (dom == r->dups) {
+				char *newdom = dl_strndup(r->value, len + 1 + strlen(part));
+				strcat(strcat(newdom, "-"), part);
+				dl_add(r->dups, newdom);
+				dom = newdom;
+			}
+			pol_new(pol, r->name, dom, metadata);
+		}
+	}
+}
+
+static struct pol_rule *config_rules = NULL;
+static struct pol_rule **config_rules_end = NULL;
+static int config_rules_has_path = 0;
+
+/*
+ * most policy comes from a set policy rules that are
+ * read from the config file.
+ * device_policy() gathers policy information for the
+ * device opened in 'fd'.
+ */
+struct dev_policy *device_policy(int fd)
+{
+	char *path;
+	char *type = type_from_fd(fd);
+	struct pol_rule *rules;
+	struct dev_policy *pol = NULL;
+
+	if (config_rules_has_path) {
+		path = path_from_fd(fd);
+		if (!path || !type) {
+			free(path);
+			return NULL;
+		}
+	}
+
+	rules = config_rules;
+
+	while (rules) {
+		char *part;
+		if (rules->type == rule_policy)
+			if (pol_match(rules->rule, path, type))
+				pol_merge(&pol, rules->rule);
+		if (rules->type == rule_part && strcmp(type, type_part) == 0)
+			if (path_has_part(path, &part)) {
+				*part = 0;
+				if (pol_match(rules->rule, path, type_disk))
+					pol_merge_part(&pol, rules->rule, part+1);
+				*part = '-';
+			}
+		rules = rules->next;
+	}
+	pol_sort(&pol);
+	pol_dedup(pol);
+	free(path);
+	return pol;
+}
+
+/*
+ * process policy rules read from config file.
+ */
+
+char rule_path[] = "path";
+char rule_type[] = "type";
+
+char rule_policy[] = "policy";
+char rule_part[] = "part-policy";
+
+char pol_metadata[] = "metadata";
+char pol_act[] = "action";
+char pol_domain[] = "domain";
+
+static int try_rule(char *w, char *name, struct rule **rp)
+{
+	struct rule *r;
+	int len = strlen(name);
+	if (strncmp(w, name, len) != 0 ||
+	    name[len] != '=')
+		return 0;
+	r = malloc(sizeof(*r));
+	r->next = *rp;
+	r->name = name;
+	r->value = strdup(w+len+1);
+	r->dups = NULL;
+	*rp = r;
+	return 1;
+}
+
+void policyline(char *line, char *type)
+{
+	struct pol_rule *pr;
+	char *w;
+
+	if (config_rules_end == NULL)
+		config_rules_end = &config_rules;
+
+	pr = malloc(sizeof(*pr));
+	pr->type = type;
+	pr->rule = NULL;
+	for (w = dl_next(line); w != line ; w = dl_next(w)) {
+		if (try_rule(w, rule_path, &pr->rule))
+			config_rules_has_path = 1;
+		else if (! try_rule(w, rule_type, &pr->rule) &&
+			 ! try_rule(w, pol_metadata, &pr->rule) &&
+			 ! try_rule(w, pol_act, &pr->rule) &&
+			 ! try_rule(w, pol_domain, &pr->rule))
+			fprintf(stderr, Name ": policy rule %s unrecognised and ignored\n",
+				w);
+	}
+	pr->next = config_rules;
+	config_rules = pr;
+}
+
+void policy_free(void)
+{
+	while (config_rules) {
+		struct pol_rule *pr = config_rules;
+		struct rule *r;
+
+		config_rules = config_rules->next;
+
+		for (r = pr->rule; r; ) {
+			struct rule *next = r->next;
+			free(r->value);
+			if (r->dups)
+				free_line(r->dups);
+			free(r);
+			r = next;
+		}
+		free(pr);
+	}
+	config_rules_end = NULL;
+	config_rules_has_path = 0;
+}
+
+void dev_policy_free(struct dev_policy *p)
+{
+	struct dev_policy *t;
+	while (p) {
+		t = p;
+		p = p->next;
+		free(t);
+	}
+}
+
+enum policy_action map_act(char *act)
+{
+	if (strcmp(act, "include") == 0)
+		return act_include;
+	if (strcmp(act, "re-add") == 0)
+		return act_re_add;
+	if (strcmp(act, "spare") == 0)
+		return act_spare;
+	if (strcmp(act, "force-spare") == 0)
+		return act_force_spare;
+	return act_err;
+}
+
+enum policy_action policy_action(struct dev_policy *plist, char *metadata)
+{
+	enum policy_action rv = act_default;
+	struct dev_policy *p;
+
+	plist = pol_find(plist, pol_act);
+	pol_for_each(p, plist, metadata) {
+		enum policy_action a = map_act(p->value);
+		if (a > rv)
+			rv = a;
+	}
+	return rv;
+}
