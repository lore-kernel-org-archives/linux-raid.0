From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 24/31] mdadm: read chunksize and layout from mdstat
Date: Tue, 9 Nov 2010 17:01:23 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CAA8@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Support reading layout and chunk size from mdstat.
It is needed for external reshape with layout or chunk size changes.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/mdadm.h  |    1 +
 mdadm/mdadm/mdstat.c |   11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/mdadm/mdadm/mdadm.h b/mdadm/mdadm/mdadm.h index cd095fc..68df20b 100644
--- a/mdadm/mdadm/mdadm.h
+++ b/mdadm/mdadm/mdadm.h
@@ -358,6 +358,7 @@ struct mdstat_ent {
 	int		resync; /* 1 if resync, 0 if recovery */
 	int		devcnt;
 	int		raid_disks;
+	int		layout;
 	int		chunk_size;
 	char *		metadata_version;
 	struct dev_member {
diff --git a/mdadm/mdadm/mdstat.c b/mdadm/mdadm/mdstat.c index 47f54cb..aecd1d4 100644
--- a/mdadm/mdadm/mdstat.c
+++ b/mdadm/mdadm/mdstat.c
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

