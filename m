Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FB0286A9;
	Mon, 18 Aug 2025 03:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755487266; cv=none; b=JeSGd/XBUwed/GcPfJjpnx2mtS2Hu9MBID7QpIwBo3KA8iK1jOj42eF3+W/66+/QLu4pJr3aEx0q4I2ioFtj9etkiGcP0w92+IMOfFoNCFxio8sznOp9JeBLuo1vqqCqg7+cZORF3c3rU6vzLiNz6VND4kYZhXYxmhyS+vZAndA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755487266; c=relaxed/simple;
	bh=YoyOFvgQK6xcREAKeyQkEmD9A8kwHUUZIfhj2tAG1HI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E1Ln/q+zdK6Er9d+wbIyLv44GfX1yYXcLwojO1QkZXw93A/zCKFDwMKTRdyM21XbFBOjA1dVRvEy3ehiR7a5AqvhYZ9SQsO6NfAjJ4OEzORpbiWdAPrJTNIFyseD0s+l/41mELEKHQazeQVIvjTeNf9zF/PRzcGWOKZu8ubo7hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IKWwgoYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IKWwgoYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 438BCC4CEEB;
	Mon, 18 Aug 2025 03:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755487266;
	bh=YoyOFvgQK6xcREAKeyQkEmD9A8kwHUUZIfhj2tAG1HI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IKWwgoYLJZxzcqUWr1+2vFz+cisjnXlhUe95llEuOMWiPI7bbuhM3NQZWO1+CIqET
	 Z9mBhBefYn7Dq2CVrtR7zK6B35MU+lB7Qv5A0F54d17Bmqbu5ug0k9FshgskaG0lp9
	 n1Gm7cjTruDpJ5NJbkf39YvtbDO45fkuTK6m9y75/RL1341jKRib2jqbWWpmEzHoAH
	 9U0DlrLpL0aCNRTYnMx/U7zekrrO1yAQZ02SYyGsMWBowhQgbEaMe9dCveSSIhptmD
	 17vg1KSLiaQWtFGbIXleHZ1Ep+nYUBLxG7Z+OSG65P4MQlCJyfHdNcUQbZ4R5qMWec
	 wqJXtfFCZAOeA==
Message-ID: <fd5c1916-936b-4253-a7b8-ba53591653f3@kernel.org>
Date: Mon, 18 Aug 2025 12:18:19 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
To: Yu Kuai <yukuai1@huaweicloud.com>, colyli@kernel.org,
 linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250817152645.7115-1-colyli@kernel.org>
 <756b587d-2a5c-4749-a03b-cfc786740684@kernel.org>
 <ffa13f8c-5dfe-20d4-f67d-e3ccd0c70b86@huaweicloud.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <ffa13f8c-5dfe-20d4-f67d-e3ccd0c70b86@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/18/25 11:57 AM, Yu Kuai wrote:
>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>> index 023649fe2476..989acd8abd98 100644
>>> --- a/drivers/md/raid5.c
>>> +++ b/drivers/md/raid5.c
>>> @@ -7730,6 +7730,7 @@ static int raid5_set_limits(struct mddev *mddev)
>>>       lim.io_min = mddev->chunk_sectors << 9;
>>>       lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
>>
>> It seems to me that moving this *after* the call to mddev_stack_rdev_limits()
>> would simply overwrite the io_opt limit coming from stacking and get you the
>> same result as your patch, but without adding the new limit flags.
> 
> This is not enough, we have the case array is build on the top of
> another array, we still need the lcm_not_zero() to not break this case.
> And I would expect this flag for all the arrays, not just raid5.

Nothing prevents you from doing that in the md code. The block layer stacking
limits provides a sensible default. If the block device driver does not like
the default given, it is free to change it for whatever valid reason it has.
As I said, that's what the DM .io_hint target driver method is for.

As for the "expected that flag for all arrays", that is optimistic at best. For
scsi hardware raid, as discussed already, the optimal I/O size is *not* the
stripe size. And good luck with any AHCI-based hardware RAID...

-- 
Damien Le Moal
Western Digital Research
