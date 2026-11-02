Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.94.104
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793609181;
	b=1Ve3JkaMM0Ary8grW8smGelElQVs/BY0pE8KE45hGqqG45PB9lWmZlv+bKuDtBBU9dpP
	 bGF0zSrGeooFQFubyzIEprQcctcsUTyc8wVV0K+Lcpjqof1ykLQaHzSrH8HislFjRYAHl
	 jDy9klMLBksFIJWxjk9/yfVQ/iGwp2a39GlHEompLhrsEzNFa2vhGr+nKQ+L7aH9nHXh/
	 nb+b6qhSFuzmmPUiEoUXdFrdZUryrZ6Ml3fSMAcP1h1UGH23ba0SqPdBRmcrYZCTvyxs7
	 e8vJviaPEIjDlYIwM3Ev2tIsbr8BRhMzfj2h7NFbgA6sS6p7k4VHfqB32uEYZj2Gb5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793609181;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=j5ib4kIh3kEAll76vLC/omf9+OjJHsf85ot8HkhBp9c=;
	b=qBg2qkouXzKRPpGYVjGCJRA4mTN7Msc/zbBLGsvwNmj+LqLEqCqMOA7lI3PgXzmp4ojB
	 NGKrkxsx2SNY8+3Vj9E78GKk6gxBxa1R9kHkf1AR42k1MAecrDYbR3hojyaMpBN+MCJq6
	 eF6kIA+YEUwXV3L4BZAIv8VtYotXKDArIYepZ3bsZsR7EMmDoNXsjtSOw8J3qUZDFwyST
	 GWJlfCUrN5bUOUKC9bYhQrilYXXhClJR/7JFazRuCE2ctTi7I4AAtizPcmVb6xBIdnc4l
	 4L+0qXmYufwas0nbDlE0vmY9i2K9UZCJffXa3LX6mdBuoY+B+qZDArAtGFRBoh2ExbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.94.104
Received: from dggmsgout13.his.huawei.com (dggmsgout13.his.huawei.com [124.71.94.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ACD606A327;
	Mon,  2 Nov 2026 08:46:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94ACD606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout13.his.huawei.com (SkyGuard) with ESMTP id 4jJ4zj3zbMz1rqbF;
	Mon,  2 Nov 2026 16:45:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C426D4056F;
	Mon,  2 Nov 2026 16:46:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvXXTehqaMofCw--.17777S7;
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
Subject: [PATCH V3 3/3] md/raid0: round member size in raid0_size() with sector_div()
Date: Mon,  2 Nov 2026 16:38:15 +0800
Message-ID: <20261102083815.127751-4-wozizhi@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAnZvXXTehqaMofCw--.17777S7
X-Coremail-Antispam: 1UD129KBjvJXoW7KF13Cw4rtrW8KF18Zr47Jwb_yoW8Gr47pw
	4jgF93uryUAr15Ja98X340gayFvF98GrWDtF9ruayUurn5Wr92ka45Kw15Xa4UZw1rA34Y
	v3yDCrZrC3WDKrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Eb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ew
	Av7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY
	6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU14xRDUUUUU==
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

raid0_size() rounds each member device down to the chunk boundary by
masking with 'chunk_sectors - 1':

	rdev->sectors & ~(sector_t)(mddev->chunk_sectors - 1)

This bit-masking only yields a correct round-down when chunk_sectors is a
power of 2. However, raid0 also supports non-power-of-2 chunk sizes, as
handled in raid0_make_request() and map_sector(), so the rounding is wrong
in that case.

Use raid0_member_sectors() instead, so that each member is rounded down
with sector_div() for any chunk size, consistent with how
create_strip_zones() already rounds the members when building the zones.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/md/raid0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c96ee54f9acc..623b0701ce70 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -369,8 +369,8 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
 		  "%s does not support generic reshape\n", __func__);
 
 	rdev_for_each(rdev, mddev)
-		array_sectors += (rdev->sectors &
-				  ~(sector_t)(mddev->chunk_sectors-1));
+		array_sectors += raid0_member_sectors(rdev->sectors,
+						      mddev->chunk_sectors);
 
 	return array_sectors;
 }
-- 
2.52.0

