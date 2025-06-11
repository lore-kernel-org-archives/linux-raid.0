Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9591A28D
	for <linux-raid@vger.kernel.org>; Wed, 11 Jun 2025 06:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749622152; cv=none; b=BEdGUzqz9gbZbO9h/o9OU27G4qAj03iw4Cqj+zLhBhAWVsOi6KQeOzwLKrZBib18uLBaFiPwTW8Lfl9H1qDh14tzoHaSnkslteeXoiefgtZJKCGPij7+befRnepqv1AqarCb1amZwqdRLbq0b1USKeSSRKq7Jcpf/b7AwSaBEwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749622152; c=relaxed/simple;
	bh=/D4w3KPrOS4zVfZd0J/HBl2XJa1ztZv6I/UkesTicDY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=GjaTg1jXADYw+VkuRWoSv5UnvVYf40QfVJvtfIALdBisYcCKXK/npbfKdJwdGBkPO9CuDlFWcsZadFfMr5avm5W8BR5MGHGwHsAw924ZfCUeYeDWZY5r9yIMwrMJ718tnOGhmMF8gHyp2Zy8H2mbKj9LqTb+ITC/G7pOyYhkgLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bHFbm03KZzYQtdq
	for <linux-raid@vger.kernel.org>; Wed, 11 Jun 2025 14:09:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 05B6F1A0FB2
	for <linux-raid@vger.kernel.org>; Wed, 11 Jun 2025 14:09:07 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDXOl+BHUloxNioPA--.2658S3;
	Wed, 11 Jun 2025 14:09:06 +0800 (CST)
Subject: Re: [PATCH 1/3] md: call del_gendisk in control path
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, song@kernel.org, yukuai1@huaweicloud.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250610072022.98907-1-xni@redhat.com>
 <20250610072022.98907-2-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <bb5300e1-201b-33f8-d1e1-e870d89a8cff@huaweicloud.com>
Date: Wed, 11 Jun 2025 14:09:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250610072022.98907-2-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOl+BHUloxNioPA--.2658S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFyUGw13uFW5XrWkWFyxGrg_yoW8GFykpa
	y0g3W3J3yjqFWfWFWUtwnF9a45uwn7KFWDtryfC3ykAFyrtr4qgF9Yg3yjyrykWas5Jr42
	q3WF9r909FWkXr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/06/10 15:20, Xiao Ni Ð´µÀ:
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index d45a9e6ead80..8cf71db12700 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -700,11 +700,26 @@ static inline bool reshape_interrupted(struct mddev *mddev)
>   
>   static inline int __must_check mddev_lock(struct mddev *mddev)
>   {
> -	return mutex_lock_interruptible(&mddev->reconfig_mutex);
> +	int ret = 0;

No need to initialize ret to 0.
> +
> +	ret = mutex_lock_interruptible(&mddev->reconfig_mutex);
> +
> +	/* MD_DELETED is set in do_md_stop with reconfig_mutex.
> +	 * So check it here.
> +	 */
> +	if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
> +		ret = -ENODEV;
> +		mutex_unlock(&mddev->reconfig_mutex);
> +	}
> +
> +	return ret;
>   }
>   
>   /* Sometimes we need to take the lock in a situation where
>    * failure due to interrupts is not acceptable.
> + * It doesn't need to check MD_DELETED here, the owner which
> + * holds the lock here can't be stopped. And all paths can't
> + * call this function after do_md_stop.
>    */
>   static inline void mddev_lock_nointr(struct mddev *mddev)
>   {
> @@ -713,7 +728,14 @@ static inline void mddev_lock_nointr(struct mddev *mddev)
>   
>   static inline int mddev_trylock(struct mddev *mddev)
>   {
> -	return mutex_trylock(&mddev->reconfig_mutex);
> +	int ret = 0;

Same here, otherwise LGTM, feel free to add

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

