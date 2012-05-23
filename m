From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] md/raid456:Remove the judgement atomic_read(&rdev->read_errors).
Date: Wed, 23 May 2012 20:38:16 +0800
Message-ID: <201205232038121562929@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It isn't necessary to judge.Because the atomic_read and atomic_set is excuce same cpu. So
read_errors is zero or not, directly set it zero.
Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/md/raid5.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f351422..1fe2def 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1690,8 +1690,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		}
-		if (atomic_read(&rdev->read_errors))
-			atomic_set(&rdev->read_errors, 0);
+		atomic_set(&rdev->read_errors, 0);
 	} else {
 		const char *bdn = bdevname(rdev->bdev, b);
 		int retry = 0;
-- 
1.7.5.4
 				
--------------
majianpeng
2012-05-23

