From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 6/6] FIX: Unblock disk in kernel only if it is blocked.
Date: Wed, 19 Jan 2011 17:23:49 +0100
Message-ID: <20110119162349.8738.43217.stgit@gklab-128-111.igk.intel.com>
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

Missing condition during setting next state for disk.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 monitor.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/monitor.c b/monitor.c
index ed3ce49..4fba5fd 100644
--- a/monitor.c
+++ b/monitor.c
@@ -336,7 +336,9 @@ static int read_and_act(struct active_array *a)
 			a->container->ss->set_disk(a, mdi->disk.raid_disk,
 						   mdi->curr_state);
 			check_degraded = 1;
-			mdi->next_state |= DS_UNBLOCK;
+			/* if '-blocked' wasn't passed to kernel, do it now */
+			if (mdi->curr_state == DS_BLOCKED)
+				mdi->next_state |= DS_UNBLOCK;
 			if (a->curr_state == read_auto) {
 				a->container->ss->set_array_state(a, 0);
 				a->next_state = active;

