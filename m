Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233301586CD;
	Fri, 30 Aug 2024 07:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725002921; cv=none; b=XJIBNZ2anFqCpBvw91Qn1uNhTa5RF0/hwd+wQHKrLpUblztdFw6yYoLh6FN2n3v1qJvcRA5ALjJEZlX8qc0voYNmBVuhlAEA/f4XUVtaby0iqBqrE3NuDrwiNEvymKgiwPOm/+ZB/Q2N0ARUwaPCFBClzswJrx/7/RBAOJOBmAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725002921; c=relaxed/simple;
	bh=C2XbD7UCV3dLEwUkE9B8HkZu1UETNiUlfpNP4DFVeh4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sVdOix1DTPzmDjQkxsxwPV68AyNaly0Tm13bq9P93cH9l6dxte3dAClyXIWuWxoJlwiqnbwLON44Md3CJqB61dmJwxdjyZzXPXADFmx3xybIDUTGSI+QGOCAnFT+So+8GaQZ85WwZk/KucIQs/KUZ8Sh52KcnmALmawJig4QDVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Ww8rn66Dnz4f3jkv;
	Fri, 30 Aug 2024 15:28:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E09A41A07B6;
	Fri, 30 Aug 2024 15:28:35 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHL4WhdNFmxAd_DA--.47391S4;
	Fri, 30 Aug 2024 15:28:35 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@intel.com,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 0/7] md: enhance faulty chekcing for blocked handling
Date: Fri, 30 Aug 2024 15:27:14 +0800
Message-Id: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHL4WhdNFmxAd_DA--.47391S4
X-Coremail-Antispam: 1UD129KBjvJXoWrtF48Kr1fGr4fAr4UXF4xWFg_yoW8JF4rpw
	sIga43Zr1UWr13X3ZxZF4UGryrWw18JFW3ArsrKw18W3yUZryxJa1kJ3WrWryYgryavws0
	qF15GrZ3WFy5Ca7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYCJmUU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The lifetime of badblocks:

- IO error, and decide to record badblocks, and record sb_flags;
- write IO found rdev has badblocks and not yet acknowledged, then this
IO is blocked;
- daemon found sb_flags is set, update superblock and flush badblocks;
- write IO continue;

Main idea is that badblocks will be set in memory fist, before badblocks
are acknowledged, new write request must be blocked to prevent reading
old data after power failure, and this behaviour is not necessary if rdev
is faulty in the first place.

Yu Kuai (7):
  md: add a new helper rdev_blocked()
  md: don't wait faulty rdev in md_wait_for_blocked_rdev()
  md: don't record new badblocks for faulty rdev
  md/raid1: factor out helper to handle blocked rdev from
    raid1_write_request()
  md/raid1: don't wait for Faulty rdev in wait_blocked_rdev()
  md/raid10: don't wait for Faulty rdev in wait_blocked_rdev()
  md/raid5: don't set Faulty rdev for blocked_rdev

 drivers/md/md.c     |  8 +++--
 drivers/md/md.h     | 24 +++++++++++++++
 drivers/md/raid1.c  | 75 +++++++++++++++++++++++----------------------
 drivers/md/raid10.c | 40 +++++++++++-------------
 drivers/md/raid5.c  | 13 ++++----
 5 files changed, 92 insertions(+), 68 deletions(-)

-- 
2.39.2

