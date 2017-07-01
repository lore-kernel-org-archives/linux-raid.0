From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Subject: [PATCH 3/5] md/linear: make memory allocation from md's numa node
Date: Sat,  1 Jul 2017 15:20:56 +0800
Message-ID: <1498893658-18409-3-git-send-email-liuzhengyuan@kylinos.cn>
References: <1498893658-18409-1-git-send-email-liuzhengyuan@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1498893658-18409-1-git-send-email-liuzhengyuan@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, neilb@suse.com, colyli@suse.de, liuyun01@kylinos.cn
List-Id: linux-raid.ids

linear has the same context as md does, so there is no need
to add a module parameter. Just inherit it from md.

Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
---
 drivers/md/linear.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 5f1eb91..43ea6eb 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -96,8 +96,8 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
 	int i, cnt;
 	bool discard_supported = false;
 
-	conf = kzalloc (sizeof (*conf) + raid_disks*sizeof(struct dev_info),
-			GFP_KERNEL);
+	conf = kzalloc_node(sizeof (*conf) + raid_disks*sizeof(struct dev_info),
+			GFP_KERNEL, mddev->numa_node_id);
 	if (!conf)
 		return NULL;
 
-- 
2.7.4



