Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADE33B7769;
	Mon, 21 Sep 2026 07:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975426; cv=none; b=afR4NIkDojKYVCLCDNibDGr8Kc+Z5UcCddqL61RnCbVTMkyY4XeSXnkesC52j1zKweotBBbw6OBVPEp/Bob2nkSMl0ka9fugxdkdJXmKHv0BmE31IaZuJODaXzD4piFkcXutqaHSkomUfjt0OjVVYd4J0HEQv9rV+z3QqMx+uy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975426; c=relaxed/simple;
	bh=2IeiAtviJVOScjys9wMB10jEZ83IZ70PKF88/Q563ts=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TGaSwgeveDOpVDrQxXF096svCzww3zhP2Nm6YEtH4mVYzq6GpKvoXSBnT1M4ZbCIMvZ6Y/3Bwug8jykHJR1sbk4XxkscHc8bJJvIr4l43TQpQLrhiVb/WORmVLmiEntvg1UCPgHPhQimLQIj4tbGFIemb+uyTO2EesQBRGLLAo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=VmHxVjas; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="VmHxVjas"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XEDgATaedwWWfZwNDoZgC9IjsQAV1C6R17+WXlc80kk=;
	b=VmHxVjasd3JzrOJ1hIHNvzGhrOixjKlpGKEFEIhiPvG4nZssVeQ2WrM/1K6bkBjTAZS869c1Z
	kAwwM1eYCK9/iUSA3GfkXMHt6mC7nqCCKsnBBCNOpzJ41asbYhuMIcMOTp53qGq+H3JPLlhF/Nf
	ihfu6DsJrRFQognbTH53bPo=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hpDv667k8zcbP5;
	Mon, 21 Sep 2026 15:12:18 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 37CB240575;
	Mon, 21 Sep 2026 15:23:39 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200011.china.huawei.com
 (7.152.185.179) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 21 Sep
 2026 15:23:38 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <neil@brown.name>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 0/3] md: Fix three raid5/raid10 bugs
Date: Mon, 21 Sep 2026 15:15:33 +0800
Message-ID: <20260921071537.2902362-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemo200011.china.huawei.com (7.152.185.179)

Fix three raid5/raid10 bugs in error injection case.

Zhihao Cheng (3):
  md/raid5: Hide the origin mddev->thread before takeover
  md/raid5: Don't free conf on raid5_run failure
  md/raid10: Don't free conf on raid10_run failure

 drivers/md/raid10.c | 22 ++++++++++------------
 drivers/md/raid5.c  | 39 ++++++++++++++++++++++++++++-----------
 2 files changed, 38 insertions(+), 23 deletions(-)

-- 
2.52.0

