Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F10A5579E
	for <linux-raid@vger.kernel.org>; Tue, 22 Jul 2025 01:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753148849; cv=none; b=Hs0Tawc1gtdZSe5BUZ0LLO5Kfa8DQkaqGDgHHj2Bzh2/bqHzz3YsmOhxfNFteRoglSP/fMZZr1rpN5ZXpYipWkkvn3zpf+BmyLzVmOj52o4Mx/LgrJolsfwO6qKbARhMPQ7yq5RtEZb02glYKfC+Y36Nkhxioc/dY8+KRo6Y1D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753148849; c=relaxed/simple;
	bh=GLm3K1Sks1v7c0UiAtg84129LLhBtsZikLQjpTC/QYg=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=SGGJnHM6nvsDkYWYqYbv1Oz3CkFvuUyY+K8ceIcHIfhQ+7MaG0/SgI7AMGGTM7ebk0u1/frcZWf1NaThaaYiaSG6IlbsjLH+nZ/G5wZsdWvG4OWgEPaZxpJX0zHrbEYhxiNDdkgVPYnDNo299vOeB7HOzmD91BkBuSVjwz9E/4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bmKlJ1FTpz14M4D;
	Tue, 22 Jul 2025 09:42:36 +0800 (CST)
Received: from kwepemg500011.china.huawei.com (unknown [7.202.181.72])
	by mail.maildlp.com (Postfix) with ESMTPS id 7E5A0140275;
	Tue, 22 Jul 2025 09:47:25 +0800 (CST)
Received: from [10.174.187.148] (10.174.187.148) by
 kwepemg500011.china.huawei.com (7.202.181.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 22 Jul 2025 09:47:24 +0800
Message-ID: <23839205-32fc-dd44-421d-1c1728af725d@huawei.com>
Date: Tue, 22 Jul 2025 09:47:24 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
To: <linux-raid@vger.kernel.org>, <yukuai@kernel.org>
CC: <yangyun50@huawei.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH] mdadm: modify the variable used in the set_bitmap_value()
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemg500011.china.huawei.com (7.202.181.72)

The function set_bitmap_value() argument is val, and optarg is a global variable.
To ensure the function's independence, modify optarg to val.

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 mdadm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdadm.c b/mdadm.c
index 50d39f67..142d2873 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -46,7 +46,7 @@ static mdadm_status_t set_bitmap_value(struct shape *s, struct context *c, char
 		return MDADM_STATUS_ERROR;
 	}

-	if (strcmp(optarg, STR_COMMON_NONE) == 0) {
+	if (strcmp(val, STR_COMMON_NONE) == 0) {
 		s->btype = BitmapNone;
 		return MDADM_STATUS_SUCCESS;
 	}
-- 
2.45.2
