From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [md PATCH 7/8] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:44:06 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65BF@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From c16036b925f2929df6eaabeaa451fc5361ec7f0f Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:27:51 +0100
Subject: [PATCH] OLCE: Fix for bio I/O error

Changes to be committed:
	modified:   raid5.c
During OLCE/reshape when delta_disks is greatrer than 0, none of request was rescheduled.
This leads to bio I/O error as requests confilcts with reshape process

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 drivers/md/raid5.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 724798e..656a852 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3920,6 +3920,13 @@ static int make_request(struct request_queue *q, struct bio * bi)
 					spin_unlock_irq(&conf->device_lock);
 					schedule();
 					goto retry;
+				} else {
+					if ((mddev->delta_disks > 0) &&
+					    (logical_sector < conf->reshape_safe)) {
+						spin_unlock_irq(&conf->device_lock);
+						schedule();
+						goto retry;
+					}
 				}
 			}
 			spin_unlock_irq(&conf->device_lock);
-- 
1.6.0.2

