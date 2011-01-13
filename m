From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 2/6] Set reshape.after.data_disks for raid0<->raid10 takeover
Date: Thu, 13 Jan 2011 16:32:35 +0100
Message-ID: <20110113153235.20266.84653.stgit@gklab-128-111.igk.intel.com>
References: <20110113152722.20266.24174.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113152722.20266.24174.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

reshape.after.data_disks field must be initiated
for raid0<->rai10 transition.
Instead calculated spares_needed variable in reshape_array
function has random value.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Grow.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 763287b..47a8fb8 100644
--- a/Grow.c
+++ b/Grow.c
@@ -966,6 +966,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		re->level = 0;
 		re->parity = 0;
 		re->before.data_disks = new_disks;
+		re->after.data_disks = re->before.data_disks;
 		re->before.layout = 0;
 		re->backup_blocks = 0;
 		return NULL;
@@ -1003,6 +1004,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 			re->parity = 0;
 			re->before.data_disks = (info->array.raid_disks +
 						 info->delta_disks);
+			re->after.data_disks = re->before.data_disks;
 			re->before.layout = info->new_layout;
 			re->backup_blocks = 0;
 			return NULL;

