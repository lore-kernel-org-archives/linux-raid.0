Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B8E1C695
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 02:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733104927; cv=none; b=oqJHSHYhvTVMPjl1InSSEd8GNkyklcyGnLJ+feU3lNae9WBPnjs9TaLBFTr8f+jTgHOuKQiT/BVsITjb+VA4RlIk1KeZzKpsHFjDKWJMMrrWP33qhOBJF7eKe4TFen0uN9cZOBiJPrjHCpnonlV7pzJ4J3GsPhjFZq0EAmEErPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733104927; c=relaxed/simple;
	bh=YhYQQXdxnHsR4UzKJnAYvvLumbypJ1mZSi7mSKo4pYY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b2xn+RcoIAtslQsooE9E9NijbL1yCXkRh2RI8SFOj6o7CnyGqgTVzdKXxNJN1/KOZruZ5WIqjwBhoC3JPVPu8+x8IMrkfJIq9mtl4JB+IaRGJ2hLddoU7q57cI8vCtByr0l7EOi780j1BUUIKY/RCny0/i34gBByY8hpYGpf+Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Y1n8G3l4Kz4f3jHx
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 10:01:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6DC5B1A018D
	for <linux-raid@vger.kernel.org>; Mon,  2 Dec 2024 10:01:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHo4cQFU1ngWmkDQ--.17049S4;
	Mon, 02 Dec 2024 10:01:54 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v4 mdadm 0/5] mdadm: remove bitmap file support
Date: Mon,  2 Dec 2024 09:59:08 +0800
Message-Id: <20241202015913.3815936-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHo4cQFU1ngWmkDQ--.17049S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtFyfZr1rWw1UZF4UJF4UCFg_yoWDWrcEqF
	yDCFWrJFW7Xa45AFy7Jr4DZry8Ar40yws8JF1DtFWxtr17Xr13Gr4UAr4qqry5ZFW7tr17
	tryUAr4kJr1qyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbo8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVF
	xhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes in v2:
 - remove patch to support lockless bitmap;

Changes in v3:
 - add patch 4;

Changes in v4:
 - add patch 4 to change behaviour if user doesn't set bitmap;
 - add commit message about external metadata for patch 3;

Yu Kuai (5):
  tests/04update-uuid: remove bitmap file test
  tests/05r1-re-add-nosuper: remove bitmap file test
  Manage: forbid re-add to the array without metadata
  mdadm: ask user if bitmap is not set
  mdadm: remove bitmap file support

 Assemble.c                | 33 +-------------
 Build.c                   | 35 +--------------
 Create.c                  | 48 ++------------------
 Grow.c                    | 94 +++++----------------------------------
 Incremental.c             | 37 +--------------
 Manage.c                  | 12 +++++
 bitmap.c                  | 44 +++++++++---------
 config.c                  | 17 ++++---
 mdadm.c                   | 87 ++++++++++++++++++------------------
 mdadm.h                   | 18 +++++---
 tests/04update-uuid       | 34 --------------
 tests/05r1-re-add-nosuper | 32 +++----------
 12 files changed, 126 insertions(+), 365 deletions(-)

-- 
2.39.2

