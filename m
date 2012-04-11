From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md/raid1:If raid1 only had one disk and readed error,should  call rdev_set_badblocks().
Date: Wed, 11 Apr 2012 11:00:50 +0800
Message-ID: <201204111100439842173@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

From 9d031da06c11d53a04c87ff8c497a99c0901d44b Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Wed, 11 Apr 2012 10:49:30 +0800
Subject: [PATCH] md/raid1:If raid1 only had one disk and readed error,should
 call rdev_set_badblocks().

Do it can
1:record bad sector
2:If raid is recoverying and set badblocks fail,so stop the recovery.

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid1.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d35e4c9..a46ab4b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -317,6 +317,11 @@ static void raid1_end_read_request(struct bio *bio, int error)
 		     !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
 			uptodate = 1;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
+		if (uptodate && !rdev_set_badblocks(conf->mirrors[mirror].rdev,
+				r1_bio->sector + conf->mirrors[mirror].rdev->data_offset,
+				r1_bio->sectors, 0))
+			md_error(conf->mddev, conf->mirrors[mirror].rdev);
+
 	}
 
 	if (uptodate)
-- 
1.7.5.4

 				
--------------
majianpeng
2012-04-11

