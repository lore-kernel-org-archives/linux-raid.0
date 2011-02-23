From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/4] FIX: disks added beyond array should be counted during
	reshape
Date: Wed, 23 Feb 2011 14:51:39 +0100
Message-ID: <20110223135139.17074.7166.stgit@gklab-128-013.igk.intel.com>
References: <20110223133557.17074.9671.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110223133557.17074.9671.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

During expansion there is more working disks that array can have.
Disks with set raid_disk (not a spare disk) during reshape should be counted
to allow array state transition to read_only state.

Array reconfiguration to new geometry should be done before reshape will
be started.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 317be8b..4d41081 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1504,6 +1504,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 {
 	struct mdinfo *dev, *sra;
 	int working = 0, preexist = 0;
+	int expansion = 0;
 	struct map_ent *map = NULL;
 
 	sysfs_init(content, mdfd, 0);
@@ -1522,6 +1523,9 @@ int assemble_container_content(struct supertype *st, int mdfd,
 			working++;
 		else if (errno == EEXIST)
 			preexist++;
+		else if (dev->disk.raid_disk >= content->array.raid_disks &&
+			  content->reshape_active)
+			expansion++;
 	if (working == 0) {
 		close(mdfd);
 		return 1;/* Nothing new, don't try to start */
@@ -1532,7 +1536,8 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		   content->uuid, chosen_name);
 
 	if (runstop > 0 ||
-		 (working + preexist) >= content->array.working_disks) {
+		 (working + preexist + expansion) >=
+			content->array.working_disks) {
 		int err;
 
 		switch(content->array.level) {
@@ -1566,6 +1571,9 @@ int assemble_container_content(struct supertype *st, int mdfd,
 					chosen_name, working + preexist);
 			if (preexist)
 				fprintf(stderr, " (%d new)", working);
+			if (expansion)
+				fprintf(stderr, " ( + %d for expansion)",
+					expansion);
 			fprintf(stderr, "\n");
 		}
 		if (!err)

