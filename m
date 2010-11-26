From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 38/53] mdadm: read chunksize and layout from mdstat
Date: Fri, 26 Nov 2010 09:08:47 +0100
Message-ID: <20101126080847.5221.15211.stgit@gklab-170-024.igk.intel.com>
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

Support reading layout and chunk size from mdstat.
It is needed for external reshape with layout or chunk size changes.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm.h  |    1 +
 mdstat.c |   11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 2c08ee6..95f355e 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -358,6 +358,7 @@ struct mdstat_ent {
 	int		resync; /* 1 if resync, 0 if recovery */
 	int		devcnt;
 	int		raid_disks;
+	int		layout;
 	int		chunk_size;
 	char *		metadata_version;
 	struct dev_member {
diff --git a/mdstat.c b/mdstat.c
index 47be2bb..7e73310 100644
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
@@ -192,7 +192,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 		ent->dev = strdup(line);
 		ent->devnum = devnum;
 
-		for (w=dl_next(line); w!= line ; w=dl_next(w)) {
+		for (w = dl_next(line); w != line ; prev = w, w = dl_next(w)) {
 			int l = strlen(w);
 			char *eq;
 			if (strcmp(w, "active")==0)
@@ -251,6 +251,13 @@ struct mdstat_ent *mdstat_read(int hold, int start)
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

