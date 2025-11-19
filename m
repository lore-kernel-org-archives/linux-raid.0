Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7989431C597;
	Wed, 19 Nov 2025 07:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763535971; cv=none; b=Ldo/NXdpgukZp+5Us/z0O1kXUhvldvoWKo7FuKhGy6pvNYXKyc+nxl7vUnlVfOOOhadGx0KGx579vEFCY2WstaRwBMiNCASzP8ntkLeOpOgBfIwVsd3J4LleG4PtYezorUsJOD0t1aWnTBqQZ9Za0pdD4TqrXaMkthAmAbrr6Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763535971; c=relaxed/simple;
	bh=zL8Y1DletekUhf65Mk8WkYDVM53kpesKIi9sHWSg3Q4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OEfYDyMhXNwe00BFrE2Biky7cXPVkn1Xy2DYxeiDgp2OAs4xroZgh+eqzvbC11Q7kSOzyYdnueXd7W99OXEf7EINZPusGYYIcYCNqsfjlYlULd7G2UpjNFn/2DeJNq8r98X4Vd2vX7b1NjRHt/B2eGiNtVsdvjCq8EuoXyNEyrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dBCDc7510zKHMLY;
	Wed, 19 Nov 2025 15:05:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id C9B961A139C;
	Wed, 19 Nov 2025 15:06:04 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHo3lbbB1pNxUQBQ--.64688S3;
	Wed, 19 Nov 2025 15:06:04 +0800 (CST)
Message-ID: <5067f181-92b8-8f9c-ce71-477bc4466e6d@huaweicloud.com>
Date: Wed, 19 Nov 2025 15:06:03 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/2] md: warn about updating super block failure
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20251117085557.770572-1-yukuai@fnnas.com>
 <20251117085557.770572-2-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251117085557.770572-2-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHo3lbbB1pNxUQBQ--.64688S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtrW5ZrW3Ar17Wr17tF4xJFb_yoWDAFc_Ww
	47ZFyfXr42qrZYyw12qF4fZrW7tFs3Wwn3WFy2qr45Zry3Jry8KFyI9w18Jw1FqF9rtasI
	yrykuw4Fyr4DZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4AYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1_MaU
	UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/11/17 16:55, Yu Kuai 写道:
> Many personalities will handle IO error from daemon thread(like raid1d,
> raid10d, raid5d), and sb will require to be clean before hanlding these
> failed IO. However update sb can fail, for example array is broken by
> IO failure, or user config sysfs api array_state.
> 
> This patch adds warning if updating sb failed first, in case this will
> be related to IO hang.
> 
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/md.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7b5c5967568f..345b1e623aba 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2788,6 +2788,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
>   	if (!md_is_rdwr(mddev)) {
>   		if (force_change)
>   			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> +		pr_err("%s: can't update sb for read-only array %s\n", __func__, mdname(mddev));
>   		return;
>   	}
>   

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>
-- 
Thanks,
Nan

