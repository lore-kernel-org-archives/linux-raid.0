From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/4] FIX: Fiddle raid_disks number for external metadta
Date: Fri, 15 Apr 2011 14:30:39 +0200
Message-ID: <20110415123039.6601.10809.stgit@gklab-128-013.igk.intel.com>
References: <20110415122820.6601.48084.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110415122820.6601.48084.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

For external metadata migration is started already.
For native metadata migration starts when md is pushed to reshape state.
Change raid disks to currently present in md to calculate required
configuration change in analyse_change() and add required disks to md.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 017a79d..4c221ad 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1676,6 +1676,8 @@ static int reshape_array(char *container, int fd, char *devname,
 	if (info->reshape_active) {
 		int new_level = info->new_level;
 		info->new_level = UnSet;
+		if (container)
+			info->array.raid_disks -= info->delta_disks;
 		msg = analyse_change(info, &reshape);
 		info->new_level = new_level;
 		if (!restart)

