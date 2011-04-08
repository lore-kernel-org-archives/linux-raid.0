From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: Raid0 expansion cannot be restarted (v2)
Date: Fri, 08 Apr 2011 15:06:18 +0200
Message-ID: <20110408130618.4967.3599.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When raid0 expansion is restarted, mdadm refuses to correctly assemble
array because critical section cannot be restored from backup file.
mdadm exits with information:
	mdadm: Failed to restore critical section for reshape - sorry.

For raid0 new level is 0, current array level is 4.
Function Grow_restart() doesn't allow for level change.
It should be allowed for raid0, while raid4 is reshape mid-point only.
'Native' raid0 reshape is not possible, because md doesn't support it.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index d6ecde2..53d0a68 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3102,7 +3102,8 @@ int Grow_restart(struct supertype *st, struct mdinfo *info, int *fdlist, int cnt
 	unsigned long long  nstripe, ostripe;
 	int ndata, odata;
 
-	if (info->new_level != info->array.level)
+	if ((info->new_level != info->array.level) &&
+	    !((info->new_level == 0) && (info->array.level == 4)))
 		return 1; /* Cannot handle level changes (they are instantaneous) */
 
 	odata = info->array.raid_disks - info->delta_disks - 1;

