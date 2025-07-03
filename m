Received: from mail-out.aladdin-rd.ru (mail-out.aladdin-rd.ru [91.199.251.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0152E426A;
	Thu,  3 Jul 2025 11:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.199.251.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751542390; cv=none; b=t3d01PSMqkDHr+gU4fWqGi6k5qLEMeD/xhy+6duKvpFcmEpwsZb4icROyAaE8zXo2y6eNnLxQozn1LcHb45EN5NIZ4tlMolhhDkkDMkQ9VBRiQUPw6qPrzxI33aHa79V3E7gJ82IYloCTJt7ytidJW8HeRs4C9f1bh5+xCFGXaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751542390; c=relaxed/simple;
	bh=CyQhUnN9yDUDBFRVhw4ghu3ibqesztbBUa/txXVxbe4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gKcZxuSL8FILhGNERsm8pZ5l/200iBcekF8HW6RhJMXoWHfseIN4vjWjdtMQorDMf2mi1bDSXYL61+mQXxoN7tLjpVoOMdQ6EOnnlAHl4keQuW4ruGiGwTjDhVe6rJnVeUm2QHuJf+kWo0G/wZ6oRF7bpN89d6xXSD5tw9x/D7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aladdin.ru; spf=pass smtp.mailfrom=aladdin.ru; dkim=pass (2048-bit key) header.d=aladdin.ru header.i=@aladdin.ru header.b=vRMO+IMi; arc=none smtp.client-ip=91.199.251.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aladdin.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aladdin.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aladdin.ru header.i=@aladdin.ru header.b="vRMO+IMi"
DKIM-Signature: v=1; a=rsa-sha256; d=aladdin.ru; s=mail; c=simple/simple;
	t=1751542376; h=from:subject:to:date:message-id;
	bh=CyQhUnN9yDUDBFRVhw4ghu3ibqesztbBUa/txXVxbe4=;
	b=vRMO+IMi3XxKo7NY4fxaOR+3ZJOosaJy8ibaMkoyuHLol/Rk3cByQ014tIZ8nBqpgbbOToQKqDs
	rKrUV4tVMfmBG46XmuM15ABi/F5IHuREwdI1od0yDpM1C5qaCWA39tXh2cvIrudnRMolo5uuQMU/X
	pbXTHtO0nvSvqL8dnxIb1ocveOTJuwN0Y/aKFyAcRjGrvSbJQL0//qw2DSchc0uICWfgzQ/DQWz4f
	BSuTGiKWisAPZkeSINEOLG9yWPK+EbDLBDkWiH+dY751Hd4q2FeuRTp//+TPy/4fGhiB2A61v5EQ2
	Baz8zdnooeWM36KOxfEWctAh8gk/cFFpVK3g==
From: Daniil Dulov <d.dulov@aladdin.ru>
To: <stable@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Daniil Dulov <d.dulov@aladdin.ru>, Song Liu <song@kernel.org>, "Vishal
 Verma" <vverma@digitalocean.com>, Jens Axboe <axboe@kernel.dk>,
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>, Xiao Ni <xni@redhat.com>, Coly Li
	<colyli@kernel.org>, Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 5.15/6.1/6.6/6.12] md/raid10: wait barrier before returning discard request with REQ_NOWAIT
Date: Thu, 3 Jul 2025 14:32:33 +0300
Message-ID: <20250703113233.51484-1-d.dulov@aladdin.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EXCH-2016-02.aladdin.ru (192.168.1.102) To
 EXCH-2016-01.aladdin.ru (192.168.1.101)

From: Xiao Ni <xni@redhat.com>

commit 3db4404435397a345431b45f57876a3df133f3b4 upstream.

raid10_handle_discard should wait barrier before returning a discard bio
which has REQ_NOWAIT. And there is no need to print warning calltrace
if a discard bio has REQ_NOWAIT flag. Quality engineer usually checks
dmesg and reports error if dmesg has warning/error calltrace.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Coly Li <colyli@kernel.org>
Link: https://lore.kernel.org/linux-raid/20250306094938.48952-1-xni@redhat.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
---
Backport fix for CVE-2025-40325.

 drivers/md/raid10.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cc194f6ec18d..a02c02684237 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1585,11 +1585,10 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return -EAGAIN;
 
-	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
+	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
 		return 0;
 	}
-	wait_barrier(conf, false);
 
 	/*
 	 * Check reshape again to avoid reshape happens after checking
-- 
2.34.1

