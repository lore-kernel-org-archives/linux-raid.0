From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/1] Avoid OOPS when reshaping raid1 to raid0
Date: Thu, 22 Mar 2012 17:15:53 +0100
Message-ID: <1332432953-30091-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1332432953-30091-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332432953-30091-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: dledford@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

raid1 arrays do not have the notion of chunk size. Set the existing
chunk size of the new raid0 to the same as the proposed new chunk size
to avoid a divide by zero OOPS when aligning the size of the new array
to that of the chunk size.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/md/raid0.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 6f31f55..dff8d6b 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -639,6 +639,14 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
 	mddev->new_level = 0;
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = 128; /* by default set chunk size to 64k */
+	mddev->chunk_sectors = 128;	/*
+					 * a raid1 one doesn't have the
+					 * notion of chunk size, so set
+					 * existing chunk_sector to match the
+					 * new size to avoid divide by zero
+					 * when aligning the size of the new
+					 * raid0 to the existing chunk size.
+					 */
 	mddev->delta_disks = 1 - mddev->raid_disks;
 	mddev->raid_disks = 1;
 	/* make sure it will be not marked as dirty */
-- 
1.7.7.6

