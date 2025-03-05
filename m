Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAFB149C53;
	Wed,  5 Mar 2025 01:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741138476; cv=none; b=mtAsw7MHfHKRChhv6TDt0Z4GvcQ1N8vzxGvd1qNtw+M+1yKKXTfJ7J7vlZiazM/ZBd9i1zVz5MZ9kYik/7x7BYJxxt2PadHVgr7XEeWyamP+4NRG3sRxNXSadMc5Vgkr6fhERx2yezh6fHruZ65osdxTXoaFIilDJ6FnUhupB7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741138476; c=relaxed/simple;
	bh=0c3GK+61GsVm5hCZWyw8H0pMy0garXAIfRJcwXOqRbo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ehWEAOI52QgXzpAhHPh+3qTkxtO0PEuQ7vASAz84qA/rR/z1P515inJGtV0t0kUw6gazUdb2j+JhFzJap6wnqkeWKXRRj0qjirJZktPkX/V82x0QgOs9UXqno09w7gqW03iIo/MoO45j6ckj3l35ge305W4mhbmzp7zPPWWZsi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z6w7g2fBxz4f3m6j;
	Wed,  5 Mar 2025 09:34:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E53491A0DED;
	Wed,  5 Mar 2025 09:34:30 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3W2Amqsdn_UVLFg--.57461S3;
	Wed, 05 Mar 2025 09:34:30 +0800 (CST)
Subject: Re: [PATCH 0/7 md-6.15] md: introduce md_submodle_head
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d7519311-8726-a837-ac0f-62482b4f95b0@huaweicloud.com>
Date: Wed, 5 Mar 2025 09:34:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3W2Amqsdn_UVLFg--.57461S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtF45uF48CFyDGr47Kr1xZrb_yoWkAFc_Za
	4jqFyfXryUXF18Ja4rWrsIvrWkAF40vr1rXFy2grWFvr13uFWxGr1093yUX3W8uFyqq3Z8
	Jr10k34Fy3y0qjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbPl1PUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/02/15 17:22, Yu Kuai Ð´µÀ:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> This set introduce md_submodle_head and related API to replace
> personality and md-cluter registration, and remove lots of exported
> helpers and global variables.
> 
> Also prepare to add kconfig for md-bitmap.
> 
> Yu Kuai (7):
>    md: merge common code into find_pers()
>    md: only include md-cluster.h if necessary
>    md: introduce struct md_submodule_head and APIs
>    md: switch personalities to use md_submodule_head
>    md/md-cluster: cleanup md_cluster_ops reference
>    md: don't export md_cluster_ops
>    md: switch md-cluster to use md_submodle_head
> 

Applied to md-6.15
Thanks

>   drivers/md/md-bitmap.c  |   8 +-
>   drivers/md/md-cluster.c |  18 ++-
>   drivers/md/md-cluster.h |   6 +
>   drivers/md/md-linear.c  |  15 ++-
>   drivers/md/md.c         | 259 +++++++++++++++++++---------------------
>   drivers/md/md.h         |  48 +++++---
>   drivers/md/raid0.c      |  18 +--
>   drivers/md/raid1-10.c   |   4 +-
>   drivers/md/raid1.c      |  33 ++---
>   drivers/md/raid10.c     |  41 ++++---
>   drivers/md/raid5.c      |  70 +++++++----
>   11 files changed, 297 insertions(+), 223 deletions(-)
> 

