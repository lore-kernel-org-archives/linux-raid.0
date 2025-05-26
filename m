Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39752136349;
	Mon, 26 May 2025 07:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748244532; cv=none; b=D95PjL/S/YAeXKExyn8DNgmmk5MWLmwH7RPbqKuAP0cLWhhPBG+VifQ/84k2pp81gNyYlKArphi6vByS/QnPQaZ9HEGTpb6JdH51U3+igw6zDbIWAMesxDkcyEtgT3s9cDsi1lNie9w+B6/Y5MsEjsW4nqJgKfjUEtO7aLvrn88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748244532; c=relaxed/simple;
	bh=1Xp4cd5s2O6SqWi4xlQf0/9NNfx7uvU2mHKZG/rrOo8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TmWHDoD+gY4H/EnYGU8JLn/OYCooYNgCSlfI56fqpk3s2m9DDcbULjTQfO8M6filpFxT44LhmfoEulqT/XrJ7OMXqGt8PMMj8+50nkcV/3CAyBcwignJCi3lDtgZCKaLICPElKCMax9VFXM9iQV5zEsVQgLY3RPbKXu5IoavEWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4b5S6f4wYnz4f3jt0;
	Mon, 26 May 2025 15:28:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BBD5B1A1CF6;
	Mon, 26 May 2025 15:28:46 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2AsGDRootk0Ng--.16762S3;
	Mon, 26 May 2025 15:28:46 +0800 (CST)
Subject: Re: [PATCH 01/23] md: add a new parameter 'offset' to
 md_super_write()
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, song@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-2-yukuai1@huaweicloud.com>
 <20250526062820.GA12730@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a5c43105-a864-910d-94c3-bf815e2fc596@huaweicloud.com>
Date: Mon, 26 May 2025 15:28:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250526062820.GA12730@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2AsGDRootk0Ng--.16762S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKw4kZw48Xw4DKF4DGFWktFb_yoW3GFbE93
	Z2yF48WF1DWrn5tr17Cw1IvFWDX3WUG3WDXFWFqFWkJrWkJ397Ary5Wr95Z34jvryxJ3WY
	v3Z3WFyfta1jgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/26 14:28, Christoph Hellwig Ð´µÀ:
> On Sat, May 24, 2025 at 02:12:58PM +0800, Yu Kuai wrote:
>> -void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
>> -		   sector_t sector, int size, struct page *page)
>> +void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
>> +		       sector_t sector, int size, struct page *page,
>> +		       unsigned int offset)
> 
> Maybe add a little command explaining what it does?

OK.
> 
>> +extern void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
>> +			      sector_t sector, int size, struct page *page,
>> +			      unsigned int offset);
> 
> No need for the extern.  Otherwise looks good:

Got it.
Thanks for the review!

Kuai

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> .
> 

