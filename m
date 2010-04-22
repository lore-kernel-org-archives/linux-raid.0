From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 03/13] Add mdstat_by_component
Date: Thu, 22 Apr 2010 23:10:56 +0100
Message-ID: <66C59AD0932712458090B447266D638CD405E3B4@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

This allows finding the array which contains a given component.
Components are named using the kernel-internal string name such
as "sda1" or "hdb".
Don't return member arrays, only the contain that contains them.

Also tidy up the parsing of 'inactive' arrays in /proc/mdstat.
If we see 'inactive' we need to set 'in_devs' immediately as there
is no level coming.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
---
 mdadm.h  |    5 ++++
 mdstat.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index f8a9e0c..402a8c6 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -350,6 +350,10 @@ struct mdstat_ent {
 	int		raid_disks;
 	int		chunk_size;
 	char *		metadata_version;
+	struct dev_member {
+		char			*name;
+		struct dev_member	*next;
+	} 		*members;
 	struct mdstat_ent *next;
 };
 
@@ -358,6 +362,7 @@ extern void free_mdstat(struct mdstat_ent *ms);
 extern void mdstat_wait(int seconds);
 extern void mdstat_wait_fd(int fd, const sigset_t *sigmask);
 extern int mddev_busy(int devnum);
+extern struct mdstat_ent *mdstat_by_component(char *name);
 
 struct map_ent {
 	struct map_ent *next;
diff --git a/mdstat.c b/mdstat.c
index 4a9f370..58d349d 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -83,14 +83,41 @@
 #include	<sys/select.h>
 #include	<ctype.h>
 
+static void free_member_devnames(struct dev_member *m)
+{
+	while(m) {
+		struct dev_member *t = m;
+
+		m = m->next;
+		free(t->name);
+		free(t);
+	}
+}
+
+static void add_member_devname(struct dev_member **m, char *name)
+{
+	struct dev_member *new;
+	char *t;
+
+	if ((t = strchr(name, '[')) == NULL)
+		/* not a device */
+		return;
+
+	new = malloc(sizeof(*new));
+	new->name = strndup(name, t - name);
+	new->next = *m;
+	*m = new;
+}
+
 void free_mdstat(struct mdstat_ent *ms)
 {
 	while (ms) {
 		struct mdstat_ent *t;
-		if (ms->dev) free(ms->dev);
-		if (ms->level) free(ms->level);
-		if (ms->pattern) free(ms->pattern);
-		if (ms->metadata_version) free(ms->metadata_version);
+		free(ms->dev);
+		free(ms->level);
+		free(ms->pattern);
+		free(ms->metadata_version);
+		free_member_devnames(ms->members);
 		t = ms;
 		ms = ms->next;
 		free(t);
@@ -159,6 +186,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 		ent->raid_disks = 0;
 		ent->chunk_size = 0;
 		ent->devcnt = 0;
+		ent->members = NULL;
 
 		ent->dev = strdup(line);
 		ent->devnum = devnum;
@@ -168,9 +196,10 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 			char *eq;
 			if (strcmp(w, "active")==0)
 				ent->active = 1;
-			else if (strcmp(w, "inactive")==0)
+			else if (strcmp(w, "inactive")==0) {
 				ent->active = 0;
-			else if (ent->active >=0 &&
+				in_devs = 1;
+			} else if (ent->active > 0 &&
 				 ent->level == NULL &&
 				 w[0] != '(' /*readonly*/) {
 				ent->level = strdup(w);
@@ -179,6 +208,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 				in_devs = 0;
 			else if (in_devs) {
 				ent->devcnt++;
+				add_member_devname(&ent->members, w);
 				if (strncmp(w, "md", 2)==0) {
 					/* This has an md device as a component.
 					 * If that device is already in the
@@ -310,3 +340,30 @@ int mddev_busy(int devnum)
 	free_mdstat(mdstat);
 	return me != NULL;
 }
+
+struct mdstat_ent *mdstat_by_component(char *name)
+{
+	struct mdstat_ent *mdstat = mdstat_read(0, 0);
+
+	while (mdstat) {
+		struct dev_member *m;
+		struct mdstat_ent *ent;
+		if (ent->metadata_version &&
+		    strncmp(ent->metadata_version, "external:", 9) == 0	 &&
+		    is_subarray(ent->metadata_version+9))
+			/* don't return subarrays, only containers */
+			;
+		else for (m = mdstat->members; m; m = m->next) {
+				if (strcmp(m->name, name) == 0) {
+					free_mdstat(mdstat->next);
+					mdstat->next = NULL;
+					return mdstat;
+				}
+			}
+		ent = mdstat;
+		mdstat = mdstat->next;
+		ent->next = NULL;
+		free_mdstat(ent);
+	}
+	return NULL;
+}
-- 
1.6.4.2

