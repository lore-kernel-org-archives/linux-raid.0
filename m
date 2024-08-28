Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949B2442C;
	Wed, 28 Aug 2024 01:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724807737; cv=none; b=kkMTdVQ9CyV7z1K72xM3nrkIkKA2EaAOGdDqZGPfHC4XqXo7dvaSi6zJ1ePVqvkLlg40rAvWvTkq6OA43O+1Sr6ve3fAE4GiKrfjkkvQXdJSM8po84bQqn43ZrVwvyQyQCBYZlSItsxvIOChem76r7tA/HDdiR+WOqev5rZyv2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724807737; c=relaxed/simple;
	bh=Y+gYAukgE39yoKxYdBAwlvlGNX4WZY3xLc1uhsYJpTc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=EM0RCz1u1Cpk8pQ3VUJ3mYLkcdOEqgnhK+f4wxCPEkOQQDFOOQbSj9W2YVs2zF6BfE/SDzLra6+85CaC3N36kS1k3GFv9Ax056gbM4RWBA/9JjbaU8XMyPjbpp6VrY4XWSWWe1qnY+Kxrxn17B0hR6iDiLhATknC6zBvoBUNJmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wtmg82pjDz4f3jMr;
	Wed, 28 Aug 2024 09:15:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EC0981A07B6;
	Wed, 28 Aug 2024 09:15:30 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHr4Uxes5mFzKoCw--.23691S3;
	Wed, 28 Aug 2024 09:15:30 +0800 (CST)
Subject: Re: [PATCH md-6.12 v2 00/42] md/md-bitmap: introduce
 bitmap_operations and make structure internal
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@linux.intel.com, xni@redhat.com,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
 <CAPhsuW6NOW9wuYD3ByJbbem79Nwq5LYcpXDj5RcpSyQ67ZHZAA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5efeec29-cf13-a872-292c-dd7737a02d68@huaweicloud.com>
Date: Wed, 28 Aug 2024 09:15:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6NOW9wuYD3ByJbbem79Nwq5LYcpXDj5RcpSyQ67ZHZAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHr4Uxes5mFzKoCw--.23691S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZF1kZFy5tw4kCw4Uury5CFg_yoWxKrbEvw
	1jyrykWw43AF42k3W7XF45ZrZ0y3s3GFnxX395tFW8Z34rZa43CFsYk34ftFn3Ww4Syr9a
	9rWjy3yrtr15AjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa
	73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/28 4:32, Song Liu 写道:
> On Mon, Aug 26, 2024 at 12:50 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
> [...]
>>
>> And with this we can build bitmap as kernel module, but that's not
>> our concern for now.
>>
>> This version was tested with mdadm tests. There are still few failed
>> tests in my VM, howerver, it's the test itself need to be fixed and
>> we're working on it.
> 
> Do we have new test failures after this set? If so, which ones?

No, there are new failures.

Thanks,
Kuai

> 
> Thanks,
> Song
> 
>> Yu Kuai (42):
>>    md/raid1: use md_bitmap_wait_behind_writes() in raid1_read_request()
>>    md/md-bitmap: replace md_bitmap_status() with a new helper
>>      md_bitmap_get_stats()
> 
> [...]
> .
> 

