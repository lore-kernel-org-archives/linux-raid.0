From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 5/6] FIX: Reset disk state if disk is missing
Date: Wed, 19 Jan 2011 17:23:41 +0100
Message-ID: <20110119162341.8738.83269.stgit@gklab-128-111.igk.intel.com>
References: <20110119161925.8738.85284.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119161925.8738.85284.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

If we can't read actual disk state, it shoud be initiated
to 0.
Overwise it may be out of date value resulting false action
later in code (e.g. set disk to improper state).


Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 monitor.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index b7287d8..ed3ce49 100644
--- a/monitor.c
+++ b/monitor.c
@@ -232,6 +232,8 @@ static int read_and_act(struct active_array *a)
 		if (mdi->state_fd >= 0) {
 			mdi->recovery_start = read_resync_start(mdi->recovery_fd);
 			mdi->curr_state = read_dev_state(mdi->state_fd);
+		} else {
+			mdi->curr_state = 0;
 		}
 	}
 

