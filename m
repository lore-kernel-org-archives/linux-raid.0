Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EE6274FFE;
	Mon, 18 Aug 2025 06:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755498685; cv=none; b=hFxybc8juw492lGpGdV0ULDkHEeBs4WmHIxXYXFiglYD7S95QlX1Olv5NJsikosQzS6DRVbqbZkL8gmtSUZ/RsxYaKorIkzCzfWv1zj/PpqG/mhU0+A4inMphiaqkJGkvcCULZ2MGhKoiwR27Ki2a6EjhPRI2OWHOCYiDliyX8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755498685; c=relaxed/simple;
	bh=Hv9/f0wZtCpcceDkI2NPRxbr1R0294UCEI5JlP+H+Nw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=tUH6t5+FyQY/bzZ6RYupoa4JmXAYahAzY9QBcWF+sKTrpC6KflpgTmt+dXMqDVag7MPVjyMTOIofy+Vwd/xKtMzbwt5BEsvO3jWsrBB1BUZCRQknfeE/UKWvdK2XgZcHaw4yvY+/QuMZtPRXY/xNpGRwOmfMPAJy0o7LrN016LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c52t13wPmzKHMZx;
	Mon, 18 Aug 2025 14:31:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EBC371A1356;
	Mon, 18 Aug 2025 14:31:20 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHzw+4yKJo_NRMEA--.49863S3;
	Mon, 18 Aug 2025 14:31:20 +0800 (CST)
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, colyli@kernel.org,
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250817152645.7115-1-colyli@kernel.org>
 <756b587d-2a5c-4749-a03b-cfc786740684@kernel.org>
 <ffa13f8c-5dfe-20d4-f67d-e3ccd0c70b86@huaweicloud.com>
 <fd5c1916-936b-4253-a7b8-ba53591653f3@kernel.org>
 <4aa48545-7398-c346-5968-5d08f29748c4@huaweicloud.com>
 <aKLAhOxV1KViVw7w@infradead.org>
 <de4fd44c-f8be-e787-27f4-9e9e09921e12@huaweicloud.com>
 <aKLFuQX8ndDxLTVs@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e00106ae-e373-9481-8377-5e69203f9de0@huaweicloud.com>
Date: Mon, 18 Aug 2025 14:31:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aKLFuQX8ndDxLTVs@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHzw+4yKJo_NRMEA--.49863S3
X-Coremail-Antispam: 1UD129KBjvdXoWrWrykJF43Zr1xJw13uFyrCrg_yoWxGwbE93
	yrCa48Aw17JFs2ya13Grn8JFZFg3y0qryDXr1UJa15J345Ar4vqryqk3s3Zw4DJF4xtrnI
	vF43W3yIgry29jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbVOJ7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/08/18 14:18, Christoph Hellwig Ð´µÀ:
> On Mon, Aug 18, 2025 at 02:14:06PM +0800, Yu Kuai wrote:
>> Please take a look at the first patch, nothing special, the new flag
>> will be passed to the top device.
> 
> But passing it on will be incorrect in many cases, e.g. for any
> write caching solution.  And that is a much more common use case
> than stacking different raid level using block layer stacking.

I don't quite understand why it's incorrect for write caching solution,
can you please explain in details? AFAIK, the behaviour is only changed
for the first mdraid device is the stacking chain.

Thanks,
Kuai

> 
> .
> 

