Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EB7377545;
	Tue,  3 Feb 2026 06:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770099769; cv=none; b=Q6lKP0PupdzQSliUnqmvo5vK65j+V35BH8NLN87EhrTEYA7IN8DoPFgNxleMz8JnRiYx7raMDlkGovsnZgPO0toIuJQhW0hrPJlVB39Y6PjDVhjy/1Jk0m8n6W0A5N5LcL95q/3KZuLPT2XugM3+TUVRnlO4LB5qkklJt+K8DL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770099769; c=relaxed/simple;
	bh=i6D08jCW9QFm5+HG1/cerZ4z9w1OQX6CnNd8hVfEUew=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HOrlagKC3aMLiCKhAY83f8Orecv8SYTbBUv/Rbj8Rcqr2HiFwfkjKrhll+358hrpR/dQsoVmEMfJb2Chcfpq3dLeLXWzFgu3nXc9YZbkc2cykraUxA74Fr1aVANs31YVL2QaZIJm0jzEZAPFkaCC4LRqCkBYNuO5HsvDvUEjndg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f4tg73t4RzYQts4;
	Tue,  3 Feb 2026 14:21:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 79D3640591;
	Tue,  3 Feb 2026 14:22:42 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBHp_cilIFpIQhbGA--.27054S4;
	Tue, 03 Feb 2026 14:22:41 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com
Cc: xni@redhat.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com
Subject: [RFC v2 0/5] md/raid1: introduce a new sync action to repair badblocks
Date: Tue,  3 Feb 2026 14:12:54 +0800
Message-Id: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHp_cilIFpIQhbGA--.27054S4
X-Coremail-Antispam: 1UD129KBjvJXoWxXrW5tF15WrWxAFyxCF1rZwb_yoW5Zw1rpF
	ZxGa43tryDGrWxCF93Aw48JFyrtrWrJay7tr43Gw1kAa98WFy0vF48tay5XFyDArZaqw1q
	qFs8KFZ7WFWDCFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x02
	62kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s
	026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_
	Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20x
	vEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE
	14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa
	7IUbRVbDUUUUU==
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

Hi,

This is v2 of the series.

# Mechanism
When rectifying badblocks, we issue a single repair write for
the bad range (copy data from a good mirror to the corresponding
LBA on bad mirror). Once the write completes successfully
(bi_status == 0), the LBA range is cleared from the badblocks
table. If the media is still bad for that LBA, a subsequent
read/write will fail again and the range will be marked bad
again.

Doing a read-back for every repair would only prove that the data
is readable at that moment, and it does not provide a stronger
guarantee against future internal remapping.

# Why use LBS granularity for bad-block repair?
In our RAID1 bad-block repair (rectify) testing on a device
reporting 512B logical blocks and 4KiB physical blocks, we
issue 512B I/O directly to the md device and inject an I/O
fault.

Since the md badblocks table can only track failures in terms
of host-visible LBA ranges, it is updated at 512B sector
granularity (i.e., it records the failing sector) and does not
attempt to infer or expand the entry to a 4KiB physical-block
boundary.

Given that the OS has no visibility into the device's internal
mapping from LBAs to physical media (or the FTL), using
logical block size for recording and repairing bad blocks is
the most appropriate choice from a correctness standpoint.

If the underlying media failure is actually larger than 512B,
this is typically reflected by subsequent failures on adjacent
LBAs, at which point the recorded bad range will naturally
grow to cover the affected area.

# Tests
This feature has been tested on a RAID1 built from two 480GB
system disks. It has also been tested under QEMU with a 4-disk
RAID1 setup, with both memory fault injection and I/O fault
injection enabled.

In addition, we will add a new test (26raid1-rectify-badblocks)
in mdadm/tests to verify whether `rectify` can effectively repair
sectors recorded in bad_blocks.

# TODO
rectify currently only supports bad-block repair for the RAID1
level. We will consider extending it to RAID5/10 in follow-up
work.

Changes in v2:
 - Patch 1: Remove non-essential helpers to reduce indirection.
 - Patch 2: Split out a bugfix that was previously included in patch 1.
 - Patch 3: Rename the /proc/mdstat action from "recovery" to "recover"
   to match the naming used by action_store() and action_show().
 - Patch 4: Add a brief comment for MAX_RAID_DISKS.
 - Patch 5: For rectify, reuse handle_sync_write_finished() to handle
   write request completion, removing duplicate completion handling.

Link of v1:
  https://lore.kernel.org/all/20251231070952.1233903-1-zhengqixing@huaweicloud.com/

Zheng Qixing (5):
  md: add helpers for requested sync action
  md: serialize requested sync actions and clear stale request state
  md: rename mdstat action "recovery" to "recover"
  md: introduce MAX_RAID_DISKS macro to replace magic number
  md/raid1: introduce rectify action to repair badblocks

 drivers/md/md.c    | 152 +++++++++++++++++++------
 drivers/md/md.h    |  21 ++++
 drivers/md/raid1.c | 270 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid1.h |   1 +
 4 files changed, 409 insertions(+), 35 deletions(-)

-- 
2.39.2

