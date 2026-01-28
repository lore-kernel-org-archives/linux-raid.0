Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7182D8796
	for <linux-raid@vger.kernel.org>; Wed, 28 Jan 2026 08:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769588658; cv=none; b=Yoj7a44EBx/xd+bET1wpWy+Y6WkORlfRhvhOkZGjcYIe+MZ1htpXpEG7iDneriJtdsCg9tVVpyZUNph4rqETqSL4IUKgqTCB7ysROvc/Tt8mV7MGX2s9FfgdaQhCSaEt9BaOamGDDtB/yY9lNbKi6Z0+4aLw0AcMfXtfr4m0Gjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769588658; c=relaxed/simple;
	bh=v2Wlz3YZ9QDdUiABsjrCWwDmZzvB2F4WwS575oeOq04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lxx8rjs2t2KLsl2L+Kei0pkbkcff14S92u6U6Kee3JjskkUmDIuvFnXbvrxgKUK6hrduq9JPPwieJ41sSEQoWgD3BR6cAq08NvsMByZypNRIqtTolkaID1iF5D2N3Xxun0GEC16CXqAp20KQeSDUHGLa52+CN8pNzlX9Nif7jv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f1FfH6s5dzYQvDS
	for <linux-raid@vger.kernel.org>; Wed, 28 Jan 2026 16:23:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E671A40574
	for <linux-raid@vger.kernel.org>; Wed, 28 Jan 2026 16:24:12 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_epx3lp6YeXFQ--.46160S3;
	Wed, 28 Jan 2026 16:24:10 +0800 (CST)
Message-ID: <d9e99d28-a620-4133-aff4-7fbf4380bc1d@huaweicloud.com>
Date: Wed, 28 Jan 2026 16:24:09 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/1] md: fix return value of mddev_trylock
To: Xiao Ni <xni@redhat.com>, yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, bvanassche@acm.org
References: <20260127073951.17248-1-xni@redhat.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260127073951.17248-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_epx3lp6YeXFQ--.46160S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GF1rWr4fAw4DZrWUAFW3trb_yoWkWrcEgF
	Wv9as2qF1DZrWvkr1vqw1SvrWakan2vr4kua47t393ZF13Jrn3Xr9Yv3srJw1rWayrGFs0
	kFZ0krs0qrs8ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j
	6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUzW
	lkUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/27 15:39, Xiao Ni 写道:
> A return value of 0 is treaded as successful lock acquisition. In fact, a
> return value of 1 means getting the lock successfully.
> 
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Reported-by: Bart Van Assche <bvanassche@acm.org>
> Closes: https://lore.kernel.org/linux-raid/20250611073108.25463-1-xni@redhat.com/T/#mfa369ef5faa4aa58e13e6d9fdb88aecd862b8f2f
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 6985f2829bbd..3bfbee595156 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -737,8 +737,8 @@ static inline int mddev_trylock(struct mddev *mddev)
>   	int ret;
>   
>   	ret = mutex_trylock(&mddev->reconfig_mutex);
> -	if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
> -		ret = -ENODEV;
> +	if (ret && test_bit(MD_DELETED, &mddev->flags)) {
> +		ret = 0;
>   		mutex_unlock(&mddev->reconfig_mutex);
>   	}
>   	return ret;

LGTM

Reviewed-by:  Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

