From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 21/29] Read chunk size and layout from mdstat
Date: Thu, 09 Dec 2010 16:21:35 +0100
Message-ID: <20101209152135.26876.34388.stgit@gklab-170-024.igk.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Support reading layout and chunk size from mdstat.
It is needed for external reshape with layout or chunk size changes.

This patch removes chunk size changing as result of mdadm action.
Chunk size in mdmon has to change when it is really changed in md only.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 managemon.c |    1 +
 mdadm.h     |    2 ++
 mdstat.c    |   11 +++++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/managemon.c b/managemon.c
index 1774299..172a355 100644
--- a/managemon.c
+++ b/managemon.c
@@ -444,6 +444,7 @@ static void manage_member(struct mdstat_ent *mdstat,
 	a->info.array.raid_disks = mdstat->raid_disks;
 	// MORE
 
+	a->info.array.chunk_size = mdstat->chunk_size;
 	/* honor 'frozen' */
 	if (sysfs_get_str(&a->info, NULL, "metadata_version", buf, sizeof(buf)) > 0)
 		frozen = buf[9] == '-';
diff --git a/mdadm.h b/mdadm.h
index c6dfa3d..ceffb81 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -387,6 +387,8 @@ struct mdstat_ent {
 	int		resync; /* 3 if check, 2 if reshape, 1 if resync, 0 if recovery */
 	int		devcnt;
 	int		raid_disks;
+	int		layout;
+	int		chunk_size;
 	char *		metadata_version;
 	struct dev_member {
 		char			*name;
diff --git a/mdstat.c b/mdstat.c
index c5a07b5..47d81d4 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -146,7 +146,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 	end = &all;
 	for (; (line = conf_line(f)) ; free_line(line)) {
 		struct mdstat_ent *ent;
-		char *w;
+		char *w, *prev = NULL;
 		int devnum;
 		int in_devs = 0;
 		char *ep;
@@ -191,7 +191,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 		ent->dev = strdup(line);
 		ent->devnum = devnum;
 
-		for (w=dl_next(line); w!= line ; w=dl_next(w)) {
+		for (w = dl_next(line); w != line ; prev = w, w = dl_next(w)) {
 			int l = strlen(w);
 			char *eq;
 			if (strcmp(w, "active")==0)
@@ -266,6 +266,13 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 				   w[0] <= '9' &&
 				   w[l-1] == '%') {
 				ent->percent = atoi(w);
+			} else if (strcmp(w, "algorithm") == 0 &&
+				   dl_next(w) != line) {
+				w = dl_next(w);
+				ent->layout = atoi(w);
+			} else if (strncmp(w, "chunk", 5) == 0 &&
+				   prev != NULL) {
+				ent->chunk_size = atoi(prev) * 1024;
 			}
 		}
 		if (insert_here && (*insert_here)) {

