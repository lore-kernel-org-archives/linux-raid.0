Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3324C1AE844;
	Thu, 21 Aug 2025 08:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755766606; cv=none; b=JkQJ3sLxKTzxOW5EDX0P3JnY+qKvxeZu7cvJ5Kw4eD/ULuaErGvNg/xygj+uA7RSeS20hUJEmb/czTqj6+SR9VdbElOwlRNT5sYXDzyHGGD6EWM+ixC32P7x79Bl0Wb5k9m4bVXTtcorMFB6d2IMsUAvVHJJ20urbzEgNB/+llQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755766606; c=relaxed/simple;
	bh=ojTgrGCKPxcDJf5fNPh7HK4tXJI5lvpspffIagftjYc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YDobHH9XhJYkPxTGkoscjpORqKPVEfN0ERygmnYigo4j3byZv9GTLihUTbW3ycH9+WVG8qhAydlvZHb96yD8yr/V5wd/cTkfFQtmmiXZSs7pSd21r/y4kUBJnk8cr6KXblCnOjVm2oY3yIvE0RQOY0S+kW5r4a+DxaGfEZP8SHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c6xyF19kVzYQw2d;
	Thu, 21 Aug 2025 16:56:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B36711A1494;
	Thu, 21 Aug 2025 16:56:35 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDXUxRB36ZoygyuEQ--.8310S3;
	Thu, 21 Aug 2025 16:56:35 +0800 (CST)
Subject: Re: [PATCH] block: fix disordered IO in the case recursive split
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, neil@brown.name, akpm@linux-foundation.org,
 linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, colyli@kernel.org, xni@redhat.com,
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250821074707.2604640-1-yukuai1@huaweicloud.com>
 <aKbcM1XDEGeay6An@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <54fc027f-f4dc-0412-0d6d-b44a3e644c39@huaweicloud.com>
Date: Thu, 21 Aug 2025 16:56:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aKbcM1XDEGeay6An@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXUxRB36ZoygyuEQ--.8310S3
X-Coremail-Antispam: 1UD129KBjvdXoWruFyDWF1DKw4ftF47uF1UAwb_yoW3Krb_Wa
	1DCr1DAr1kCrZrArWjkFnYqr4kWr45Wr1xWrWfKF4xGr95G39xJF10yFsrZr1UGrn7K39I
	gFn0qa9293y7ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
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

ÔÚ 2025/08/21 16:43, Christoph Hellwig Ð´µÀ:
> On Thu, Aug 21, 2025 at 03:47:06PM +0800, Yu Kuai wrote:
>> +	if (current->bio_list) {
>> +		if (bio_flagged(bio, BIO_CHAIN))
>> +			bio_list_add_head(&current->bio_list[0], bio);
>> +		else
>> +			bio_list_add(&current->bio_list[0], bio);
>> +	} else if (!bdev_test_flag(bio->bi_bdev, BD_HAS_SUBMIT_BIO)) {
> 
> This breaks all the code the already chains the right way around,
> and there's quite a bit of that (speaking as someone who created a few
> instances).
> 
> So instead fix your submitter to chain the right way instead.
> 

Can you give some examples as how to chain the right way? BTW, for all
the io split case, should this order be fixed? I feel we should, this
disorder can happen on any stack case, where top max_sector is greater
than stacked disk.

Thanks,
Kuai

> 
> .
> 

