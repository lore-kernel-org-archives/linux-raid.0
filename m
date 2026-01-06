Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF89F2C0307
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 07:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767683618; cv=none; b=FPPSxieKoP7ITxh8QUvh7kQP8R0olyKXZOcputjZk/eJaThiLQP8BXiNneYbv8z6Kl9dhHeifsMmXAG8K1/dU8edEu3f43o8088n+bgRalfPbotCsD22LSlq/vmh0w0VE7/UFviZvf7nz2PF23moBu3cRFJ1GFrgqmmfMSLqex8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767683618; c=relaxed/simple;
	bh=ko74liYT+6KmFbFIQBahqsbIreBXiE4Eb+bfkEc+Uaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k53yk9sHCg6DJZXOnvUYEaEm8nv59WQ2/Lv8LDmtjGN9HCry1+640hrbZlVd+c2qDDDFrp1JVGv0uHrTT5NE29Uldtqi4TCHfSPJxkbBZts5IAhsc6ofDvFXCCOmxqz7J5aN+amM9lPZzNyc5gMv8/hX5HTVxYGmI244ypbzc1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dlj6s6M7BzKHMlx
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 15:12:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4A5C640562
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 15:13:33 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAHaPgctlxp2iQ_Cw--.4085S3;
	Tue, 06 Jan 2026 15:13:33 +0800 (CST)
Message-ID: <70f65144-0c98-bb4a-280e-8d4e61c2f1be@huaweicloud.com>
Date: Tue, 6 Jan 2026 15:13:32 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 09/11] md/raid10: align bio to io_opt
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
Cc: colyli@fnnas.com
References: <20260103154543.832844-1-yukuai@fnnas.com>
 <20260103154543.832844-10-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260103154543.832844-10-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHaPgctlxp2iQ_Cw--.4085S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZFy7JFyxtw17tw43ZFyDGFg_yoW3tFg_K3
	Z3uF9xtr1Ikr1xWw17tr1IvryYv340gFs7uas0g39xua45ZF1FkFy0gas5Ja1YqayYgr9Y
	kwn7uw40krn8XjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbx8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UCD7
	3UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/3 23:45, Yu Kuai 写道:
> The impact is not so significant for raid10 compared to raid5, however
> it's still more appropriate to issue IOs evenly to underlying disks.
> 
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/raid10.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 09328e032f14..2c6b65b83724 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4008,6 +4008,8 @@ static int raid10_set_queue_limits(struct mddev *mddev)
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>   	if (err)
>   		return err;
> +
> +	md_config_align_limits(mddev, &lim);
>   	return queue_limits_set(mddev->gendisk->queue, &lim);
>   }
>   


LGTM

Reviewed-by: Li Nan <linan122@huawei.com>
-- 
Thanks,
Nan

