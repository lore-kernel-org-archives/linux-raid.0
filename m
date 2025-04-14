Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0157D45C18;
	Mon, 14 Apr 2025 06:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744613316; cv=none; b=bmB4kaXzANVkpgS1XCxMU3GoD96ekNhdUJh5lFqQ/uubWwhnu0aEnBX4ouakyWCyDSQlJypjXEj2jlerqxn1py2AfqKu5mtmAMJxB2kr9cgh3o/gG5AsizcG4mfXCW2Vq5BWZ6nWzUuS5Wk+vULyRCwYd0ORjXDNBV5yMxdZu24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744613316; c=relaxed/simple;
	bh=xOklMPqVNN1X1dewtku3L5mCtFujrl6xMsh3ab6ehfA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lWKfdFRIL1+R7YbB0qTpT8bmguiNOEK9CnRVzqWzsFc05OeK8r5lpalDy0aj8aNjsTVKqLR9bqHtRTe1uVsOzDDteFE+ukn/6AZXhhT+eE+HZXX1sAdUGWUN2kOYF0YKUCis1Z+G2puli8vKQbccXMi00jA1EWWpiHz/YAIw1cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZbdCN6jVtz4f3lDG;
	Mon, 14 Apr 2025 14:48:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1D9801A0847;
	Mon, 14 Apr 2025 14:48:26 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAXe1+4r_xnsGu_JQ--.24636S3;
	Mon, 14 Apr 2025 14:48:25 +0800 (CST)
Subject: Re: [PATCH 1/4] block: export part_in_flight()
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, song@kernel.org, xni@redhat.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250412073202.3085138-1-yukuai1@huaweicloud.com>
 <20250412073202.3085138-2-yukuai1@huaweicloud.com>
 <Z_yr67xrbkuQwy0P@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <12e79682-21a3-9389-9390-14702d6ca389@huaweicloud.com>
Date: Mon, 14 Apr 2025 14:48:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Z_yr67xrbkuQwy0P@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXe1+4r_xnsGu_JQ--.24636S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww1ftF1xuw1rZF4ftF1xuFg_yoW8Gr4rpF
	4ftayUAr4Dur18ZF17ta13Za40yws0gr13Zr1rAr93XrZ8KrySkw10gws8Ka4Sva97tw47
	Wa1S9F97CF48A37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

ÔÚ 2025/04/14 14:32, Christoph Hellwig Ð´µÀ:
> On Sat, Apr 12, 2025 at 03:31:59PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> This helper will be used in mdraid in later patches, check if there
>> are normal IO inflight while generating background sync IO, to fix a
>> problem in mdraid that foreground IO can be starved by background sync
>> IO.
> 
> If we export this it needs a kerneldoc comment, and probably also
> a better name.

Sure about comment.
> 
> Looking at this I'm also a little confused about blk_mq_in_flight_rw vs
> blk_mq_in_flight and why one needs blk-mq special casing and the other
> not, maybe we need to dig into the history and try to understand that
> as well while we're at it.

There are two kinds of helpers:

1) part_in_flight and part_in_flight_rw
2) blk_mq_in_flight and blk_mq_in_flight_rw

1) is accounted at blk_account_io_start(), while 2) is
blk_mq_start_request(), I think this is the essential difference.

part_in_flight_rw() and blk_mq_in_flight_rw() is also used in sysfs API
inflight for bio/rq based device. And commit 7be835694dae ("block: fix
that util can be greater than 100%") convert blk_mq_in_flight() to
part_in_flight() from disk stats API. Now I just checked there is no use
for blk_mq_in_flight() anymore and maybe it can be removed.

Thanks,
Kuai

> 
> 
> .
> 

