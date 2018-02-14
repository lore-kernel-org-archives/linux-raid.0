From: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Subject: [RESEND PATCH 1/5] raid1: copy write hint from master bio to behind bio
Date: Wed, 14 Feb 2018 14:23:30 +0100
Message-ID: <20180214132334.13687-2-mariusz.dabrowski@intel.com>
References: <20180214132334.13687-1-mariusz.dabrowski@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180214132334.13687-1-mariusz.dabrowski@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Mariusz Dabrowski <mariusz.dabrowski@intel.com>
List-Id: linux-raid.ids

Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
---
 drivers/md/raid1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b2eae332e1a2..c512926a5193 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1092,6 +1092,8 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
 		goto skip_copy;
 	}
 
+	behind_bio->bi_write_hint = bio->bi_write_hint;
+
 	while (i < vcnt && size) {
 		struct page *page;
 		int len = min_t(int, PAGE_SIZE, size);
-- 
2.16.1

