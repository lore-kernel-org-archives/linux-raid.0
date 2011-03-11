From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/2] FIX: Last_checkpoint has to be initialized in per disk
	units
Date: Fri, 11 Mar 2011 12:59:12 +0100
Message-ID: <20110311115912.12324.34950.stgit@gklab-128-013.igk.intel.com>
References: <20110311115051.12324.75830.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110311115051.12324.75830.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

last_checkpoint is variable that tracks sync_complete sysfs entry.
sync_complete is per disk counter, so initializing during starting from checkpoint
has to have this in mind and convert reshape position properly.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 managemon.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/managemon.c b/managemon.c
index 1362a0e..87fdd1d 100644
--- a/managemon.c
+++ b/managemon.c
@@ -667,6 +667,15 @@ static void manage_new(struct mdstat_ent *mdstat,
 		if (sysfs_get_ll(mdi, NULL, "reshape_position",
 			&new->last_checkpoint) != 0)
 			new->last_checkpoint = 0;
+		else {
+			int data_disks = mdi->array.raid_disks;
+			if (mdi->array.level == 5)
+				data_disks--;
+			if (mdi->array.level == 6)
+				data_disks -= 2;
+
+			new->last_checkpoint /= data_disks;
+		}
 		dprintf("mdmon: New monitored array is under reshape.\n"
 			"       Last checkpoint is: %llu\n",
 			new->last_checkpoint);

