Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E62F1FCD0D;
	Mon, 27 Jan 2025 08:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737968300; cv=none; b=FEBWmAoj6XCUSnANfko8UTH/Qe4KFNK9ysYm7C1kkSa1kcIOu+Zm9m1wNEFcXck/TqfxeO3b0IhaNCkYS7QoiWJvAf+T4erExXD4wZjEGjIh/hjSB3RCscmzwlAcWIBGhOzOOvfVvxcOR3RtKb+NYCWwFwUhrP/sU8AKaZr6HDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737968300; c=relaxed/simple;
	bh=cVVuoQeKN5zhyvnH1ul9ksYWOd+TMGxso+PF2LKvaRE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=G/uiISh5xGBhSe7Y0i5nzEfDLQoVGwyKK7C8PMntBvoShrzRsVC/VfFto9BXidNYBtXK3kAmQJ84lF76OXd55Ya5AP4GQ2Q1RcWtaGYbKx0crWFU6JSw3KD4O8hhfZ5gcEsRVPhUS/wt3YA31/do8TMZlUkhFIRbzKbV+nRtXiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YhMkn4r8Pz4f3lV7;
	Mon, 27 Jan 2025 16:57:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BE4BF1A06DD;
	Mon, 27 Jan 2025 16:58:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAXe1+mSpdnShB+CA--.53281S4;
	Mon, 27 Jan 2025 16:58:15 +0800 (CST)
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
Subject: [PATCH 6.12 0/5] md/md-bitmap: move bitmap_{start, end}write to md upper layer
Date: Mon, 27 Jan 2025 16:52:09 +0800
Message-Id: <20250127085214.3197761-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXe1+mSpdnShB+CA--.53281S4
X-Coremail-Antispam: 1UD129KBjvdXoW7XFW5WF48Gr1rAFW8uF18AFb_yoWkXrgE9a
	srXFyftFyUXF15JFy5Wr1xZryjvr4DZ3WkJFZ2grWrZry3Zr1UGr48uws5W3WfXFWDuFn8
	JFyUJr1rAr4DujkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r4a
	6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRAWrXUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

This set fix reported problem:

https://lore.kernel.org/all/CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com/
https://lore.kernel.org/all/ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io/

See details in patch 5.

Yu Kuai (5):
  md/md-bitmap: factor behind write counters out from
    bitmap_{start/end}write()
  md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
  md: add a new callback pers->bitmap_sector()
  md/raid5: implement pers->bitmap_sector()
  md/md-bitmap: move bitmap_{start, end}write to md upper layer

 drivers/md/md-bitmap.c   |  74 ++++++++++++++++----------
 drivers/md/md-bitmap.h   |   7 ++-
 drivers/md/md.c          |  29 ++++++++++
 drivers/md/md.h          |   5 ++
 drivers/md/raid1.c       |  34 +++---------
 drivers/md/raid1.h       |   1 -
 drivers/md/raid10.c      |  26 +--------
 drivers/md/raid10.h      |   1 -
 drivers/md/raid5-cache.c |   4 --
 drivers/md/raid5.c       | 111 ++++++++++++++++++++-------------------
 drivers/md/raid5.h       |   4 --
 11 files changed, 149 insertions(+), 147 deletions(-)

-- 
2.39.2

