Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941CA30FF30;
	Thu, 28 Aug 2025 12:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756382883; cv=none; b=Cw1/HH2yl+j90OOJCksqwOFuZ8HVcXRVv9xV34s8k1E5cOG+ae6Usp1Ns7QV8bNVLU5Y56Nnfuewgznn7cYfj61E9UofKGXo+u1ybUvYG/8dJRod6RHAAKHScAo4jZgzICJUsm9kYOc1TblA06oAN4j2s3IhYupSsP7VVJXXqr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756382883; c=relaxed/simple;
	bh=RTSMa+jChyeyumlcrB+4gk8hV/fLvrsg5knL9t7Fy2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aJS6pS8S4X4MOu36UZB6QAP5zBT84RXgC1AOSlEw5A4Jz+ue6aa9RmWswDJUWh5Xs/zGMVXsepPk4kz6MvfXn7W+8bYwdapKnd7F6CQRVc37JRVRhwSwq97DpOUvGSCKEMziofo1yeQcDruBSgpul7TWi2EAMn7kZIkfxoQiqcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cCKsr3CNbzYQvFM;
	Thu, 28 Aug 2025 20:08:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 002AF1A01A2;
	Thu, 28 Aug 2025 20:07:58 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgAXYIydRrBowpJVAg--.3954S3;
	Thu, 28 Aug 2025 20:07:58 +0800 (CST)
Message-ID: <5b5f598b-0aa7-c836-91bd-a1fa78371a78@huaweicloud.com>
Date: Thu, 28 Aug 2025 20:07:57 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] dm vdo: Use str_plural() to simplify the code
To: Xichao Zhao <zhao.xichao@vivo.com>, song@kernel.org, yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250828112714.633108-1-zhao.xichao@vivo.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250828112714.633108-1-zhao.xichao@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXYIydRrBowpJVAg--.3954S3
X-Coremail-Antispam: 1UD129KBjvdXoWruF4kArW3JF43AF1DJFy3CFg_yoWfZFc_Kr
	4Iqw1aqr4kZrW0vw13Xw4IkrWrKw1kWws7uw43tr45X3sxZF98WF97ZryDZw1kWrWayF43
	urWfA3Wxt348WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3kYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x07jb2-nUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/8/28 19:27, Xichao Zhao 写道:
> Use the string choice helper function str_plural() to simplify the code.
> 
> Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
> ---
>   drivers/md/raid0.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index cbe2a9054cb9..a2e59a8d441f 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c

Why subject is 'dm vdo'? The modified file is raid0. Please check before
sending.

> @@ -41,7 +41,7 @@ static void dump_zones(struct mddev *mddev)
>   	int raid_disks = conf->strip_zone[0].nb_dev;
>   	pr_debug("md: RAID0 configuration for %s - %d zone%s\n",
>   		 mdname(mddev),
> -		 conf->nr_strip_zones, conf->nr_strip_zones==1?"":"s");
> +		 conf->nr_strip_zones, str_plural(conf->nr_strip_zones));
>   	for (j = 0; j < conf->nr_strip_zones; j++) {
>   		char line[200];
>   		int len = 0;

-- 
Thanks,
Nan

