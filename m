From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 4/4] md: raid10: Fix compilation warning
Date: Thu, 16 Jul 2020 13:54:43 +0900
Message-ID: <20200716045443.662056-5-damien.lemoal@wdc.com>
References: <20200716045443.662056-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200716045443.662056-1-damien.lemoal@wdc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Remove the if statement around the call to sysfs_link_rdev() in
raid10_start_reshape() to avoid the compilation warning:

warning: suggest braces around empty body in an ‘if’ statement

when compiling with W=1.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/raid10.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2c47474fa69d..14b1ba732cd7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4307,8 +4307,8 @@ static int raid10_start_reshape(struct mddev *mddev)
 					else
 						rdev->recovery_offset = 0;
 
-					if (sysfs_link_rdev(mddev, rdev))
-						/* Failure here  is OK */;
+					/* Failure here is OK */
+					sysfs_link_rdev(mddev, rdev);
 				}
 			} else if (rdev->raid_disk >= conf->prev.raid_disks
 				   && !test_bit(Faulty, &rdev->flags)) {
-- 
2.26.2
