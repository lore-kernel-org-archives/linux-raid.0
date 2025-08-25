Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877A220A5C4;
	Mon, 25 Aug 2025 06:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756102557; cv=none; b=pBso1Zk9hY20EU2Cmi13A/AM2yUiK3UlVcY1hQ7hGTrXRvfaP5UCbyTd0Z3nYLRsRtbgtuKKalGvd1RWm5qvqNool6y/8tldI99Fi/Y5ciPVbBHGSKPVIVgn/y64ORORFwxpmt+rQFiNxwq4oP2xAEMwDApBgsC7cbNHrVwFH3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756102557; c=relaxed/simple;
	bh=U97WVDPZFYoUgWdt+TuwlTAS+SfYDfaU00t+WmyHZtg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=WvZjHWXb01Kt3cceVsBtJPiAwgcu6stx26OKzSupy2B9m+/vzWW/xdBUalWjFlsO+AZeUZYwSQV5EpceDKrQKlsslaFKOJGpSDsarwYLTZ4VcvysPNJREgXLfWUaN3ozwGa0B9IPyHieQWdvamAbTht6jKVFI8HIkfzDPfodEek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c9LBw2TbmzKHLyH;
	Mon, 25 Aug 2025 14:15:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E48B61A129A;
	Mon, 25 Aug 2025 14:15:51 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCX4o6V_6toKrDgAA--.58258S3;
	Mon, 25 Aug 2025 14:15:51 +0800 (CST)
Subject: Re: [PATCH] block: fix disordered IO in the case recursive split
To: Yu Kuai <yukuai1@huaweicloud.com>, Christoph Hellwig <hch@infradead.org>
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <510600c4-5ff3-a02e-de6d-020fad771425@huaweicloud.com>
Date: Mon, 25 Aug 2025 14:15:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <060396d7-797e-b876-9945-1dc9c8cbf2b4@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCX4o6V_6toKrDgAA--.58258S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtF4DtrWxAFW3Cr15CF1Utrb_yoW3GrcEva
	9akw4DCw1UA3s29as8Krnxt3yvgw4rJr4xXF98GF4Y9r98JryDG3W5C39xZrWrurn5Xwn3
	u3ykXry0qryYgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
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

在 2025/08/21 17:37, Yu Kuai 写道:
> 在 2025/08/21 17:02, Christoph Hellwig 写道:
>> On Thu, Aug 21, 2025 at 04:56:33PM +0800, Yu Kuai wrote:
>>> Can you give some examples as how to chain the right way?
>>
>> fs/xfs/xfs_bio_io.c: xfs_rw_bdev
> 
> Just take a look, this is
> 
> old bio->new bio
> 
> while bio split is:
> 
> new_bio->old bio
> 
> So xfs_rw_bdev won't flag old bio as BIO_CHAIN, while old bio will still
> be resubmitted to current->bio_list, hence this patch won't break this
> case, right?

And xfs_rw_bdev() is not under submit_bio() context, current->bio_list
is still NULL, means xfs_rw_bdev() is submitting bio one by one in the
right lba order, the bio recursive handling is not related in this case.

Thanks,
Kuai

