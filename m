Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A29815820C
	for <linux-raid@vger.kernel.org>; Wed, 20 Nov 2024 06:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732085346; cv=none; b=Y2LAJcWq9hU4C+cs3EnWjmQFg4vaFFV/B81nwsDhX4JWrG/zdylxc1gE32M0sngMI555zksAv8GIXaNYd01gFKDhyIwCYj/S9Id7BMbIltlxHpnhMG85UBosS8F8e24TLUSPqjag7acVl7u6Dw9hWgFkMX8sNER5RbgqH7iKdFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732085346; c=relaxed/simple;
	bh=O1T8DMhSdwHOhBzedjGiHV6K6/TqL0481FR0MXOzHAA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=toUxMFlowi2HchodxiuAm7AuFlqTgup0gHap+rJUSsdKXsdCXA5QBoCm5KRe3VajQk7UDk/Cw2NmNgFFhSP52q3vqg/wqIg9OK1gl/+zwYQEpXKBN+uRLFgkn75NUAhiw87cIfMhrr//rvQ2hPG0tklE6++pH1ZM9tjM4wf0lMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XtX535Ck3z4f3kvP
	for <linux-raid@vger.kernel.org>; Wed, 20 Nov 2024 14:48:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 28B841A0568
	for <linux-raid@vger.kernel.org>; Wed, 20 Nov 2024 14:48:59 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnzoJZhj1nRlQ5CQ--.45081S4;
	Wed, 20 Nov 2024 14:48:59 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v3 0/4] mdadm: remove bitmap file support
Date: Wed, 20 Nov 2024 14:46:33 +0800
Message-Id: <20241120064637.3657385-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnzoJZhj1nRlQ5CQ--.45081S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtFyfZr18ZFWkXF1UCF15urg_yoW3trXEqF
	yDAFZ5JFW7Xa45JFy7Jr1DZa48Ar4jyr1DJF1DtFW7Jr17Jr17Gr4UAr4qqry5ZF43Jr17
	tryUJrW8Jr1jyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbo8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVF
	xhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Changes in v2:
 - remove patch to support lockless bitmap;

Changes in v3:
 - add patch 4;

Yu Kuai (4):
  tests/04update-uuid: remove bitmap file test
  tests/05r1-re-add-nosuper: remove bitmap file test
  mdadm: remove bitmap file support
  Manage: forbid re-add to the array without metadata

 Assemble.c                | 33 +-------------
 Build.c                   | 35 +--------------
 Create.c                  | 39 +++-------------
 Grow.c                    | 94 +++++----------------------------------
 Incremental.c             | 37 +--------------
 Manage.c                  | 12 +++++
 bitmap.c                  | 44 +++++++++---------
 config.c                  | 17 ++++---
 mdadm.c                   | 76 +++++++++++++------------------
 mdadm.h                   | 18 +++++---
 tests/04update-uuid       | 34 --------------
 tests/05r1-re-add-nosuper | 32 +++----------
 12 files changed, 117 insertions(+), 354 deletions(-)

-- 
2.39.2

