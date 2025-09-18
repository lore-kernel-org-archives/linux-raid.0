Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08982C15BA;
	Thu, 18 Sep 2025 12:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758197280; cv=none; b=cgTmrEJzBq5EdbzYEEmanPuM1jZf81oan9ifqr2YsmqKq9OIs046mNE+7wrT04gcpAI51E0UzRuNvzKD502lfRPCMltIRZMSdmRyluqw5hlX9V6T+70cJnEEirODntJ3GPYmZRP8lrYfp7z9L4Ntc8xb1zkS09uBxKYJwk+sXhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758197280; c=relaxed/simple;
	bh=UutQBfXZXPXxyLjn8faVqz4W+WjVmJpu8sFRgE1XbHk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sRDUaUIdP1c2u9o2/px38VrXNVUeU+LN4fu0GrQ7q/Y00liSBw602ZRG4Re/E+3R3bIs2YJSNhyL0HXMcmUs+i6KUxBYUaV6bWLlzhqm0vCZXMkebcmVfLQd54BqkhT48HQOZsR1CA6eyzh+r9Rveg4DnCprcc370Qf6zCc+GTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cSDt36tRzzYQvhv;
	Thu, 18 Sep 2025 20:07:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 926E51A0BC3;
	Thu, 18 Sep 2025 20:07:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgA3+mEY9sto5eMAAA--.164S4;
	Thu, 18 Sep 2025 20:07:54 +0800 (CST)
From: linan666@huaweicloud.com
To: corbet@lwn.net,
	song@kernel.org,
	yukuai3@huawei.com,
	linan122@huawei.com,
	hare@suse.de,
	xni@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	martin.petersen@oracle.com,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v5 0/2] make logical block size configurable
Date: Thu, 18 Sep 2025 19:57:57 +0800
Message-Id: <20250918115759.334067-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3+mEY9sto5eMAAA--.164S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr4xCr4xuFy8uF4UZr4fZrb_yoWDZFbE9a
	yxXrZ3Kr1IgF4xZay5urs3AFWjkF48u34vvF43Kr4a934avr18GFWv9r98Jw1kGFy2qF1U
	Gr1Ut3y8Ar4DWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbDxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
	rcIFxwACI402YVCY1x02628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw
	0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYWrWUUUU
	U
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

v5: in patch2:
    Fix typo. Add reproducer in log.

v4:
 patch 1: add fix tag.
 patch 2:
 - add documentation for sysfs.
 - only support metadata format 1.x.
 - do not call md_update_sb when writing sysfs. mddev->pers is NULL here.
 - return directly before hold lock in lbs_store.

v3:
 - logical_block_size must not exceed PAGE_SIZE for bio device.
 - Assign lim to mddev rather than to gendisk in mddev_stack_rdev_limits().
 - Remove the patch that modifies the return value.

v2: No new exported interfaces are introduced.

Li Nan (2):
  md: prevent adding disks with larger logical_block_size to active
    arrays
  md: allow configuring logical block size

 Documentation/admin-guide/md.rst |  7 +++
 drivers/md/md.h                  |  1 +
 include/uapi/linux/raid/md_p.h   |  3 +-
 drivers/md/md-linear.c           |  1 +
 drivers/md/md.c                  | 82 ++++++++++++++++++++++++++++++++
 drivers/md/raid0.c               |  1 +
 drivers/md/raid1.c               |  1 +
 drivers/md/raid10.c              |  1 +
 drivers/md/raid5.c               |  1 +
 9 files changed, 97 insertions(+), 1 deletion(-)

-- 
2.39.2

