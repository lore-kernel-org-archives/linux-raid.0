From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: After discarding array give chance monitor to remove it
Date: Mon, 28 Mar 2011 13:56:49 +0200
Message-ID: <20110328115648.13950.11803.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When raid0 expansion occurs, takeover operation is used.
After backward takeover monitor remains in memory.

This happens due to remaining just removed active array in mdmon structures.
If there is no other monitored arrays, mdmon has to finish his work.

Problem was introduced in patch (2011.03.22):
    mdmon: Stop keeping track of RAID0 (and LINEAR) arrays.
Prior to this patch mdmon kicking occurs via replace_array() where
wakeup_monitor() was called.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 managemon.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/managemon.c b/managemon.c
index 67c5951..6662f67 100644
--- a/managemon.c
+++ b/managemon.c
@@ -462,6 +462,7 @@ static void manage_member(struct mdstat_ent *mdstat,
 		int level = map_name(pers, mdstat->level);
 		if (level == 0 || level == LEVEL_LINEAR) {
 			a->container = NULL;
+			wakeup_monitor();
 			return;
 		}
 		else if (a->info.array.level != level && level > 0) {

