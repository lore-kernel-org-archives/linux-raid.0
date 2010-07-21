From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 02/10] mdadm: read chunksize and layout from mdstat
Date: Wed, 21 Jul 2010 12:18:08 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040804E2A49BA@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Maciej Trela <maciej.trela@intel.com>

Support reading layout and chunk size from mdstat.
It is needed for external reshape with layout or chunk size changes.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 mdadm.h  |    1 +
 mdstat.c |   11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index 9889c60..e5e56fe 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -348,6 +348,7 @@ struct mdstat_ent {
 	int		resync; /* 1 if resync, 0 if recovery */
 	int		devcnt;
 	int		raid_disks;
+	int		layout;
 	int		chunk_size;
 	char *		metadata_version;
 	struct mdstat_ent *next;
diff --git a/mdstat.c b/mdstat.c
index af1cae4..287ed48 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -118,7 +118,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 	end = &all;
 	for (; (line = conf_line(f)) ; free_line(line)) {
 		struct mdstat_ent *ent;
-		char *w;
+		char *w, *prev = NULL;
 		int devnum;
 		int in_devs = 0;
 		char *ep;
@@ -163,7 +163,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 		ent->dev = strdup(line);
 		ent->devnum = devnum;
 
-		for (w=dl_next(line); w!= line ; w=dl_next(w)) {
+		for (w = dl_next(line); w != line ; prev = w, w = dl_next(w)) {
 			int l = strlen(w);
 			char *eq;
 			if (strcmp(w, "active")==0)
@@ -220,6 +220,13 @@ struct mdstat_ent *mdstat_read(int hold, int start)
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

