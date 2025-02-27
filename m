Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615EC227BB0;
	Thu, 27 Feb 2025 07:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740643165; cv=none; b=XPT23cES1WP/NF1MPtrrMuhYhHjwmMG0P9vOGaTTghSs+3icp1gT1pk/mYRYa6/2IGE4GYYBHEPbcbTIKj2IfKcnb6kkb0sz+iCq+44cyVg9kDiZIu/8nw8TC/5+gvf97o2wcG5pAYvflmQFhyMypTiLL7TZZnjs5W7VR6MODRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740643165; c=relaxed/simple;
	bh=6oBs3WpSlBUFPcWaoJaR+XKYQEw9cDKj054cJxoJTBc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PPU35My/KHveCwnTiXcvztOlYowAWU51ozGwMmtqV5/x7ivrcPZpRBpIbuU5W+iOceIwqs6tfDhqVBEhU9aKicJjeCVq5TIPkdKa6h//vLtNJN569DFYqiA2gnJO8J4o861CruN9T2Ol7R7ZO/Unf+xvgGniwmwnXbxjoNHCwdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z3NyP1bmkz4f3js6;
	Thu, 27 Feb 2025 15:58:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1844B1A0D77;
	Thu, 27 Feb 2025 15:59:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl9PG8Bn6c8gFA--.31377S5;
	Thu, 27 Feb 2025 15:59:14 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: axboe@kernel.dk,
	song@kernel.org,
	yukuai3@huawei.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	dlemoal@kernel.org,
	kch@nvidia.com,
	yanjun.zhu@linux.dev,
	hare@suse.de,
	zhengqixing@huawei.com,
	colyli@kernel.org,
	geliang@kernel.org,
	xni@redhat.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH V2 01/12] badblocks: Fix error shitf ops
Date: Thu, 27 Feb 2025 15:54:56 +0800
Message-Id: <20250227075507.151331-2-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
References: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl9PG8Bn6c8gFA--.31377S5
X-Coremail-Antispam: 1UD129KBjvJXoW7CrykAw4UJw1rCr1DCrW8Xrb_yoW8XFW7pr
	nrG343GrW7W3yj93W5X3WUGr9aq3W3JF43Ca17Ja4jkry5t3srta4kXrySva4a9FW3Grn0
	g3WruryrZrZ7C37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI
	0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUIw0e
	DUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Li Nan <linan122@huawei.com>

'bb->shift' is used directly in badblocks. It is wrong, fix it.

Fixes: 3ea3354cb9f0 ("badblocks: improve badblocks_check() for multiple ranges handling")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Coly Li <colyli@kernel.org>
---
 block/badblocks.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index db4ec8b9b2a8..bcee057efc47 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -880,8 +880,8 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 		/* round the start down, and the end up */
 		sector_t next = s + sectors;
 
-		rounddown(s, bb->shift);
-		roundup(next, bb->shift);
+		rounddown(s, 1 << bb->shift);
+		roundup(next, 1 << bb->shift);
 		sectors = next - s;
 	}
 
@@ -1157,8 +1157,8 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 		 * isn't than to think a block is not bad when it is.
 		 */
 		target = s + sectors;
-		roundup(s, bb->shift);
-		rounddown(target, bb->shift);
+		roundup(s, 1 << bb->shift);
+		rounddown(target, 1 << bb->shift);
 		sectors = target - s;
 	}
 
@@ -1288,8 +1288,8 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 
 		/* round the start down, and the end up */
 		target = s + sectors;
-		rounddown(s, bb->shift);
-		roundup(target, bb->shift);
+		rounddown(s, 1 << bb->shift);
+		roundup(target, 1 << bb->shift);
 		sectors = target - s;
 	}
 
-- 
2.39.2

