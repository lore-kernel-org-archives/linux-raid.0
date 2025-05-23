Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBD7228CA3;
	Fri, 23 May 2025 09:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994357; cv=none; b=rShS7IiK2SUhuNjlz4L1d6hewKmkoniZYqW1avAFT4ZPI5UvS0t5Ll+5H5uc9uWrnpieDrVB4iFRqJP3JPs6Hug7uDaNIbqD1KVIC4Hm2he/ps+IwVqdWJ9HguFtwKaPD+uVhhFxhCBnE9Ql6CzPUJWdR6pIbozn/UWskoKQTmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994357; c=relaxed/simple;
	bh=L3kgv+1AXVcfkAUiGth6DfjiW7WzYFWp7E7HAOljHHw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=pb7j0FmyYIdnGJhLEe0Y+G0hvKPslUk3a/iUD6FbB9037HWEwPnp6ND9YhsgEh9aw3RWMHIS5uPtslnSLp7jLWsF7pFqUvlknhq/h2cd/RYVTenHyz/thCMYS187R3x9yhByAlg+k/Hb/iweV5z3H+VpTAgiKCprxVu7llYQ0e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4b3gbS5jBDz4f3lCf;
	Fri, 23 May 2025 17:58:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6935F1A12E3;
	Fri, 23 May 2025 17:59:11 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3Wl_tRjBoDxMPNQ--.30170S3;
	Fri, 23 May 2025 17:59:11 +0800 (CST)
Subject: Re: [PATCH] md: fix potential NULL pointer dereference in
 md_super_write
To: Ye Chey <yechey@ai-sast.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250523093554.23182-1-yechey@ai-sast.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <daf88fa3-f87e-a0c7-b93c-a4d150be8afc@huaweicloud.com>
Date: Fri, 23 May 2025 17:59:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250523093554.23182-1-yechey@ai-sast.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3Wl_tRjBoDxMPNQ--.30170S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw15JF15ArWDJr4rArW7twb_yoWfZFX_Wr
	43ur9rXw1UCrn0yF1UurWSyrWFyFs7urn7uFyIqayfGrZ5Zr18Kry8Z3s8Jw1fuFyxAFn8
	G34v9ryftr4xGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4kYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7IJmUU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/23 17:35, Ye Chey Ð´µÀ:
> The bio_alloc_bioset() call in md_super_write() could fail under memory
> pressure and return NULL. Add a check to handle this case gracefully by
> returning early, preventing a potential NULL pointer dereference.

NAK, if you read the comments of bio_alloc_bioset(), you'll know there
are cases bio_alloc_bioset() will never return NULL.

Thanks,
Kuai

> 
> Signed-off-by: Ye Chey <yechey@ai-sast.com>
> ---
>   drivers/md/md.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9daa78c5f..a0e2d90d4 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1002,6 +1002,8 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
>   			      REQ_OP_WRITE | REQ_SYNC | REQ_IDLE | REQ_META
>   				  | REQ_PREFLUSH | REQ_FUA,
>   			      GFP_NOIO, &mddev->sync_set);
> +	if (!bio)
> +		return;
>   
>   	atomic_inc(&rdev->nr_pending);
>   
> 

