Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46BD202984;
	Tue,  4 Mar 2025 12:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741091036; cv=none; b=E+rEwPffGOS3b4WXXSeaofAn7vfliFtbSKeYRu+zUjKvKttovL450ZFDNNdNYhEsObVeE7K7XAsN2CGlkY10CF6+5kTWQThm8mNp2aH05mwFN/t32E8C3oQVeDSepLL0g2ZPx5NKjSvyikBNmeym0BRuSGGXg6Qu0zvEKGMZ59g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741091036; c=relaxed/simple;
	bh=fK01A2FhtET1I5fWk9BnZhECN7fNOjaIqKDIDqP1ANk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uqQqUGz2JrwPjBKHgnE0tedturabLSkUBiuoL5Z114VxDZX6pgAoezMFNnIpmxMsLCq/ItbS9qY49PcDsO3DGkGUdeo0vnjCUJ0BPK6A5yQ8bciWWOaN1qi77u+LshI8NeaLT/r/ZuPwW80JU58NnkygZSt8WGMykpKtjoQGqdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z6ZbN5vWCz4f3jt9;
	Tue,  4 Mar 2025 20:23:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 89B4C1A16DC;
	Tue,  4 Mar 2025 20:23:45 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB321_O8MZnFO8VFg--.52907S8;
	Tue, 04 Mar 2025 20:23:45 +0800 (CST)
From: linan666@huaweicloud.com
To: axboe@kernel.dk,
	song@kernel.org,
	yukuai3@huawei.com,
	hare@suse.de,
	martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	zhangxiaoxu5@huawei.com,
	wanghai38@huawei.com
Subject: [PATCH 4/4] md: Fix the return value of mddev_stack_new_rdev
Date: Tue,  4 Mar 2025 20:19:18 +0800
Message-Id: <20250304121918.3159388-5-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250304121918.3159388-1-linan666@huaweicloud.com>
References: <20250304121918.3159388-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB321_O8MZnFO8VFg--.52907S8
X-Coremail-Antispam: 1UD129KBjvdXoWruFyDZF43Gr45Kw4kKF1Dtrb_yoWftwc_CF
	ZYvF92qrykCF97Zr1YvFWxZryDt3W8Wan7XF1ag3WfZFZrJrn5JFy8C343W3y5u3yayryU
	KrsF9aySyw4akjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbl8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
	kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8
	ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr
	0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoHqcDUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

In mddev_stack_new_rdev(), if the integrity profile check fails, it
returns -ENXIO, which means "No such device or address". This is
inaccurate and can mislead users. Change it to return -EINVAL.

Fixes: c6e56cf6b2e7 ("block: move integrity information into queue_limits")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 48c35b6fb52e..e974280b38bb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5869,7 +5869,7 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
 		pr_err("%s: incompatible integrity profile for %pg\n",
 		       mdname(mddev), rdev->bdev);
 		queue_limits_cancel_update(mddev->gendisk->queue);
-		return -ENXIO;
+		return -EINVAL;
 	}
 
 	return queue_limits_commit_update(mddev->gendisk->queue, &lim);
-- 
2.39.2

