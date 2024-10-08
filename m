Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4030C7DA87;
	Tue,  8 Oct 2024 07:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728371251; cv=none; b=WSwmdG/04w1XmVOwau9PPp6wwnGhTDj+OySGZHX6AJ1yQpfQ1JhJ8FSJ+aW902kqyxkYCrj5YVZYWFQs1SMnAt8xtib9/ujigFFtAWOViDx9DIP5BBKn9nUfp3sZ99wDRgoCDuGoA1HjM1OIEl1WXFJj16N0IjMdGPqlfqO+elk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728371251; c=relaxed/simple;
	bh=PFGxxiXD3oPhRgGJAOwWR0H9h0aNGOfHAbG9WJYWG1M=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=U2njwl/U3B7genhpCLSTRRm2wag/afI+12XAxMJCF0jGAIIalACm255nxf5zq5FCCif1DBYMt5raC3Xflxj3i8iEMFk7yJpYDT5HnhvlXTtwpB/q31mWG8Q1JkRe65l8rIurSG73KBjY11CzF0+iTDZhYC5QbjERPZd8fIM+7PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XN6Vc3JcMz1P9Yl;
	Tue,  8 Oct 2024 15:05:44 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 44C151800DE;
	Tue,  8 Oct 2024 15:07:26 +0800 (CST)
Received: from [10.174.176.73] (10.174.176.73) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 8 Oct 2024 15:07:25 +0800
Subject: Re: [PATCH] md/raid5-ppl: Use atomic64_inc_return() in
 ppl_new_iounit()
To: Uros Bizjak <ubizjak@gmail.com>, <linux-raid@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Song Liu <song@kernel.org>, "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <20241007084831.48067-1-ubizjak@gmail.com>
From: Yu Kuai <yukuai3@huawei.com>
Message-ID: <8de92255-dc6f-eb42-3ee5-5d7259c7616d@huawei.com>
Date: Tue, 8 Oct 2024 15:07:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241007084831.48067-1-ubizjak@gmail.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600009.china.huawei.com (7.193.23.164)

ÔÚ 2024/10/07 16:48, Uros Bizjak Ð´µÀ:
> Use atomic64_inc_return(&ref) instead of atomic64_add_return(1, &ref)
> to use optimized implementation and ease register pressure around
> the primitive for targets that implement optimized variant.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Song Liu <song@kernel.org>
> Cc: Yu Kuai <yukuai3@huawei.com>

LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/raid5-ppl.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index a70cbec12ed0..37c4da5311ca 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -258,7 +258,7 @@ static struct ppl_io_unit *ppl_new_iounit(struct ppl_log *log,
>   	memset(pplhdr->reserved, 0xff, PPL_HDR_RESERVED);
>   	pplhdr->signature = cpu_to_le32(ppl_conf->signature);
>   
> -	io->seq = atomic64_add_return(1, &ppl_conf->seq);
> +	io->seq = atomic64_inc_return(&ppl_conf->seq);
>   	pplhdr->generation = cpu_to_le64(io->seq);
>   
>   	return io;
> 
