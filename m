Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0507F2F745D;
	Wed, 27 Aug 2025 03:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756266305; cv=none; b=tyHtrg6bzJ1bBrpxETUSUEBmgexYCpXOhDi6fUWxe2rlAkyT+szPUReXdL/8NwT9PcNeqt21/jKBk4CLUVvdWrPeFSGsywUL+pJ0GpIpAUYutboI5pL1C/oJk+Hid5ce5rbyj+b6ex+70s36bMWMrkkj90uGqEWFcXvMSu72ri4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756266305; c=relaxed/simple;
	bh=IzA+zlZANtCcfm/OoIkm3c87o5aHOFLp0+8E3+hzmzg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=EeYt5djDb5+Zv/NHIfmGeHtK1JvlJS+pBNgY7H1GyR5jYKXIjzxRJw1/+MLXc7s0yiNsR2B1njbbXJ/Gy04LlXfgqFA7/8UYSEsny9U9wLqhWnuKQjYk2HtOIasmh0Depbx/bS/gi2QHMqTgm/u63S1kTfSHEc6kPZ7DzSmBAnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cBVlx0qbqzKHMk3;
	Wed, 27 Aug 2025 11:45:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BAF681A10DA;
	Wed, 27 Aug 2025 11:45:00 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDnMY46f65oLHq6AQ--.48889S3;
	Wed, 27 Aug 2025 11:45:00 +0800 (CST)
Subject: Re: [PATCH v6 md-6.18 11/11] md/md-llbitmap: introduce new lockless
 bitmap
To: Paul Menzel <pmenzel@molgen.mpg.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, corbet@lwn.net, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, xni@redhat.com, hare@suse.de,
 linan122@huawei.com, colyli@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250826085205.1061353-1-yukuai1@huaweicloud.com>
 <20250826085205.1061353-12-yukuai1@huaweicloud.com>
 <4d21e669-f989-4bbc-8c38-ac1b311e8d01@molgen.mpg.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <65a2856a-7e2f-111a-c92e-7941206ad006@huaweicloud.com>
Date: Wed, 27 Aug 2025 11:44:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4d21e669-f989-4bbc-8c38-ac1b311e8d01@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnMY46f65oLHq6AQ--.48889S3
X-Coremail-Antispam: 1UD129KBjvdXoWruryDXFyrZFWrJr4rtFWxXrb_yoWDCrX_ZF
	s8Z34qqayUCws8tr4vyFW0vry0ka4DuF48X34a9ryrAFykXFZxWFs3C3sa9r1rCayUX3Wf
	Aw1DJrWak3WxWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRidbbtUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/08/26 17:52, Paul Menzel 写道:
> It’d be great if you could motivate, why a lockless bitmap is needed  > compared to the current implemention.

Se the performance test, old bitmap have global spinlock and is bad with
fast disk.

[snip the typo part]

> How can/should this patch be tested/benchmarked?

There is pending mdadm patch, rfc verion can be used. Will work on
formal version after this set is applied.

> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -9,10 +9,26 @@
>    #define BITMAP_MAGIC 0x6d746962
> +/*
> + * version 3 is host-endian order, this is deprecated and not used for new
> + * array
> + */
> +#define BITMAP_MAJOR_LO        3
> +#define BITMAP_MAJOR_HOSTENDIAN    3
> +/* version 4 is little-endian order, the default value */
> +#define BITMAP_MAJOR_HI        4
> +/* version 5 is only used for cluster */
> +#define BITMAP_MAJOR_CLUSTERED    5  > Move this to the header in a separate patch?

I prefer not, old bitmap use this as well.

Thanks,
Kuai

