Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771CF10E9;
	Thu, 14 Dec 2023 07:15:15 -0800 (PST)
X-QQ-mid: bizesmtp65t1702566900tw788o8z
Received: from localhost.localdomain ( [125.76.217.162])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 14 Dec 2023 23:14:58 +0800 (CST)
X-QQ-SSF: 01400000000000E0H000000A0000000
X-QQ-FEAT: kUim6XnhvqXLGVCGif12YpsOAXyfr323UC3dd/L/ZZMRExUmZKiKHx5oLDwbc
	LZzHsLq4aDfbgSQBoakNgqyPtoAG8ML/TL2OLcIplBRfcTGJV3PPVGtuuGQ8pxWx/vIbIwR
	5ZAFYsHnG0GHnlOQuCfHCgj5BCPU+Sp5ikANO2re6gi78KCC4oZ2SlOTAZZdmUfd/tpqRLx
	BCIp/8BX6nhxXydNyFpX4qd9MEtqTJO0gbbOdgkurPdXoX4elaPv0zkzjXbvy4mDwgJ+u5T
	SEbIvwlMP2On1e7fyOe2gsqtX6nCX33EzaxInBrs5an8wRXUQ4NmpffwfQHuFBCyyZKaakA
	IN5FFUpjE52KjRyGo9s3SmS9ZPTkBVhRvTH+JHNnfvuzTCtz8YlBuXkRf7qbUW64QU13N4m
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16267120763352956004
From: Gou Hao <gouhao@uniontech.com>
To: song@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	gouhaojake@163.com
Subject: [PATCH] md/raid1: remove unnecessary null checking
Date: Thu, 14 Dec 2023 23:14:58 +0800
Message-Id: <20231214151458.28970-1-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz7a-0

If %__GFP_DIRECT_RECLAIM is set then bio_alloc_bioset will always
be able to allocate a bio. See comment of bio_alloc_bioset.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 drivers/md/raid1.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 35d12948e0a9..e77dc95d4a75 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1126,8 +1126,6 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
 
 	behind_bio = bio_alloc_bioset(NULL, vcnt, 0, GFP_NOIO,
 				      &r1_bio->mddev->bio_set);
-	if (!behind_bio)
-		return;
 
 	/* discard op, we don't support writezero/writesame yet */
 	if (!bio_has_data(bio)) {
-- 
2.34.1

