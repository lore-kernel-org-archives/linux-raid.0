Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596534C6D;
	Tue, 18 Jun 2024 01:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718672886; cv=none; b=LEwkCMfubSPI75JBjh7btHFUL7rgSD9gL6n2z4agqwyrPOqstG0Sne0d5Tbdd4F6m4e05AH1XdIpjHk8I8WwpIc3lYOL7E5ci6cL8ei0WZXohiRRRKfFR+ls2dLkk8cDLC8XgJUE7sVW1tV2929OTdG7DsQHY4u2tBpiQDrTZXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718672886; c=relaxed/simple;
	bh=rjT0EI9etBbL+Y6dXBlrEOgbm8/Qvb0uMTATxY6Fbao=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ai1iXTyY9VlMtwiBz5IWFrMNz/j9Aq1eVuBYww0CXI4A3zErNqqOEurT/pB25nYoNFRbBQ83Nlk7bvSC/R9jHVZzo1GeuNY5bCd5wFKU8dt/bexWRoUK9i0LGC502Zm31SdXnOlH297Rp+G9z+GxU+IBxMhHkY7mZaoe1INn038=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=TqJIZ+7a; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="TqJIZ+7a"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718672882; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=CQ2sGjVCPnJDglJl9677NUUki1SRCCOB/wxAqKRJaes=;
	b=TqJIZ+7aPEidTWsvRiycN3ohuyIJlrWd1z8HdczOmVYk34cAYWnpdTsRIT9Ab9JrI7EUAe273scIO/j3S3TL1iy6eIytT1+pmRmedtJ9gAoKJ2j+3v/AiF4rOYL+Ga/0P+Qj8PrVNr1KxwTLXpfh7cmTElw797h3zgYXB9ztTWo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033022160150;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W8hmqCN_1718672880;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0W8hmqCN_1718672880)
          by smtp.aliyun-inc.com;
          Tue, 18 Jun 2024 09:08:01 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] md: Remove unneeded semicolon
Date: Tue, 18 Jun 2024 09:07:59 +0800
Message-Id: <20240618010759.85416-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

./drivers/md/md.c:630:21-22: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9344
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cf510a68705f..ece807b3f854 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -627,7 +627,7 @@ static void md_submit_flush_data(struct work_struct *ws)
 		 * always is 0, make_request() will not be called here.
 		 */
 		if (WARN_ON_ONCE(!mddev->pers->make_request(mddev, bio)))
-			bio_io_error(bio);;
+			bio_io_error(bio);
 	}
 
 	/* The pair is percpu_ref_get() from md_flush_request() */
-- 
2.20.1.7.g153144c

