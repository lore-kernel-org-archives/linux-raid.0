Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD632101B0
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 13:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730984789; cv=none; b=bhAJquKl3ozeutkjcnzSqfqdt0+oVc1xNSXFfrybAvsJAVghmwuzQ6fnkiM5UY8zJfRuk8kIwgrMKFPyD1g7WAjrIWjv2oc/kakGp+/lrk5t7ohmxmz1m/ch4fMaH1VjGvV6mEP03GThv4tSlS+Sm0/zdwBDykWNe3ypLmqSbeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730984789; c=relaxed/simple;
	bh=f1huip4EYxIskBPhbTgBSGXxiRcysyYrVJPnmY9RvPA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fUg89Udxr2ouu4lJRAfYyVxGNEMEWNqdtqSQJvXpBtdkGQGFmhA0pxi/WTXRGUiK0/WHr4fR9IBXV0QP99Jhuj10RFpQM6EH4h62UPT0sDsilzoOCWCl/EnvLrsrN9BudOp5KPlHDIt1XwjAladBrRFGVVBEDiiFCoiMRviO99E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xkj4Y3Dnlz4f3nJY
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 21:06:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 55FBC1A0568
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 21:06:24 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnzoJPuyxnnCtzBA--.58960S4;
	Thu, 07 Nov 2024 21:06:24 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v3 0/3] mdadm: remove bitmap file support
Date: Thu,  7 Nov 2024 21:02:50 +0800
Message-Id: <20241107130253.315551-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnzoJPuyxnnCtzBA--.58960S4
X-Coremail-Antispam: 1UD129KBjvdXoW7XFy8JFWrCFy5KF4DXr4DXFb_yoWxtFX_JF
	yDAFWrJFW7XFy5AFy7Jr1DZ34UXr4jyr1DJF1ktFWUJr17Jr1UGr4UAr4jqry5Xr43Gr17
	JryUJr48Jr10yjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUboxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnI
	WIevJa73UjIFyTuYvjxUwmhFDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes in v3:
 - fix that wrong patch is removed from v2;

Yu Kuai (3):
  tests/04update-uuid: remove bitmap file test
  tests/05r1-re-add-nosuper: remove bitmap file test
  mdadm: remove bitmap file support

 Assemble.c                | 33 +-------------
 Build.c                   | 35 +--------------
 Create.c                  | 39 +++-------------
 Grow.c                    | 94 +++++----------------------------------
 Incremental.c             | 37 +--------------
 bitmap.c                  | 44 +++++++++---------
 config.c                  | 17 ++++---
 mdadm.c                   | 76 +++++++++++++------------------
 mdadm.h                   | 18 +++++---
 tests/04update-uuid       | 34 --------------
 tests/05r1-re-add-nosuper |  5 +--
 11 files changed, 100 insertions(+), 332 deletions(-)

-- 
2.39.2

