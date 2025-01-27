Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF951FCD0C;
	Mon, 27 Jan 2025 08:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737968397; cv=none; b=WQBGFcDxUf6kmOD7WmaYIDjmBtV0jECj3EQK7yPvMrsESZh6Op/Bn/wyPaNbo1H8GZ3FwfMusW+dYITTLEcM1cP2hHLZZsko0IBcWNfQgn1fmVa/zXTkIiRUuvWQ+qwPP/1XVRtH5AjVORc+H1sqMXN/laBRKfz8zNNl4pKMvO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737968397; c=relaxed/simple;
	bh=uZu74+Pd+rmW9viNS9dZnevf2u6HlaE8S/yAE9i+M14=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=KsXfCLSnA+xlZTmwvEcfE0Fk+ZuWoArORqrm531sZMU/l0AHFuPYcvplbI4hZY+ZVRxkKXVM0Zp9wnCKqwFPQobz8AILqsKLhoWhgDj8H+rlle78yIgxgqOGUBvlVGnZ/1LlqRGDCs73S6VnKG2guNDLje9SrS+2Ts3gUTKflF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YhMmh2g8rz4f3jY9;
	Mon, 27 Jan 2025 16:59:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2D8F01A0E1E;
	Mon, 27 Jan 2025 16:59:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHa18IS5dnHix+CA--.52181S4;
	Mon, 27 Jan 2025 16:59:52 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 6.6 0/6] md/md-bitmap: move bitmap_{start, end}write to md upper layer
Date: Mon, 27 Jan 2025 16:53:45 +0800
Message-Id: <20250127085351.3198083-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHa18IS5dnHix+CA--.52181S4
X-Coremail-Antispam: 1UD129KBjvdXoW7XFW5WF48Gr1rAw1UGF48JFb_yoWkuFcE9a
	srZFyftFy8XF15GFy5Wr1xZrWjvr4kZ3WkJFZ2grWrZr13Zr1UGr48uws5W3WfXFWDuF15
	JFy8Jr18Ars8ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbx8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	tVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
	Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUpwZ
	cUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

This set fix reported problem:

https://lore.kernel.org/all/CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com/
https://lore.kernel.org/all/ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io/

See details in patch 6.

Benjamin Marzinski (1):
  md/raid5: recheck if reshape has finished with device_lock held

Yu Kuai (5):
  md/md-bitmap: factor behind write counters out from
    bitmap_{start/end}write()
  md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
  md: add a new callback pers->bitmap_sector()
  md/raid5: implement pers->bitmap_sector()
  md/md-bitmap: move bitmap_{start, end}write to md upper layer

 drivers/md/md-bitmap.c   |  75 ++++++++++-------
 drivers/md/md-bitmap.h   |   6 +-
 drivers/md/md.c          |  26 ++++++
 drivers/md/md.h          |   5 ++
 drivers/md/raid1.c       |  35 ++------
 drivers/md/raid1.h       |   1 -
 drivers/md/raid10.c      |  26 +-----
 drivers/md/raid10.h      |   1 -
 drivers/md/raid5-cache.c |   4 -
 drivers/md/raid5.c       | 174 ++++++++++++++++++++++-----------------
 drivers/md/raid5.h       |   4 -
 11 files changed, 185 insertions(+), 172 deletions(-)

-- 
2.39.2

