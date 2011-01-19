From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 3/6] Check number of failed disks durig raid10->raid0 takeover
Date: Wed, 19 Jan 2011 17:23:25 +0100
Message-ID: <20110119162325.8738.10485.stgit@gklab-128-111.igk.intel.com>
References: <20110119161925.8738.85284.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119161925.8738.85284.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Number of failed disks MUST be half of initial number of disks.
If number of failed disks is different we should not update
metadata- data corruption may occur after array reassemlation.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e284a4a..b25d4fb 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5835,6 +5835,10 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
 	map = get_imsm_map(dev, 0);
 
 	if (u->direction == R10_TO_R0) {
+		/* Number of failed disks must be half of initial disk number */
+		if (imsm_count_failed(super, dev) != (map->num_members / 2))
+			return 0;
+
 		/* iterate through devices to mark removed disks as spare */
 		for (dm = super->disks; dm; dm = dm->next) {
 			if (dm->disk.status & FAILED_DISK) {

