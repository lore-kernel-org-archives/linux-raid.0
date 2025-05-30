Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855F119B5B4;
	Fri, 30 May 2025 06:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748587557; cv=none; b=R4lfDZO8Hw1Yr+H5YUJqIoXgFeEacIm7rxtenQzw7KLnh9kgGWlVn9AJ9D2u2IqWOsDFjJ/yFO8H54Ctb1kU5Qe+N9CMP+ltI38LHclV0swcE62GLi5hL01thaZkWss0h/Tjm5Mq/XvmVrI2ELRm9jDW4buVy3GU4OATto0Gw4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748587557; c=relaxed/simple;
	bh=uN6UYCjIALHTqmUsk5NgYUPOBmSD+x85D8PxtSEoA18=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CmJgzPg0F+Zm66RZgHUbUlOLyiAFhmeLJIUoiYrVuvhogOywArh44IUKfg+VJxe2kg+cvNHoPi2pVMBayREs5CSxM3hZBrh2UBptmzEiS8tWLrBmOLDkyH+JLRrImrJHHIkZh5kPoFvyl+wQYx3covfCM2ncvHwknHc0ZQfhZbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4b7tzj3PKpzYQtG7;
	Fri, 30 May 2025 14:45:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8E49E1A11B9;
	Fri, 30 May 2025 14:45:52 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDnSl8fVDloHl3RNw--.12560S3;
	Fri, 30 May 2025 14:45:52 +0800 (CST)
Subject: Re: [PATCH 00/23] md/llbitmap: md/md-llbitmap: introduce a new
 lockless bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <44929c92-76fd-3a87-6d89-700b1d488277@huaweicloud.com>
Date: Fri, 30 May 2025 14:45:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250524061320.370630-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnSl8fVDloHl3RNw--.12560S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CryUGF4kAFy7AF17urW3Jrb_yoW8ur1DpF
	yqqr15W3y3AF17X3W3Xr97AFyFqF4ktrZrtr97Cw4fua4Dur98Gr48G3W3Aw17Wry3JF1D
	Xr45tFn8Ww1rX3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/24 14:12, Yu Kuai Ð´µÀ:
> Yu Kuai (23):
>    md: add a new parameter 'offset' to md_super_write()
>    md: factor out a helper raid_is_456()
>    md/md-bitmap: cleanup bitmap_ops->startwrite()
>    md/md-bitmap: support discard for bitmap ops
>    md/md-bitmap: remove parameter slot from bitmap_create()
>    md/md-bitmap: add a new sysfs api bitmap_type
>    md/md-bitmap: delay registration of bitmap_ops until creating bitmap
>    md/md-bitmap: add a new method skip_sync_blocks() in bitmap_operations
>    md/md-bitmap: add a new method blocks_synced() in bitmap_operations
>    md: add a new recovery_flag MD_RECOVERY_LAZY_RECOVER
>    md/md-bitmap: make method bitmap_ops->daemon_work optional
>    md/md-bitmap: add macros for lockless bitmap
>    md/md-bitmap: fix dm-raid max_write_behind setting
>    md/dm-raid: remove max_write_behind setting limit
>    md/md-llbitmap: implement llbitmap IO
>    md/md-llbitmap: implement bit state machine
>    md/md-llbitmap: implement APIs for page level dirty bits
>      synchronization
>    md/md-llbitmap: implement APIs to mange bitmap lifetime
>    md/md-llbitmap: implement APIs to dirty bits and clear bits
>    md/md-llbitmap: implement APIs for sync_thread
>    md/md-llbitmap: implement all bitmap operations
>    md/md-llbitmap: implement sysfs APIs
>    md/md-llbitmap: add Kconfig

Patch 3, 13, 14 are applied to md-6.16, they are not related to
new bitmap:

	md/md-bitmap: cleanup bitmap_ops->startwrite()
	md/md-bitmap: fix dm-raid max_write_behind setting
	md/dm-raid: remove max_write_behind setting limit

Thanks,
Kuai

> 
>   Documentation/admin-guide/md.rst |   80 +-
>   drivers/md/Kconfig               |   11 +
>   drivers/md/Makefile              |    2 +-
>   drivers/md/dm-raid.c             |    6 +-
>   drivers/md/md-bitmap.c           |   50 +-
>   drivers/md/md-bitmap.h           |   55 +-
>   drivers/md/md-llbitmap.c         | 1556 ++++++++++++++++++++++++++++++
>   drivers/md/md.c                  |  247 +++--
>   drivers/md/md.h                  |   20 +-
>   drivers/md/raid5.c               |    6 +
>   10 files changed, 1901 insertions(+), 132 deletions(-)
>   create mode 100644 drivers/md/md-llbitmap.c

