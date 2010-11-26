From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 14/53] FIX: Cannot exit monitor after takeover
Date: Fri, 26 Nov 2010 09:05:37 +0100
Message-ID: <20101126080537.5221.28837.stgit@gklab-170-024.igk.intel.com>
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

When performing backward takeover to raid0 monitor cannot exit
for single raid0 array configuration.
Monitor is locked by communication (ping_manager()) after unfreeze()

Do not ping manager for raid0 array as they shouldn't be monitored.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 msg.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/msg.c b/msg.c
index 8e7ebfd..95c6f0b 100644
--- a/msg.c
+++ b/msg.c
@@ -385,11 +385,12 @@ void unblock_monitor(char *container, const int unfreeze)
 		if (!is_container_member(e, container))
 			continue;
 		sysfs_free(sra);
-		sra = sysfs_read(-1, e->devnum, GET_VERSION);
+		sra = sysfs_read(-1, e->devnum, GET_VERSION|GET_LEVEL);
 		if (unblock_subarray(sra, unfreeze))
 			fprintf(stderr, Name ": Failed to unfreeze %s\n", e->dev);
 	}
-	ping_monitor(container);
+	if (sra && sra->array.level > 0)
+		ping_monitor(container);
 
 	sysfs_free(sra);
 	free_mdstat(ent);

