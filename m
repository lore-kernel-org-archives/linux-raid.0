Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBBD3659F9;
	Fri, 12 Jun 2026 08:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781251526; cv=none; b=QnRrHJWordq4eL66wgPCPXxD5d4jyC0gvM2RjsAxmw8MmGu7iMlnacFv5a7Bm4OtLDOZ93ICO/c6OtLRMRM+6zL2TLKrkMo/N/0cpNZIK2++wk09gC4qbfipcDKniWofzhGWLDHRpEcPCt+ftcest1+NDD+A7ql94T680b/Ocms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781251526; c=relaxed/simple;
	bh=enh4Zi0E3JX3/7uiXATuVib1imY3TN3wgKiQdK4bqWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=e40MkQH41kac2qVwL/WjZisy3HvMJGdXnLRZl+S2YO/SMmNicYKcmSsaGstwKBcXqw2PpAJav6HziXlZGmQW1mezJNiPFKzYtkMISRPBmocnaMe5t4Uh+eHRde3bJUmHaXVLo0mia/6Zdj9cIUCCcH93OUp3D7b5bNPu6+YuuDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=d7iAjO2C; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="d7iAjO2C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=z309+93AHboJ8kiQZj7wFOdICj/bj7Ritu4UcUIfpWI=;
	b=d7iAjO2CHGURw9rRIfXhyih1b74QmQJxjkM3l8BKJNdzsI8M1ALgnUHblk/Aym
	Hc8l1CvKxbrDpZC/ZLrQcTm94K7B3coE9/dflyC0SlS9Lnls0bjLlt/p/bDduK2I
	AaSJNC97db9/wYMiC0PKUIhFc4DsGWQL7VQ5hxEkMOY/M=
Received: from [192.168.3.184] (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgAHLgWxvStqzQi6Bw--.60351S2;
	Fri, 12 Jun 2026 16:05:05 +0800 (CST)
Message-ID: <8da26fc1-d582-4e93-8c00-d545b8558fb2@163.com>
Date: Fri, 12 Jun 2026 16:05:04 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] raid10: badblock-aware reshape write error handling
To: Li Nan <magiclinan@foxmail.com>
References: <20260601054630.74483-1-ghuicao@163.com>
 <tencent_1A4057A928F0CDF70F24A070B03ABFB34A05@qq.com>
Content-Language: en-US
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 song@kernel.org, xiao@kernel.org, yukuai@fnnas.com
From: caogh <ghuicao@163.com>
In-Reply-To: <tencent_1A4057A928F0CDF70F24A070B03ABFB34A05@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgAHLgWxvStqzQi6Bw--.60351S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGw4kJrWDZFy7Jr1xZr1rtFb_yoW5KFW3pr
	4DKas0yw4DCwsF9anrZa98Aa4S9392krW5Ar4aqw13C3s8trWSyryDW345u3yUZrsxXa1F
	qrWjgrZ8u3s0kaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U2JPiUUUUU=
X-CM-SenderInfo: 5jkxxuldr6il2tof0z/xtbC-BEBk2orvbFlKQAA3+

Nan, thanks for the review.

You're right that the current code chains several mechanisms (badblock 
recording, WantReplacement, md_error) together, which hurts readability. 
I'll refactor in the next version to make the logic clearer.

However, regarding your suggested logic:

> The correct logic might be:
>    1. If there is a replacement, fail directly with md_error
>    2. If not, mark the badblock and set WantReplacement

I have some questions.

If a replacement device hits a write error, calling md_error directly 
will mark it Faulty and kick it out of the array. But it may just be a 
few bad sectors — recording the badblock and continuing the reshape is 
sufficient. Is it really necessary to call md_error directly in this case?

The current patch does:
     1、Try to record the badblock first
     2、On success:
          a) member device: set WantReplacement to trigger a replacement
          b) replacement device: skip WantReplacement to avoid a 
replacement loop
     3、On failure: rdev_set_badblocks has already called md_error 
internally, no further action needed

Does this approach seem reasonable?


在 2026/6/12 11:42, Li Nan 写道:
> On Mon Jun 1, 2026 at 1:46 PM CST, ghuicao wrote:
>> From: Cao Guanghui<caoguanghui@kylinos.cn>
>>
>> Replace the FIXME in end_reshape_write(). Instead of failing the device
>> immediately on write errors during reshape, attempt to record badblocks
>> using new_data_offset with is_new=1.
>>
>> rdev_set_badblocks() returns true on success. On failure (e.g., badblocks
>> table full), it has already called md_error() internally to degrade the
>> device. Queue WantReplacement for member devices regardless of badblock
>> recording success, but skip this for replacement devices to avoid
>> replacement loops.
>>
>> On successful write, clear stale badblock records at the new location
>> since data has migrated.
>>
>> Signed-off-by: Cao Guanghui<caoguanghui@kylinos.cn>
>> ---
>>   drivers/md/raid10.c | 27 ++++++++++++++++++++++++---
>>   1 file changed, 24 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 4901ebe45c87..08d58a1c680e 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -4991,9 +4991,30 @@ static void end_reshape_write(struct bio *bio)
>>   		      conf->mirrors[d].rdev;
>>   
>>   	if (bio->bi_status) {
>> -		/* FIXME should record badblock */
>> -		md_error(mddev, rdev);
>> -	}
>> +		set_bit(WriteErrorSeen, &rdev->flags);
>> +
>> +		/* rdev_set_badblocks returns true on success.
>> +		 * On failure, it has already called md_error() internally.
>> +		 * Use is_new=1 as reshape writes target the new layout
>> +		 * (new_data_offset).
>> +		 */
>> +		if (rdev_set_badblocks(rdev, r10_bio->devs[slot].addr,
>> +				       r10_bio->sectors, 1)) {
>> +			/* Queue async replacement for member devices
>> +			 * For replacement devices, do not trigger WantReplacement
>> +			 * to avoid circular replacement storms.
>> +			 */
>> +			if (!repl) {
>> +				if (!test_and_set_bit(WantReplacement, &rdev->flags))
>> +					set_bit(MD_RECOVERY_NEEDED,
>> +						&rdev->mddev->recovery);
> The logic here seems a bit odd — several mechanisms are chained together.
>
> The correct logic might be:
>    1. If there is a replacement, fail directly with md_error
>    2. If not, mark the badblock and set WantReplacement
>
>> +			}
>> +		}
>> +	} else {
>> +		/* Write succeeded, clear stale badblock records */
>> +		rdev_clear_badblocks(rdev, r10_bio->devs[slot].addr,
>> +				     r10_bio->sectors, 1);
>> +	}
>>   
>>   	rdev_dec_pending(rdev, mddev);
>>   	end_reshape_request(r10_bio);
>>

Thanks, Cao Guanghui

