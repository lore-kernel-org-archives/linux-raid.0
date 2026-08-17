Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415A6311C2D;
	Mon, 17 Aug 2026 03:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786937997; cv=none; b=pTwIuIfJq4Lwh8wZuxN0Yb4YIABhzA0Bbbm2pCuUg4F+q6+edf4Nl2gk0uhN4muar9xPwvf1IqyJJcbRhUgEiLiBckqV5i0kjjNVh78UMPFkIi+yb7spqKREV+9R1sOqVhFt7RENGuFe0c6gzOZOOSe2SRyfX+rlSkEKevUdrPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786937997; c=relaxed/simple;
	bh=CtTx/sk1AKsAsQrolQe9VoteOh5+pUp5tejA6+5DBoU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=i/Xjmci5egbKcBQIOBLcvhbcnRzEHeMAJprwog4XEQuiBOiGBggBIDZqhJPMR4L3fFYF3gcscI+oamgCFYOKySXRPJALhDbQKXt4W1N/o2+cFVGyxcw3BOkRoJDsFOjw9o+4dZyrI2oIkVmeztiRsqwu9hcmgci6niOt3gNuYec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=RZIZ1CQO; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="RZIZ1CQO"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6tblXp9JuzxssIoDCqUqifNBsAm9lceEkfnQ93pNBKk=;
	b=RZIZ1CQO9+0Z5C6jNWLRQwjuJOwsJ6SZyUx49tUe6+uuqWpa/MfagmCZN4fGR7rKwmH1mg8UG
	Um7qm4EZcVih3zCHcbbpUGZwDYnbPZ0BsPXVFislTp+KF9ktRAufvl2rsVDqQ3F6wscjucOICVX
	I4hRntIv1moDTEYDCPMyy7s=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hNdbg2F3Rz1prKd;
	Mon, 17 Aug 2026 11:29:03 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 493B040561;
	Mon, 17 Aug 2026 11:39:45 +0800 (CST)
Received: from localhost.localdomain (10.50.85.155) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 17 Aug 2026 11:39:44 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <magiclinan@didiglobal.com>,
	<xiao@kernel.org>, <linux-raid@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>,
	<chengzhihao1@huawei.com>, <wozizhi@huawei.com>
Subject: [PATCH V2 0/2] md/raid10: annotate lockless access and fix hungtask
Date: Mon, 17 Aug 2026 11:33:38 +0800
Message-ID: <20260817033340.418119-1-wozizhi@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf100017.china.huawei.com (7.202.181.16)

Patch 1 annotates the lockless access to conf->array_freeze_pending with
READ_ONCE()/WRITE_ONCE(). No functional change.

Patch 2 fixes a hungtask in raid10.

Changes in v2:
- Add patch 1 to annotate the lockless reads of conf->array_freeze_pending
  with READ_ONCE(), paried with WRITE_ONCE() on the write side.
- Use READ_ONCE() when reading conf->array_freeze_pending in patch 2.

v1:
https://lore.kernel.org/all/20260810135521.3470422-1-wozizhi@huaweicloud.com/

Zizhi Wo (2):
  md/raid10: annotate lockless access to array_freeze_pending
  md/raid10: fix missing wakeup in wait_barrier_nolock

 drivers/md/raid10.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.52.0

