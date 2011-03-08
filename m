From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/5] FIX: Set new raid disks when delta_disks is valid
Date: Tue, 08 Mar 2011 14:24:47 +0100
Message-ID: <20110308132446.9578.63183.stgit@gklab-128-013.igk.intel.com>
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

(Possible problem)
When delta_disks is not equal to 0, and is not UnSet (INT_MAX)
new raid disks can be set. Especially in second case passed value
can cause an error in array configuration.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 sysfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/sysfs.c b/sysfs.c
index a7dfcc2..571eab5 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -575,7 +575,9 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 				    info->reshape_progress);
 		rv |= sysfs_set_num(info, NULL, "chunk_size", info->new_chunk);
 		rv |= sysfs_set_num(info, NULL, "layout", info->new_layout);
-		rv |= sysfs_set_num(info, NULL, "raid_disks",
+		if ((info->delta_disks != 0) &&
+		    (info->delta_disks != UnSet))
+			rv |= sysfs_set_num(info, NULL, "raid_disks",
 				    info->array.raid_disks + info->delta_disks);
 		/* We don't set 'new_level' here.  That can only happen
 		 * once the reshape completes.

