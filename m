Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BA81D0F66;
	Thu, 21 Nov 2024 12:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732192660; cv=none; b=R2sdFhp2LDkm21SxFOjGBghCjERX/HNZMf/zCJxkqNAjSYI5f6twQIF/68CGakHcyCkyUhRmagieHyQbzH1aUzB4+1LmDwUiqhvoomLEE97CkVXfLcbUYQeJ/ioBTGjWbX3/pgnM2A5GNh03Q2l0B2/hHG74tmyjBMms0ZZ4T8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732192660; c=relaxed/simple;
	bh=/ZXPPPVdbG+j3djrBAL+e7IdbHb1alFH6Q36A14etac=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Q5fQv1DQh5vQGRU5+TgE2w7U7qM0ftIrf+AHcleHLfkzgy561oaw917ldhapO7QzGoLX1W782cpcuwavP/CJRupHQCSDsIIfRhKxk0doOgYDytA7t7qnot2wgtzblRqwWdMH2U9aV6jUdERp02loN/4ujMRoqmPvMgE8wHKwdtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XvHmp5FYyz4f3nK6;
	Thu, 21 Nov 2024 20:37:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 35FB91A018D;
	Thu, 21 Nov 2024 20:37:34 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCnzoKIKT9nmwOwCQ--.21489S3;
	Thu, 21 Nov 2024 20:37:30 +0800 (CST)
Subject: Re: [PATCH md-6.13 4/5] md/raid5: implement pers->bitmap_sector()
To: Christian Theune <ct@flyingcircus.io>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Jinpu Wang <jinpu.wang@ionos.com>, Haris Iqbal <haris.iqbal@ionos.com>,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org,
 xni@redhat.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 =?UTF-8?Q?Florian-Ewald_M=c3=bcller?= <florian-ewald.mueller@ionos.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <adf796b9-2443-d29a-f4ac-fb9b8a657f93@huaweicloud.com>
 <20241119152939.158819-1-jinpu.wang@ionos.com>
 <CAMGffEkODwo19u0EjKojQ0WaWVkvOOB8aRR8R3NXn+oC6TFQWQ@mail.gmail.com>
 <d456368e-cff5-5476-238e-4cc97f016cfa@huaweicloud.com>
 <3038E681-BC24-491B-9AA1-52A4F86E5196@flyingcircus.io>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e688ffc6-73ff-ba82-4991-4a072c5bc5fe@huaweicloud.com>
Date: Thu, 21 Nov 2024 20:37:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <3038E681-BC24-491B-9AA1-52A4F86E5196@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnzoKIKT9nmwOwCQ--.21489S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtF1kWFykKFWxur4UJw4UXFb_yoWftrc_AF
	WFkFy3J34DGF47XFsIqF4Sqw1DKF4UGFWrJ3W8KF4Iq3s5Zrs5WFZ3GF4Y9wn3Wan3try3
	CF4Y93s0ganrXjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY
	04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/21 20:21, Christian Theune 写道:
> Hi,
> 
>> On 21. Nov 2024, at 09:33, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Thanks for the test! And just to be sure, the BUG_ON() problem in the
>> other thread is not triggered as well, right?
>>
>> +CC Christian
>>
>> Are you able to test this set for lastest kernel?
> 
> Reading through the list - I’m confused. You posted a patchset on 2024-11-18@12:48. There was discussion later around an adjustment but I’m not seeing the adjusted patchset.

I don't know you mean here, this is the only set. If you didn't
subscribe mail-list and don't know how to find the set:

https://lore.kernel.org/all/20241118114157.355749-1-yukuai1@huaweicloud.com/

> 
> Also, which kernel do you want me to test on? 6.12?

The branch is from the title, md-6.13. If you don't know:

https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/log/?h=md-6.13

Thanks,
Kuai

> 
> Christian
> 

