From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/16] md: reject a re-add request that cannot be honoured.
Date: Wed, 11 May 2011 16:30:30 +1000
Message-ID: <20110511063030.21263.15426.stgit@notabene.brown>
References: <20110511062743.21263.72802.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511062743.21263.72802.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The 'add_new_disk' ioctl can be used to add a device either as a
spare, or as an active disk that just needs to be resynced based on
write-intent-bitmap information (re-add)

Currently if a re-add is requested but fails we add as a spare
instead.  This makes it impossible for user-space to check for
failure.

So change to require that a re-add attempt will either succeed or
completely fail.  User-space can then decide what to do next.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4a4c0f8..5469ae3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5216,6 +5216,16 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 		} else
 			super_types[mddev->major_version].
 				validate_super(mddev, rdev);
+		if ((info->state & (1<<MD_DISK_SYNC)) &&
+		    (!test_bit(In_sync, &rdev->flags) ||
+		     rdev->raid_disk != info->raid_disk)) {
+			/* This was a hot-add request, but events doesn't
+			 * match, so reject it.
+			 */
+			export_rdev(rdev);
+			return -EINVAL;
+		}
+
 		if (test_bit(In_sync, &rdev->flags))
 			rdev->saved_raid_disk = rdev->raid_disk;
 		else


