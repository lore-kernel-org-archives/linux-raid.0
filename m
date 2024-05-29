Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF5E15CD41;
	Wed, 29 May 2024 06:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716962909; cv=none; b=D8JHyie4rcs1MVKhUkCY7CdV/DPy5bE2UF1ySRp7YWAViFKqbYLZGGVPPLSdM+GrdD6ypx8nc5OXNv6SDVbA3+o4UmrRYiF6b0WCmzRp66pxcZEs5uJXeMaO+cVuD4YWDRlvx4T0VgSsfIyyXmhERZYiOiamfhQIWqROmss3KT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716962909; c=relaxed/simple;
	bh=fcgG25lIxVnelVDTENHtDJb72EPGR4FZzZ5wD20KqI4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KqO3r/oaXGfebmDJjLLKtSDMmHosPxxFXqpzjYosiog8nrXE7vPKj2WjbYOT++DtcHJupiY+eTDaq1gXN+si+MEvNmjpcNEMBi2Uknre0NS9ik6AanNZsS1j4+29Rfi0x/lXnRQgFbNQwqwOK8I+d166WHIO0T36flTbrdjPvgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VpzT75hyVz4f3n5d;
	Wed, 29 May 2024 14:08:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 9620C1A01D2;
	Wed, 29 May 2024 14:08:22 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHZQ5UxlZmgL3rNw--.35803S3;
	Wed, 29 May 2024 14:08:22 +0800 (CST)
Subject: Re: [PATCH v2] md: make md_flush_request() more readable
To: Christoph Hellwig <hch@infradead.org>, Li Nan <linan666@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20240528203149.2383260-1-linan666@huaweicloud.com>
 <ZlXa5mFl9x4Lk4KQ@infradead.org>
 <bc582a25-2124-2aa8-f26b-94fd5a50f900@huaweicloud.com>
 <ZlbAo1XgsPAxQ2Qe@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <dc394cf0-337d-a216-2fb2-8813e4c82575@huaweicloud.com>
Date: Wed, 29 May 2024 14:08:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZlbAo1XgsPAxQ2Qe@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHZQ5UxlZmgL3rNw--.35803S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtry5trWfAFy8KrWktFyrJFb_yoWfJFcEg3
	WSvrZrWr4DXr95Kr4qkw1vv39Y9ryUGF1rWFZxKFW8G3s5ArWDJF1Du395Za4xt3yIqFsI
	9a9FqFWaq34jgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/05/29 13:44, Christoph Hellwig 写道:
> On Tue, May 28, 2024 at 09:49:44PM +0800, Li Nan wrote:
>>
>>
>> 在 2024/5/28 21:23, Christoph Hellwig 写道:
>>> Looks good:
>>>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>
>>> .
>> As suggested by Kuai, I will use bio_sectors instead of bi_size in v3.
>>
>> -       if (bio->bi_iter.bi_size == 0) {
>> +       if (!bio_sectors(bio)) {
> 
> That looks weird.   bio_sectors literally just shifts
> bio->bi_iter.bi_size to be in units of sectors, which doesn't
> matter for comparing with 0.

The block layer use the same code several times to check if flush bio
contain data, for example:

submit_bio_noacct
  if (op_is_flush(bio->bi_opf))
   if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
    if (!bio_sectors(bio))
     bio_endio(bio);

Or will the bi_size to be less than one sector?

Thanks,
Kuai
> 
> .
> 

