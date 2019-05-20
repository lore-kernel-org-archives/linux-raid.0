From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 3/4] md: raid0: Return md_integrity_register result directly
Date: Mon, 20 May 2019 18:44:26 -0300
Message-ID: <20190520214427.18729-4-marcos.souza.org@gmail.com>
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

Commit 0c35bd4723e4a39ba2da4c13a22cb97986ee10c8
("md: fix problems with freeing private data after ->run failure")
removed the check for the result of md_integrity_register, so we don't
need to store it anymore, so return it directly.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/md/raid0.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 42b0287104bd..e72255464c09 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -431,9 +431,7 @@ static int raid0_run(struct mddev *mddev)
 
 	dump_zones(mddev);
 
-	ret = md_integrity_register(mddev);
-
-	return ret;
+	return md_integrity_register(mddev);
 }
 
 static void raid0_free(struct mddev *mddev, void *priv)
-- 
2.21.0
