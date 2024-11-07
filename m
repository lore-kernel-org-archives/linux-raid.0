Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294BF1DBB37
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 13:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730984537; cv=none; b=BWw6c9XdG6BmzdYX8KPtV8vKzBESnykYrSHJ812jy5MJ5zaZ8+AY7FcfVE/SuDwSURQpoZoGP+CHIvuLIZr21kb08kC/s1IiJp8xwI6r1S8FOnbWkGO+mf8sQmQimEZeRGjcmdz/UlLMFIhzfB2kghawMZeVCJGH44a/F+8Z9to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730984537; c=relaxed/simple;
	bh=6OAPAwXpJNuzR7i4HwtX5sHeRowYoU6zOR9eErFwNGk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QFpfVQDqKnP4RkFoKgCHIPkKiMnWn8uoS3BVBA/yUzvbSl/6/5V44cDkh3H9g2ap+r1I/NZ5ARsVCJBLh4q1cpRlznA8VTS5E38+vBiFIF5kBEpvf+PtWEe8DzQMVFD8UOGIvHJp8DagIxnsM/JPueLfpA66GNO98zo/PbadiK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xkhzh4dKFz4f3p0p
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 21:01:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 867DF1A0359
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 21:02:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCXc4dRuixnj+RyBA--.6466S4;
	Thu, 07 Nov 2024 21:02:11 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH V2 0/3] mdadm: remove bitmap file support
Date: Thu,  7 Nov 2024 20:58:36 +0800
Message-Id: <20241107125839.310633-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXc4dRuixnj+RyBA--.6466S4
X-Coremail-Antispam: 1UD129KBjvdXoWrZF1UuryrGr17uF1UGF1fXrb_yoWxArg_tF
	y8CFWrJFW7XFy5AFy7Jr4DZ34rAr4jyw1UJFyktFW8Jr17Jr17JF1UAr4jqry5Zr47Cr17
	AryUJr48Jr18ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUboxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnI
	WIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes in v2:
 - remove patch 4;

Yu Kuai (3):
  tests/05r1-re-add-nosuper: remove bitmap file test
  mdadm: remove bitmap file support
  mdadm: add support for new lockless bitmap

 Assemble.c                | 33 +-------------
 Build.c                   | 35 +--------------
 Create.c                  | 42 ++++-------------
 Grow.c                    | 95 +++++----------------------------------
 Incremental.c             | 37 +--------------
 bitmap.c                  | 44 +++++++++---------
 bitmap.h                  |  1 +
 config.c                  | 17 ++++---
 mdadm.c                   | 83 ++++++++++++++++------------------
 mdadm.h                   | 19 +++++---
 tests/05r1-re-add-nosuper |  5 +--
 11 files changed, 113 insertions(+), 298 deletions(-)

-- 
2.39.2

