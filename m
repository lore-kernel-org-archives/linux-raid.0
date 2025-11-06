Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748C232A3CA;
	Thu,  6 Nov 2025 12:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762430892; cv=none; b=as5p8ZCZxHDpy2dtuRp4IAKGWCkOiofk58g5BHQVH4K6wd+nAlqohbS47gF7zdV7NUiinkLwNK6GJFACYMg7PZJXV7uEhgSJJnv1IVjRPg53huPKkzCjCSqHM2bPss0N3qFUx5rUH5wzfzNoqxqksxVhr6sW8FuJod0QPRjDyqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762430892; c=relaxed/simple;
	bh=xFos9lJAcfnoplZ0GiAcj3DYFFlQPMklkNPev8k/Tv0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AOCurTnwUesMHc/XcCKr/2zwJ3H6QryELGAxpekvZc3fDHCIf0VeNjFQigyAB6FRKsxNMT87sQnSpVh6KlDp0r22SxiMcsCSi414Pc/0ixaVsUgtgzt0Ppg4pqZh5Tm8qFgH4Ny6u9DHtw6QLMGnlidK/cdeBkT43NnJTdD1DzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d2LYN6qgczKHMmC;
	Thu,  6 Nov 2025 20:07:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 9E2811A07BB;
	Thu,  6 Nov 2025 20:08:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgCH3UWfjwxpEbabCw--.33933S5;
	Thu, 06 Nov 2025 20:08:01 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xni@redhat.com,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 01/11] md/raid1: simplify uptodate handling in end_sync_write
Date: Thu,  6 Nov 2025 19:59:25 +0800
Message-Id: <20251106115935.2148714-2-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251106115935.2148714-1-linan666@huaweicloud.com>
References: <20251106115935.2148714-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCH3UWfjwxpEbabCw--.33933S5
X-Coremail-Antispam: 1UD129KBjvJXoW7CFy7tF4UtrWUGFW5Xr4ruFg_yoW8XFyrp3
	yUXFy5Ww43KFW5ZF4DGFWDZF1fKw1fJ3y7CrZrWw1fXFn8tF98G3WUXryYgFyDXFZ3CrW3
	Zw1kKay5Aa13XFJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHY14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8
	ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr
	0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUcjjkUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

In end_sync_write, r1bio state is always set to either R1BIO_WriteError
or R1BIO_MadeGood. Consequently, put_sync_write_buf() never takes the
'else' branch that calls md_done_sync(), making the uptodate parameter
have no practical effect.

Pass 1 to put_sync_write_buf(). A more complete cleanup will be done in
a follow-up patch.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid1.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 592a40233004..fbd39c44dc04 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2080,13 +2080,12 @@ static void put_sync_write_buf(struct r1bio *r1_bio, int uptodate)
 
 static void end_sync_write(struct bio *bio)
 {
-	int uptodate = !bio->bi_status;
 	struct r1bio *r1_bio = get_resync_r1bio(bio);
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
 	struct md_rdev *rdev = conf->mirrors[find_bio_disk(r1_bio, bio)].rdev;
 
-	if (!uptodate) {
+	if (bio->bi_status) {
 		abort_sync_write(mddev, r1_bio);
 		set_bit(WriteErrorSeen, &rdev->flags);
 		if (!test_and_set_bit(WantReplacement, &rdev->flags))
@@ -2099,7 +2098,7 @@ static void end_sync_write(struct bio *bio)
 		set_bit(R1BIO_MadeGood, &r1_bio->state);
 	}
 
-	put_sync_write_buf(r1_bio, uptodate);
+	put_sync_write_buf(r1_bio, 1);
 }
 
 static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
-- 
2.39.2

