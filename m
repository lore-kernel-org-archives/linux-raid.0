Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366BD219A7D;
	Thu, 25 Sep 2025 09:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758790923; cv=none; b=O3tB1/Oayt8ZVX9pFqZGwZmDzJOjKsXZIaHCoT+QmRPp7YWTFiK+ACDNHV8fCZo4T/Qk59/hV63F89YXTZgplnRTsvbwOBbvyP/i4UTGHhsZWoUmC88GNkrI5Xs02TJAhKZ19wD6nOKC8VtEpjbOhnjAVPDqCqT9EFwyvcXM8A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758790923; c=relaxed/simple;
	bh=maIJ4TR91gEWbjfND2qRjo0K5H/zlUG2zC0c1SuCbrQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=J1zJVdaqfJY6+mcg5EhwU40XUV/WIzdEKuDS7JZZQfPcin3Zy0SExoylFcI9e3IClyGMA66qfQALlVRJQK90qHBhsUTKfSEmsxA0FX+j/ZQdh1mG9VDes0+MP6O2ok0VaOsRMgP/vNF4YA7+45J6VUj1h/sItwfpsxFmdhnSR6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cXSQ62wYBzKHMvJ;
	Thu, 25 Sep 2025 17:01:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4D2791A084B;
	Thu, 25 Sep 2025 17:01:58 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCXW2MEBdVoThULAw--.12884S3;
	Thu, 25 Sep 2025 17:01:58 +0800 (CST)
Subject: Re: [PATCH 5/7] md/raid10: fix any_working flag handling in
 raid10_sync_request
To: linan666@huaweicloud.com, song@kernel.org, neil@brown.name,
 namhyung@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250917093508.456790-1-linan666@huaweicloud.com>
 <20250917093508.456790-6-linan666@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2d94765c-219b-75f5-30fa-79a7324ba525@huaweicloud.com>
Date: Thu, 25 Sep 2025 17:01:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250917093508.456790-6-linan666@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXW2MEBdVoThULAw--.12884S3
X-Coremail-Antispam: 1UD129KBjvdXoWrXFWDWF15Kr1xKF45ury8Krg_yoWxGrXEka
	y5tFZ5Xr4Iyr1Iyw15GryIqr4Sgay5Wws5ua4DtryrZa4ava48Kas0g3Z5ZF43XFZ0gasx
	C3W0qr9IvrsF9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUpwZcUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/09/17 17:35, linan666@huaweicloud.com Ð´µÀ:
> From: Li Nan<linan122@huawei.com>
> 
> In raid10_sync_request(), 'any_working' indicates if any IO will
> be submitted. When there's only one In_sync disk with badblocks,
> 'any_working' might be set to 1 but no IO is submitted. Fix it by
> setting 'any_working' after badblock checks.
> 
> Fixes: e875ecea266a ("md/raid10 record bad blocks as needed during recovery.")
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/raid10.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

