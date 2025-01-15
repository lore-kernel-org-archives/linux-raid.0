Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604DE1DB12F;
	Wed, 15 Jan 2025 07:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736926321; cv=none; b=pdg4sdM7J2kagRjI1A/dIS12qTXkF5cnXk/biE4mX1WFlFAx1sldyfy7Mt93Fn8T21yiJZkq/Mw/3hNr4TMHxxCYq0RHKaj8Zvw5IaDtZOZ6GtKfAGW52u1ueWDMeVmd8uPMn321rqtUkkgA50OIwQiYjamk2Zaz45PVtvsxjk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736926321; c=relaxed/simple;
	bh=ewQdqRgpwRn9vAS/RWd75mbnlBeYuXNPL5x0HiVF0uk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rtYf1KqSOSo2Q8/l69PZuqlpbGIftVh5nXEMWQPpQE0LHup0Te0ULW5TsBdCcL6GmUuwQwSLfGhuHaypH63ok32sfikVmpPfNCEk83hR3fLe6Uy4DBkFVIK/MeEeKeZpNZq4Ye3oOcicOSjxU5gRSvWxuqFy1g+nELay41ra9wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YXyNq5q0Qz4f3jks;
	Wed, 15 Jan 2025 15:31:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 075F11A0D08;
	Wed, 15 Jan 2025 15:31:55 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP3 (Coremail) with SMTP id _Ch0CgCH2sRpZIdneEn4Aw--.15027S3;
	Wed, 15 Jan 2025 15:31:54 +0800 (CST)
Subject: Re: [PATCH next] md/md-linear: Fix a NULL vs IS_ERR() bug in
 linear_add()
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Song Liu <song@kernel.org>, Coly Li <colyli@kernel.org>,
 Mike Snitzer <snitzer@kernel.org>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <add654be-759f-4b2d-93ba-a3726dae380c@stanley.mountain>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <41e896f6-c71b-48c3-8944-eba3dba235cc@huaweicloud.com>
Date: Wed, 15 Jan 2025 15:31:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <add654be-759f-4b2d-93ba-a3726dae380c@stanley.mountain>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCH2sRpZIdneEn4Aw--.15027S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZr47uw48KF4xZr4rtw1xAFb_yoWDWrg_ur
	s2vry7Cwn8XFyjvr1Yq3ySvrZ09w1j9r4kZryftFZxua4Fy3s3XryDGr1kAas7ZFWfJFy5
	A3s2g34ftrZ7ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4kYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/01/15 14:53, Dan Carpenter Ð´µÀ:
> The linear_conf() returns error pointers, it doesn't return NULL.  Update
> the error checking to match.
> 
> Fixes: 127186cfb184 ("md: reintroduce md-linear")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>   drivers/md/md-linear.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 53bc3fda9edb..a382929ce7ba 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -204,8 +204,8 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
>   	rdev->saved_raid_disk = -1;
>   
>   	newconf = linear_conf(mddev, mddev->raid_disks + 1);
> -	if (!newconf)
> -		return -ENOMEM;
> +	if (IS_ERR(newconf))
> +		return PTR_ERR(newconf);
>   
>   	/* newconf->raid_disks already keeps a copy of * the increased
>   	 * value of mddev->raid_disks, WARN_ONCE() is just used to make
> 

