Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E1A1925AD
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 08:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730967444; cv=none; b=TuBSu/c1jYu0xYDzuxD5181Zm6+xuGcjiatQG+YtK5hKRoHZBOSfGr8vyF9wB3pize/oX8Uk5aiumDuPjH+MZkS/a/MMOqei25s8Zc//O+ub1TKMsI+Y+N8zORmLBZhPkMnhpZX9lFmGk72hSRt8Qk8cSSRxbWVwg6N0npW95+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730967444; c=relaxed/simple;
	bh=2VySxcs1BFzi6eLYEurZ01ZlmtUAVA5UCfjnX4OQgbk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ED79ecZKTLOoc9Hw4faJmXTJZZGGyyatS5CgL6Pfnv7W7WiRYhBJp2d1efEYHlvNWZ5lW1gcoAvq9Kk3efTQEEikw/XHq/FLyc7NcAO8H9Qg0X3Wtg9Bp7In67xFLlK+xpKna9n46lM4mMu5zxlTbv0KqfQNIOIC04SsmxX1L9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XkZg55Zclz4f3lXc
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 16:17:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AADB41A018D
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 16:17:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHI4eMdyxnL91fBA--.3434S4;
	Thu, 07 Nov 2024 16:17:18 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH mdadm/master v2 0/4] remove bitmap file support and reserve major number for lockless bitmap
Date: Thu,  7 Nov 2024 16:13:43 +0800
Message-Id: <20241107081347.1947132-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHI4eMdyxnL91fBA--.3434S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Xr13Wr4fZry7KFy3Gr1xZrb_yoWxKrgEyF
	yDAFWrJFW7XFy5JFy7Jr4DZ34UJr4jyr1DtF1ktFW8Jr17Jr17Jr1UAr4jqry5Zr43Gr17
	JryUGr48Jr10vjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbokYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Yu Kuai (4):
  tests/04update-uuid: remove bitmap file test
  tests/05r1-re-add-nosuper: remove bitmap file test
  mdadm: remove bitmap file support
  mdadm: add support for new lockless bitmap

 Assemble.c                | 33 +-------------
 Build.c                   | 35 +--------------
 Create.c                  | 40 ++++-------------
 Grow.c                    | 95 +++++----------------------------------
 Incremental.c             | 37 +--------------
 bitmap.c                  | 44 +++++++++---------
 bitmap.h                  |  1 +
 config.c                  | 17 ++++---
 mdadm.c                   | 83 ++++++++++++++++------------------
 mdadm.h                   | 19 +++++---
 tests/04update-uuid       | 34 --------------
 tests/05r1-re-add-nosuper |  5 +--
 12 files changed, 112 insertions(+), 331 deletions(-)

-- 
2.39.2

