Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7671E1C84A0
	for <linux-raid@vger.kernel.org>; Thu,  9 Oct 2025 02:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759977319; cv=none; b=WMivOhY0MtqFmZ10Xg70e/rTSexyAwBWUwomJ36XK0PV9CAWXBEa1T1x3cLcCah1XvTg4ghK1Pa9Y/jDR4vn0iTZlnzC5Qe0FEnIbqF9zwACR/+I2r06cTa8xSEQVN2jDQWKPyz4JP/VqB5kJJFZtbJ5Ve7ON9TCD5YPxaUcRoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759977319; c=relaxed/simple;
	bh=rndAleYJmyiGeOXowie1utwP2c6mFSgJjP16WWvJCnk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=t4m89wHpqaaVvlX8WYBG1mm0Yr+ytAyaIQCA+yuydC7TaR4kautSX8UEiha8CyVtjCjPVudimbXESt7c3hrCmCB2+Zbd7wYHDYsVaVfC4lHWtGyz/RDNCaDQF5fmroty1mlSFpG2auJoVIQLOCG+6fkIYHEDj3oeIl1i9j4yfN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4chtpF4zWqzYQtmC
	for <linux-raid@vger.kernel.org>; Thu,  9 Oct 2025 10:18:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A12621A08FC
	for <linux-raid@vger.kernel.org>; Thu,  9 Oct 2025 10:19:01 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3CGGUG+dozLwgCQ--.10270S3;
	Thu, 09 Oct 2025 10:19:01 +0800 (CST)
Message-ID: <8b51544b-8ca0-3879-f878-e8bd42aaa148@huaweicloud.com>
Date: Thu, 9 Oct 2025 10:18:59 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md: don't add empty badblocks record table in
 super_1_load()
To: colyli@fnnas.com, linux-raid@vger.kernel.org
References: <20251005162159.25864-1-colyli@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251005162159.25864-1-colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3CGGUG+dozLwgCQ--.10270S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw1kZF43ZFW3tF1xuF4fAFb_yoW8Wr48pr
	yDWrWavr97Jr12q3ZrZw409F9Yg3s3tFWUWrW3Aw1rur1UAr1DG3W0qF98Wryq9F1fKFnF
	qay5WasY9a4kGaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
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
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07URwZ
	7UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/10/6 0:21, colyli@fnnas.com 写道:
> From: Coly Li <colyli@fnnas.com>
> 
> In super_1_load() when badblocks table is loaded from component disk,
> current code adds all records including empty ones into in-memory
> badblocks table. Because empty record's sectors count is 0, calling
> badblocks_set() with parameter sectors=0 will return -EINVAL. This isn't
> expected behavior and adding a correct component disk into the array
> will incorrectly fail.
> 
> This patch fixes the issue by checking the badblock record before call-
> ing badblocks_set(). If this badblock record is empty (bb == 0), then
> skip this one and continue to try next bad record.
> 
> Signed-off-by: Coly Li <colyli@fnnas.com>
> ---
>   drivers/md/md.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 41c476b40c7a..b4b5799b4f9f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1873,9 +1873,14 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
>   		bbp = (__le64 *)page_address(rdev->bb_page);
>   		rdev->badblocks.shift = sb->bblog_shift;
>   		for (i = 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
> -			u64 bb = le64_to_cpu(*bbp);
> -			int count = bb & (0x3ff);
> -			u64 sector = bb >> 10;
> +			u64 bb, sector;
> +			int count;
> +
> +			bb = le64_to_cpu(*bbp);
> +			if (bb == 0)
> +				continue;

Can we just break:

    			if (bb + 1 == 0 || bb == 0)
				break;

Otherwise LGTM.

> +			count = bb & (0x3ff);
> +			sector = bb >> 10;
>   			sector <<= sb->bblog_shift;
>   			count <<= sb->bblog_shift;
>   			if (bb + 1 == 0)

-- 
Thanks,
Nan

