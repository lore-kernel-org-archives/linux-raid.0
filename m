From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 1/2] FIX: imsm: Rebuild does not start on second failed disk
Date: Wed, 23 Mar 2011 16:04:20 +0100
Message-ID: <20110323150420.15226.56305.stgit@gklab-128-111.igk.intel.com>
References: <20110323150115.15226.20076.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110323150115.15226.20076.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Problem:
If we have an array with two failed disks and the array is in degraded
state (now it is possible only for raid10 with 2 degraded mirrors) and
we have two spare devices in the container, recovery process should be
triggered on booth failed disks. It does not.
Recovery is triggered only for first failed disk.
Second failed disk remains unchanged although the spare drive exists
in the container and is ready to recovery.

Root cause:
mdmon does not check if the array is degraded after recovery of first
drive is completed.

Resolution:
Check if current number of disks in the array equals target number of disks.
If not, trigger degradation check and then recovery process.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 monitor.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index 4a34bc1..7ac5907 100644
--- a/monitor.c
+++ b/monitor.c
@@ -219,6 +219,7 @@ static int read_and_act(struct active_array *a)
 	int deactivate = 0;
 	struct mdinfo *mdi;
 	int dirty = 0;
+	int count = 0;
 
 	a->next_state = bad_word;
 	a->next_action = bad_action;
@@ -311,7 +312,10 @@ static int read_and_act(struct active_array *a)
 						   mdi->curr_state);
 			if (! (mdi->curr_state & DS_INSYNC))
 				check_degraded = 1;
+			count++;
 		}
+		if (count != a->info.array.raid_disks)
+			check_degraded = 1;
 	}
 
 	if (!deactivate &&

