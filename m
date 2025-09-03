Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15D6191F66
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 02:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756867572; cv=none; b=rzb9vrmEoyjVuG7N/jyjUwS79w1zPQvNmAr2o1taBuDflGcHi7OEXfsSf1nfo1IZxMuvlCuVNNmJqV7rjtoA0NQ2NbjAIWbJg5y0wASumhc5alzXhH2TOqdZidEVXO1BaP6iBZ2DL4UIbwUCqaDtbgmti6by4j0D2p1+mXpoHxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756867572; c=relaxed/simple;
	bh=17yNbpRayZ44xrt4PDK1gBVN3+qFntcG4btz0E6cuZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aJAqgZsXZMMcqiiobKWSlIZwrc0o52KIaNWhoSDTNKSi0Dup5vsrHWuYzN4MYvZgUJt+MaNS+2bUWNULNMVt+H9mgY8Ec18i1MqH+rIUxsK94Ulge1M4N5coDYhY5JBO4ew1bX+Kkcbxy7Hu4OyhGMBIKv+VFONgSD+rLQyJv1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5gIspog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5gIspog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FB7C4CEED;
	Wed,  3 Sep 2025 02:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756867571;
	bh=17yNbpRayZ44xrt4PDK1gBVN3+qFntcG4btz0E6cuZM=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=q5gIspogKsUtSFDSX26CSPLGlpr3iMRXnuDfyMRf5pOl4qKW1NZ33ERgI8fJJIdXj
	 n2JDfwBnxcqUhKSXN00Vn3AWRrpCscE7K/I3dJC1vPiALGVp/jy1Yu2+0l9A16G9R8
	 HR48o62iC+O61++BZKgfQhp1DkSQzf8HucdaJRhTLxUkFJKx38kH3NjXmzMdlof2VU
	 5b3nUQziq7pwKY40ngvv1KYkz2SapUgsBKKP/9SBPz1ZbzGUMeksp3O+yMZsP9Xv/5
	 dEkFE4yj1ktuv/8BPCRJp+oSq1WMrwWh8PwUZjkhQsq+zm+lK1au+bt+8zM7Dxb6zG
	 UTGRw4hWAjehg==
Message-ID: <90bbc066-c306-4430-a541-2e700f7ca404@kernel.org>
Date: Wed, 3 Sep 2025 11:46:09 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: Correctly disable write zeroes for raid 1, 10 and 5
To: Yu Kuai <hailan@yukuai.org.cn>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org
References: <20250902093843.187767-1-dlemoal@kernel.org>
 <0c28296f-1661-4629-9114-72bb55c97fa3@yukuai.org.cn>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <0c28296f-1661-4629-9114-72bb55c97fa3@yukuai.org.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/2/25 19:58, Yu Kuai wrote:
> Hi,
> 
> 在 2025/9/2 17:38, Damien Le Moal 写道:
>> raid1_set_limits(), raid10_set_queue_limits() and raid5_set_limits()
>> set max_write_zeroes_sectors to 0 to disable write zeroes support.
>>
>> However, blk_validate_limits() checks that if
>> max_hw_wzeroes_unmap_sectors is not zero, it must be equal to
>> max_write_zeroes_sectors. When creating a RAID1, RAID10 or RAID5 array
>> of block devices that have a non-zero max_hw_wzeroes_unmap_sectors
>> limit, blk_validate_limits() returns an error resulting in a failure
>> to start the array.
>>
>> Fix this by setting max_hw_wzeroes_unmap_sectors to 0 as well in
>> raid1_set_limits(), raid10_set_queue_limits() and raid5_set_limits().
>>
>> Fixes: 0c40d7cb5ef3 ("block: introduce max_{hw|user}_wzeroes_unmap_sectors to queue limits")
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>   drivers/md/raid1.c  | 2 ++
>>   drivers/md/raid10.c | 1 +
>>   drivers/md/raid5.c  | 1 +
>>   3 files changed, 4 insertions(+)
> 
> Yi already posted a fix:
> 
> [PATCH 1/2] md: init queue_limits->max_hw_wzeroes_unmap_sectors 
> parameter - Zhang Yi <https://lore.kernel.org/all/20250825083320.797165-2-yi.zhang@huaweicloud.com/>

Missed that... Thank you for the link.


-- 
Damien Le Moal
Western Digital Research
