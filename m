From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 14/16] md/raid5: recognise replacements when assembling
 array.
Date: Wed, 26 Oct 2011 12:43:01 +1100
Message-ID: <20111026014301.21110.58312.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If a Replacement is seen, file it as such.

If we see two replacements (or two normal devices) for the one slot,
abort.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid5.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6c22f09..efe3679 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4824,7 +4824,15 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 			continue;
 		disk = conf->disks + raid_disk;
 
-		disk->rdev = rdev;
+		if (test_bit(Replacement, &rdev->flags)) {
+			if (disk->replacement)
+				goto abort;
+			disk->replacement = rdev;
+		} else {
+			if (disk->rdev)
+				goto abort;
+			disk->rdev = rdev;
+		}
 
 		if (test_bit(In_sync, &rdev->flags)) {
 			char b[BDEVNAME_SIZE];


