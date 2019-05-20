From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 4/4] md: raid0: Make ret local in raid0_run
Date: Mon, 20 May 2019 18:44:27 -0300
Message-ID: <20190520214427.18729-5-marcos.souza.org@gmail.com>
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

ret variable is only used in a specific situation, so make it local
instead of global.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/md/raid0.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e72255464c09..b28dbb797f76 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -364,7 +364,6 @@ static void raid0_free(struct mddev *mddev, void *priv);
 static int raid0_run(struct mddev *mddev)
 {
 	struct r0conf *conf;
-	int ret;
 
 	if (mddev->chunk_sectors == 0) {
 		pr_warn("md/raid0:%s: chunk size must be set.\n", mdname(mddev));
@@ -375,7 +374,7 @@ static int raid0_run(struct mddev *mddev)
 
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
-		ret = create_strip_zones(mddev, &conf);
+		int ret = create_strip_zones(mddev, &conf);
 		if (ret < 0)
 			return ret;
 		mddev->private = conf;
-- 
2.21.0
