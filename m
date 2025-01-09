Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965384A1A;
	Thu,  9 Jan 2025 01:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736387808; cv=none; b=eU5LShOU0KXzPbMhqHiNMfBqymL6ibmE0dsL9RwbKrfFEqPJB2E9yt+VCkYM9HgACwyDQCkqQDinpKpKuqHkM1TFBONROi0ZPrx+1qPLTR1RWuo8lspK8DK5h71HbM483NwasN5Rj66dBlcBAgspMuBNDzpR1MIxLBFGwvBYmmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736387808; c=relaxed/simple;
	bh=97N8cpq8oNivG9jpM1/4aoiyGpBje0S+lUaRYtyDraE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=CdBdudxxYLgXY0s8T9N11Gi8AYlCgVu4PBG8wvDqY3tujPEksydZ4GdKTksTJAzlLpyU6Kpt7jqGWQ/ACzHWEc4wH7YkIWq2V+JRcrENCfZEg1mU5fL5qQt1iDOOMx+9IQUcRA6D4eOiD8YEkWXzdIJQy9x6cqqlaWUudp4LuGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YT7Dk0wgCz4f3kFM;
	Thu,  9 Jan 2025 09:56:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 51C081A0D4B;
	Thu,  9 Jan 2025 09:56:42 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCH61_YLH9nk+G_AQ--.844S4;
	Thu, 09 Jan 2025 09:56:42 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	xni@redhat.com,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 md-6.14 0/5] md/md-bitmap: move bitmap_{start, end}write to md upper layer
Date: Thu,  9 Jan 2025 09:51:40 +0800
Message-Id: <20250109015145.158868-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH61_YLH9nk+G_AQ--.844S4
X-Coremail-Antispam: 1UD129KBjvdXoWrurWUWr4rtF43Jw1fXF45Awb_yoWfZrXE9a
	4DZFyftFy7WF13AFy5Xr1xZrWjvr4DZ3WkXFZ2grWrZr13ur1UGr4UZws3Xw1rZFWq9Fn8
	Ary8Xr18Ars8ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes in v2:
 - add commit message in patch 2;
 - also remove unsed flags in patch 2;
 - handle rehspae in patch 4;

Yu Kuai (5):
  md/md-bitmap: factor behind write counters out from
    bitmap_{start/end}write()
  md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
  md: add a new callback pers->bitmap_sector()
  md/raid5: implement pers->bitmap_sector()
  md/md-bitmap: move bitmap_{start, end}write to md upper layer

 drivers/md/md-bitmap.c   |  74 ++++++++------
 drivers/md/md-bitmap.h   |   7 +-
 drivers/md/md.c          |  29 ++++++
 drivers/md/md.h          |   5 +
 drivers/md/raid1.c       |  34 ++-----
 drivers/md/raid1.h       |   1 -
 drivers/md/raid10.c      |  26 +----
 drivers/md/raid10.h      |   1 -
 drivers/md/raid5-cache.c |   4 -
 drivers/md/raid5.c       | 205 ++++++++++++++++++++-------------------
 drivers/md/raid5.h       |   4 -
 11 files changed, 196 insertions(+), 194 deletions(-)

-- 
2.39.2

