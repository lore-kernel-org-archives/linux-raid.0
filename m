Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA2018DB0D;
	Mon, 26 May 2025 08:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748247134; cv=none; b=LzafeF4mTkzzx8ypX7sxbFenA5ppsWMfrZqTAuzSFHUZRH7jkRV2w97fmaf4AhX7W10vP7cTZLytCrXeoVGjqs1/PbRf+SbjsSPWbP5HxdYPZ1KIqY8jpvx+lhh5WQafJbR4yUSqKIFYY1pC2SZ2xQApcf+u3cTs/BCHmJWRJfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748247134; c=relaxed/simple;
	bh=X7fMDGCsbBpqSlwjRsy6zU3JYRMFZwL3oXyJE1OQjPg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gpmJn/VtKDWUBLeJLy5gQF05JCcaJ7+DpVGV8J546MraE029SyFvkl7OyFGaVh54qbzS3bLNPQCnLHkhkoF93Y56D9ivVWft4t1dtXGresQ+dCaJilo9gXRY987rqELh6l7YYFxHHK1SUkkww2wi3alHXKryJzQFPuo6kw3RWSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4b5T4Z2lBqz4f3lDc;
	Mon, 26 May 2025 16:11:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 203551A0F0B;
	Mon, 26 May 2025 16:12:09 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl9XIjRoTfQ3Ng--.11988S3;
	Mon, 26 May 2025 16:12:08 +0800 (CST)
Subject: Re: [PATCH 12/23] md/md-bitmap: add macros for lockless bitmap
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, song@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-13-yukuai1@huaweicloud.com>
 <20250526064013.GE12811@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <40af768d-373c-4a56-8af5-82aeabe49515@huaweicloud.com>
Date: Mon, 26 May 2025 16:12:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250526064013.GE12811@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl9XIjRoTfQ3Ng--.11988S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKFyUXw17uFW7XFW7uF47CFg_yoWkCrXEgr
	9avas3J348Ja1rtwsIyw45ZFZ8K3WUA348GrZ7XF1xZrykJas8GF4kCrZIqrW5Ga1Fyw4f
	CryDXFWFvwnIvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU13ku3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/26 14:40, Christoph Hellwig Ð´µÀ:
> On Sat, May 24, 2025 at 02:13:09PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Also move other values to md-bitmap.h and update comments.
> 
> Hmm.  The commit message looks very confusing to me.
> 
> I think this should be two patches:
> 
>   1) move defines relevant to the disk format from md-bitmap.c to md-bitmap.h
>   2) add new bits for llbitmap (and explain what they are).

OK.

> 
>> +#define BITMAP_SB_SIZE 1024
> 
> And while we're at it: this is still duplicated in llbitmap.c later.
> But shouldn't it simply be replaced with a sizeof on struct bitmap_super_s?

Sorry that I forgot to explain why it's still in .c

sizeof(struct bitmap_super_s) is actually 256 bytes, while by default,
1k is reserved, perhaps I can name it as BITMAP_DATA_OFFSET ?

0-255B		bitmap_super_s
256-1023B	hole
1024-[space]	bitmap
[space] - 128k	hole

BTW, the new bitmap only support the default offset and space, user
can't configure it manually.

Thanks,
Kuai

> 
> (and when cleaning thing up, rename that to bitmap_super without
> the _s and use it instead of the typedef at least for all new code)?
> .
> 

