Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36053C17;
	Sun,  2 Nov 2025 15:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762096896; cv=none; b=XEI50GWovO9SfzmsI0p5faPPiqf32HUqk9NyK49bJe+jOH9Age6ZjaT4R2s8l2xjGScjMbhpcatC4Gfpm6F34ZmproWMd7SaY3vp0N3wGUveZVMZzXhLZM9GDn0/A6qjS7E1z5OIPIToB9ozI2/4kcWIPniWRqt3PuCtmxQ9WTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762096896; c=relaxed/simple;
	bh=TM5xg7bglH2dpuu5Ugsc9jR3ADV+9opvunL9JC+du+g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kkVItTNLcZVcVyY7DXgIs785SzDPMCWKMFuYNBvhDmrXQw/9je+ejP+BHBrcMKjIhe9Nir2B2KS0VJjH5HbFbBQq3yW9m4n+GzIfI+fgtWuv7aYVVRI7Xf0VqV08vc6CHaRDF0I7dSjbJlS203TzMN5rRlJXyfhblozSXtHY6Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 97f49afcb7ff11f0a38c85956e01ac42-20251102
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, DN_TRUSTED, SRC_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:5279e763-e628-4766-bf85-9cb4cce730f9,IP:10,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:-30,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:5279e763-e628-4766-bf85-9cb4cce730f9,IP:10,URL
	:0,TC:0,Content:0,EDM:25,RT:0,SF:-30,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:92530eb60aeddc96ed0c3bdc6f1d39ff,BulkI
	D:251102232014ZSYNL67C,BulkQuantity:1,Recheck:0,SF:10|38|66|78|102|850,TC:
	nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:n
	il,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 97f49afcb7ff11f0a38c85956e01ac42-20251102
X-User: hehuiwen@kylinos.cn
Received: from localhost.localdomain [(220.202.195.150)] by mailgw.kylinos.cn
	(envelope-from <hehuiwen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1869174748; Sun, 02 Nov 2025 23:21:24 +0800
From: Huiwen He <hehuiwen@kylinos.cn>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Huiwen He <hehuiwen@kylinos.cn>
Subject: [PATCH] md/raid5: remove redundant __GFP_NOWARN
Date: Sun,  2 Nov 2025 23:21:08 +0800
Message-Id: <20251102152108.868869-1-hehuiwen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The __GFP_NOWARN flag was included in GFP_NOWAIT since commit
16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT"). So
remove the redundant __GFP_NOWARN flag.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
---
 drivers/md/raid5-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index ba768ca7f422..e29e69335c69 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -3104,7 +3104,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 		goto out_mempool;
 
 	spin_lock_init(&log->tree_lock);
-	INIT_RADIX_TREE(&log->big_stripe_tree, GFP_NOWAIT | __GFP_NOWARN);
+	INIT_RADIX_TREE(&log->big_stripe_tree, GFP_NOWAIT);
 
 	thread = md_register_thread(r5l_reclaim_thread, log->rdev->mddev,
 				    "reclaim");
-- 
2.25.1

