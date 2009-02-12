From: NeilBrown <neilb@suse.de>
Subject: [PATCH 04/18] md: be more consistent about setting WriteMostly flag
	when adding a drive to an array
Date: Thu, 12 Feb 2009 14:10:10 +1100
Message-ID: <20090212031010.23983.88571.stgit@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212031009.23983.14496.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When a drive is added to an array using ADD_NEW_DISK, there are two
places we can get certain flags from:  the meta on the disk or the
flags passed through the IOCTL.

For the WriteMostly flag (aka MD_DISK_WRITEMOSTLY) we take the value
from either of those sources depending on if it is set (i.e. we
effectively 'or' the two sources together).

This makes it awkward to clear, and is at best inconsistent.

As documented code (in mdadm) requires that setting
MD_DISK_WRITEMOSTLY in the ioctl will be effective, we resolve the
inconsistency by always using the value for this flag from the ioctl,
and ignoring the value on disk.


Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7639c08..8c5cc02 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4477,6 +4477,8 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 		clear_bit(In_sync, &rdev->flags); /* just to be sure */
 		if (info->state & (1<<MD_DISK_WRITEMOSTLY))
 			set_bit(WriteMostly, &rdev->flags);
+		else
+			clear_bit(WriteMostly, &rdev->flags);
 
 		rdev->raid_disk = -1;
 		err = bind_rdev_to_array(rdev, mddev);


