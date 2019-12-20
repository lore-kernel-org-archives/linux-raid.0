From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 43/52] raid5: need to set STRIPE_HANDLE for batch head
Date: Fri, 20 Dec 2019 09:29:45 -0500
Message-ID: <20191220142954.9500-43-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Xiao Ni <xni@redhat.com>, Song Liu <songliubraving@fb.com>, Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit a7ede3d16808b8f3915c8572d783530a82b2f027 ]

With commit 6ce220dd2f8ea71d6afc29b9a7524c12e39f374a ("raid5: don't set
STRIPE_HANDLE to stripe which is in batch list"), we don't want to set
STRIPE_HANDLE flag for sh which is already in batch list.

However, the stripe which is the head of batch list should set this flag,
otherwise panic could happen inside init_stripe at BUG_ON(sh->batch_head),
it is reproducible with raid5 on top of nvdimm devices per Xiao oberserved.

Thanks for Xiao's effort to verify the change.

Fixes: 6ce220dd2f8ea ("raid5: don't set STRIPE_HANDLE to stripe which is in batch list")
Reported-by: Xiao Ni <xni@redhat.com>
Tested-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 12a8ce83786ea..36cd7c2fbf408 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5726,7 +5726,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 				do_flush = false;
 			}
 
-			if (!sh->batch_head)
+			if (!sh->batch_head || sh == sh->batch_head)
 				set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			if ((!sh->batch_head || sh == sh->batch_head) &&
-- 
2.20.1
