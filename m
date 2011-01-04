From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 19/34] imsm: Finalize reshape in metadata
Date: Tue, 04 Jan 2011 15:38:08 +0100
Message-ID: <20110104143808.6697.95865.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When reshape is finished monitor calls set_array_state() and finishes migration in metadata.
This change allows for finishing metadata migration on reshape end.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index f07665b..58ed702 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4894,6 +4894,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 				dev->vol.curr_migr_unit = __cpu_to_le32(unit);
 				super->updates_pending++;
 			}
+			return 0;
 		} else {
 			if (a->last_checkpoint == 0 && a->prev_action == reshape) {
 				/* for some reason we aborted the reshape.
@@ -4928,7 +4929,6 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 				super->updates_pending++;
 			}				
 		}
-		return 0;
 	}
 
 	/* before we activate this array handle any missing disks */

