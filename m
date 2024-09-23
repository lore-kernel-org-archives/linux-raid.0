Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C4A6F2EB;
	Mon, 23 Sep 2024 08:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727079525; cv=none; b=O9j4ei7Dfd09THILjP58eBhPyXfCAe6NltVSB9Rj+OY9XsmNPMipm12qKJokyZ+dLjaCWiTUW54rqHQhzdNQcnnuekjZihAYBi2ldmokWYI0a0lwa9Wpaewhp+6BhWfmpBTPIGsW23kZ64ypALLgPTivmCP5PV5EVLXlU7Mk0Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727079525; c=relaxed/simple;
	bh=fijOqEVomEustEmItf5PSy8xG7Va8hKn/5IRgxXspOs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=j+fVug6CHowGMn4BFbrGPTXdGBAujwYJi00jaFaaVWSL3jiMsBT0EbEMgFDyuzCA6ywNntgiTcCVqHkfZqUdYQzxlCxb+TImwBe+Lx1fC8vzFSyxu8z08KA0VqHR8YreibsDstDNPwSk4LcRBxKWWTgA2R0nJfbVzXUdQMYvSGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XBwqP12W7z4f3jkg;
	Mon, 23 Sep 2024 16:18:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 446591A08FC;
	Mon, 23 Sep 2024 16:18:36 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAnXMhaJPFmsdt0CA--.61517S3;
	Mon, 23 Sep 2024 16:18:36 +0800 (CST)
Subject: Re: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 axboe@kernel.dk, hch@lst.de
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <59a46919-6c6d-46cb-1fe4-5ded849617e1@huaweicloud.com>
Date: Mon, 23 Sep 2024 16:18:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <44806c6f-d96a-498c-83e1-e3853ee79d5a@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnXMhaJPFmsdt0CA--.61517S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AF47Aw17Gr13ZFW7Cw4rXwb_yoW8Cw4rpr
	yFka95Ar4DJFWIkr18Zr40yasYvw1fAa15J348G3y7urn0g3Z7trWUWw409ayagFy7Cw1q
	qryrWa9xGFyUZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/09/23 15:44, John Garry 写道:
> On 23/09/2024 07:15, Yu Kuai wrote:
>>>>
>>>> This way, BLK_STS_IOERR will always be returned, perhaps what you want
>>>> is to return the error code from bio_split()?
>>>
>>> Yeah, I would like to return that error code, so maybe I can encode 
>>> it in the master_bio directly or pass as an arg to raid_end_bio_io().
>>
>> That's fine, however, I think the change can introduce problems in some
>> corner cases, for example there is a rdev with badblocks and a slow rdev
>> with full copy. Currently raid1_read_request() will split this bio to
>> read some from fast rdev, and read the badblocks region from slow rdev.
>>
>> We need a new branch in read_balance() to choose a rdev with full copy.
> 
> Sure, I do realize that the mirror'ing personalities need more 
> sophisticated error handling changes (than what I presented).
> 
> However, in raid1_read_request() we do the read_balance() and then the 
> bio_split() attempt. So what are you suggesting we do for the 
> bio_split() error? Is it to retry without the bio_split()?
> 
> To me bio_split() should not fail. If it does, it is likely ENOMEM or 
> some other bug being exposed, so I am not sure that retrying with 
> skipping bio_split() is the right approach (if that is what you are 
> suggesting).

bio_split_to_limits() is already called from md_submit_bio(), so here
bio should only be splitted because of badblocks or resync. We have to
return error for resync, however, for badblocks, we can still try to
find a rdev without badblocks so bio_split() is not needed. And we need
to retry and inform read_balance() to skip rdev with badblocks in this
case.

This can only happen if the full copy only exist in slow disks. This
really is corner case, and this is not related to your new error path by
atomic write. I don't mind this version for now, just something
I noticed if bio_spilit() can fail.

Thanks,
Kuai

> 
> Thanks,
> John
> 
> .
> 

