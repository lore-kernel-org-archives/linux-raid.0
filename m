From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 09/17] md/raid10: recognise replacements when assembling
 array.
Date: Wed, 02 Nov 2011 16:25:44 +1100
Message-ID: <20111102052544.17566.64117.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If a Replacement is seen, file it as such.

If we see two replacements (or two normal devices) for the one slot,
abort.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index fd28f03..15e3f73 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3195,6 +3195,16 @@ static int run(struct mddev *mddev)
 			continue;
 		disk = conf->mirrors + disk_idx;
 
+		if (test_bit(Replacement, &rdev->flags)) {
+			if (disk->replacement)
+				goto out_free_conf;
+			disk->replacement = rdev;
+		} else {
+			if (disk->rdev)
+				goto out_free_conf;
+			disk->rdev = rdev;
+		}
+
 		disk->rdev = rdev;
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
@@ -3222,6 +3232,13 @@ static int run(struct mddev *mddev)
 
 		disk = conf->mirrors + i;
 
+		if (!disk->rdev && disk->replacement) {
+			/* The replacement is all we have - use it */
+			disk->rdev = disk->replacement;
+			disk->replacement = NULL;
+			clear_bit(Replacement, &disk->rdev->flags);
+		}
+
 		if (!disk->rdev ||
 		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;


