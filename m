From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 10/21] FIX: Unfreeze not only container for external metadata
Date: Tue, 23 Nov 2010 13:40:57 +0100
Message-ID: <20101123124057.17770.29791.stgit@gklab-170-024.igk.intel.com>
References: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101123123900.17770.75516.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Unfreeze for external metadata case should unfreeze arrays and container,
not only container as so far. Unfreeze() function doesn't know
what the changes to configuration was made so far, and if arrays
are pulled from frozen state in md.
Unfreeze() has to make sure by performing array unfreeze that all arrays
are not frozen and then unblock monitor.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/Grow.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/mdadm/mdadm/Grow.c b/mdadm/mdadm/Grow.c
index 127e535..9b1c4c5 100644
--- a/mdadm/mdadm/Grow.c
+++ b/mdadm/mdadm/Grow.c
@@ -491,16 +491,14 @@ static void unfreeze(struct supertype *st, int frozen)
 		return;
 
 	if (st->ss->external)
-		return unfreeze_container(st);
-	else {
-		struct mdinfo *sra = sysfs_read(-1, st->devnum, GET_VERSION);
-
-		if (sra)
-			sysfs_set_str(sra, NULL, "sync_action", "idle");
-		else
-			fprintf(stderr, Name ": failed to unfreeze array\n");
-		sysfs_free(sra);
-	}
+		unfreeze_container(st);
+
+	struct mdinfo *sra = sysfs_read(-1, st->devnum, GET_VERSION);
+	if (sra)
+		sysfs_set_str(sra, NULL, "sync_action", "idle");
+	else
+		fprintf(stderr, Name ": failed to unfreeze array\n");
+	sysfs_free(sra);
 }
 
 void wait_reshape(struct mdinfo *sra)

