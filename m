From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/3] imsm: FIX: Check array alignment before expansion
Date: Tue, 05 Apr 2011 15:46:17 +0200
Message-ID: <20110405134617.4843.10973.stgit@gklab-128-013.igk.intel.com>
References: <20110405134609.4843.95211.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110405134609.4843.95211.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

It can occur that OROM creates array not aligned properly.
Expansion cannot be run in such cases. It is detected in analyse_change().
It is too late. This causes that metadata is in migration state already,
when expansion cannot be started.
This problem has to be detected before metadata is updated,
in all arrays in reshaped container.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 9c2caf7..9e9d6a9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6946,6 +6946,14 @@ static int imsm_reshape_is_allowed_on_container(struct supertype *st,
 					 geo->raid_disks > 1 ? "s" : "");
 				break;
 			}
+			/* check if component size is aligned to chunk size
+			 */
+			if (info->component_size %
+			    (info->array.chunk_size/512)) {
+				dprintf("Component size is not alligned to "
+					"chunk size\n");
+				break;
+			}
 		}
 
 		if (*old_raid_disks &&

