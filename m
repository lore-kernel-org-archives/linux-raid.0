From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Subject: [PATCH 2/5] raid0: make memory allocation from md's numa node
Date: Sat,  1 Jul 2017 15:20:55 +0800
Message-ID: <1498893658-18409-2-git-send-email-liuzhengyuan@kylinos.cn>
References: <1498893658-18409-1-git-send-email-liuzhengyuan@kylinos.cn>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1498893658-18409-1-git-send-email-liuzhengyuan@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, neilb@suse.com, colyli@suse.de, liuyun01@kylinos.cn
List-Id: linux-raid.ids

raid0 has the same context as md does, so there is no need
to add a module parameter. Just inherit it from md.

Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
---
 drivers/md/raid0.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 94d9ae9..7a301b3 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -89,7 +89,8 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	int cnt;
 	char b[BDEVNAME_SIZE];
 	char b2[BDEVNAME_SIZE];
-	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
+	struct r0conf *conf = kzalloc_node(sizeof(*conf), GFP_KERNEL,
+				mddev->numa_node_id);
 	unsigned short blksize = 512;
 
 	*private_conf = ERR_PTR(-ENOMEM);
@@ -158,13 +159,14 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	}
 
 	err = -ENOMEM;
-	conf->strip_zone = kzalloc(sizeof(struct strip_zone)*
-				conf->nr_strip_zones, GFP_KERNEL);
+	conf->strip_zone = kzalloc_node(sizeof(struct strip_zone)*
+				conf->nr_strip_zones, GFP_KERNEL,
+				mddev->numa_node_id);
 	if (!conf->strip_zone)
 		goto abort;
-	conf->devlist = kzalloc(sizeof(struct md_rdev*)*
+	conf->devlist = kzalloc_node(sizeof(struct md_rdev *)*
 				conf->nr_strip_zones*mddev->raid_disks,
-				GFP_KERNEL);
+				GFP_KERNEL, mddev->numa_node_id);
 	if (!conf->devlist)
 		goto abort;
 
-- 
2.7.4



