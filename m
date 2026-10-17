Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FB135DA4A;
	Sat, 17 Oct 2026 01:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199113; cv=none; b=jxtvCRiD3rOOzb/6lsIM0WdZxgPs7gaA4dRvaLfV78e5pTxPVL+jZN7PffdxHGpJOlfjM9Pr579X0h2Bhscqc6txQL9UFCLdE1d5tj8DTT/J0E5KY/tfYVOe5B9UcJgc/prXs9JtTx47nGROVMng1guQjW1fye5v9mgAwe7xBLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199113; c=relaxed/simple;
	bh=CHwy9belNj4xKGjhGkSeSjw4XV3VQy6YFzSZvUXQqzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyYx2l5QeP1OQNMcUIXZ5ViwHZ1y7E7s0B2NZizMf9rGiRkB8+OR4i4iIk3x5uS57NMQ2dwZ6ccR8pg4wEVXjsdRhAsZx6RN1d+67+h+3b8sjEsxs1tkSNt1u/RC7MQrgvs2e0zKD7r9doGQHxhwQr4OH+kMaAWmU06K/hyzTJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4j63VL1Js5zYQtm9;
	Sat, 17 Oct 2026 09:04:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7E2F2405B2;
	Sat, 17 Oct 2026 09:05:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvXBydJqADTpAg--.35962S7;
	Sat, 17 Oct 2026 09:05:07 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huawei.com
Subject: [PATCH 3/3] md/raid0: round member size in raid0_size() with sector_div()
Date: Sat, 17 Oct 2026 08:58:02 +0800
Message-ID: <20261017005802.2212102-4-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261017005802.2212102-1-wozizhi@huaweicloud.com>
References: <20261017005802.2212102-1-wozizhi@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnZvXBydJqADTpAg--.35962S7
X-Coremail-Antispam: 1UD129KBjvJXoW7KF13Cw4rtrW8KF18Zr47Jwb_yoW8Gw4xpw
	4UXFn3uryUAry5Ja98Ja4jgayFyF9xGrWDtF9ruayUurn3Wr92ka45t345Xa4UA34rAw1Y
	y3yDCrWDC3WDKrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFF4iUUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

raid0_size() rounds each member device down to the chunk boundary by
masking with 'chunk_sectors - 1':

	rdev->sectors & ~(sector_t)(mddev->chunk_sectors - 1)

This bit-masking only yields a correct round-down when chunk_sectors is a
power of 2. However, raid0 also supports non-power-of-2 chunk sizes, as
handled in raid0_make_request() and map_sector(), so the rounding is wrong
in that case.

Use raid0_member_sectors() instead, so that each member is rounded down
with sector_div() for any chunk size, consistent with how
create_strip_zones() already rounds the members when building the zones.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/md/raid0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c96ee54f9acc..623b0701ce70 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -367,12 +367,12 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
 
 	WARN_ONCE(sectors || raid_disks,
 		  "%s does not support generic reshape\n", __func__);
 
 	rdev_for_each(rdev, mddev)
-		array_sectors += (rdev->sectors &
-				  ~(sector_t)(mddev->chunk_sectors-1));
+		array_sectors += raid0_member_sectors(rdev->sectors,
+						      mddev->chunk_sectors);
 
 	return array_sectors;
 }
 
 static void raid0_free(struct mddev *mddev, void *priv)
-- 
2.52.0

