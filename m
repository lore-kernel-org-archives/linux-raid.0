From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 34/34] Raid0: detect reshape on array start
Date: Tue, 04 Jan 2011 15:40:06 +0100
Message-ID: <20110104144006.6697.7928.stgit@gklab-128-013.igk.intel.com>
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

When raid0 array is takeovered to raid4 for reshape it should be possible to detect
that array for reshape is monitored now for metadata update.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 monitor.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index 937cc6b..a0068d3 100644
--- a/monitor.c
+++ b/monitor.c
@@ -235,6 +235,13 @@ static int read_and_act(struct active_array *a)
 		}
 	}
 
+	if (a->curr_state > inactive &&
+	    a->prev_state == inactive) {
+		/* array has been started
+		 * possible that container operation has to be completed
+		 */
+		a->container->ss->set_array_state(a, 0);
+	}
 	if (a->curr_state <= inactive &&
 	    a->prev_state > inactive) {
 		/* array has been stopped */

