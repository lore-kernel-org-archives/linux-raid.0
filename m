From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 27/28] md/raid1: fix confusing 'redirect sector' message.
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.68004.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Tim Burgess <ozburgess@gmail.com>
List-Id: linux-raid.ids

This message seems to suggest the named device is the one on which a
read failed, however it is actually the device that the read will be
redirected to.
So make the message a little clearer.

Reported-by: Tim Burgess <ozburgess@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index dd0ef70..d0d32f0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1688,10 +1688,10 @@ static void raid1d(mddev_t *mddev)
 				r1_bio->bios[r1_bio->read_disk] = bio;
 				rdev = conf->mirrors[disk].rdev;
 				if (printk_ratelimit())
-					printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
-					       " another mirror\n",
-					       bdevname(rdev->bdev,b),
-					       (unsigned long long)r1_bio->sector);
+					printk(KERN_ERR "raid1: redirecting sector %llu to"
+					       " other mirror: %s\n",
+					       (unsigned long long)r1_bio->sector,
+					       bdevname(rdev->bdev,b));
 				bio->bi_sector = r1_bio->sector + rdev->data_offset;
 				bio->bi_bdev = rdev->bdev;
 				bio->bi_end_io = raid1_end_read_request;


