Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B69A12E4A;
	Sat, 28 Dec 2024 06:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735366293; cv=none; b=ZZvoenViebQULMWBHs8+J/dnRGLLnlPpe4DTowErX/GK6JKuAKGh7q3iMSlN8KDyFnFho5m6ea8515djuvgdfd4AE3WJgLlBDObcHmT6d3CSE1k/RDODTS3ED5827HIRHBdK7qpS4ixsJRsp5l9sPSuI3KccctZd3O/9wpRyt5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735366293; c=relaxed/simple;
	bh=uvaY0dLR8+m2OVt5nmOaP6QDrfJj+Qoms700lkz4Wgg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CQNR2M69Om1x8GIFI7v2zTUdWH+xUEV6e8WZmAOL3ueh8GJeUaMMvHqFCkauN2vkZx1zRa8p3BK9YLq0Gw6K0poKY5PaIyFS5Y7gt0Z5QPu2PqAW77DoLdNffwoAbwkXUPGpP0GiKcg8ey47BDE/j7uQqqagWuELyd07ohJAlKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YKsS91vYwz4f3kvl;
	Sat, 28 Dec 2024 14:11:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2E3811A0359;
	Sat, 28 Dec 2024 14:11:26 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgDH7oKMlm9nQgFoFw--.12735S3;
	Sat, 28 Dec 2024 14:11:26 +0800 (CST)
Subject: Re: [PATCH] md: fix NULL point access
To: Chaohai Chen <wdhh66@163.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241228021543.216542-1-wdhh66@163.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <54d19fb4-f55f-64d9-10b9-2ece1147efaa@huaweicloud.com>
Date: Sat, 28 Dec 2024 14:11:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241228021543.216542-1-wdhh66@163.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDH7oKMlm9nQgFoFw--.12735S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GF43KFykuF47KFyrKFyxAFb_yoW3uFc_K3
	98ZryS9F98Cr1vyF42gF1xZrWSyFsruwn29F1Sq3y3W345Aw10krn3W34kJ34ruFW8uFyU
	J34jvw4S9w1DCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4AYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU80fO7
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/12/28 10:15, Chaohai Chen Ð´µÀ:
> bio_alloc_bioset may return NULL, we need to judge it before
> assign value to members of "new".

No, please read more about bio_alloc_bioset(), it doesn't return
NULL in this case.

Thanks,
Kuai

> 
> Signed-off-by: Chaohai Chen <wdhh66@163.com>
> ---
>   drivers/md/md.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aebe12b0ee27..a23419ad3dd8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -585,6 +585,8 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
>   		new = bio_alloc_bioset(rdev->bdev, 0,
>   				       REQ_OP_WRITE | REQ_PREFLUSH, GFP_NOIO,
>   				       &mddev->bio_set);
> +		if (!new)
> +			continue;
>   		new->bi_private = bio;
>   		new->bi_end_io = md_end_flush;
>   		bio_inc_remaining(bio);
> 

