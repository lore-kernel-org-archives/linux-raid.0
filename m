From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 5/6] FIX: Container can be left frozen
Date: Tue, 08 Feb 2011 14:31:09 +0100
Message-ID: <20110208133109.8787.93211.stgit@gklab-128-013.igk.intel.com>
References: <20110208131046.8787.1777.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110208131046.8787.1777.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When container operation fails before child process starts,
array can be left frozen because container_reshape() doesn't make
unfreeze() operation in all error cases, as it is responsible for.

add unfreeze() operation for error case scenarios in reshape_container()

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 09d7439..e77ab80 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2123,8 +2123,10 @@ int reshape_container(char *container, int cfd, char *devname,
 	if (reshape_super(st, -1, info->new_level,
 			  info->new_layout, info->new_chunk,
 			  info->array.raid_disks + info->delta_disks,
-			  backup_file, devname, quiet))
+			  backup_file, devname, quiet)) {
+		unfreeze(st);
 		return 1;
+	}
 
 	sync_metadata(st);
 
@@ -2135,6 +2137,7 @@ int reshape_container(char *container, int cfd, char *devname,
 	switch (fork()) {
 	case -1: /* error */
 		perror("Cannot fork to complete reshape\n");
+		unfreeze(st);
 		return 1;
 	default: /* parent */
 		printf(Name ": multi-array reshape continues in background\n");

