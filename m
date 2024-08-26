Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A93013A27D;
	Mon, 26 Aug 2024 07:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724658595; cv=none; b=R8C2ct6RsNoP0e/X3D2BTSqM2p3Ec8mfjCTcEckyYEW4f5cGqL1USr1nge5mpTQvbNiVxatyXvMn1o76lqqeCsL7o6IHklsJEqmAmZJhflR2cJUZDxtEOgTFTIBOYH2lxxeW1CK5JO91Hi4jvgGENpp2OL8ZP1BEzha/8Y+cD64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724658595; c=relaxed/simple;
	bh=E0qLlnR1qv4l5JAEhksEDnZONBgLcJCbGR1KTRTXefA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ryRe3xKlbPnCUuv4bW+rSHqfgNmZRhArBB1J0tTxGhIz5H6mHR9QzPmvBP1eJU2M7QZZxuCal7/rA59W045mIXrfRU3SC9M6Feb/Qjvj2GZJV+uZMcdHYWSpAzw4JOREwGzBWFRRkREgd0jRX9deSnbSxiLlq5twEYXYsIDi8MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WsjW85M68z4f3jjw;
	Mon, 26 Aug 2024 15:49:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9BAA41A1127;
	Mon, 26 Aug 2024 15:49:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WaM8xmWWIECw--.13849S9;
	Mon, 26 Aug 2024 15:49:50 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	xni@redhat.com,
	song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 v2 05/42] md/md-cluster: fix spares warnings for __le64
Date: Mon, 26 Aug 2024 15:44:15 +0800
Message-Id: <20240826074452.1490072-6-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
References: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WaM8xmWWIECw--.13849S9
X-Coremail-Antispam: 1UD129KBjvJXoW7ArWxArWkKw1fZr17JF1kKrg_yoW8AF13pF
	W09ry3Gw43Zw4UJr17Xrs7Za4rtasrt3y7KryUAwsYgFyqy3W3JFn7JFZxurWqgF15JrnI
	qryUKF4ru3Z3Cw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtV
	W8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUU
	UUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

drivers/md/md-cluster.c:1220:22: warning: incorrect type in assignment (different base types)
drivers/md/md-cluster.c:1220:22:    expected unsigned long my_sync_size
drivers/md/md-cluster.c:1220:22:    got restricted __le64 [usertype] sync_size
drivers/md/md-cluster.c:1252:35: warning: incorrect type in assignment (different base types)
drivers/md/md-cluster.c:1252:35:    expected unsigned long sync_size
drivers/md/md-cluster.c:1252:35:    got restricted __le64 [usertype] sync_size
drivers/md/md-cluster.c:1253:41: warning: restricted __le64 degrades to integer

Fix the warnings by using le64_to_cpu() to convet __le64 to integer.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-cluster.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 1d0db62f0351..e642361b6526 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1217,7 +1217,7 @@ static int cluster_check_sync_size(struct mddev *mddev)
 	struct dlm_lock_resource *bm_lockres;
 
 	sb = kmap_atomic(bitmap->storage.sb_page);
-	my_sync_size = sb->sync_size;
+	my_sync_size = le64_to_cpu(sb->sync_size);
 	kunmap_atomic(sb);
 
 	for (i = 0; i < node_num; i++) {
@@ -1249,8 +1249,8 @@ static int cluster_check_sync_size(struct mddev *mddev)
 
 		sb = kmap_atomic(bitmap->storage.sb_page);
 		if (sync_size == 0)
-			sync_size = sb->sync_size;
-		else if (sync_size != sb->sync_size) {
+			sync_size = le64_to_cpu(sb->sync_size);
+		else if (sync_size != le64_to_cpu(sb->sync_size)) {
 			kunmap_atomic(sb);
 			md_bitmap_free(bitmap);
 			return -1;
-- 
2.39.2

