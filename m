Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19FA2D9ED8;
	Thu, 21 Aug 2025 09:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755769043; cv=none; b=s1tM9Fv9jqnwf6PT6/RxgErJjixqstDmWNG0ULIF5jPOoToCwnMojvU1QS7gY91iWJydD2ucLRQSAj2hhzjZcdA0QFL6Kl8jHk+7izfouDRxq71cPzO0+HRvHEruYmLyS1B6tcCHblHgX/0goV1kRSHKRwbssfNnIsF3Quu1Fvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755769043; c=relaxed/simple;
	bh=n4fIBJ6MbfStIGrhDd09fFWKmMINwX0H3pKE+b6YzSQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=QvrfMQ8W+KxEvK64sdFAfP+5sSQVXRi7hG8boqLP5c63R6BwY9Xq15znK/Eum+yxAS2c1nQuu3Lx+fVU1MbYbGr5ZapBvcAcmPRjGeqK154moje3ONB5IC3zx4yTnoP9E5V4WzIxP8xRBUqX95xbJU7IQBe/veU4r3Io/KPiAuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c6ysB1rqlzKHMST;
	Thu, 21 Aug 2025 17:37:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B04971A0D11;
	Thu, 21 Aug 2025 17:37:17 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHzw_L6KZoEFaxEQ--.38020S3;
	Thu, 21 Aug 2025 17:37:17 +0800 (CST)
Subject: Re: [PATCH] block: fix disordered IO in the case recursive split
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, neil@brown.name, akpm@linux-foundation.org,
 linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, colyli@kernel.org, xni@redhat.com,
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>, tieren@fnnas.com
References: <20250821074707.2604640-1-yukuai1@huaweicloud.com>
 <aKbcM1XDEGeay6An@infradead.org>
 <54fc027f-f4dc-0412-0d6d-b44a3e644c39@huaweicloud.com>
 <aKbgqoF0UN4_FbXO@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <060396d7-797e-b876-9945-1dc9c8cbf2b4@huaweicloud.com>
Date: Thu, 21 Aug 2025 17:37:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <aKbgqoF0UN4_FbXO@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHzw_L6KZoEFaxEQ--.38020S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw4DGF1xKw47Gw47CFWUXFb_yoW8Wrykpw
	n3Wan5tr4DtF1SkF9rWr4jq3WrA3yrXry8AF9agFn3Zay5KrnrZrn3Ja1Fkry5WFyDKayq
	vrWxt345W3y5ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/08/21 17:02, Christoph Hellwig Ð´µÀ:
> On Thu, Aug 21, 2025 at 04:56:33PM +0800, Yu Kuai wrote:
>> Can you give some examples as how to chain the right way?
> 
> fs/xfs/xfs_bio_io.c: xfs_rw_bdev

Just take a look, this is

old bio->new bio

while bio split is:

new_bio->old bio

So xfs_rw_bdev won't flag old bio as BIO_CHAIN, while old bio will still
be resubmitted to current->bio_list, hence this patch won't break this
case, right?

I'll take look at all the bio_chain() callers other than split case to
make sure.
> fs/xfs/xfs_buf.c: xfs_buf_submit_bio

This is a little different, new bio -> old bio, while new bio is
resubmitted, the new bio still don't have flag BIO_CHAIN, so this is not
affected by this patch.

> fs/xfs/xfs_log.c: xlog_write_iclog

This is the same as above.
> 
>> BTW, for all
>> the io split case, should this order be fixed? I feel we should, this
>> disorder can happen on any stack case, where top max_sector is greater
>> than stacked disk.
> 
> Yes, I've been trying get Bart to fix this for a while instead of
> putting in a workaround very similar to the one proposed here,
> but so far nothing happened.
> 

Do you mean this thread?

Fix bio splitting by the crypto fallback code

I'll take look at all the callers of bio_chain(), in theory, we'll have
different use cases like:

1) chain old -> new, or chain new -> old
2) put old or new to current->bio_list, currently always in the tail,
we might want a new case to the head;

Perhaps it'll make sense to add high level helpers to do the chain
and resubmit and convert all callers to use new helpers, want do you
think?

Thanks,
Kuai

> .
> 

