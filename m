Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A6733F3;
	Tue,  9 Sep 2025 01:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757379777; cv=none; b=m/oOwOB+fn+3vEdZhRlYzQam6VVXoOAMxase15rGgzW533YE2og2ehhri4uUHGfrQcP6PdowEnFKk5QDnN2W1JsZ6CkQ9HqaankTX3IPXoQncUVbeRwpRGxzeLTIjO62OQSzQsPBpKkTRa2AreiCyx9Om/4l56k9ilPrAWkpPVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757379777; c=relaxed/simple;
	bh=2hKv+N/vmtvMw02UNXtSa5H5LaBjZjyq+UNAbr4YHvA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=aRPkf+MadQPsirrmzRf4j68Ldl4rKSs6389/g2xScEQKmUuWq3KOz/WExWmJmPYvdz7aJBbWvIpkbr9ktO4uIyhqmDUgs/REQvY8KayffuvjDAVXdWRW992z3mp7vAIxMwsACLUl1WTSGaYl5m0lX4kbeV+u5YeD1x048MunTog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cLQXr1PRFzYQtp7;
	Tue,  9 Sep 2025 09:02:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AC1951A0902;
	Tue,  9 Sep 2025 09:02:50 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDXIY65fL9o5X98Bw--.16106S3;
	Tue, 09 Sep 2025 09:02:50 +0800 (CST)
Subject: Re: [PATCH v3 1/3] md/raid1,raid10: Do not set MD_BROKEN on failfast
 io failure
To: Kenta Akagi <k@mgml.me>, Yu Kuai <yukuai1@huaweicloud.com>,
 Li Nan <linan666@huaweicloud.com>, Song Liu <song@kernel.org>,
 Mariusz Tkaczyk <mtkaczyk@kernel.org>, Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250828163216.4225-1-k@mgml.me>
 <20250828163216.4225-2-k@mgml.me>
 <dcb72e23-d0ea-c8b3-24db-5dd515f619a8@huaweicloud.com>
 <6b3119f1-486e-4361-b04d-5e3c67a52a91@mgml.me>
 <3ea67e48-ce8a-9d70-a128-edf5eddf15f0@huaweicloud.com>
 <29e337bc-9eee-4794-ae1e-184ef91b9d24@mgml.me>
 <6edb5e2c-3f36-dc2c-3b41-9bf0e8ebb263@huaweicloud.com>
 <7e268dff-4f29-4155-8644-45be74d4c465@mgml.me>
 <48902d38-c2a1-b74d-d5fb-3d1cdc0b05dc@huaweicloud.com>
 <34ebcc5b-db67-49e0-a304-4882fa82e830@mgml.me>
 <ae39d3a6-86a2-b90d-b5d6-887b7fc28106@huaweicloud.com>
 <7072d96b-c2d4-4225-ad4f-1cba8f683985@mgml.me>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <62365ca9-3cdb-c213-b0d4-5480ad734dd6@huaweicloud.com>
Date: Tue, 9 Sep 2025 09:02:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <7072d96b-c2d4-4225-ad4f-1cba8f683985@mgml.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXIY65fL9o5X98Bw--.16106S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr48uw18KFWfXr18CFy8Zrb_yoW8Gw43pa
	yDtayvyr4DAa4jg3WF9r18X3WFyF17Wry3Wr1fJrnrZws09rySgr4UXw4Y9F1DWrn8Aw18
	Aw4UKrWDZ3WFqaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/09/09 1:29, Kenta Akagi 写道:
> On 2025/09/08 10:20, Yu Kuai wrote:
>>
>>
>> 在 2025/09/02 0:48, Kenta Akagi 写道:
>>> In the current raid1_end_write_request implementation,
>>> - md_error is called only in the Failfast case.
>>> - Afterwards, if the rdev is not Faulty (that is, not Failfast,
>>>     or Failfast but the last rdev — which originally was not expected
>>>     MD_BROKEN in RAID1), R1BIO_WriteError is set.
>>> In the suggested implementation, it seems that a non-Failfast write
>>> failure will immediately mark the rdev as Faulty, without retries.
>>
>> I still prefer a common helper to unify the code, not sure if I still
>> missing something ...
>>
>> In general, if bio failed, for read/write/metadata/resync should be the
>> same:
>>
>> 1) failfast is set, and not last rdev, md_error();
>> 2) otherwise, we should always retry;
>>
>> And I do believe it's the best to unify this by a common helper.
> 
> Yes, I realized that my idea is bad. Your idea is best,
> especially considering the error handling in super_written.
> I'll implement a common helper.
> 
> By the way, I think md_error should only be serialized on RAID1 and 10
> for now. Serializing unnecessary personalities is inefficient and can
> lead to unfavorable results. What do you think?

Just make code cleaner and I don't have preference here, md_error is
super cold path I think.

Thanks,
Kuai

> 
> Thanks,
> Akagi
> 
>> Thanks,
>> Kuai
>>
>>
> 
> .
> 

