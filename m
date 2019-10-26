From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 50/59] md/raid0: fix warning message for parameter default_layout
Date: Sat, 26 Oct 2019 09:19:01 -0400
Message-ID: <20191026131910.3435-50-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, NeilBrown <neilb@suse.de>, Ivan Topolsky <doktor.yak@gmail.com>, Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Song Liu <songliubraving@fb.com>

[ Upstream commit 3874d73e06c9b9dc15de0b7382fc223986d75571 ]

The message should match the parameter, i.e. raid0.default_layout.

Fixes: c84a1372df92 ("md/raid0: avoid RAID0 data corruption due to layout confusion.")
Cc: NeilBrown <neilb@suse.de>
Reported-by: Ivan Topolsky <doktor.yak@gmail.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 43fa7dbf844b0..3cafbfd655f5d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -158,7 +158,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	} else {
 		pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layout setting\n",
 		       mdname(mddev));
-		pr_err("md/raid0: please set raid.default_layout to 1 or 2\n");
+		pr_err("md/raid0: please set raid0.default_layout to 1 or 2\n");
 		err = -ENOTSUPP;
 		goto abort;
 	}
-- 
2.20.1
