From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/4] FIX: Target disk number depends on source raid level
Date: Fri, 11 Feb 2011 14:44:22 +0100
Message-ID: <20110211134422.6212.27478.stgit@gklab-128-013.igk.intel.com>
References: <20110211133959.6212.57757.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110211133959.6212.57757.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Target number of data disk depends on source raid level not on working raid level.
if transition is from raid0 to raid5 with working level== 5, this means that we add one disk (delta_disks == 1)
but data disks number doesn't change.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index b04faf1..baa493a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1174,7 +1174,7 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 			return "Cannot convert to RAID5 from this level";
 		if (info->delta_disks == UnSet)
 			re->after.data_disks = re->before.data_disks;
-		else if (re->level == 5)
+		else if (info->array.level == 5)
 			re->after.data_disks =
 				re->before.data_disks + info->delta_disks;
 		else

