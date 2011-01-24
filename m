From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 3/5] Mistake in raid1->raid5 migration
Date: Mon, 24 Jan 2011 15:17:20 +0100
Message-ID: <20110124141720.16405.54759.stgit@gklab-128-111.igk.intel.com>
References: <20110124141704.16405.6081.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110124141704.16405.6081.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

1. Mistake in target level comparison.
2. Initialize reshape->after.data_disks field
to proper spares_needed calculation
---
 Grow.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index a8da20a..e1e509e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -941,11 +941,12 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 			return NULL;
 		}
 		if (info->array.raid_disks == 2 &&
-		    info->array.raid_disks == 5) {
+		    info->new_level == 5) {
 			/* simple in-place conversion */
 			re->level = 5;
 			re->parity = 1;
 			re->before.data_disks = 1;
+			re->after.data_disks = 1;
 			re->before.layout = ALGORITHM_LEFT_SYMMETRIC;
 			re->backup_blocks = 0;
 			return NULL;

