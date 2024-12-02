Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A906F9E6
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 02:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733104926; cv=none; b=rpmYybNUT8F5/u84fUuDrBgpQX83SXabIkYts8EZTxKa4EicmZk5CI6/DKp15sQ/0lsCdyTyU6pYT2yzy2WFoR1+o0HeiqNgEAMDjVUBVAPDBGT0eC8VapAe8e3RytcepvluqVD8e/uU25aAT+/Nm31m6atvnSGAA+AYQWm9U3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733104926; c=relaxed/simple;
	bh=+OS7YPpV4s9Bwg5wGzrrL3ou+5dY8ALnAbZHaPIAwAk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A3Bltb8Pel3gTRD+R4rPK4ealQVgoR3FdXA+xtBYiwly7ra6yCLDhdesEY1gi4TcmtgzukGg+pseIKq9MVujsNyBYI7FzM9TZXYrgofDl4mLB3rgoEY563VOhKWbbmoAJRcf+A3L7L0Xlah0pgqHFd5VChDGRLPvJnfr4X4iNRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Y1n8J3xmnz4f3jMx
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 10:01:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 796E41A018D
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 10:01:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHo4cQFU1ngWmkDQ--.17049S8;
	Mon, 02 Dec 2024 10:01:55 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v4 mdadm 4/5] mdadm: ask user if bitmap is not set
Date: Mon,  2 Dec 2024 09:59:12 +0800
Message-Id: <20241202015913.3815936-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241202015913.3815936-1-yukuai1@huaweicloud.com>
References: <20241202015913.3815936-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHo4cQFU1ngWmkDQ--.17049S8
X-Coremail-Antispam: 1UD129KBjvJXoW7uF4kuF4kGr1UCry5XFWDArb_yoW8Xw1UpF
	sI9w1rGr10qr4Y9rnrJa48WF1Fgw4kXrZ7GF95Z3s5Xw15Wr1a9w18GFyxXay7AFykXa95
	ur45CFyI9FyjyF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvEb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjxU2CJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Instead of auto-forcing bitmap only for large arrays, it is more
reasonable to let user do the chooice if bimtap is not set.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 Create.c | 12 ------------
 mdadm.c  |  8 ++++++++
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/Create.c b/Create.c
index 140a7098..f6d14f76 100644
--- a/Create.c
+++ b/Create.c
@@ -949,18 +949,6 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 		}
 	}
 
-	if (!s->bitmap_file &&
-	    !st->ss->external &&
-	    s->level >= 1 &&
-	    st->ss->add_internal_bitmap &&
-	    s->journaldisks == 0 &&
-	    (s->consistency_policy != CONSISTENCY_POLICY_RESYNC &&
-	     s->consistency_policy != CONSISTENCY_POLICY_PPL) &&
-	    (s->write_behind || s->size > 100*1024*1024ULL)) {
-		if (c->verbose > 0)
-			pr_err("automatically enabling write-intent bitmap on large array\n");
-		s->bitmap_file = "internal";
-	}
 	if (s->bitmap_file && str_is_none(s->bitmap_file) == true)
 		s->bitmap_file = NULL;
 
diff --git a/mdadm.c b/mdadm.c
index 8cb4ba66..b7bcb336 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1535,6 +1535,14 @@ int main(int argc, char *argv[])
 			break;
 		}
 
+		if (!s.bitmap_file) {
+			if (c.runstop != 1 && s.level >= 1 &&
+			    ask("To optimalize recovery speed, it is recommended to enable write-indent bitmap, do you want to enable it now?"))
+				s.bitmap_file = "internal";
+			else
+				s.bitmap_file = "none";
+		}
+
 		rv = Create(ss, &ident, devs_found - 1, devlist->next, &s, &c);
 		break;
 	case MISC:
-- 
2.39.2

