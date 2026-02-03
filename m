Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AA639A7E3
	for <linux-raid@vger.kernel.org>; Tue,  3 Feb 2026 09:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770112351; cv=none; b=nBKuewBpiA20IBv5CLKKdrwsYDtErDFCl3U/Nqnjg1p46E/o7akxp5v75/tUFG7buJeXMX9if19hs7w+qzxgBxB5+B5gEScS7eCmUk32I4yelvFGy0rHrLR0l2yu5RvhInFc16SHBZrjrW6HcTro8pfbJLM4vVYZKPltv9YmKog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770112351; c=relaxed/simple;
	bh=az7YzXWQU5GKgBkC7zMghPzgdUKEiWFvOVJxRnW+caE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dtqxgByDo4kRFTnZYfIMeJ8lRdGV+aXEVTkHEqAHX7DyakbBhp2l7iq3CdY9FifhJbFy0yIZS8VfVG6UPM3RzENaDvqphX/krmh31UshqQZWYQhR3+U8xw7sjybOMtbg37CbuCoxDeItCm/san+GA6QJnusGNB+mlDT3rKJZk/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=exVKvERR; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="exVKvERR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=/V
	UJx5REtxSTf80ZseihXwR77Wmx89OzC/PgPJo0EQc=; b=exVKvERRKIM0SKBQXN
	+9rwdZk+jKNCevDeMNYkWrOOrdx227OwE+XLUAevC5/1sY1qhglkL6AYf6htOcRm
	zfuFvFoXiD13JqBt1gnyVwFCslUqDcCGy10PzgDdS4oP5G58iLLvHoaheAvwH0R1
	8lBOZirTV/7jO2XSa6zscR/QE=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDHmOA+xYFpNsheNw--.139S2;
	Tue, 03 Feb 2026 17:52:01 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: song@kernel.org,
	yukuai@fnnas.com,
	snitzer@kernel.org,
	xni@redhat.com
Cc: linux-raid@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 1/1] md/raid5: don't set bi_status for requeued IO in STRIPE_WAIT_RESHAPE
Date: Tue,  3 Feb 2026 17:51:56 +0800
Message-Id: <20260203095156.2349174-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDHmOA+xYFpNsheNw--.139S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrZrWxAF1DAF1fCF18Ww1Dtrb_yoW8JryDp3
	yDCa4fuw1UWayxtayDAFWkW3W5Ga4DKFWUJasrKw48ZF15Xr1UZr13Jr98Wr1UGF4Sq390
	v34jv34DCan8ta7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Ud5rsUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwQE8zGmBxUF7JQAA3C

When reshape is interrupted, IO that needs to be requeued incorrectly
sets bi->bi_status to BLK_STS_RESOURCE. This causes md_free_cloned_bio()
to copy the error status to the original bio, which is wrong because
requeued IO should be retried, not failed.

This was found during LVM testing where reshape operations under I/O
load would cause I/O errors and filesystem corruption.

Remove the bi_status assignment to prevent incorrect error marking.

Fixes: 41425f96d7aa ("dm-raid456, md/raid456: fix a deadlock for dm-raid456 while io concurrent with reshape")

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/md/raid5.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8dc98f545969..128c0b7e9f54 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6038,7 +6038,6 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 	raid5_release_stripe(sh);
 out:
 	if (ret == STRIPE_SCHEDULE_AND_RETRY && reshape_interrupted(mddev)) {
-		bi->bi_status = BLK_STS_RESOURCE;
 		ret = STRIPE_WAIT_RESHAPE;
 		pr_err_ratelimited("dm-raid456: io across reshape position while reshape can't make progress");
 	}
-- 
2.25.1

