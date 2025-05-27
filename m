Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B0E142E6F;
	Tue, 27 May 2025 08:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748336141; cv=none; b=u2HKcAvzaJ5vF6nIAmIiXIIov683kn8I+M1RkLQSpQDw3SkflGY4w5hxuWGaFmBl1jC0inxE7yELsf1NtHBmrFErzd6wcQnDsULav7mpsBjUm8i1WFJDkC0VT57hQcGPWVXJ3EoFCQFojxNFT+rProKspWmMkRlGf8cpauKwO6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748336141; c=relaxed/simple;
	bh=aJIF+fqz29XOXPB5Pt16zi4q6rP09wVcco+skS8uyjY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JmC7zYl9ndJ/TiU173D02p9H8DqAXDp0EklQ0ULbbvqw1QTkHmwHPw6FVmNKVXmP8yp2MnCOA8Ke8744gq4Bc4jEKB5oym2I7dXXVSW+ontxxh2jpHA88TCCBydtxRIwxsfq0ui5+Qv/cAlhuYbZGLaAUev1IlXHtKfPhC6eij8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4b660F5Xbrz4f3jY1;
	Tue, 27 May 2025 16:55:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0DA641A0DAA;
	Tue, 27 May 2025 16:55:35 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAXe18EfjVoi+6hNg--.29395S3;
	Tue, 27 May 2025 16:55:34 +0800 (CST)
Subject: Re: [PATCH 15/23] md/md-llbitmap: implement llbitmap IO
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, song@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-16-yukuai1@huaweicloud.com>
 <20250527082709.GA32108@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6eea2fad-f405-ed20-73f3-c26542b401bf@huaweicloud.com>
Date: Tue, 27 May 2025 16:55:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250527082709.GA32108@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXe18EfjVoi+6hNg--.29395S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr18WF45uFy8GF1Dur4UArb_yoW8Gr1xpF
	4rWFy3GFn5JF10gwn7GryYgF1fKa1ktry3Crn8A3s3u3s0vrn3tFs7KFWUC3s3Wrn8JFs2
	q3W5K398Ja1qv3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x
	0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUqeHgUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/27 16:27, Christoph Hellwig Ð´µÀ:
> FYI, I still find splitting the additioon of the new md-llbitmap.c into
> multiple patches not helpful for reviewing it.  I'm mostly reviewing
> the applied code and hope I didn't forget to place anything into the
> right mail.
> 
>> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
>> new file mode 100644
>> index 000000000000..1a01b6777527
>> --- /dev/null
>> +++ b/drivers/md/md-llbitmap.c
>> @@ -0,0 +1,571 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +#ifdef CONFIG_MD_LLBITMAP
> 
> Please don't ifdef the entire code in a sourc file, instead just compile
> it conditionally:
> 
> 
> md-mod-y        += md.o md-bitmap.o
> md-mod-$(CONFIG_MD_LLBITMAP) += md-llbitmap.o
> 

Thanks for the suggestion, this is indeed better.

>> +	BitNeedSync,
>> +	/* data is synchronizing */
>> +	BitSyncing,
>> +	nr_llbitmap_state,
> 
> Any reason nr_llbitmap_state, doesn't follow the naming scheme of the other
> bits,?

I'm following the enum name(enum llbitmap_state) here, because this is
the number to total bits, not a meaningful bit.

Do you prefer a name like BitStateCount?

Thanks,
Kuai

> 
>> +	BitmapActionStale,
>> +	nr_llbitmap_action,
> 
> Same here?
> 
>> +			if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
> 
> Overly long line.
> .
> 

