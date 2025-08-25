Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1102D5C9B;
	Mon, 25 Aug 2025 09:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756115348; cv=none; b=Hu15D2FPnn460h+wbHVaf59BCiwtCPrVz9X3b3JeDbX1NjwT2zrGywdM8+TBIC1P1o4FCP/SN1zpvP/Sip7Lm97ovLvhsHaAMEfKMmKL/FjqMklYMXjDUYuVrNzClSIzCmaaP2zSPjQf7QJZ3B+IAsLiP50lwbRd4E6Nm8JZ9cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756115348; c=relaxed/simple;
	bh=FCNe7R2tu9pEL+yxNl6HqlgLNxIQ1nzimAYmzB4Boeo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=i2TActjlNKxExxAu9fPPeKDrTmMFx5C/ROUpB5gc4nmgE2RoIPV0MRWrvo7NzsplLYe5owB9hEFHUuSxzZtd9dg3F8D6SiOtpmbtpxbvHnWSWmvYV/Z+dv9v82VHdIeFImjdstctjuX8y6DFjkqhKy7cp4EC8CS3BgtRkrvwG64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c9Qwv4mvkzKHNKY;
	Mon, 25 Aug 2025 17:49:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 409DC1A0839;
	Mon, 25 Aug 2025 17:49:03 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3QY6NMaxoyuHxAA--.63474S3;
	Mon, 25 Aug 2025 17:49:03 +0800 (CST)
Subject: Re: [PATCH] block: fix disordered IO in the case recursive split
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, neil@brown.name, akpm@linux-foundation.org,
 linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, colyli@kernel.org, xni@redhat.com,
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
 tieren@fnnas.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250821074707.2604640-1-yukuai1@huaweicloud.com>
 <aKbcM1XDEGeay6An@infradead.org>
 <54fc027f-f4dc-0412-0d6d-b44a3e644c39@huaweicloud.com>
 <aKbgqoF0UN4_FbXO@infradead.org>
 <060396d7-797e-b876-9945-1dc9c8cbf2b4@huaweicloud.com>
 <aKwqGHE_ImVwoH6B@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <dc98ae47-5abf-05dc-5441-547cbb4b9c80@huaweicloud.com>
Date: Mon, 25 Aug 2025 17:49:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aKwqGHE_ImVwoH6B@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3QY6NMaxoyuHxAA--.63474S3
X-Coremail-Antispam: 1UD129KBjvJXoWruFyfuFWkJw47Xr1Dtr13Arb_yoW8Jry7pF
	WfWa15Jw4qyF4a9as2qw4j93WFy393ZrW5ZFnYkr4DZr90gr92grnxJw4FkFyUGrWvga10
	vayFvrZ5Gw4UArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBa14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY
	6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aV
	CY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/08/25 17:17, Christoph Hellwig Ð´µÀ:
> On Thu, Aug 21, 2025 at 05:37:15PM +0800, Yu Kuai wrote:
>> Fix bio splitting by the crypto fallback code
> 
> Yes.
> 
>>
>> I'll take look at all the callers of bio_chain(), in theory, we'll have
>> different use cases like:
>>
>> 1) chain old -> new, or chain new -> old
>> 2) put old or new to current->bio_list, currently always in the tail,
>> we might want a new case to the head;
>>
>> Perhaps it'll make sense to add high level helpers to do the chain
>> and resubmit and convert all callers to use new helpers, want do you
>> think?
> 
> I don't think chaining really is problem here, but more how bios
> are split when already in the block layer.  It's been a bit of a
> source for problems, so I think we'll need to sort it out.  Especially
> as the handling of splits for the same device vs devices below the
> current one seems a bit problematic in general.
> 

I just send a new rfc verion to unify block layer and mdraid to use
the same helper bio_submit_split(), and convert only that helper to
insert split bio to the head of current->bio_list(). And probably
blk-crypto-fallback can use this new helper as well.

Can you take a look? This is the proper solution that I can think of
for now.

Thanks,
Kuai

> .
> 

