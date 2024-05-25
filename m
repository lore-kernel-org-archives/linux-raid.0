Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C219C2D057;
	Sat, 25 May 2024 11:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716634803; cv=none; b=cjtfLmZ/8VPuPxwdnseSDtdtU7TliOIAR96kui0y8MMijnjsEhexFtcbhaFS2q6PCn74dG14I605LBdcbkRsyee6HkvCKqLRmPCo7dnXOgIIDb/KIKalqEWfFPgIYmTTD3tuojiqz3hxKGJtmd7cNtrXBJSNQve2vZ+aBRubQ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716634803; c=relaxed/simple;
	bh=7dl2Bh8LAmoOVP7rl0gg3sxEmnfsUoeNDDLEpztPm90=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=P4jxuVN29IqlK1flZ+8pGRRUc+RhSk/T14TAUoa5K2YwWyh2zlIlZLb3EC15HxMDSBoGduUT0yz3iCnAJYI8KS2Uk6XEw/a1VooDl2TooWZ7lwzbZSdtlhr++6RTgSB+NtfvLrQr4LKkPk0RZ7F2gKlKnoj0zBWJLS3ujKfq/yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vmf7M1N14z4f3jM1;
	Sat, 25 May 2024 18:59:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 4AE481A06D6;
	Sat, 25 May 2024 18:59:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgBHZQ6mxFFm87GJNg--.25077S4;
	Sat, 25 May 2024 18:59:52 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yi.zhang@huawei.com,
	houtao1@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 0/2] md: flush deadlock bugfix
Date: Sun, 26 May 2024 02:52:55 +0800
Message-Id: <20240525185257.3896201-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHZQ6mxFFm87GJNg--.25077S4
X-Coremail-Antispam: 1UD129KBjvdXoW7GFWfAFyDCw4rtw4kJFWkZwb_yoWxuFg_Ga
	4qqFyft3sag3Z7AFy5XF1xZr98tF48Wrn7JF13trW5Zry3Zr1rWr1Uu3yrZw18ZFWUuFn5
	Jr1DJr9a9r4FqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M280x2IEY4vEnII2IxkI6r1a6r45M28lY4IEw2IIxx
	k0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4
	vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8I
	j28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr
	4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxG
	rwACjI8F5VA0II8E6IAqYI8I648v4I1lw4CEc2x0rVAKj4xxMxAIw28IcxkI7VAKI48JMx
	C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
	wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
	vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v2
	0xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjTRuMKZUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

I recently identified a flush deadlock issue, which can be resolved
by this patch set. After testing for a day in an environment where the
problem can be easily reproduced, I did not encounter the issue again.

Before a complete overwrite of the md flush, first fix the issue with
this patch set.

Li Nan (2):
  md: change the return value type of md_write_start to void
  md: fix deadlock between mddev_suspend and flush bio

 drivers/md/md.h     |  2 +-
 drivers/md/md.c     | 40 +++++++++++++++++++---------------------
 drivers/md/raid1.c  |  3 +--
 drivers/md/raid10.c |  3 +--
 drivers/md/raid5.c  |  3 +--
 5 files changed, 23 insertions(+), 28 deletions(-)

-- 
2.39.2

