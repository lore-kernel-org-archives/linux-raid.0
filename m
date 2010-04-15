From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 17/28] md: don't reference gendisk in getgeo
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.88275.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Using ->array_sectors rather than get_capacity() is more
direct and is a step towards relaxing the tight connection
between mddev and gendisk.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 16f032b..56a2c12 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5555,7 +5555,7 @@ static int md_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 
 	geo->heads = 2;
 	geo->sectors = 4;
-	geo->cylinders = get_capacity(mddev->gendisk) / 8;
+	geo->cylinders = mddev->array_sectors / 8;
 	return 0;
 }
 


