From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 5/5] FIX: Compute spares_needed basing on metadata info
Date: Tue, 08 Mar 2011 14:25:11 +0100
Message-ID: <20110308132511.9578.81775.stgit@gklab-128-013.igk.intel.com>
References: <20110308132228.9578.34611.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110308132228.9578.34611.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When metadata raid_disks information is correct for reshape working level,
this information has to be used for spares_needed calculation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index a05bcef..68962bf 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1661,7 +1661,7 @@ static int reshape_array(char *container, int fd, char *devname,
 	sysfs_freeze_array(info);
 	spares_needed = max(reshape.before.data_disks,
 			    reshape.after.data_disks)
-		+ reshape.parity - array.raid_disks;
+		+ reshape.parity - info->array.raid_disks;
 
 	if (!force &&
 	    info->new_level > 1 &&

