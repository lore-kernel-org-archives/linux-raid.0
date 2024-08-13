Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890334963A;
	Tue, 13 Aug 2024 07:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534592; cv=none; b=uk5GtD0cXVJptb3zoW7zfLyADOOjKagUAxgkm3RFASBhCocq5jzcgM0dUNOHuhghnVsQUb9ayf6lWRThhqCBCDuFPvs6v3bjDkFky4vDtOdT/VosssslzFdh4tIZlDnvu6PbSgLOKe0Pb6C1r8proyavFpRFneLOjNG2StBofzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534592; c=relaxed/simple;
	bh=+h5Tf7dU7uJA6beHqVOim+jZtY4qWsc2Afashvogcak=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=LbHqUqUAGjmX/UE87j3fXUxzHiSCl20A7+T+P9B8AM034nE9vZ85cN1Sf3b/0RqA7Wm0LcB6bF49piIWxXr1Vh5fSOSGxyC0+xjWqHOM6f9S3MghVAnJLJEzP9bJTfPMtEDSw1Quuc7rs1sixk+pxXNGs1xLBTLPYo/PCl10CWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wjjqc5KD4z4f3jsG;
	Tue, 13 Aug 2024 15:36:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6F7011A170E;
	Tue, 13 Aug 2024 15:36:26 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB37IL5DLtmQ1k+Bg--.7907S3;
	Tue, 13 Aug 2024 15:36:26 +0800 (CST)
Subject: Re: [PATCH RFC -next 00/26] md/md-bitmap: introduce bitmap_operations
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240810020854.797814-1-yukuai1@huaweicloud.com>
 <ZrsJeabpeFdXVfIb@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9607d43d-5196-6a2a-dcd6-6471baaa3d70@huaweicloud.com>
Date: Tue, 13 Aug 2024 15:36:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZrsJeabpeFdXVfIb@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB37IL5DLtmQ1k+Bg--.7907S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tr18AFW7tFyrJFWrtFW8WFg_yoW8JFW5pF
	WkGayFkan8ArnF9Fn7trWUXa4a9aykWrsxGw1rGw1fGr98trnxWr18Ka1Yqas7Ars5W3ZF
	g345tr18Xw1DZFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUQo7NUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/



ÔÚ 2024/08/13 15:21, Christoph Hellwig Ð´µÀ:
> On Sat, Aug 10, 2024 at 10:08:28AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> The background is that currently bitmap is using a global spin_lock,
>> cauing lock contention and huge IO performance degration for all raid
>> levels.
>>
>> However, it's impossible to implement a new lock free bitmap with
>> current situation that md-bitmap exposes the internal implementation
>> with lots of exported apis. Hence bitmap_operations is invented, to
>> describe bitmap core implementation, and a new bitmap can be introduced
>> with a new bitmap_operations, we only need to switch to the new one
>> during initialization.
>>
>> And with this we can build bitmap as kernel module, but that's not
>> our concern for now.
>>
>> Noted I just compile this patchset, not tested yet.
> 
> Refactoring the bitmap code to be modular seems like a good idea.
> 
> But I'd just turn this into plain function calls and maybe a hidden
> data structure if you feel really fancy.  No need to introduce expensive
> indirect calls and a separate module.

Got it, and will make the struct bitmap a hidden structure in the next
version. This is exactly what I'm doing now locally, get rid of bitmap
direct dereference :).

Thanks for the review!
Kuai
> 
> .
> 

