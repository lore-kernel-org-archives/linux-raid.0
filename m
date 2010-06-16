From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 2/3] md: clear layout after ->raid0 takeover
Date: Wed, 16 Jun 2010 11:55:14 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E873F03@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From: Maciej Trela <maciej.trela@intel.com>

After takeover from raid5/10 -> raid0 mddev->layout is not cleared.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 drivers/md/raid0.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c index 7c7c380..ac09b7d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -592,6 +592,7 @@ static void *raid0_takeover_raid5(mddev_t *mddev)
 
 	/* Set new parameters */
 	mddev->new_level = 0;
+	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
 	mddev->raid_disks--;
 	mddev->delta_disks = -1;
@@ -631,6 +632,7 @@ static void *raid0_takeover_raid10(mddev_t *mddev)
 
 	/* Set new parameters */
 	mddev->new_level = 0;
+	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
 	mddev->delta_disks = - mddev->raid_disks / 2;
 	mddev->raid_disks += mddev->delta_disks;

