From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 31/34] imsm: FIX: do not repair raid4 arrays
Date: Tue, 04 Jan 2011 15:39:42 +0100
Message-ID: <20110104143942.6697.48922.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

As raid4 is not supported by imsm (this is takeovered raid0)
do not fix degraded raid4 arrays.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 1be0e72..b01d52a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5432,6 +5432,12 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 		/* No repair during migration */
 		return NULL;
 
+	if (a->info.array.level == 4)
+		/* No repair for takeovered array
+		 * imsm doesn't support raid4
+		 */
+		return NULL;
+
 	if (imsm_check_degraded(super, dev, failed) != IMSM_T_STATE_DEGRADED)
 		return NULL;
 

