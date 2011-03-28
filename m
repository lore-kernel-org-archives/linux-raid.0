From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH] FIX: Cleanup after raid45->raid0 takeover
Date: Mon, 28 Mar 2011 15:31:57 +0200
Message-ID: <20110328133156.10923.98647.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Problem:
After raid4->raid0 takeover operation, another takeover operation
(e.g raid0->raid10) results "kernel oops".
Root cause:
Variables 'degraded' and 'plug' in mddev structure are not cleared
after raid45->raid0 takeover.

This patch reset these variables.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 drivers/md/raid0.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c0ac457..5d47113 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -603,6 +603,8 @@ static void *raid0_takeover_raid45(mddev_t *mddev)
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
 	mddev->raid_disks--;
 	mddev->delta_disks = -1;
+	mddev->degraded = 0;
+	mddev->plug = NULL;
 	/* make sure it will be not marked as dirty */
 	mddev->recovery_cp = MaxSector;
 

