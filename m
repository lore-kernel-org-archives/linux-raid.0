Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137B91362
	for <linux-raid@vger.kernel.org>; Wed,  9 Oct 2024 01:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728436284; cv=none; b=cAcgMY6h5Lw4rYk6yi6msm1UrFTtCydX+5oiMLh2hgaq/k9BsoKqWVgVRsaZAj3rXintmQZ+6/4JR82YFrSIhaVwJzs6D35pQ1DCLFAMxZJKKuv9oEJcOnet2/ThlwvrXyI+gVO9lgWDYI4dMeymedCJbKMh8cOP+pCEbb5qZ98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728436284; c=relaxed/simple;
	bh=Dz34y9luICe98qzYu699QOMzbS2QFmbqm3vEQotp6fs=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=L9oTwA9BLG0ztsrz4bJDSuEnWvzpm8lDdDCuxIMOpWFLY3er1cmNtq7IHvVMRUwDcr6XTbettM3CD9eUGNkug/S2nPPhUJ96wLm2PiyNckiCvbUVEs50jtOHfQc1gFPaMgWQNWTm8EhTEBgKlKqAcF9EhIgHDdxP09q1zMczhwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XNZZz0JLJz4f3jjx
	for <linux-raid@vger.kernel.org>; Wed,  9 Oct 2024 09:11:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C40C81A0A22
	for <linux-raid@vger.kernel.org>; Wed,  9 Oct 2024 09:11:18 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAHPMg12AVnJ7dHDg--.64821S3;
	Wed, 09 Oct 2024 09:11:18 +0800 (CST)
Subject: Re: Null dereference in raid10_size, I/O lockup afterwards
To: ValdikSS <iam@valdikss.org.ru>, Yu Kuai <yukuai1@huaweicloud.com>,
 linux-raid@vger.kernel.org, "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <0dd96820-fe52-4841-bc58-dbf14d6bfcc8@valdikss.org.ru>
 <e12e1789-5a07-4d42-8f06-afa99d820444@valdikss.org.ru>
 <3de753c8-86ee-6e7c-fe06-7c0693e95bbd@huaweicloud.com>
 <7a21c8d6-3012-6816-b1d8-0bebdd7b10cc@huaweicloud.com>
 <06206bdf-6d63-483a-8afc-d56d733db2ff@valdikss.org.ru>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8abd507d-4b80-8505-1f1c-cc5f9fcbe54e@huaweicloud.com>
Date: Wed, 9 Oct 2024 09:11:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <06206bdf-6d63-483a-8afc-d56d733db2ff@valdikss.org.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHPMg12AVnJ7dHDg--.64821S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGw17Jr1kGw4UGr48tF13Arb_yoWruw43pr
	4ktayUGryrJrn7Jw1Utr1UGa4UtFyDt3WUXr1kGFyDXrnIvw1Ygr1DXry0gF1jqw4xAF1j
	gF1UWrW7ZF1UJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUjuHq7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/10/08 23:01, ValdikSS 写道:
> On 08.10.2024 05:32, Yu Kuai wrote:
>>> 在 2024/10/05 10:55, ValdikSS 写道:
>>>> On 05.10.2024 04:35, ValdikSS wrote:
>>>>> Fedora 39 with 6.10.11-100.fc39 kernel dereferences NULL in 
>>>>> raid10_size and locks up with 3-drive raid10 configuration upon its 
>>>>> degradation and reattachment.
>>>>>
>>>>> How to reproduce:
>>>>>
>>>>> 1. Get 3 USB flash drives
>>>>> 2. mdadm --create -b internal -l 10 -n 3 -z 1G /dev/md0 /dev/sda 
>>>>> /dev/sdb /dev/sdc
>>>>> 3. Unplug 2 USB drives
>>>>> 4. Plug one of the drive again
>>>>>
>>>>> Happens every time, every USB flash reattachment.
>>>>
>>>> Reproduced on 6.11.2-250.vanilla.fc39.x86_64
>>>
>>> Can you use addr2line or gdb to see which codeline is this?
>>>
>>> RIP: 0010:raid10_size+0x15/0x70 [raid10]
> 
> It's raid10.c:3768 (6.10.11)
> https://github.com/gregkh/linux/blob/8a886bee7aa574611df83a028ab435aeee071e00/drivers/md/raid10.c#L3768 
> 
> 
> raid10_size(struct mddev *mddev, sector_t sectors, int raid_disks)
> {
>      sector_t size;
>      struct r10conf *conf = mddev->private;
> 
>      if (!raid_disks)
> -->        raid_disks = min(conf->geo.raid_disks,
>                   conf->prev.raid_disks);
>      if (!sectors)
>          sectors = conf->dev_sectors;
> 
> 
>>  From code review, looks like this can only happen if raid10_run() return
>> 0 while mddev->private(the raid10 conf) is still NULL. Can you also give
>> the following patch a test?
> 
> It works, thanks a lot! No dereference, no oops.

Thanks for the test! Will send a patch soon.
Kuai

> 
> [   47.933178] scsi host4: usb-storage 4-1.3:1.0
> [   48.778815] scsi 3:0:0:0: Direct-Access     ASolid   USB      PQ: 0 
> ANSI: 6
> [   48.779024] scsi 2:0:0:0: Direct-Access     ASolid   USB      PQ: 0 
> ANSI: 6
> [   48.779968] sd 3:0:0:0: Attached scsi generic sg0 type 0
> [   48.781100] sd 2:0:0:0: Attached scsi generic sg1 type 0
> [   48.782111] sd 3:0:0:0: [sda] 122880001 512-byte logical blocks: 
> (62.9 GB/58.6 GiB)
> [   48.782336] sd 2:0:0:0: [sdb] 122880001 512-byte logical blocks: 
> (62.9 GB/58.6 GiB)
> [   48.782479] sd 3:0:0:0: [sda] Write Protect is off
> [   48.782487] sd 3:0:0:0: [sda] Mode Sense: 23 00 00 00
> [   48.782658] sd 3:0:0:0: [sda] Write cache: disabled, read cache: 
> enabled, doesn't support DPO or FUA
> [   48.782658] sd 2:0:0:0: [sdb] Write Protect is off
> [   48.782667] sd 2:0:0:0: [sdb] Mode Sense: 23 00 00 00
> [   48.782831] sd 2:0:0:0: [sdb] Write cache: disabled, read cache: 
> enabled, doesn't support DPO or FUA
> [   48.787556] sd 2:0:0:0: [sdb] Attached SCSI removable disk
> [   48.788403] sd 3:0:0:0: [sda] Attached SCSI removable disk
> [   48.931643] md/raid10:md0: not enough operational mirrors.
> [   48.948990] md: pers->run() failed ...
> [   48.969698] scsi 4:0:0:0: Direct-Access     ASolid   USB      PQ: 0 
> ANSI: 6
> [   48.970382] sd 4:0:0:0: Attached scsi generic sg2 type 0
> [   48.971534] sd 4:0:0:0: [sdc] 122880001 512-byte logical blocks: 
> (62.9 GB/58.6 GiB)
> [   48.971862] sd 4:0:0:0: [sdc] Write Protect is off
> [   48.971868] sd 4:0:0:0: [sdc] Mode Sense: 23 00 00 00
> [   48.972058] sd 4:0:0:0: [sdc] Write cache: disabled, read cache: 
> enabled, doesn't support DPO or FUA
> [   48.976216] sd 4:0:0:0: [sdc] Attached SCSI removable disk
> [   49.067973] md0: ADD_NEW_DISK not supported
> 
> 
> 
>>
>> Thanks,
>> Kuai
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index f3bf1116794a..b7f2530ae257 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -4061,9 +4061,13 @@ static int raid10_run(struct mddev *mddev)
>>          }
>>
>>          if (!mddev_is_dm(conf->mddev)) {
>> -               ret = raid10_set_queue_limits(mddev);
>> -               if (ret)
>> +               /* don't overwrite ret on success */
>> +               int err = raid10_set_queue_limits(mddev);
>> +
>> +               if (err) {
>> +                       ret = err;
>>                          goto out_free_conf;
>> +               }
>>          }
>>
>>          /* need to check that every block has at least one working 
>> mirror */
>>
>>
>>>
>>> Thanks,
>>> Kuai
>>>
>>> .
>>>
>>
>>

