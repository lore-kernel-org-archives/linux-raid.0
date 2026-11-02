Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.94.104
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793609182;
	b=X43edQbM7CYy0Q4PszRurg2op5jZFehh9ir+bmpMgau4oOriFy+M5xWAPw8UaYMqttZK
	 wy4kOajKSbg6U0I3Hj3szOrVM+E+tsq9UFQ1S+JOMssuM2SqKI4/ATMRduPEqSBMQqR/i
	 C0BfV+1ZdXpRrnxqb1YZg7z5oI7mP25PR1GDVArcGGFs0PpdyfIpBSXdVuoVQbOE24dXx
	 FgCX3hxONzmNZjIET9BKEGH+CUAfiLyj2iA+GNjZYvlmvoC5ehsl/RFKmnT1+lSicpvN4
	 vkEtnNp5Ajpy0qibjTGrqB93YzyMR+UQUH3pcM2etJw1GW35uQ+rSaOd16jBDOz9DFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793609182;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=VvuQCogP1YXMBvcAg+eTf4BGotpiHGOnJ1AnHct85Ws=;
	b=lvrNELB6krlasf5NybKiZDLriXev/ur0DEMkr91xL52UmDa8dSf5lML/VPQAu17BsiY2
	 FimhcYXxbTYTNWo1Nwoua7wq4X2uqPCUzuSxjUcpeBzE64eemO/hNFaeMlnrT8VQ6Ebw4
	 2CfU98EvnsTfov956vaJUVjrOJ0bKouNPwvvReoGeY5uVp8XDhHxPCBevjlmCwSzR364M
	 10W3waSe21/92rbQFjLI5FPwnBcCfLYnpsKkRT99VDyK/KgNCH9lG1/e2to5RmzDtGb1d
	 YewOEoaCds+zAE+YeALtnnGW40/Hz+6azJTOoy4E2G7OyyuLnGJvVbJkhc4fx4x53xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.94.104
Received: from dggmsgout13.his.huawei.com (dggmsgout13.his.huawei.com [124.71.94.104])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D37D606A32C;
	Mon,  2 Nov 2026 08:46:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D37D606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout13.his.huawei.com (SkyGuard) with ESMTP id 4jJ4zj3dlbz1rrKP;
	Mon,  2 Nov 2026 16:45:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B8F864056E;
	Mon,  2 Nov 2026 16:46:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZvXXTehqaMofCw--.17777S6;
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
Subject: [PATCH V3 2/3] md/raid0: factor out raid0_member_sectors()
Date: Mon,  2 Nov 2026 16:38:14 +0800
Message-ID: <20261102083815.127751-3-wozizhi@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAnZvXXTehqaMofCw--.17777S6
X-Coremail-Antispam: 1UD129KBjvJXoW7ArW5Xw18Kw13tFy3JF4UCFg_yoW8Cr18pw
	4UKas2gry0gryfX3WDJ34DuayFqFy5GrWDKFy3Za48Ww1xCryDCFWfX345WFyUA3sYv34a
	qw1jkrWjk3Z5GrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Eb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ew
	Av7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY
	6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8fWrJUUUUU==
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

create_strip_zones() and the takeover coverage check both compute the size
a member contributes to a raid0 array. Pull that into a small helper so the
two sites share one definition.

No functional change.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/md/raid0.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index fccc62a5fecc..c96ee54f9acc 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -63,6 +63,12 @@ static void dump_zones(struct mddev *mddev)
 	}
 }
 
+static sector_t raid0_member_sectors(sector_t sectors, unsigned int chunk)
+{
+	sector_div(sectors, chunk);
+	return sectors * chunk;
+}
+
 static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 {
 	int i, c, err;
@@ -86,9 +92,8 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		c = 0;
 
 		/* round size to chunk_size */
-		sectors = rdev1->sectors;
-		sector_div(sectors, mddev->chunk_sectors);
-		rdev1->sectors = sectors * mddev->chunk_sectors;
+		rdev1->sectors = raid0_member_sectors(rdev1->sectors,
+						      mddev->chunk_sectors);
 
 		if (mddev_is_dm(mddev))
 			blksize = max(blksize, queue_logical_block_size(
@@ -654,12 +659,8 @@ static int raid0_takeover_check(struct mddev *mddev, int chunk)
 	sector_t coverage = 0;
 	struct md_rdev *rdev;
 
-	rdev_for_each(rdev, mddev) {
-		sector_t sectors = rdev->sectors;
-
-		sector_div(sectors, chunk);
-		coverage += sectors * chunk;
-	}
+	rdev_for_each(rdev, mddev)
+		coverage += raid0_member_sectors(rdev->sectors, chunk);
 
 	if (coverage < capacity) {
 		pr_warn("md/raid0:%s: refusing takeover, zones cover only %llu of %llu sectors\n",
-- 
2.52.0

