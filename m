Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866261FBEB9;
	Mon, 27 Jan 2025 08:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737968144; cv=none; b=IeUaXvUMGVh0mNluCapekOp+VV6GewfEVa+HlW2vFMgi0CZwPvSx4IIk0eH9/Ez0rk0MvdFNK9/XXsoTX+AwEwsBkMfRexg0AJwHh68A2GSsqxUctnNcZghAwQJt5Bpt/UmoGaqOI4AYY3vt1Bzm4ZbVRU4FeozEod2SkBnjB4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737968144; c=relaxed/simple;
	bh=co3x97Uu5AxKsPA0E9ITFkp3gtz+YwNnFYDYjSU+8j4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YMYQovEMGfqRHqRBOrz6pOfipB3Z4wRZJ3ik/01CA/+zKzB1hlnZfNq6IWePamBtmiU5hFg3o+XTYbf53rgqMlPRnU1ht32+pesCnib/xlRCfFfazATpKP72Xmy90uptnxnNpu9A1UTf8GLWZE0Kz30rQQjc9sjn4wCXweuwhQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YhMgh26Sdz4f3kFl;
	Mon, 27 Jan 2025 16:55:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 188391A07B6;
	Mon, 27 Jan 2025 16:55:33 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2ABSpdnDuF9CA--.54166S7;
	Mon, 27 Jan 2025 16:55:32 +0800 (CST)
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
Subject: [PATCH 6.13 3/5] md: add a new callback pers->bitmap_sector()
Date: Mon, 27 Jan 2025 16:49:26 +0800
Message-Id: <20250127084928.3197157-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250127084928.3197157-1-yukuai1@huaweicloud.com>
References: <20250127084928.3197157-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2ABSpdnDuF9CA--.54166S7
X-Coremail-Antispam: 1UD129KBjvdXoW7GF47Cry8KF4UJFW5uw4Durg_yoWDtFg_CF
	nIgryfWF1fGrn5Kr18ur1SvrWq9wn3WF4DWFy7KFyfZF9Yq34SvrWvkryrJw1xXF95uasx
	JFyDXrsYyrnrJjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbhAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84
	ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I2
	62IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcV
	AFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG
	0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_Jw0_GFyl42
	xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWU
	GwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI4
	8JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4U
	MIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I
	8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUF3kuDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

commit 0c984a283a3ea3f10bebecd6c57c1d41b2e4f518 upstream.

This callback will be used in raid5 to convert io ranges from array to
bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/r/20250109015145.158868-4-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Yu Kuai <yukuai1@huaweicloud.com>
---
 drivers/md/md.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4ba93af36126..de6dadb9a40b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -746,6 +746,9 @@ struct md_personality
 	void *(*takeover) (struct mddev *mddev);
 	/* Changes the consistency policy of an active array. */
 	int (*change_consistency_policy)(struct mddev *mddev, const char *buf);
+	/* convert io ranges from array to bitmap */
+	void (*bitmap_sector)(struct mddev *mddev, sector_t *offset,
+			      unsigned long *sectors);
 };
 
 struct md_sysfs_entry {
-- 
2.39.2

