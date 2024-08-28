Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD0115E5B5;
	Wed, 28 Aug 2024 09:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724836421; cv=none; b=ZfyMR2l0SVjRXPAlOp32caC3tEP5xQGJj9/7O6MmuJGXNR/nreNxZSKv8LzO49zuIur8x0mVugNbENcd+6uXPrTSMf8VrPy3gwVZls4kPH8CHhEJMqq8/mm2g+QgHXhwynMyRTVgZn2cP4FJSs1KBW0RzkakyHio3SF98C7VYVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724836421; c=relaxed/simple;
	bh=my1j5FvugVUV25xBnj5k5mZl9KjOhaywMZwYI1x9wwg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JFSzJAmgkAaQNC9XF17R11UNiU2lSkdieuW6GyCadz6TKpTc76OI1gAk8pZLD3bKGAdaOocJtrkA843bM14HJXiCkSxE3qcoGNPNwnxHQ1L2mkxOeoVtBFfp+ov6eeavYayUT86TcO1sZrNazdUNNaq6r7kHfCymQnQIE4LdsOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WtzGn0QHMz4f3jMP;
	Wed, 28 Aug 2024 17:13:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9EEAC1A0359;
	Wed, 28 Aug 2024 17:13:35 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB3n4U96s5mS5THCw--.35306S3;
	Wed, 28 Aug 2024 17:13:35 +0800 (CST)
Subject: Re: [PATCH md-6.12 v2 00/42] md/md-bitmap: introduce
 bitmap_operations and make structure internal
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Song Liu <song@kernel.org>, mariusz.tkaczyk@linux.intel.com,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
 <CAPhsuW6NOW9wuYD3ByJbbem79Nwq5LYcpXDj5RcpSyQ67ZHZAA@mail.gmail.com>
 <5efeec29-cf13-a872-292c-dd7737a02d68@huaweicloud.com>
 <CALTww2-Z7fp3O2ZELT=HQsxVqfFs1KZGMgQ6TJ4VKgBbeV1dhw@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d8447fb3-f71e-c202-a301-39132ea3562c@huaweicloud.com>
Date: Wed, 28 Aug 2024 17:13:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww2-Z7fp3O2ZELT=HQsxVqfFs1KZGMgQ6TJ4VKgBbeV1dhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3n4U96s5mS5THCw--.35306S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tr4fJFy7tw43XrWkGr1kGrg_yoW8WryfpF
	9xJ3WUt3ykC3WrtFnFqr10qFyrtFn7Zr429w1rGr17Gr98KF9xZrs7Krs8uFnIyFykZa1Y
	9ay8Xa4fWr4UXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/28 9:31, Xiao Ni 写道:
> On Wed, Aug 28, 2024 at 9:15 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2024/08/28 4:32, Song Liu 写道:
>>> On Mon, Aug 26, 2024 at 12:50 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>>
>>> [...]
>>>>
>>>> And with this we can build bitmap as kernel module, but that's not
>>>> our concern for now.
>>>>
>>>> This version was tested with mdadm tests. There are still few failed
>>>> tests in my VM, howerver, it's the test itself need to be fixed and
>>>> we're working on it.
>>>
>>> Do we have new test failures after this set? If so, which ones?
>>
>> No, there are new failures.
> 
> Hi all
> 
> I suggest running lvm2 regression tests too. I can't run it myself now
> because I can't get a stable network connection all the time.
> 

Today, I run one round of the lvm2 tests with following script in my VM:
for t in `ls test/shell`; do
         if cat test/shell/$t | grep raid &> /dev/null; then
                 make check T=shell/$t
         fi
done

And the failed tests are:
[root@fedora lvm2]# cat log1 | grep "###   " | grep failed
###       failed: [ndev-vanilla] shell/lvconvert-raid-reshape-size.sh
###       failed: [ndev-vanilla] shell/lvconvert-repair-raid.sh

Then, I revert this set and test above tests again, they still fail. So
I didn't dig into these tests. :)

Thanks,
Kuai

> Best Regards
> Xiao
>>
>> Thanks,
>> Kuai
>>
>>>
>>> Thanks,
>>> Song
>>>
>>>> Yu Kuai (42):
>>>>     md/raid1: use md_bitmap_wait_behind_writes() in raid1_read_request()
>>>>     md/md-bitmap: replace md_bitmap_status() with a new helper
>>>>       md_bitmap_get_stats()
>>>
>>> [...]
>>> .
>>>
>>
> 
> 
> .
> 

