From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 6/6] FIX: sync_completed == 0 causes reshape cancellation in
	metadata
Date: Thu, 13 Jan 2011 15:50:50 +0100
Message-ID: <20110113145050.12728.43280.stgit@gklab-128-013.igk.intel.com>
References: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113144252.12728.82642.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

md signals reshape completion (whole area or parts) by setting sync_completed to 0.
This causes in set_array_state() to rollback metadata changes (super-intel.c:4977.
To avoid this do not allow for set last_checkpoint to 0 if reshape is finished.

This was also root cause of my previous fix for finalization reshape that I agreed earlier is not necessary,

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 monitor.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/monitor.c b/monitor.c
index 1107d47..b7287d8 100644
--- a/monitor.c
+++ b/monitor.c
@@ -363,8 +363,10 @@ static int read_and_act(struct active_array *a)
 		/* Reshape has progressed or completed so we need to
 		 * update the array state - and possibly the array size
 		 */
-		a->last_checkpoint = sync_completed;
+		if (sync_completed != 0)
+			a->last_checkpoint = sync_completed;
 		a->container->ss->set_array_state(a, a->curr_state <= clean);
+		a->last_checkpoint = sync_completed;
 	}
 
 	if (sync_completed > a->last_checkpoint)

