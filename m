Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDCE2DF710;
	Mon, 27 Oct 2025 07:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761550634; cv=none; b=Q5CooUIg4y8j8sZtm9Zkfr7drqy86Q8S2o87vBbY/xqnYUn8BMBHiHLZygPk8yvl+UKgbjA5494i5AmuK5KXZTWpyhcj/VAQJjNbDrpiOkdK7p7Yb8hk1L8xb9TN+fvgIw2ghzpLpjFsjhplZmbWKtYF1N6PlsCyi99hv7ukmFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761550634; c=relaxed/simple;
	bh=tw7WnEht10HqcA5XXRhw7X4XHmD61BOQ6F3hTuuWDT4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UySK8EVTPK06QYsvzgR1qvDgIMFlZjIbAaHxojWmqZ9cj70sSiPlNkg4gsgh4kLNR+tkciSAFo49HCVX7ch8HyqX2jOS1kratcrP6qNklTW3iamhE1GiDqUvWb1jx501m+F3KurxvyfZ2vwF+9B19au4PXO/pm190zndLiieQeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=AbMP9KuK; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="AbMP9KuK"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Veqlajx9hcX/caaFx5LjXLvLPmhYovUz7QjCrks7n5E=;
	b=AbMP9KuKtdxhfbRct2piViGDvVvWJ3bY2uxjcRV+WwQlUTQ5vWox08kki7E8VkVLEDbS3RrCV
	RBR4m8IxCZLuLgWGaWXRcScTDIwALzzS9s1JKufmLajGzyKa0cWEbKOQTdLO8aSDtTsKqIH4ucH
	TKGUqshEArWLIqHxVmABnXQ=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cw5100WHYzKm9W;
	Mon, 27 Oct 2025 15:36:36 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 8C7D71A0188;
	Mon, 27 Oct 2025 15:37:03 +0800 (CST)
Received: from kwepemn500011.china.huawei.com (7.202.194.152) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 27 Oct 2025 15:37:03 +0800
Received: from huawei.com (10.50.87.129) by kwepemn500011.china.huawei.com
 (7.202.194.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 27 Oct
 2025 15:37:02 +0800
From: <linan122@huawei.com>
To: <corbet@lwn.net>, <song@kernel.org>, <yukuai@fnnas.com>,
	<linan122@huawei.com>, <hare@suse.de>, <xni@redhat.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <linan666@huaweicloud.com>,
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v7 0/4] make logical block size configurable
Date: Mon, 27 Oct 2025 15:29:11 +0800
Message-ID: <20251027072915.3014463-1-linan122@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemn500011.china.huawei.com (7.202.194.152)

From: Li Nan <linan122@huawei.com>

Resent to cc Kuai's new email.

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

