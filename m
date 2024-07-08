Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55431C17;
	Mon,  8 Jul 2024 02:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720404702; cv=none; b=ojfWiZJUHAXiJfZDBrmYL3vjc0P+slft310e/NWYk9yvVEEqwr+s74LPqqumXSPaKJdb3afp0P1QBSwvPxLhuGPUlHTkECpH29elh++KylqkaCLo1swBTRVP1Hhyk7ZoJeo05qS+lGTcuO4YZIQNxg5hHWsgSzOG9fkS/j5jKQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720404702; c=relaxed/simple;
	bh=9nD53nRrte+kAzCjSb9QVY/6h91GoXPMMNzBGJ+2RLU=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=S6C68M7bkyjI8pmivn8rYdEu8IS/pVnYh05C12Nspc3/qbYRHW3ssmpo8B7UAm/zoHTtzWXo2a2BwB0db9cHI4ZIT+xfVT1jaaltRJTr4q86cmZGRtjC1R4k0EsHH6PFOrPlhIdgMMIghy6xxDE6Z3rHUq1wqMLdiLE6N6m0K7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4WHRw71Nvnz1xtLf;
	Mon,  8 Jul 2024 09:52:55 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id E019A1400DD;
	Mon,  8 Jul 2024 09:54:29 +0800 (CST)
Received: from [10.174.176.73] (10.174.176.73) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 8 Jul 2024 09:54:29 +0800
Subject: Re: [REGRESSION] Cannot start degraded RAID1 array with device with
 write-mostly flag
To: =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>,
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <regressions@lists.linux.dev>, Song Liu <song@kernel.org>, Paul Luse
	<paul.e.luse@linux.intel.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <20240706143038.7253-1-mat.jonczyk@o2.pl>
From: Yu Kuai <yukuai3@huawei.com>
Message-ID: <a703ec45-6cd5-4970-db22-fb9e7469332a@huawei.com>
Date: Mon, 8 Jul 2024 09:54:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240706143038.7253-1-mat.jonczyk@o2.pl>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600009.china.huawei.com (7.193.23.164)

Hi,

‘⁄ 2024/07/06 22:30, Mateusz Jo®Ωczyk –¥µ¿:
> Subject: [RFC PATCH] md/raid1: fill in max_sectors
> 
> 
> 
> Not yet fully tested or carefully investigated.
> 
> 
> 
> Signed-off-by: Mateusz Jo≈Ñczyk<mat.jonczyk@o2.pl>
> 
> 
> 
> ---
> 
>   drivers/md/raid1.c | 1 +
> 
>   1 file changed, 1 insertion(+)
> 
> 
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> 
> index 7b8a71ca66dd..82f70a4ce6ed 100644
> 
> --- a/drivers/md/raid1.c
> 
> +++ b/drivers/md/raid1.c
> 
> @@ -680,6 +680,7 @@ static int choose_slow_rdev(struct r1conf *conf, struct r1bio *r1_bio,
> 
>   		len = r1_bio->sectors;
> 
>   		read_len = raid1_check_read_range(rdev, this_sector, &len);
> 
>   		if (read_len == r1_bio->sectors) {
> 
> +			*max_sectors = read_len;
> 
>   			update_read_sectors(conf, disk, this_sector, read_len);
> 
>   			return disk;
> 
>   		}

This looks correct, can you give it a test and cook a patch?

Thanks,
Kuai
