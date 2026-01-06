Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E7C2C0307
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 07:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767683597; cv=none; b=uiUZ+sGQTh4WUqy+Tb5HNSVgNp7UBFlAVg9f6/Utm3FrU0tPpQdcEc2npan2+cVpXSO7G8l3IpxgpgFDebjq+5bCov5ojEMgC2nhP0IdGSmQf0Gb+YyIAxSjbCqM4eR9HwiUSS8pUZb/BrbXbOwyNbbPX3a27q7D0nRyiBiG9z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767683597; c=relaxed/simple;
	bh=RyzsPKjtYnC+n3Yj5w+XQU6k1ZB76S8tH65bCWnR9R8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fBlrS9P2RMJqoA7qZ01hlFLMvSRYhtWZ6vEJRzay70DzW185eJhvUkRlzTMfoDjdFNlThCWoDCm+ni8WfXQVxni836qUs1e54kFXuQF5KNVEdNOxiY7AgopSyVS32CgN1yoNjgzGGsgFL/FnmyDZFgwW/28DYYorVOUVbkdqH3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dlj6Q71gQzKHMmN
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 15:12:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 61CDE40562
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 15:13:10 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAHZ_cEtlxpXBw_Cw--.221S3;
	Tue, 06 Jan 2026 15:13:10 +0800 (CST)
Message-ID: <760aeee5-dd27-6ed5-a18d-382fc4a416cb@huaweicloud.com>
Date: Tue, 6 Jan 2026 15:13:08 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 08/11] md/raid5: align bio to io_opt
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
Cc: colyli@fnnas.com
References: <20260103154543.832844-1-yukuai@fnnas.com>
 <20260103154543.832844-9-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260103154543.832844-9-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHZ_cEtlxpXBw_Cw--.221S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WrWxGrWDXr1DZFWUGFyfJFb_yoW8Wry3pw
	4DurW2vF98X3W5CasxXayj9FWrX3W3Wr1qyFW3Xw4kWw1Fgr90ga1Iq3yjqF1xuFnYgayx
	GF10krZrGas0y3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzW
	lkUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/3 23:45, Yu Kuai 写道:
> raid5 internal implementaion indicates that if write bio is aligned to
> io_opt, then full stripe write will be used, which will be best for
> bandwidth because there is no need to read extra data to build new
> xor data.
> 
> Simple test in my VM, 32 disks raid5 with 64kb chunksize:
> dd if=/dev/zero of=/dev/md0 bs=100M oflag=direct
> 
> Before this patch:  782 MB/s
> With this patch:    1.1 GB/s
> 
> BTW, there are still other bottleneck related to stripe handler, and
> require further optimization.
> 
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/raid5.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 005a2404de27..69a5eb02b891 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -59,8 +59,7 @@
>   #define UNSUPPORTED_MDDEV_FLAGS		\
>   	((1L << MD_FAILFAST_SUPPORTED) |	\
>   	 (1L << MD_FAILLAST_DEV) |		\
> -	 (1L << MD_SERIALIZE_POLICY) |		\
> -	 (1L << MD_BIO_ALIGN))
> +	 (1L << MD_SERIALIZE_POLICY))
>   
>   
>   #define cpu_to_group(cpu) cpu_to_node(cpu)
> @@ -7818,8 +7817,7 @@ static int raid5_set_limits(struct mddev *mddev)
>   	 * Limit the max sectors based on this.
>   	 */
>   	lim.max_hw_sectors = RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf);
> -	if ((lim.max_hw_sectors << 9) < lim.io_opt)
> -		lim.max_hw_sectors = lim.io_opt >> 9;
> +	md_config_align_limits(mddev, &lim);
>   
>   	/* No restrictions on the number of segments in the request */
>   	lim.max_segments = USHRT_MAX;

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>
-- 
Thanks,
Nan

