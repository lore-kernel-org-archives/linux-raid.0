From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 44/52] md: raid1: check rdev before reference in raid1_sync_request func
Date: Fri, 20 Dec 2019 09:29:46 -0500
Message-ID: <20191220142954.9500-44-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Zhiqiang Liu <liuzhiqiang26@huawei.com>, Song Liu <songliubraving@fb.com>, Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

[ Upstream commit 028288df635f5a9addd48ac4677b720192747944 ]

In raid1_sync_request func, rdev should be checked before reference.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index bb29aeefcbd0f..c7137f50bd1d3 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2781,7 +2781,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 				write_targets++;
 			}
 		}
-		if (bio->bi_end_io) {
+		if (rdev && bio->bi_end_io) {
 			atomic_inc(&rdev->nr_pending);
 			bio->bi_iter.bi_sector = sector_nr + rdev->data_offset;
 			bio_set_dev(bio, rdev->bdev);
-- 
2.20.1
