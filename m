From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: Cannot remove failed disk from container
Date: Thu, 29 Dec 2011 14:27:38 +0100
Message-ID: <20111229132738.5659.99578.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

When disk is failed by mdadm e.g.:
    mdadm -f /dev/md/raid_array /dev/sdX
and then it is tried to be removed from container e.g.:
    mdadm --remove /dev/md/container /dev/sdX

mdadm refuses it with information:
    mdadm: /dev/sdX is still in use, cannot remove.

Problem was introduced in commit:
    monitor: don't unblock a device that isn't blocked.
    /2011-12-06/
Disk without unblocking it cannot be really removed from array
and reference to if is still reported under 'holders' sysfs entry.

As this commit is necessary for managing degraded array during
reshape and rebuild code for unconditional unblocking disk on removal
is added.
Guard for setting DS_UNBLOCK during reshape/rebuild avoids process
performance degradation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 monitor.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index 29bde18..ce66625 100644
--- a/monitor.c
+++ b/monitor.c
@@ -346,6 +346,12 @@ static int read_and_act(struct active_array *a)
 				a->next_state = active;
 			}
 			if (a->curr_state > readonly)
+				/* For disk removal when no md process
+				 * /e.g. reshape/ is in progress, trigger
+				 * unconditional device unblock first
+				 */
+				if (a->curr_action == idle)
+					mdi->next_state |= DS_UNBLOCK;
 				mdi->next_state |= DS_REMOVE;
 		}
 	}

