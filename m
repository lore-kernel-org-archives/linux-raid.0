From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 01/10] FIX: Cannot exit monitor after takeover
Date: Thu, 02 Dec 2010 09:18:49 +0100
Message-ID: <20101202081849.4639.32739.stgit@gklab-170-024.igk.intel.com>
References: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202080818.4639.38119.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

When performing backward takeover to raid0 monitor cannot exit
for single raid0 array configuration.
Monitor is locked by communication (ping_manager()) after unfreeze()

Do not ping manager for raid0 array as they shouldn't be monitored.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 msg.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/msg.c b/msg.c
index 5ddf6e3..5511ecd 100644
--- a/msg.c
+++ b/msg.c
@@ -381,6 +381,7 @@ void unblock_monitor(char *container, const int unfreeze)
 {
 	struct mdstat_ent *ent, *e;
 	struct mdinfo *sra = NULL;
+	int to_ping = 0;
 
 	ent = mdstat_read(0, 0);
 	if (!ent) {
@@ -394,11 +395,14 @@ void unblock_monitor(char *container, const int unfreeze)
 		if (!is_container_member(e, container))
 			continue;
 		sysfs_free(sra);
-		sra = sysfs_read(-1, e->devnum, GET_VERSION);
+		sra = sysfs_read(-1, e->devnum, GET_VERSION|GET_LEVEL);
+		if (sra->array.level > 0)
+			to_ping++;
 		if (unblock_subarray(sra, unfreeze))
 			fprintf(stderr, Name ": Failed to unfreeze %s\n", e->dev);
 	}
-	ping_monitor(container);
+	if (to_ping)
+		ping_monitor(container);
 
 	sysfs_free(sra);
 	free_mdstat(ent);

