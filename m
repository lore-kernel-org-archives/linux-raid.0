Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3142010E3
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 12:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741091193; cv=none; b=MO3ozcuFG0F/tXoool5uHi3GsPQMH+R/x1wGsJdkzClYP6s5GmLaB6EPfnYpvyqhwp0L8cxyMGO/3QDKiPvsuUXAKdigfsPlaTezN6uZ8nmhmhs/XwpycqfzBQQUBrwUjGYU2L+4m0v/XzKqWA8Ch5+sfQg5Z+kDMH3d6herf0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741091193; c=relaxed/simple;
	bh=SK95jhW7ZKAdGxdejFVQYUALO4bIzmRx7g5TXgb4xnQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rzJLKkLDAqdrpgSulPM7ahE4td0LHepd+KAk9HhlfB8XwPRO+GOOhvsUfbMtEXlMJe06KTeF3HNFyT0TdMIxB2F+WdSYToqpPHyUCar2FJM00tN/1HeObWYNNOl++DsZ/cXsKreUVav0HvC9GZ7kN2lSBjyuYmuIROvM9pwfdcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z6ZfT4Gdbz4f3jsv
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 20:26:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 552401A06D7
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 20:26:26 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP1 (Coremail) with SMTP id cCh0CgAHbHxw8cZn5qvKFQ--.55471S3;
	Tue, 04 Mar 2025 20:26:26 +0800 (CST)
Subject: Re: [PATCH] mdadm: Don't set bad_blocks flag when initializing
 metadata
To: Wu Guanghao <wuguanghao3@huawei.com>,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org, liubo254@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <d78cbb12-9a9c-7965-db9a-70b4b277f908@huawei.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <42e56670-e595-1c66-208c-40c103262890@huaweicloud.com>
Date: Tue, 4 Mar 2025 20:26:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d78cbb12-9a9c-7965-db9a-70b4b277f908@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAHbHxw8cZn5qvKFQ--.55471S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar47Cw1xtFWfZrWxXrWUurg_yoW8tr13pF
	Wqya4rCr90ga1UuasrG3yxXFy8uw18ZFW5ur4UXry7CF98JFyIgr1xtF15WF90qr9Fqa4D
	ZF18WFWUWay0kaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwx
	hLUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/03/04 14:12, Wu Guanghao 写道:
> When testing the raid1, I found that adding disk to raid1 fails.
> Here's how to reproduce it:
> 
> 	1. modprobe brd rd_nr=3 rd_size=524288
> 	2. mdadm -Cv /dev/md0 -l1 -n2 -e1.0 /dev/ram0 /dev/ram1
> 
> 	3. mdadm /dev/md0 -f /dev/ram0
> 	4. mdadm /dev/md0 -r /dev/ram0
> 
> 	5. echo "10000 100" > /sys/block/md0/md/dev-ram1/bad_blocks
> 	6. echo "write_error" > /sys/block/md0/md/dev-ram1/state
> 
> 	7. mkfs.xfs /dev/md0
> 	8. mdadm --examine-badblocks /dev/ram1  # Bad block records can be seen
> 	   Bad-blocks on /dev/ram1:
> 	               10000 for 100 sectors
> 
> 	9. mdadm /dev/md0 -a /dev/ram2
> 	   mdadm: add new device failed for /dev/ram2 as 2: Invalid argument

Can you add a new regression test as well?

> 
> When adding a disk to a RAID1 array, the metadata is read from the existing
> member disks for synchronization. However, only the bad_blocks flag are copied,
> the bad_blocks records are not copied, so the bad_blocks records are all zeros.
> The kernel function super_1_load() detects bad_blocks flag and reads the
> bad_blocks record, then sets the bad block using badblocks_set().
> 
> After the kernel commit 1726c7746("badblocks: improve badblocks_set() for
> multiple ranges handling"), if the length of a bad_blocks record is 0, it will
> return a failure. Therefore the device addition will fail.
> 
> So, don't set the bad_blocks flag when initializing the metadata, kernel can
> handle it.
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>   super1.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/super1.c b/super1.c
> index fe3c4c64..03578e5b 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2139,6 +2139,9 @@ static int write_init_super1(struct supertype *st)
>   		if (raid0_need_layout)
>   			sb->feature_map |= __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT);
> 
> +		if (sb->feature_map & MD_FEATURE_BAD_BLOCKS)
> +			sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_BAD_BLOCKS);

There are also other flags that is per rdev, like MD_FEATURE_REPLACEMENT
and MD_FEATURE_JOURNAL, they should be excluded as well.

Thanks,
Kuai

> +
>   		sb->sb_csum = calc_sb_1_csum(sb);
>   		rv = store_super1(st, di->fd);
> 

