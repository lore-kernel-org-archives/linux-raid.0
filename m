Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036C17CF30
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 08:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721377257; cv=none; b=is5CdZLI1W1Yqr7b1qgQHIUVaLbxvwVc+vKKWgvSnc70uX1Lm2AF2Et3iwAm/C+o6oIqyFoW7ODuxdjJpE6hfpVqsZDVtg/KZiwM0/Vlk0LA0zo911MVc0alAJEKpJfYBq93Ch2p9NfjpPqApmiBPfcZchIrLi1b4qc55BleO8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721377257; c=relaxed/simple;
	bh=+rXu3gIK7pdWenUmhsOV0LZqBWiqOUr/oxdWRCIKhBw=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qv++PHwEg+s8yma1qUka4AkiLjdYKVyXLJnHXlbt1Z5UI4yhTayPqmTR3g8mmWB5qPPg6VTKRBRWA/qJNuTiQ4IW/T+1Hl6mMqrj9ZufFj0yLpQ1W+Ga9bPrYantHak5Nol00nwlTMiSUv0OwkI6z13CLWmOIHSRYrxoR4VG0d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WQN0W5wF7z4f3jYh
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 16:20:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E37921A0572
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 16:20:51 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXyDbiIZpmYMs6Ag--.33675S3;
	Fri, 19 Jul 2024 16:20:51 +0800 (CST)
Subject: Re: IMSM: Drive removed during I/O is set to faulty but not removed
 from volume
To: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <f34452df-810b-48b2-a9b4-7f925699a9e7@linux.intel.com>
 <f3d0f203-f9b9-04c1-e5a0-d61fc5c6c0d2@huaweicloud.com>
 <3564b25f-e754-4556-afcc-c6045d38e183@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <36abf047-20f0-2647-83dc-c1c685a9d056@huaweicloud.com>
Date: Fri, 19 Jul 2024 16:20:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <3564b25f-e754-4556-afcc-c6045d38e183@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXyDbiIZpmYMs6Ag--.33675S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WrWkGFyDJFy8CF45uw48JFb_yoW8Xw4rpr
	WktFy5ArWUCr1kJw17tw1UCry5tr1UK3srKryUZ3WUZry5JFn0qr47Wrs0gr1DArWxCr4U
	Jw1UJF1DZr10gr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUehL0UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/07/19 16:02, Mateusz Kusiak 写道:
> 
> 
> On 19.07.2024 09:02, Yu Kuai wrote:
>>
>> Hi,
>>
>> With some discussion and log collection, looks like this is a deadlock
>> introduced by:
>>
>> https://lore.kernel.org/r/20230825031622.1530464-8-yukuai1@huaweicloud.com 
>>
>>
>> Root cause is that:
>>
>> 1) New io is blocked because array is suspended;
>> 2) md_start_sync suspend the array, and it's waiting for inflight IO 
>> to be done;
>> 3) inflight IO is waiting for md_start_sync to be done, from
>> md_start_write->flush_work().
>>
>> Can you give following patch a test?
>>
>> Thanks!
>> Kuai
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 64693913ed18..10c2d816062a 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -8668,7 +8668,6 @@ void md_write_start(struct mddev *mddev, struct 
>> bio *bi)
>>          BUG_ON(mddev->ro == MD_RDONLY);
>>          if (mddev->ro == MD_AUTO_READ) {
>>                  /* need to switch to read/write */
>> -               flush_work(&mddev->sync_work);
>>                  mddev->ro = MD_RDWR;
>>                  set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>                  md_wakeup_thread(mddev->thread);
>>
> 
> Hi Kuai,
> With the patch you provided the issue still reproduces.

Thanks for the test, then after eliminating this problem, can we collect
log with this patch?

Thanks,
Kuai


> 
> Thanks,
> Mateusz
> 
> .
> 

