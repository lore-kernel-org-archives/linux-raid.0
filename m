Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BB349E5DC;
	Wed, 23 Sep 2026 11:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790163023; cv=none; b=qepsuvlLqwNUDPKIeZCsK+/aV5HkqZeOMzCUu3X0omCM5oqlr5qcnX1C8T7H2kiTP9ZbfpJA6qiaz4n8rIhTb4MsVHXTAA7cYq6kXtasLHcIrkGHH/BhxzMvYQD7IKd5IqWp3cpvubDINVbj2v1dDk24mldsQCxQkIcDz0OHWi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790163023; c=relaxed/simple;
	bh=nfxT/kp9OqY+fVwhfAedYeGKscZDGmU72il7hEm8qDA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ltGMEm+IPLn0F98KFvRhsF9/81kAmrlwB9sf/FFTPbUHcFBT7MCRQh6MW70qS3gNl5FHopg4bZ0EiMVwuAXDcytF8FFq8IW++PEXGMil5DGv70CncSEID8AEzP6GjvDYBA46maK/uZpxxi7cj+SVjbuzi49PDOwW/Rack3pEJj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=MqyUEkoS; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="MqyUEkoS"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7znhjJwFSioVpfSs+gFzAxzxqWM6d2MLE9U5F19qE5w=;
	b=MqyUEkoSThhhRdSMSOIzEKY+xz9QosGM75MvOAy7gmS6T3QysON7DWi9qwuBh1gU9emkCbZy0
	ZrRq4OcLw8t3ZTVkIws0sVmfr6WOIzfdo2l2T7D43g9iAhiLmR+jIBjqW0snRtMqh4C7LVnizXv
	JBKwqTmWyinHn3QrcbZdl9s=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hqZFk3xBVzLlSh;
	Wed, 23 Sep 2026 19:18:02 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 01A1840578;
	Wed, 23 Sep 2026 19:30:08 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200011.china.huawei.com
 (7.152.185.179) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 23 Sep
 2026 19:30:06 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <shli@kernel.org>, <neil@brown.name>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v3 0/4] md: Fix two raid5/raid10 bugs
Date: Wed, 23 Sep 2026 19:21:54 +0800
Message-ID: <20260923112159.94175-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemo200011.china.huawei.com (7.152.185.179)

Fix two raid5/raid10 bugs in error injection case.

v1->v2:
 Handle pers->run failure in level_store
v2->v3:
 Patch 2: Release sysfs group in 'pers->run' error handling path

Zhihao Cheng (4):
  md/raid5: Hide the origin mddev->thread before takeover
  md: Handle pers->run failure in level_store
  md/raid5: Don't free conf on raid5_run failure
  md/raid10: Don't free conf on raid10_run failure

 drivers/md/md.c     | 29 ++++++++++++++++++++++++++++-
 drivers/md/raid10.c | 22 ++++++++++------------
 drivers/md/raid5.c  | 39 ++++++++++++++++++++++++++++-----------
 3 files changed, 66 insertions(+), 24 deletions(-)

-- 
2.52.0

