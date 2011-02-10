From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/4] FIX: Add raid5 to raid0 case to analyse_change()
Date: Thu, 10 Feb 2011 14:56:43 +0100
Message-ID: <20110210135643.9276.89033.stgit@gklab-128-013.igk.intel.com>
References: <20110210134710.9276.91430.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110210134710.9276.91430.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Transition raid5 to raid0 was not covered in analyse_change()
Missing code added.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 08fc258..b04faf1 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1056,6 +1056,14 @@ char *analyse_change(struct mdinfo *info, struct reshape *re)
 		info->array.layout = ALGORITHM_PARITY_N;
 	case 5:
 		switch (info->new_level) {
+		case 0:
+			re->level = 5;
+			info->delta_disks = 0;
+			re->before.data_disks = info->array.raid_disks - 1;
+			re->before.layout = info->array.layout;
+			re->after.data_disks = info->array.raid_disks;
+			re->after.layout = 0;
+			break;
 		case 4:
 			re->level = info->array.level;
 			re->before.data_disks = info->array.raid_disks - 1;

