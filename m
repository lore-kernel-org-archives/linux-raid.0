Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938B554857B;
	Tue, 22 Sep 2026 14:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086990; cv=none; b=pywimv+LkBhieddT/lAgM0JjY8cf8jp0Yd3oA98/i2Sr3rUXMK7f9s1GcieCZ9F1/AzMF7ye2qakDsiooWJ6BHsD0T6Ljai5uQy2VX/SMTvDBAYGI6ChSNlNZ+LiPhY9ptEBAicajdv20ljATqYmBG6Lrugh+HYejch/pa2Ycis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086990; c=relaxed/simple;
	bh=kuYW+v5+MrFKqThT4ha6/jHSNBCdzt3JE9ahVmXveEQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lWIFvYNMcLGVE8zdmWnFS0NsybCfvwN6qBnBVSCIUQInDm7nBfZu0omaIRAl6piegAuX2103Q/v2OE14GTft4i2XLyO5q4W5vNKBn0TDFSmxXesJicEeWbxXKxVajmJMAlirbtN5JNjZN+u4pkIRXrhuTbJ5tT0vV9L/nhPpdw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=VRCY9OC9; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="VRCY9OC9"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jxpJXFOnJR5RSW0Oyb+P+nnRutLcn50GIwTNdsXmnuA=;
	b=VRCY9OC9VkhBLHHr6w9q1TDaIBgoi4X6XQe/LHpdy3iYDkhl6Dt4LskX1kr7XGTFzcmAnK1Ca
	hAeUf3ZRR2hKprBX/21H5z6+PDFIV/cHmRD4EfFYdXn04j3lrRsMFtAbTD17XiK+diP+xbPLSBq
	39HotaaP4Jd8g2Z9EVifjmI=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hq27n5kctzRhQs;
	Tue, 22 Sep 2026 22:11:01 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 395384058C;
	Tue, 22 Sep 2026 22:23:03 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200011.china.huawei.com
 (7.152.185.179) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 22 Sep
 2026 22:23:02 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <shli@kernel.org>, <neil@brown.name>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v2 0/4] md: Fix two raid5/raid10 bugs
Date: Tue, 22 Sep 2026 22:14:52 +0800
Message-ID: <20260922141456.738937-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemo200011.china.huawei.com (7.152.185.179)

Fix two raid5/raid10 bugs in error injection case.

v1->v2:
 Handle pers->run failure in level_store

Zhihao Cheng (4):
  md/raid5: Hide the origin mddev->thread before takeover
  md: Handle pers->run failure in level_store
  md/raid5: Don't free conf on raid5_run failure
  md/raid10: Don't free conf on raid10_run failure

 drivers/md/md.c     | 27 ++++++++++++++++++++++++++-
 drivers/md/raid10.c | 22 ++++++++++------------
 drivers/md/raid5.c  | 39 ++++++++++++++++++++++++++++-----------
 3 files changed, 64 insertions(+), 24 deletions(-)

-- 
2.52.0

