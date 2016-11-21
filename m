From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/2] md: stop write should stop journal reclaim
Date: Mon, 21 Nov 2016 10:29:19 -0800
Message-ID: <6691f75c96d9e95d64fbb8d07675356ddc7fa638.1479751751.git.shli@fb.com>
References: <598ff2610261ffa745b682c311d5300fefeb2fcc.1479751751.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <598ff2610261ffa745b682c311d5300fefeb2fcc.1479751751.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, neilb@suse.com
List-Id: linux-raid.ids

__md_stop_writes currently doesn't stop raid5-cache reclaim thread. It's
possible the reclaim thread is still running and doing write, which
doesn't match what __md_stop_writes should do. The extra ->quiesce()
call should not harm any raid types. For raid5-cache, this will
guarantee we reclaim all caches before we update superblock.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f548469..560150c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5474,6 +5474,10 @@ static void __md_stop_writes(struct mddev *mddev)
 
 	del_timer_sync(&mddev->safemode_timer);
 
+	if (mddev->pers && mddev->pers->quiesce) {
+		mddev->pers->quiesce(mddev, 1);
+		mddev->pers->quiesce(mddev, 0);
+	}
 	bitmap_flush(mddev);
 
 	if (mddev->ro == 0 &&
-- 
2.9.3

