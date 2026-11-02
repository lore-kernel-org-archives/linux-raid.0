Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.94.104
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793609182;
	b=VLpto/+lif+O+bH0LiOY2tltE1imu3YMo6RRw0asC1ZLIWdNThd2+vWGvboFZDfYMWxC
	 89j/pQZCOyAvGGuBSYjLQXwrYHtrePE8kZxpW+VKj2w75cLX+nXT1i14JA5RChw2zP5rn
	 ytNoTKUIWlKf0OgYFFk/r3QxsjFdo9PKgDKFKSPRJenhiA9/uC06tV+jqmBOVqEjzkuFz
	 u8W/MHqzy9Us8QFJL+CS14Tp6bTTKZ63nRB0nfw3n0nZVt4/elvBdZc+RSad59JB/u6Rd
	 EhZpkpfIkeyXzuAqW1Ggoedcg3C22sNWPXbqjP3j2SECLGRqLbe+voiLbofy8ad5pSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793609182;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=/izG8lm3u575/3B41GmNqXIxQnvbCRzRu6K9lcU/TUo=;
	b=jSH2sne65mcSLupyxY2kqs+gKfNTKD9OLdsn/gxE2ymgXo2ZgwxgEgVWBa9h7Ow9O1pN
	 kLa1Zl4d5tGo/M00skaQwYeWmNPXPwNjZm2JAJLoPtKeIallYpIcOuxc2xlzm/rbXfDYS
	 QQ3h1o/AP3KjrO/0rSH5G0LnIKwFWkgvMwHy5k9QQTCDI5iWnGI6Apaao/5z/UhFEaXam
	 f7p/RhUbM4NrYBtNNpL8lgpgP3Wgb5VSTv5gvQayD0Hmxns72dt9vNm8P0Zmp2M4HH04w
	 RQ64CrwPwrEjE/iyVb/VAovj3xN60yxyt0lqVSexMMEKjABODNMY5+j1vViB3rXg8pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.94.104
Received: from dggmsgout13.his.huawei.com (dggmsgout13.his.huawei.com [124.71.94.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66D8606A329;
	Mon,  2 Nov 2026 08:46:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A66D8606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggmsgout13.his.huawei.com (SkyGuard) with ESMTP id 4jJ4zj3MMDz1rrFF;
	Mon,  2 Nov 2026 16:45:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A9C8A405A4;
	Mon,  2 Nov 2026 16:46:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvXXTehqaMofCw--.17777S5;
	Mon, 02 Nov 2026 16:46:16 +0800 (CST)
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
Subject: [PATCH V3 1/3] md/raid0: reject a takeover whose zones cannot cover the array
Date: Mon,  2 Nov 2026 16:38:13 +0800
Message-ID: <20261102083815.127751-2-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102083815.127751-1-wozizhi@huaweicloud.com>
References: <20261102083815.127751-1-wozizhi@huaweicloud.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnZvXXTehqaMofCw--.17777S5
X-Coremail-Antispam: 1UD129KBjvJXoWxWF1kKF4UGF1fWrWxCrW8Crg_yoWrJF13pw
	40qFn8Xrs5Gr93JwnxAryDGa4FyryxGrZrtF9xX348Gw13ArykGFy5XFyYgayUAas5ZryU
	ta1UGFWqkFWvgrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Eb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ew
	Av7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY
	6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1_cTDUUUUU==
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

If a raid0 takeover builds strip zones that cover less than the advertised
array size, the block layer still accepts I/O for the whole size.
raid0_make_request() hands any request past the zones to the mapping code,
which fails to map it and triggers a BUG_ON.

The zones are built from the member sizes in rdev->sectors, which may not
match the size the array already advertises, so the zones can come out
covering less than it. The extreme case is a member with no size recorded
at all: an array created without metadata imports its devices through
md_import_device(dev, -1, -1), which never sets rdev->sectors, and
bind_rdev_to_array() does not reject such a member either, because its
check that mddev->dev_sectors fits inside a member is skipped when
rdev->sectors is zero.

Refuse a raid0 takeover when its zones cannot cover the size the gendisk
advertises. This prevents the takeover from silently shrinking the array,
mirroring the rule raid5_start_reshape() and raid10_start_reshape() apply
to a reshape.

The check iterates the same devices and uses the same rounding as
create_strip_zones(). It does not skip devices with rdev->raid_disk < 0:
such devices cannot be raid0 members, so counting them only overestimates
the coverage and, if present, the takeover fails later in
create_strip_zones() anyway.

Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and Raid10->Raid0 takeover")
Fixes: fc3a08b85b7a ("Add raid1->raid0 takeover support")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/md/raid0.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 35e103f0c2c3..fccc62a5fecc 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -643,6 +643,34 @@ static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
 	}
 }
 
+/*
+ * Refuse a takeover whose strip zones cannot cover the capacity the gendisk
+ * advertises: raid0 derives those zones from the sizes of its members, so
+ * find_zone() cannot map I/O that falls beyond them.
+ */
+static int raid0_takeover_check(struct mddev *mddev, int chunk)
+{
+	sector_t capacity = get_capacity(mddev->gendisk);
+	sector_t coverage = 0;
+	struct md_rdev *rdev;
+
+	rdev_for_each(rdev, mddev) {
+		sector_t sectors = rdev->sectors;
+
+		sector_div(sectors, chunk);
+		coverage += sectors * chunk;
+	}
+
+	if (coverage < capacity) {
+		pr_warn("md/raid0:%s: refusing takeover, zones cover only %llu of %llu sectors\n",
+			mdname(mddev), (unsigned long long)coverage,
+			(unsigned long long)capacity);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void *raid0_takeover_raid45(struct mddev *mddev)
 {
 	struct md_rdev *rdev;
@@ -665,6 +693,9 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
 		rdev->sectors = mddev->dev_sectors;
 	}
 
+	if (raid0_takeover_check(mddev, mddev->chunk_sectors))
+		return ERR_PTR(-EINVAL);
+
 	/* Set new parameters */
 	mddev->new_level = 0;
 	mddev->new_layout = 0;
@@ -707,6 +738,9 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (raid0_takeover_check(mddev, mddev->chunk_sectors))
+		return ERR_PTR(-EINVAL);
+
 	/* Set new parameters */
 	mddev->new_level = 0;
 	mddev->new_layout = 0;
@@ -750,6 +784,9 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
 		/* array size does not allow a suitable chunk size */
 		return ERR_PTR(-EINVAL);
 
+	if (raid0_takeover_check(mddev, chunksect))
+		return ERR_PTR(-EINVAL);
+
 	/* Set new parameters */
 	mddev->new_level = 0;
 	mddev->new_layout = 0;
-- 
2.52.0

