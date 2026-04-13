Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD21378D6E
	for <linux-raid@vger.kernel.org>; Mon, 13 Apr 2026 08:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776068113; cv=none; b=ueItsuA3U3YQ74OsRZ8msri5ryp+c76xvOcFxwVWjbcFAJEHeeq3mH2Hqe1WGd20QU9Lsqymks2qbnbgd1zqUGDHAG697aSSKbkVjRGPj66oOuIAcO60jEisztEQ4eAMIjlYIxqc7aQ2eSsOZYCyQqxAQheEn3kGwmL7CKhUtsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776068113; c=relaxed/simple;
	bh=Kdq84xXU9pWfmSYbNVPc651Fl+0IQ2T2+cVNqiqnUHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u38/aCx8m91C+tQNEVYShEGeIXi5/glhWHw3SiZcln0KglfnnZFmkYBBNLbfrteLaVcvBO6uXRZsCdPHkveZN4bfQzfgBeuMs9W/hSDgbfRDBHJs8AawtOqRJtdIwcNIWDX5xgPnGrbRfw6h0ZuK2/ZBGw1tlNZKoFftFeeHY3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fvKv45WkNzYQv23
	for <linux-raid@vger.kernel.org>; Mon, 13 Apr 2026 16:14:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 19DA44058D
	for <linux-raid@vger.kernel.org>; Mon, 13 Apr 2026 16:15:07 +0800 (CST)
Received: from [10.174.178.255] (unknown [10.174.178.255])
	by APP3 (Coremail) with SMTP id _Ch0CgAHtL0Jptxp2tD1AA--.58631S3;
	Mon, 13 Apr 2026 16:15:06 +0800 (CST)
Message-ID: <4be300df-3943-acf3-ace1-cf6316f2c936@huaweicloud.com>
Date: Mon, 13 Apr 2026 16:15:05 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 4/5] md: skip ID_BITMAP_NONE when show available bitmap
 types
To: Su Yue <glass.su@suse.com>, linux-raid@vger.kernel.org
Cc: song@kernel.org, xni@redhat.com, yukuai@fnnas.com, heming.zhao@suse.com,
 l@damenly.org
References: <20260407102625.5686-1-glass.su@suse.com>
 <20260407102625.5686-5-glass.su@suse.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260407102625.5686-5-glass.su@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAHtL0Jptxp2tD1AA--.58631S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Xr4UKF4UGrWxtFWkWr48WFg_yoWDCrg_ur
	4UZFWxW343Aa1kCFsxtw4fZrWYg3ZF93ZYyrsxtrZ7Aw1rXa45uFyxC34DJ348CFykCa47
	AryUt395Cr1fWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3kYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
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
	VFxhVjvjDU0xZFpf9x07UMnQUUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/4/7 18:26, Su Yue 写道:
> As none_bitmap_ops is introduced, ID_BITMAP_NONE should be skipped while
> iterating md submodules, otherwise:
> 
> $ cat /sys/block/md0/md/bitmap_type
> [none] bitmap llbitmap [none]
> 
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---
>   drivers/md/md.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 55a95b227b83..20a953676319 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4269,6 +4269,8 @@ bitmap_type_show(struct mddev *mddev, char *page)
>   	xa_for_each(&md_submodule, i, head) {
>   		if (head->type != MD_BITMAP)
>   			continue;
> +		if (head->id == ID_BITMAP_NONE)
> +			continue;
>   
>   		if (mddev->bitmap_id == head->id)
>   			len += sprintf(page + len, "[%s] ", head->name);

If we indeed add ID_BITMAP_NONE as patch 3, would it be better to delete
this piece of code instead?

         if (mddev->bitmap_id == ID_BITMAP_NONE)
                 len += sprintf(page + len, "[none] ");
         else
                 len += sprintf(page + len, "none ");

-- 
Thanks,
Nan

