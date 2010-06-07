From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 05/16] md: reject devices with bad blocks and v0.90
	metadata.
Date: Mon, 07 Jun 2010 10:07:54 +1000
Message-ID: <20100607000754.13302.36871.stgit@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

v0.90 metadata cannot record bad blocks, so if there are any we need
to fail the devices.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 63b185e..8a888d5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1310,6 +1310,10 @@ static void super_90_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 
 	sb->this_disk = sb->disks[rdev->desc_nr];
 	sb->sb_csum = calc_sb_csum(sb);
+
+	if (rdev->badblocks.count)
+		/* Cannot record individual bad blocks so... */
+		md_error(mddev, rdev);
 }
 
 /*


