Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C73125DE;
	Wed, 19 Jun 2024 14:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718807274; cv=none; b=DoZ3xb/WiVic+51LJ/erpnXudRgxQLsPi0jFxGgbUERrVVkGB7YPPWJqAhpA1ewUZLk7+M4S02bzGQP0WLX4HjrjY8SYbtExIfydHCdiLfQ38PbCHqftZulbUgWCC+E8Sy9ZyP9eHPiG1qgLFWkUi/9ZuWUrbrwyWb0QheObAws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718807274; c=relaxed/simple;
	bh=J0iyq9z8K+ilkeHkyqkiRoS91qUS/ejsMb2z52uR5IQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DRRS0WEOsr7XabwAx10H/gBrfWiPa4aqeKxNC3u3funutciiQZoibi5H91Y12BoSnbtRTD8noFhyEdfC/g4agkvTb0I0Q84mHryM+7egRP1oZLMlxroSnvA/InHLCmNu3fiPnCpJVMnJ6c4AHw5g7ylnHAAYDWCE6hSu0v1SFk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nOU0KLxb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nOU0KLxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806F2C2BBFC;
	Wed, 19 Jun 2024 14:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718807273;
	bh=J0iyq9z8K+ilkeHkyqkiRoS91qUS/ejsMb2z52uR5IQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nOU0KLxbCvwE/ME4QRSs2Fvxl5lMWLy/Vm0ERSSFCiQYXTS3zv/qGwiGF8IFrGiGo
	 PuXUqNoyYW1DkB/1qnoInPIBJ2H4LJq9eqO0OfACJFw81gTkZYOTlBH9UQJ/newfvh
	 es6Pujqc7h3+/cG4WVVhRIJ6XiMiND0oxGs9QQB3DnrX1RyzZC28oNM3HLj5qd49cX
	 FBBOum6uMiVdNjHVY6MlNUUzaZvk/q3PmE75A6aNHPmca+hvLwMohWAOIaSPU2VwDi
	 XBabukN2TWR628mavLH1RVMeB5rBgWruTyK0SJI/gZpNJyXznwA5jmCbtMHLPmpl37
	 2Dqnlcdi4L4Aw==
Date: Wed, 19 Jun 2024 10:27:51 -0400
From: Sasha Levin <sashal@kernel.org>
To: Yu Kuai <yukuai3@huawei.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Li Nan <linan122@huawei.com>, Song Liu <song@kernel.org>,
	axboe@kernel.dk, linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.9 02/15] md: Fix overflow in is_mddev_idle
Message-ID: <ZnLq5-UAvwFliWV3@sashalap>
References: <20240526094152.3412316-1-sashal@kernel.org>
 <20240526094152.3412316-2-sashal@kernel.org>
 <217cd112-b5cb-9b6b-9dc9-b11490c2f137@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <217cd112-b5cb-9b6b-9dc9-b11490c2f137@huawei.com>

On Mon, May 27, 2024 at 09:08:27AM +0800, Yu Kuai wrote:
>Hi,
>
>在 2024/05/26 17:41, Sasha Levin 写道:
>>From: Li Nan <linan122@huawei.com>
>>
>>[ Upstream commit 3f9f231236ce7e48780d8a4f1f8cb9fae2df1e4e ]
>>
>>UBSAN reports this problem:
>>
>>   UBSAN: Undefined behaviour in drivers/md/md.c:8175:15
>>   signed integer overflow:
>>   -2147483291 - 2072033152 cannot be represented in type 'int'
>>   Call trace:
>>    dump_backtrace+0x0/0x310
>>    show_stack+0x28/0x38
>>    dump_stack+0xec/0x15c
>>    ubsan_epilogue+0x18/0x84
>>    handle_overflow+0x14c/0x19c
>>    __ubsan_handle_sub_overflow+0x34/0x44
>>    is_mddev_idle+0x338/0x3d8
>>    md_do_sync+0x1bb8/0x1cf8
>>    md_thread+0x220/0x288
>>    kthread+0x1d8/0x1e0
>>    ret_from_fork+0x10/0x18
>>
>>'curr_events' will overflow when stat accum or 'sync_io' is greater than
>>INT_MAX.
>>
>>Fix it by changing sync_io, last_events and curr_events to 64bit.
>>
>>Signed-off-by: Li Nan <linan122@huawei.com>
>>Reviewed-by: Yu Kuai <yukuai3@huawei.com>
>>Link: https://lore.kernel.org/r/20240117031946.2324519-2-linan666@huaweicloud.com
>>Signed-off-by: Song Liu <song@kernel.org>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Hi, please notice that this patch doesn't fix real issue expect for
>the ubsan warning, and this patch is reverted:

I'll drop it, thanks!

-- 
Thanks,
Sasha
