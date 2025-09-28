Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C941A9FB6
	for <linux-raid@vger.kernel.org>; Sun, 28 Sep 2025 07:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759043629; cv=none; b=QG6l6SzAIHb0x9bWgsNQSZL3HgNRzpPhfvk2C/mM9mNJHjwLRNPokSzaLDpQLRcB6yNqySf/NyQuMwT4gcLiYIVGte2yBvCxT8Hrd/eg5YdcpdbhpYZ+6rrvsWg1MX2eo2HeBvE6H7Hay2nTevekeVEb/nKWoflQNqb1rVIrRuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759043629; c=relaxed/simple;
	bh=W611Dh2b8wBWgXtRBfN+KBWi1bkIg1eWa+To1V6lgso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HUVxXxjGPlfCAvZsuu/A5SHilemhDObb9jrbV0iOw3CKrhVDph4AV2N7nIZX/RFo0noWt8AhUJUSeCb/SVnA2Skug56ANjrHXoOPEzu11eme/bU+Yi8eq5U5hNBMuRy7jFcAQtdF0aaLsAZQqgWWW51XGVLFJKStFU11TtI+ZNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cZFsf3HVFzKHMRw
	for <linux-raid@vger.kernel.org>; Sun, 28 Sep 2025 15:13:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AAD7A1A1A95
	for <linux-raid@vger.kernel.org>; Sun, 28 Sep 2025 15:13:38 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgDn+GAg4NhojeNVBA--.46519S3;
	Sun, 28 Sep 2025 15:13:38 +0800 (CST)
Message-ID: <035a04da-7663-e9f3-fc05-3b84ec2554e5@huaweicloud.com>
Date: Sun, 28 Sep 2025 15:13:36 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH RFC] md: disable atomic writes if any bad blocks found
To: John Garry <john.g.garry@oracle.com>, song@kernel.org,
 yukuai3@huawei.com, hch@lst.de
Cc: linux-raid@vger.kernel.org, martin.petersen@oracle.com
References: <20250926125825.3015322-1-john.g.garry@oracle.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250926125825.3015322-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDn+GAg4NhojeNVBA--.46519S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tr4rJrW8WryrtF1rKFWUCFg_yoW8JF47pF
	WDG34DCrWqgF1jkF4Du3W0kw4F9ws3AFWftw48CryUua4DW3ZrtFZ2gF9Yva4jvrn3J3s0
	qw45WrykWrZ5Ga7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x07UMnQUUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/26 20:58, John Garry 写道:
> RAID1 and RAID10 personalities support bad blocks management. In handling
> read or writing from a region which has bad blocks, the read and write bio
> is split as to not access the bad block sectors.
> 
> Splitting of writes is not allowed for atomic writes. As such, bad blocks
> are incompatible with atomic writes. If an atomic write ever occurs over
> a region which has bad blocks, then the write is rejected.
> 
> It is not ever expected in practice that we will ever see devices which
> support atomic writes and also require bad block kernel support. However
> it is not proper to say that atomic writes are supported for a device
> which actually has bad blocks.
> 
> md maintains a persistent feature flag to say whether bad block management
> is active on the array, MD_FEATURE_BAD_BLOCKS.
> 

MD_FEATURE_BAD_BLOCKS is not set at RAID creation time. It is set later if
badblocks recorded due to read/write error. Therefore, checking it at
creation time does not work.

If badblocks is disabled, devices that have been recorded badblocks will be
marked Faulty and kicked out of the array, becoming unreadable and
unwritable. That outcome is worse than a single atomic write failing — is
this the expected behavior?

-- 
Thanks,
Nan

