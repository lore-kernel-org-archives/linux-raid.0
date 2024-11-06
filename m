Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92063A1DB
	for <linux-raid@vger.kernel.org>; Wed,  6 Nov 2024 01:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855151; cv=none; b=Loyhu6HJuAgiLvutoERq+21ebcaQKz6r9mXLWcl4UcOZdMOuyKNO4GIVs+eFBzgR4wauwXozee1mZ2QtEsdcy6DYelvWl9XrX0m2YcG3Ajp+f3/nu5s2zXJBocWMFE/JmY8tHDoeS/lVybcWd6nOsg2dN0xL8Q20+bcKsaizY3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855151; c=relaxed/simple;
	bh=FwP6vefKv7z7sCBujIrK+EFh47dTYHPw9odnpNgMuGg=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NcQUFF5YAPxQMBtIEMfD4iWt2t+5QZGTDqUX3lDHsJbNewYHU7Ue1+uB2/isEDfq3AUjwAnY8PSHyNfstuUDyE29c0VFtGZRBgbnYW7RTaBo10okzKIppnfn9Ash1vMEZrzkyMjhNelrovGrRygrpJptj4es7UaeJ/XACldKDcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xjn7T5Vvhz4f3jHg
	for <linux-raid@vger.kernel.org>; Wed,  6 Nov 2024 09:05:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 965BF1A0568
	for <linux-raid@vger.kernel.org>; Wed,  6 Nov 2024 09:05:44 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCnzoLnwCpnokPjAw--.6262S3;
	Wed, 06 Nov 2024 09:05:44 +0800 (CST)
Subject: Re: [PATCH] md/md-bitmap: Add missing destroy_work_on_stack()
To: Yuan Can <yuancan@huawei.com>, song@kernel.org,
 linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20241105130105.127336-1-yuancan@huawei.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <90dbe078-986d-46fa-0a46-2f8eaa070e09@huaweicloud.com>
Date: Wed, 6 Nov 2024 09:05:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241105130105.127336-1-yuancan@huawei.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnzoLnwCpnokPjAw--.6262S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKw1rJrykAFy8Jw48tw43Wrg_yoWfArc_G3
	4Dtr97KryUCrnYvr17Xr1xZrWvkws8X3Z8Xr4xt3yfZFy5A3sYkrWvvwnrt34rJFy7A34a
	kryUX345trZ8WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbzxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/11/05 21:01, Yuan Can Ð´µÀ:
> This commit add missed destroy_work_on_stack() operations for
> unplug_work.work in bitmap_unplug_async().
> 
> Fixes: a022325ab970 ("md/md-bitmap: add a new helper to unplug bitmap asynchrously")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>   drivers/md/md-bitmap.c | 1 +
>   1 file changed, 1 insertion(+)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 29da10e6f703..c3a42dd66ce5 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1285,6 +1285,7 @@ static void bitmap_unplug_async(struct bitmap *bitmap)
>   
>   	queue_work(md_bitmap_wq, &unplug_work.work);
>   	wait_for_completion(&done);
> +	destroy_work_on_stack(&unplug_work.work);
>   }
>   
>   static void bitmap_unplug(struct mddev *mddev, bool sync)
> 

