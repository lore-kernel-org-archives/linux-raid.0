From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 13/17] md/raid1: Allow a failed replacement device to be
 removed.
Date: Wed, 02 Nov 2011 16:25:44 +1100
Message-ID: <20111102052544.17566.9675.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Replacement devices are stored at a different offset, so look
there too.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid1.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 99cd12e..eac9a1d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1336,6 +1336,9 @@ static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	int number = rdev->raid_disk;
 	struct mirror_info *p = conf->mirrors+ number;
 
+	if (rdev != p->rdev)
+		p = conf->mirrors + conf->raid_disks + number;
+
 	print_conf(conf);
 	if (rdev == p->rdev) {
 		if (test_bit(In_sync, &rdev->flags) ||
@@ -1359,6 +1362,9 @@ static int raid1_remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 			err = -EBUSY;
 			p->rdev = rdev;
 			goto abort;
+		} else {
+			clear_bit(Replacement, &rdev->flags);
+			clear_bit(Replaceable, &rdev->flags);
 		}
 		err = md_integrity_register(mddev);
 	}


