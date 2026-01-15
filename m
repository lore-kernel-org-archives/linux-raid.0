Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658B52629D
	for <linux-raid@vger.kernel.org>; Thu, 15 Jan 2026 01:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768440504; cv=none; b=Gy46Y1flx1JBmlaoxgMsjQoklyPlJZoXQkFlvZv7SQgZ3P4RBYtOcnymlL/f6zPmfdvgRlQmgAblNmZNrN8Su9B5TDfRylJ5boEh5XIGnV6NHuJX9035Q3q8In1w0jzCkFxEeSxNkDwwRNogTbI5fx5ttLnazL5f5znd34hIhT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768440504; c=relaxed/simple;
	bh=6azUKzp7Ka2uSzaePHwsRnKPRIACVCfKSxvz+IDmlts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h4ga7zFoKfdmlFLZuwKzeGqRBzYGfLrGZ9sjVpTuBXdbViiVooNT+puV6fhSlgJ+OwhJe9yWvCLeKZ8vqrTu8Wrl/Sw73rxoolaqcXUilY9s3Yc0XIw3WIKH0YrIPkZf3t+Tl6GUt6kN7QQiaa2WAtaRPLpta0sXt58WRRqsPfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ds5266XygzKHM0S
	for <linux-raid@vger.kernel.org>; Thu, 15 Jan 2026 09:27:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C42A14056D
	for <linux-raid@vger.kernel.org>; Thu, 15 Jan 2026 09:28:19 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAHaPiwQmhpLu1cDw--.3378S3;
	Thu, 15 Jan 2026 09:28:17 +0800 (CST)
Message-ID: <5e0e470a-e7de-f632-7407-361f8ae5b180@huaweicloud.com>
Date: Thu, 15 Jan 2026 09:28:16 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5 01/12] md/raid5: fix raid5_run() to return error when
 log_init() fails
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
Cc: xni@redhat.com, dan.carpenter@linaro.org
References: <20260114171241.3043364-1-yukuai@fnnas.com>
 <20260114171241.3043364-2-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260114171241.3043364-2-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHaPiwQmhpLu1cDw--.3378S3
X-Coremail-Antispam: 1UD129KBjvJXoW7XrWrAr1UZrWfCw4UZF1rXrb_yoW8Jr45p3
	yku34UZryru3y7AayDJ3y7Zay5ZanFk347Grnavw1rZa1jvrW7uw40gr1Ygr1kZay5Kayr
	ZFyqkF4vg3WrKrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07URwZ
	7UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/15 1:12, Yu Kuai 写道:
> Since commit f63f17350e53 ("md/raid5: use the atomic queue limit
> update APIs"), the abort path in raid5_run() returns 'ret' instead of
> -EIO. However, if log_init() fails, 'ret' is still 0 from the previous
> successful call, causing raid5_run() to return success despite the
> failure.
> 
> Fix this by capturing the return value from log_init().
> 
> Fixes: f63f17350e53 ("md/raid5: use the atomic queue limit update APIs")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/202601130531.LGfcZsa4-lkp@intel.com/
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/raid5.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e57ce3295292..39bec4d199a1 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8055,7 +8055,8 @@ static int raid5_run(struct mddev *mddev)
>   			goto abort;
>   	}
>   
> -	if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
> +	ret = log_init(conf, journal_dev, raid5_has_ppl(conf));
> +	if (ret)
>   		goto abort;
>   
>   	return 0;

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

