Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C116B30C606;
	Mon, 10 Nov 2025 11:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762775819; cv=none; b=SEJGqeoMpwp6nwapfsEakVoA8fCXSXZmsCiquaolna7WC+RrjT/ou6AodYJTpPi1ZQko0Os629gr2ohG8hxL1FdSgLD3Ym+cegfLFCWReAtr6jI+kz4JMm274zUajpcwCTgXbtjgxtWsCJSUg5fsKc/gUZObCXB76VDoNC5j1Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762775819; c=relaxed/simple;
	bh=Y/jAnkngLZQo+uWruFgZLanl3mb34pYToR6q/XAXuS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CqaElTBCbOgpzHeaMYBANpjjJ2wVJclqPVoVPS4/KAx6FqqwR18XI+BPWGKEY7hEvGtQTW3Bgm8C9o5/wHqaiqFm3QvUJwEW5xka1H5LdhNvr3SSnudllmEqSXjUMmIobO2kvYxSlYPin4dgORK/O9c9LSIKh6LIDTBrHmzVolI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d4p6P2zknzYQtyD;
	Mon, 10 Nov 2025 19:56:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 6CFA91A018C;
	Mon, 10 Nov 2025 19:56:54 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgD3VHsC0xFpdVoLAQ--.11444S3;
	Mon, 10 Nov 2025 19:56:52 +0800 (CST)
Message-ID: <ae9fde4f-eaf3-b5a2-4fea-8d83cad42ae4@huaweicloud.com>
Date: Mon, 10 Nov 2025 19:56:50 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 03/11] md/raid1,raid10: return actual write status in
 narrow_write_error
To: yukuai@fnnas.com, linan666@huaweicloud.com, song@kernel.org,
 neil@brown.name, namhyung@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, xni@redhat.com,
 k@mgml.me, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20251106115935.2148714-1-linan666@huaweicloud.com>
 <20251106115935.2148714-4-linan666@huaweicloud.com>
 <63857ce2-0521-4f38-b3d4-d95c8eafc175@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <63857ce2-0521-4f38-b3d4-d95c8eafc175@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgD3VHsC0xFpdVoLAQ--.11444S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ary3ur43Gry3Zw17CFW5GFg_yoW8uw45p3
	yqgF9IyFyDWry5u3WDXFy5WFyFy397KFW2yr4xJwnxur9Yyr93GF40qryYgFykur9xKa10
	qr4qgrZxuF1jyFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPI14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7
	AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQ
	vtAUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/11/8 18:07, Yu Kuai 写道:
> Hi,
> 
> 在 2025/11/6 19:59, linan666@huaweicloud.com 写道:
>> From: Li Nan <linan122@huawei.com>
>>
>> narrow_write_error() currently returns true when setting badblocks fails.
>> Instead, return actual status of all retried writes, succeeding only when
>> all retried writes complete successfully. This gives upper layers accurate
>> information about write outcomes.
>>
>> When setting badblocks fails, mark the device as faulty and return at once.
>> No need to continue processing remaining sections in such cases.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>    drivers/md/raid1.c  | 17 +++++++++--------
>>    drivers/md/raid10.c | 15 +++++++++------
>>    2 files changed, 18 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index e65d104cb9c5..090fe8f71224 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2541,11 +2541,15 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
>>    		bio_trim(wbio, sector - r1_bio->sector, sectors);
>>    		wbio->bi_iter.bi_sector += rdev->data_offset;
>>    
>> -		if (submit_bio_wait(wbio) < 0)
>> +		if (submit_bio_wait(wbio)) {
>>    			/* failure! */
>> -			ok = rdev_set_badblocks(rdev, sector,
>> -						sectors, 0)
>> -				&& ok;
>> +			ok = false;
>> +			if (!rdev_set_badblocks(rdev, sector, sectors, 0)) {
>> +				md_error(mddev, rdev);
>> +				bio_put(wbio);
>> +				break;
>> +			}
>> +		}
>>    
>>    		bio_put(wbio);
>>    		sect_to_write -= sectors;
>> @@ -2596,10 +2600,7 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>>    			 * errors.
>>    			 */
>>    			fail = true;
>> -			if (!narrow_write_error(r1_bio, m))
>> -				md_error(conf->mddev,
>> -					 conf->mirrors[m].rdev);
>> -				/* an I/O failed, we can't clear the bitmap */
>> +			narrow_write_error(r1_bio, m);
> 
> Now that return value is not used, you can make this helper void.
> 
> Thanks,
> Kuai
> 

Hi, Kuai

In v1, I changed return type of narrow_write_error() to void.
But a better return value will help Akagi's fix:
https://lore.kernel.org/all/8136b746-50c9-51eb-483b-f2661e86d3eb@huaweicloud.com/

-- 
Thanks,
Nan

