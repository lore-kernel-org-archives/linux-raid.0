Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400B63B1AF;
	Fri, 25 Oct 2024 01:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729820361; cv=none; b=d3zpVCHynAM3jAicd/HkJjpGLUUtsHP+KhCwYQccpEfLVEnQDlJ6U+ADRnjviNzWjsZF9Y/nP33HD5a8NZqx+Bq99sEZHTQNmIXP369qTmz01Ec8AwlqEleOiHFren3xY9sGuBEHOx97i5GlvfXz48yQZvjKccTDRIA9LfcM0qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729820361; c=relaxed/simple;
	bh=Lh4vwJ+pyZ0F6Xqc1uRRkWpp54/qwKgligFRKznTP4g=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=LWkuU/a0OB180Z5xsB1cYUzljc65PvMm4MzCEiCLEF6mjBcKg/1vh/908nGuZ50RhkGtD1l4VHmJX/P2mwaA++1noT9HbYfuInPbIiZ/ZXDbi70k6ruAPal2nk29p36SfTMU//i34f3N7T/dSOVcsSzZSeYGPO9r0jn5lHDETiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XZQRh2M6Qz4f3jJ1;
	Fri, 25 Oct 2024 09:38:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CA2011A0568;
	Fri, 25 Oct 2024 09:39:13 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgDH+8e_9hpnS3grFA--.63561S3;
	Fri, 25 Oct 2024 09:39:13 +0800 (CST)
Subject: Re: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Geoff Back <geoff@demonlair.co.uk>, axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-6-john.g.garry@oracle.com>
 <bc4c414c-a7aa-358b-71c1-598af05f005f@huaweicloud.com>
 <0161641d-daef-4804-b4d2-4a83f625bc77@oracle.com>
 <c03de5c7-20b8-3973-a843-fc010f121631@huaweicloud.com>
 <44806c6f-d96a-498c-83e1-e3853ee79d5a@oracle.com>
 <59a46919-6c6d-46cb-1fe4-5ded849617e1@huaweicloud.com>
 <6148a744-e62c-45f6-b273-772aaf51a2df@oracle.com>
 <be465913-80c7-762a-51f1-56021aa323dd@huaweicloud.com>
 <0cf7985e-e7ac-4503-827b-eb2a0fd6ef67@oracle.com>
 <098e65e7-53fb-4bf1-b973-2bda425139ae@demonlair.co.uk>
 <5a16f8c2-d868-48cf-96c8-a0d99e440ca5@oracle.com>
 <ea19f2f4-32e8-e551-c59d-19185da1be0a@huaweicloud.com>
 <3654e52e-d51e-4a61-aead-789e745599bf@oracle.com>
 <95915b76-97ce-55b1-6a5a-7ff8a89bc430@huaweicloud.com>
 <82a49b38-2732-4461-a714-908877714f35@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <fa43e80c-0aab-b4bf-039f-c3b70856335b@huaweicloud.com>
Date: Fri, 25 Oct 2024 09:39:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <82a49b38-2732-4461-a714-908877714f35@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDH+8e_9hpnS3grFA--.63561S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AF1ftrW5uFW5JF1UJF1UKFg_yoW8JF4kpa
	yDWan7Kr4jyasYyw1qkF47Xw4YyayYyayrXr4xKry8K390gryaqF4Sqa10kryjqr1rAw1U
	AF4rt39xu3Z5KrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2024/10/24 17:56, John Garry 写道:
> On 24/10/2024 10:12, Yu Kuai wrote:
>>>>
>>>>>>>
>>>>>>> Indeed, IMO, chance of encountering a device with BBs and supporting
>>>>>>> atomic writes is low, so no need to try to make it work (if it were
>>>>>>> possible) - I think that we just report EIO.
>>>>
>>>> If you want this, then make sure raid will set fail fast together with
>>>> atomic write. This way disk will just faulty with IO error instead of
>>>> marking with BB, hence make sure there are no BBs.
>>>
>>> To be clear, you mean to set the r1/r10 bio failfast flag, right? 
>>> There are rdev and also r1/r10 bio failfast flags.
>>
>> I mean the rdev flag, all underlying disks should set FailFast, so that
>> no BB will be present. rdev will just become faulty for the case IO
>> error.
>>
>> r1/r10 bio failfast flags is for internal usage to handle IO error.
> 
> I am not familiar with all consequences of FailFast for an rdev, but it 
> seems a bit drastic to set it just because the rdev supports atomic 
> writes. If we support atomic writes, then not all writes will 
> necessarily be atomic.

I don't see there is other option for now.

1) set failfast and make sure no BB will be present;
2) handle BB and don't split it for the good disks for atomic writes.

Thanks,
Kuai

> 
> Thanks,
> John
> 
> .
> 

