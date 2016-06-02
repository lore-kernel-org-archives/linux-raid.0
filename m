From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 03/18] md/raid10: fix refounct imbalance when resyncing
 an array with a replacement device.
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.2298.stgit@noble>
References: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160602061319.2939.72280.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you have a raid10 with a replacement device that is resyncing -
e.g. after a crash before the replacement was complete - the write to
the replacement will increment nr_pending on the wrong device, which
will lead to strangeness.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cc9e3813e1a4..f371d45f786a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3222,7 +3222,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_error = -EIO;
 
 			sector = r10_bio->devs[i].addr;
-			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
+			atomic_inc(&conf->mirrors[d].replacement->nr_pending);
 			bio->bi_next = biolist;
 			biolist = bio;
 			bio->bi_private = r10_bio;


