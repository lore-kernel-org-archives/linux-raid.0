Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099B3199384;
	Wed, 25 Dec 2024 11:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735125600; cv=none; b=nVWJesv+txr2BqrhlQmvtT1QZro4j8Ax2B/xlPiROpEgxofI/B0U9fUBHvkZ2BGT9TwDayuKQJNtucEeMOReKn8ErH4I1fU9TP351TMFn/DTT/n8O8/UbHMdckmP1RE8E5a8GL2sEuh6dIRnszsaqCqcp+P+3WLUPfQLgSTg5+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735125600; c=relaxed/simple;
	bh=QyRFyW5wC17u9UTxOc+cCccnlpjt1detXEIAG9tHC0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=daVJRl5Y3RiIU366waPCza1ryvQZKT+d40/McW6Q2TeiFD3lXZU9UR+D3cdL5a41eojR0I4ZkKKXHCM0M3Iiwj7HJHYG+ZxXM9Ajqg0BD0vb728q6QETcY2jhGvTj7NMt0aZ8kh43dI5H5M9Itv/Sj1MvU2nWsrBo9jFJpapoyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YJ8Rb6M9Cz4f3jqw;
	Wed, 25 Dec 2024 19:19:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8368A1A018D;
	Wed, 25 Dec 2024 19:19:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAnT4NV6mtntXlgFg--.39006S10;
	Wed, 25 Dec 2024 19:19:54 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.14 06/13] md/dm-raid: check if bitmap is registered in raid_ctr()
Date: Wed, 25 Dec 2024 19:15:39 +0800
Message-Id: <20241225111546.1833250-7-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241225111546.1833250-1-yukuai1@huaweicloud.com>
References: <20241225111546.1833250-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnT4NV6mtntXlgFg--.39006S10
X-Coremail-Antispam: 1UD129KBjvdXoW7XFyDJr43CrWkWr1xGF4kZwb_yoWfJrXEkw
	1Sqr97Xr45G3W3Cw4UtanYvrZYkw1kWrZ7uFWqvay3AF1ruryfKw409r98Wr47ZrZ3AFyr
	CFy7Kr4rZr9rZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbvxFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVF
	xhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Prepare to support building md-bitmap as kernel module.

dm-raid should always enable bitmap and mdraid will try to load the module
automatically, just in case the module can't be loaded, for example,
user somehow remove the module file.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 0ca73b571c7d..c56c42503ca4 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3054,6 +3054,9 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (IS_ERR(rs))
 		return PTR_ERR(rs);
 
+	if (WARN_ON_ONCE(!md_bitmap_registered(&rs->md)))
+		goto bad;
+
 	r = parse_raid_params(rs, &as, num_raid_params);
 	if (r)
 		goto bad;
-- 
2.39.2

