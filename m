Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD26B218827;
	Wed, 17 Sep 2025 01:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758072056; cv=none; b=mkU51Jcyiz3u0BOJvvHTKElJgeK3uifikB6kbLfMDdsErmV0IWBkQph/fesvndfekAaTDbBa5gIaB28fSXNE/UJnfPz2hkxQe9sbhoLN12xFljBdN3a7OzRn2n5ja2hQpxwR8mYXPUwK6zeJEsowyr43HUpwMdo8Tc6rbwMctDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758072056; c=relaxed/simple;
	bh=lzsyV+P7DVedeesKr/JZ731ihVclpmWmbLLcKbL5Pp0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z99tMzigWv0o86l0eP6SRRyRb6d8KUjymb/4Fg4U8Zvf88bGovEWQGPQdCZsOXJq4izrK2kn77GRGexJDtm/QedLxNKEA3jDys9ByRcveA2a6VNt2XqB3BuB41guwq7ijDxP86aBTF63z032X0Vfvwd0cKU1QIF79hPHUTw5Lds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cRLYn6D5lzKHMZW;
	Wed, 17 Sep 2025 09:20:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8BFB01A0E1F;
	Wed, 17 Sep 2025 09:20:46 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY3sDMpo5pYNCw--.41830S4;
	Wed, 17 Sep 2025 09:20:45 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: john.g.garry@oracle.com,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [GIT PULL] md-6.17-20250917
Date: Wed, 17 Sep 2025 09:10:56 +0800
Message-Id: <20250917011056.1843135-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY3sDMpo5pYNCw--.41830S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr4rJw15CF13AF1UXryxXwb_yoWkGwc_uF
	WrXFWrtr4UGw17Aa1UWFn3ZryYv34UWF1vqr45KrWYqw13ZF1UKr1aqrWrX3WDZa4IqF98
	Ar1Ut3s5Ar15ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	tVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi, Jens

For 6.17 on drivers supporting write zeros, raid{0,1,10,5} are broken and
can't be assembled.

Please consider pulling following changes on your block-6.17 branch to
fix this serious regerssion.

Thanks,
Kuai

The following changes since commit 743bf030947169c413a711f60cebe73f837e649f:

  Merge tag 'md-6.17-20250905' of https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux into block-6.17 (2025-09-05 05:08:27 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/md-6.17-20250917

for you to fetch changes up to f0bd03832f5c84f90919bd018156b1b6eb911692:

  md: init queue_limits->max_hw_wzeroes_unmap_sectors parameter (2025-09-17 00:37:12 +0800)

----------------------------------------------------------------
Zhang Yi (1):
      md: init queue_limits->max_hw_wzeroes_unmap_sectors parameter

 drivers/md/md-linear.c | 1 +
 drivers/md/raid0.c     | 1 +
 drivers/md/raid1.c     | 1 +
 drivers/md/raid10.c    | 1 +
 drivers/md/raid5.c     | 1 +

 5 files changed, 5 insertions(+)

