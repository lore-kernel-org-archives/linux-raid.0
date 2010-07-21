From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 1/2] md: raid5 return new layout in mdstat while reshaping
Date: Wed, 21 Jul 2010 12:03:51 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040804E2A4993@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From: Maciej Trela <maciej.trela@intel.com>

While reshaping, report mdstat algorithm according to the new_layout.

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 drivers/md/raid5.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c index 4d85632..b7c6561 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5256,8 +5256,12 @@ static void status(struct seq_file *seq, mddev_t *mddev)
 	raid5_conf_t *conf = mddev->private;
 	int i;
 
-	seq_printf(seq, " level %d, %dk chunk, algorithm %d", mddev->level,
-		mddev->chunk_sectors / 2, mddev->layout);
+	seq_printf(seq, " level %d, %dk chunk,", mddev->level,
+		mddev->chunk_sectors / 2);
+	if (mddev->reshape_position != MaxSector)
+		seq_printf(seq, " algorithm %d", mddev->new_layout);
+	else
+		seq_printf(seq, " algorithm %d", mddev->layout);
 	seq_printf (seq, " [%d/%d] [", conf->raid_disks, conf->raid_disks - mddev->degraded);
 	for (i = 0; i < conf->raid_disks; i++)
 		seq_printf (seq, "%s",
