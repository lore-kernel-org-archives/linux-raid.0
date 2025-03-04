Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3771F4604
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 06:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741068733; cv=none; b=n31mQ4UAQ0FYodkPJ1e9KwjAspRZWFDaPsGNNdeUivfo/SUBf2uqE9PFjzIFiuq059AiqWi5jwsj826r/g8/MWKy+X1bS8csnZ5kF1U3Gbj8zSoDDwqE8gTFJ1Qt6HdUyMlfq9v5Dt7y2F2+5+e006N+5fIFY4wldLoe624v6ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741068733; c=relaxed/simple;
	bh=dXFNw1ASZ/4ZWW07aaY2W1FN9ycd3q60hJuYtHjafHo=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=GySdtGRrAUaDP7d9cu2YWVeyI1SN5Kr8ToI2yyRr8gc4UrseTWW09y1Ul53ZJ3av/d3d6qIit6Fp2ie7+774LJEb/tPHH6qCGn5XYPyP/ajhotAGIRWEyjJT38JL7x87ze/nH+HRjazXBfjrWNO6loXSWcfBeDT06g+WKB1olBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Z6QG31f7Gz2DjfY;
	Tue,  4 Mar 2025 14:07:55 +0800 (CST)
Received: from kwepemg500011.china.huawei.com (unknown [7.202.181.72])
	by mail.maildlp.com (Postfix) with ESMTPS id 5A6DC18001B;
	Tue,  4 Mar 2025 14:12:06 +0800 (CST)
Received: from [10.174.177.167] (10.174.177.167) by
 kwepemg500011.china.huawei.com (7.202.181.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Mar 2025 14:12:05 +0800
Message-ID: <d78cbb12-9a9c-7965-db9a-70b4b277f908@huawei.com>
Date: Tue, 4 Mar 2025 14:12:04 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
CC: <ncroxon@redhat.com>, <linux-raid@vger.kernel.org>, <liubo254@huawei.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH] mdadm: Don't set bad_blocks flag when initializing metadata
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemg500011.china.huawei.com (7.202.181.72)

When testing the raid1, I found that adding disk to raid1 fails.
Here's how to reproduce it:

	1. modprobe brd rd_nr=3 rd_size=524288
	2. mdadm -Cv /dev/md0 -l1 -n2 -e1.0 /dev/ram0 /dev/ram1

	3. mdadm /dev/md0 -f /dev/ram0
	4. mdadm /dev/md0 -r /dev/ram0

	5. echo "10000 100" > /sys/block/md0/md/dev-ram1/bad_blocks
	6. echo "write_error" > /sys/block/md0/md/dev-ram1/state

	7. mkfs.xfs /dev/md0
	8. mdadm --examine-badblocks /dev/ram1  # Bad block records can be seen
	   Bad-blocks on /dev/ram1:
	               10000 for 100 sectors

	9. mdadm /dev/md0 -a /dev/ram2
	   mdadm: add new device failed for /dev/ram2 as 2: Invalid argument

When adding a disk to a RAID1 array, the metadata is read from the existing
member disks for synchronization. However, only the bad_blocks flag are copied,
the bad_blocks records are not copied, so the bad_blocks records are all zeros.
The kernel function super_1_load() detects bad_blocks flag and reads the
bad_blocks record, then sets the bad block using badblocks_set().

After the kernel commit 1726c7746("badblocks: improve badblocks_set() for
multiple ranges handling"), if the length of a bad_blocks record is 0, it will
return a failure. Therefore the device addition will fail.

So, don't set the bad_blocks flag when initializing the metadata, kernel can
handle it.

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
---
 super1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/super1.c b/super1.c
index fe3c4c64..03578e5b 100644
--- a/super1.c
+++ b/super1.c
@@ -2139,6 +2139,9 @@ static int write_init_super1(struct supertype *st)
 		if (raid0_need_layout)
 			sb->feature_map |= __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);

+		if (sb->feature_map & MD_FEATURE_BAD_BLOCKS)
+			sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
+
 		sb->sb_csum = calc_sb_1_csum(sb);
 		rv = store_super1(st, di->fd);

-- 
2.45.2

