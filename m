Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088D0224B1F;
	Wed, 15 Oct 2025 08:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760515864; cv=none; b=dZRo2L/NbxU6LwduWVoDAU7oUSES4T/RYSlOoUDjRLbJ5Fmjb8efSx6GrVuCFHuBFtbgU/glDB2qzQUkvNJ8PgJd2+J1WbBNhG9FQnfOtbWSIMgYHA0DKaCF3LLZNzV77yxhUdKeK+2PMVddoR/uc6oGdhn24AtX2dlfBg13rFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760515864; c=relaxed/simple;
	bh=Cz0QAQDRMXr5TPxLZtu/5pZYWl/RX/8g2S3tIWM3lKE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j55LmgeRnjEzzPoa6z/u6eu6z11JbhbJ4dQ7BIZuxsp1pUFexrzofe+YVLgIeSEWFg/uu6f30dVPqfHpbNzrwiJMGXugllbh17AZtg8W7hzExnWcKr971qwGozucH34/eR96p6ijtd7GQcsJTJAsNNpzpxltGEQr4LZM1DUxATE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=myO7X/sI; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="myO7X/sI"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OfMvrlC6OBN0gcP3E9vB1YqFdp5QboXs6/S49Edpn0U=;
	b=myO7X/sI1oZ0gvf0C4rWrOHsQsYSYAII/ehCiVwKyJcLZlJH6aHPv40scbdPnLRxH4kPDwoUZ
	pv5wwx6Jb/KS5nqEiGy/z+H6Nvc9xp688jRWdemSKWy8HCLqeaYjnPb0gQBnXojEpTm6e+jsf9t
	MYup/gKCNbO0TOghe46vkXE=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4cmkKp6NLXz1K97v;
	Wed, 15 Oct 2025 16:10:38 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 76BAF1A016C;
	Wed, 15 Oct 2025 16:10:58 +0800 (CST)
Received: from kwepemn500011.china.huawei.com (7.202.194.152) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Oct 2025 16:10:58 +0800
Received: from huawei.com (10.50.87.129) by kwepemn500011.china.huawei.com
 (7.202.194.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 15 Oct
 2025 16:10:57 +0800
From: <linan122@huawei.com>
To: <corbet@lwn.net>, <song@kernel.org>, <yukuai3@huawei.com>,
	<linan122@huawei.com>, <xni@redhat.com>, <hare@suse.de>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <martin.petersen@oracle.com>,
	<linan666@huaweicloud.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH -next v7 0/4] make logical block size configurable
Date: Wed, 15 Oct 2025 16:03:50 +0800
Message-ID: <20251015080354.3398457-1-linan122@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemn500011.china.huawei.com (7.202.194.152)

From: Li Nan <linan122@huawei.com>

v7:
 - Add three prerequisite patch to fix some config lbs related issues
 - Update sb when lbs configuration is done
 - This feature should support raid0, update documentation accordingly

Li Nan (4):
  md: delete md_redundancy_group when array is becoming inactive
  md: init bioset in mddev_init
  md/raid0: Move queue limit setup before r0conf initialization
  md: allow configuring logical block size

 Documentation/admin-guide/md.rst |   7 ++
 drivers/md/md.h                  |   1 +
 include/uapi/linux/raid/md_p.h   |   3 +-
 drivers/md/md-linear.c           |   1 +
 drivers/md/md.c                  | 154 +++++++++++++++++++++++--------
 drivers/md/raid0.c               |  14 +--
 drivers/md/raid1.c               |   1 +
 drivers/md/raid10.c              |   1 +
 drivers/md/raid5.c               |   1 +
 9 files changed, 140 insertions(+), 43 deletions(-)

-- 
2.39.2

