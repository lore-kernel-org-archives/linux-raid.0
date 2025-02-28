Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79A0125B2
	for <linux-raid@vger.kernel.org>; Fri, 28 Feb 2025 02:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740708398; cv=none; b=stlyge8o3mdL3gwypd3TGduie7YgvYl0A3aOCygnQQGa5lSwl3xn1TkvI0T0pXRdQoLWhDZ6u4Hh1jhy3YTaoHTZPsL/YFY9C4qbWo3otXaz2bEZn0pnz56eT3cxXN50XmVZ8a/gMLymGKxokWQCDY/D5Dk5tTMo7utomYEwdSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740708398; c=relaxed/simple;
	bh=dkDEg3LWYVv80yl5UCBDtzamnGa1Ftdh8cly/8Da8kA=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=LU8zDR3XR52vsaX5yODyvpT3ZfJpUKVOJfVkc7cDgOpppwJMW65SEHTq2w+LzuunEIkzygInGjMjiEv3uq4JYFxiPFG0SXFiNmcEAHDrB6gRh98i+XZ7bq2Wd2vGeK9hwKt2zQCJpOaKxw8ksXaT41tQBLSR1zcQV+o20zGiqAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z3s4w4fkHz4f3kvf
	for <linux-raid@vger.kernel.org>; Fri, 28 Feb 2025 10:06:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 063341A0DBF
	for <linux-raid@vger.kernel.org>; Fri, 28 Feb 2025 10:06:32 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXu18mGsFnmu1pFA--.48864S3;
	Fri, 28 Feb 2025 10:06:31 +0800 (CST)
Subject: Re: md bitmap writes random memory over disks' bitmap sectors
To: Nigel Croxon <ncroxon@redhat.com>, yukuai1@huaweicloud.com,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
 Jonathan Derrick <jonathan.derrick@linux.dev>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <6083cbff-0896-46af-bd76-1e0f173538b7@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8318b662-e391-d7d2-0014-173a16c4bc20@huaweicloud.com>
Date: Fri, 28 Feb 2025 10:06:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <6083cbff-0896-46af-bd76-1e0f173538b7@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXu18mGsFnmu1pFA--.48864S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr1UGFy8tw4UWF1UtryDGFg_yoW8XFWxpa
	yrCF18G345tr1Fkwn7Z3ykZFyFyws5XasrKryrJFy3Cw45JF9Fgr4IgFWYg343AryxCF4U
	ZrsYvFyrAw10v3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/02/25 23:32, Nigel Croxon 写道:
> -       md_super_write(mddev, rdev, sboff + ps, (int) size, page);
> +       md_super_write(mddev, rdev, sboff + ps, (int)min(size, 
> bitmap_limit), page);
>          return 0;
> 
> This patch still will attempt to send writes greater than a page using 
> only a single page pointer for multi-page bitmaps. The bitmap uses an 
> array (the filemap) of pages when the bitmap cannot fit in a single 
> page. These pages are allocated separately and not guaranteed to be 
> contiguous. So this patch will keep writes in a multi-page bitmap from 
> trashing data beyond the bitmap, but can create writes which corrupt 
> other parts of the bitmap with random memory.

Is this problem introduced by:

8745faa95611 ("md: Use optimal I/O size for last bitmap page")

> 
> The opt using logic in this function is fundamentally flawed as 
> __write_sb_page should never send a write bigger than a page at a time. 
> It would need to use a new interface which can build multi-page bio and 
> not md_super_write() if it wanted to send multi-page I/Os.

I argree. And I don't understand that patch yet, it said:

If the bitmap space has enough room, size the I/O for the last bitmap
page write to the optimal I/O size for the storage device.

Does this mean, for example, if bitmap space is 128k, while there is
only one page, means 124k is not used. In this case, if device opt io
size is 128k, this patch will choose to issue 128k IO instead of just
4k IO? And how can this improve performance ...

Thanks,
Kuai

