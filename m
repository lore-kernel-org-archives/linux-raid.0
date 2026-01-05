Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8526258CDF;
	Mon,  5 Jan 2026 11:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767611502; cv=none; b=b3m4A5hMif6ftDTtOPJ5n+x23Mt15WoGWEqh3INA6c/arvi4N+L4VGMVsRkJF4CZf86iBNYZBRjdJmv3DNgdsC9bPmQk9C34sPBD43+8Urw39RHxq67ydzwykM/PXh1Z36n9EDK9Qb4NbyvP1qbG5Rnpe1ZPsmJzOemENzvEYCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767611502; c=relaxed/simple;
	bh=kol7nKOTHhmzvvwout/eC/zPYeCpPmgcDVjcD0ebrX8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JndO6j/+f7rlcbO712mbBq44RamBAw5N0IBt9RKprZYh9Uh+Dj/Ox3PfT6EhARoSXhIFJv/Ir+0NzXG1aZS9oPwhbSvLhMkMe4prx9mRzC03v73yvd4zZT3KAqcKjWWB8OxGSe0zrTXRJOUMEsvBpn3aPRRjB50nmQqwTYLJKq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dlBRf3xrDzYQv2L;
	Mon,  5 Jan 2026 19:10:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 471C64056B;
	Mon,  5 Jan 2026 19:11:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBXuPhmnFtp6EHbCg--.50545S5;
	Mon, 05 Jan 2026 19:11:37 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v4 01/12] md/raid1: simplify uptodate handling in end_sync_write
Date: Mon,  5 Jan 2026 19:02:49 +0800
Message-Id: <20260105110300.1442509-2-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260105110300.1442509-1-linan666@huaweicloud.com>
References: <20260105110300.1442509-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXuPhmnFtp6EHbCg--.50545S5
X-Coremail-Antispam: 1UD129KBjvJXoW7CFy7tF4UtF1UuFWrKry8Xwb_yoW8Xw4kp3
	yUGFW5WrW5KFZ8ZFWDGFyDZF1fKw13W3y7CrZrWw1fXFn8tr98Ga1UXrWYgFyDZFZ3Cr43
	Xw1vkay3Aa13JFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmC14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2Iq
	xVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
	106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
	xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7
	xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_
	Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUqtCcUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

In end_sync_write, r1bio state is always set to either R1BIO_WriteError
or R1BIO_MadeGood. Consequently, put_sync_write_buf() never takes the
'else' branch that calls md_done_sync(), making the uptodate parameter
have no practical effect.

Pass 1 to put_sync_write_buf(). A more complete cleanup will be done in
a follow-up patch.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid1.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 57d50465eed1..6af75b82bc64 100644
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

