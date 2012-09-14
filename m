From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] fix: imsm: do not accept too small sizes
Date: Fri, 14 Sep 2012 16:20:31 +0200
Message-ID: <20120914142030.19105.28984.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

Inappriopriate error messages (e.g. mdadm: platform does not support
raid5 with 0 disk) have been displayed when too small size was given.
This patch fixes it.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 1d36613..107550f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -9744,6 +9744,13 @@ enum imsm_reshape_type imsm_analyze_change(struct supertype *st,
 				    get_imsm_raid_level(dev->vol.map),
 				    chunk * 1024,
 				    geo->size * 2);
+		if (geo->size == 0) {
+			pr_err("Error. Size expansion is " \
+				   "supported only (current size is %llu, " \
+				   "requested size /rounded/ is 0).\n",
+				   current_size);
+			goto analyse_change_exit;
+		}
 	}
 
 	if ((current_size != geo->size) && (geo->size > 0)) {

