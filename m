From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 2/4] md: raid0: Remove return statement from void function
Date: Mon, 20 May 2019 18:44:25 -0300
Message-ID: <20190520214427.18729-3-marcos.souza.org@gmail.com>
References: <20190520214427.18729-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190520214427.18729-1-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This return statement was introduced in commit
1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 ("Linux-2.6.12-rc2") and can be
safely removed.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/md/raid0.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f3fb5bb8c82a..42b0287104bd 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -609,7 +609,6 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 static void raid0_status(struct seq_file *seq, struct mddev *mddev)
 {
 	seq_printf(seq, " %dk chunks", mddev->chunk_sectors / 2);
-	return;
 }
 
 static void *raid0_takeover_raid45(struct mddev *mddev)
-- 
2.21.0
