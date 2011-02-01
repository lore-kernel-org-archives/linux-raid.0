From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 6/8] FIX: Do not set array size after reshape in mdadm
Date: Tue, 01 Feb 2011 14:49:44 +0100
Message-ID: <20110201134944.13398.41001.stgit@gklab-128-013.igk.intel.com>
References: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110201134226.13398.4071.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Do not set array size after reshape in mdadm,
as it is up to mdmon metadata handler (set_array_state()) now.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   35 -----------------------------------
 1 files changed, 0 insertions(+), 35 deletions(-)

diff --git a/Grow.c b/Grow.c
index 8229b4d..a74da89 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2045,41 +2045,6 @@ started:
 		}
 	}
 
-	/* set new array size if required customer_array_size is used
-	 * by this metadata.
-	 */
-	if (reshape.before.data_disks !=
-	    reshape.after.data_disks &&
-	    info->custom_array_size) {
-		struct mdinfo *info2;
-		char *subarray = strchr(info->text_version+1, '/')+1;
-
-		info2 = st->ss->container_content(st, subarray);
-		if (info2) {
-			unsigned long long current_size = 0;
-			unsigned long long new_size =
-				info2->custom_array_size/2;
-
-			if (sysfs_get_ll(sra,
-					 NULL,
-					 "array_size",
-					 &current_size) == 0 &&
-			    new_size > current_size) {
-				if (sysfs_set_num(sra, NULL,
-						  "array_size", new_size)
-				    < 0)
-					dprintf("Error: Cannot"
-						" set array size");
-				else
-					dprintf("Array size "
-						"changed");
-				dprintf(" from %llu to %llu.\n",
-					current_size, new_size);
-			}
-			sysfs_free(info2);
-		}
-	}
-
 	if (info->new_level != reshape.level) {
 
 		c = map_num(pers, info->new_level);

