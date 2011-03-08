From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/2] FIX: During reshape array is in active state
Date: Tue, 08 Mar 2011 08:37:39 +0100
Message-ID: <20110308073739.8142.87741.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

During reshape array is in active state. This has to be considered during
calling set_array_state() and setting consistent flag.
Consistent flag during reshape has to be set to 1 to keep volume in clean state.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 monitor.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/monitor.c b/monitor.c
index fb2288d..0d238cf 100644
--- a/monitor.c
+++ b/monitor.c
@@ -384,7 +384,7 @@ static int read_and_act(struct active_array *a)
 			     strncmp(buf, "none", 4) == 0)
 				a->last_checkpoint = a->info.component_size;
 		}
-		a->container->ss->set_array_state(a, a->curr_state <= clean);
+		a->container->ss->set_array_state(a, a->curr_state <= active);
 		a->last_checkpoint = sync_completed;
 	}
 

