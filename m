From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 01/53] Provide a mdstat_ent to subarray helper
Date: Fri, 26 Nov 2010 09:03:59 +0100
Message-ID: <20101126080359.5221.11173.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

...before introducing another open coded instace of this conversion.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 managemon.c |    2 +-
 mdadm.h     |    5 +++++
 util.c      |   11 ++++-------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/managemon.c b/managemon.c
index bab0397..544c4a6 100644
--- a/managemon.c
+++ b/managemon.c
@@ -511,7 +511,7 @@ static void manage_new(struct mdstat_ent *mdstat,
 
 	new->container = container;
 
-	inst = &mdstat->metadata_version[10+strlen(container->devname)+1];
+	inst = to_subarray(mdstat, container->devname);
 
 	new->info.array = mdi->array;
 	new->info.component_size = mdi->component_size;
diff --git a/mdadm.h b/mdadm.h
index 03dd41c..9787f9e 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -979,6 +979,11 @@ static inline int is_subarray(char *vers)
 	return (*vers == '/' || *vers == '-');
 }
 
+static inline char *to_subarray(struct mdstat_ent *ent, char *container)
+{
+	return &ent->metadata_version[10+strlen(container)+1];
+}
+
 #ifdef DEBUG
 #define dprintf(fmt, arg...) \
 	fprintf(stderr, fmt, ##arg)
diff --git a/util.c b/util.c
index c9bdd6e..6f1c1d2 100644
--- a/util.c
+++ b/util.c
@@ -1437,14 +1437,11 @@ int is_subarray_active(char *subarray, char *container)
 	struct mdstat_ent *mdstat = mdstat_read(0, 0);
 	struct mdstat_ent *ent;
 
-	for (ent = mdstat; ent; ent = ent->next) {
-		if (is_container_member(ent, container)) {
-			char *inst = &ent->metadata_version[10+strlen(container)+1];
-
-			if (!subarray || strcmp(inst, subarray) == 0)
+	for (ent = mdstat; ent; ent = ent->next)
+		if (is_container_member(ent, container))
+			if (!subarray ||
+			    strcmp(to_subarray(ent, container), subarray) == 0)
 				break;
-		}
-	}
 
 	free_mdstat(mdstat);
 

