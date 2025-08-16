Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F9210E9;
	Sat, 16 Aug 2025 00:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755305610; cv=none; b=HhKQO4sfOFH/aTfW3L+3TKdIyDht2MijVpi8JRrDmd1fCJZqS3+OEOQVGqSwLlh4ezEHQTXZpYaNKrzOeTgKoZ2zdb+2jRNT4ptybQi7RAH0eKYuJuglA+YOtcyde1OGf56JvgiZNRprsqlaaJPduEvU/twm3H+7nNbB2L/8Ook=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755305610; c=relaxed/simple;
	bh=6/oXogRSqckEYjadwzaTGSlOnJF7x4kotmMwf+VJ1v8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=olSiyEJeW54M9t88UnMXfFoA+4pV/ZtGmpyBBqZI3haONtdQg3YoXD/gORoQWWK8PkGkJqYjNrLBAMbP+WRNID7qAzDlGcaTwS2mf4/PquMurXiNaUFBYnC6Z7hPM0StoYGugDEAwPWEYlcSddC4DOJ4+vhdzekxFAFX/t1FLR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cwk0loxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cwk0loxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1F8C4CEEB;
	Sat, 16 Aug 2025 00:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755305609;
	bh=6/oXogRSqckEYjadwzaTGSlOnJF7x4kotmMwf+VJ1v8=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Cwk0loxk+gMEXPycBG1Tdf7f7v2oqnI+LXMOMfORLqAcRxiOlCV0QmQ2HAc9IKm84
	 SXv6OjlbukKEAh2WNIactAijsHixyslIC/e/hqKTaT1YdAJ3dQ+0DdI+YTxo0eCJ+j
	 k+OqW5D5JgqtP0txjpCo7ydHi3YvCI6nz+fG7NfQlE4qZLYecFgak5lDbayW1rec0x
	 YbJHC4FDjIDJZnmV0pA+MTSkqX7GmkB1DYFDrqXAhvX00K09WQ/Ry/NO/P2wI9FRHf
	 ArS79qqgjHsRiMQguh/7t0HC8CN7sDzGk/gRA7rvFtJN5LC73O+NR5AmObZP8HlMxn
	 ClH6yhJLBLK6g==
Message-ID: <2b91bd3b-450b-44d9-bd45-ab633c86da0e@kernel.org>
Date: Sat, 16 Aug 2025 08:53:22 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH v4 0/2] md: fix sync_action show
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
 yukuai3@huawei.com, linan122@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com, pmenzel@molgen.mpg.de
References: <20250816002534.1754356-1-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <20250816002534.1754356-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2025/8/16 8:25, Zheng Qixing 写道:

> From: Zheng Qixing <zhengqixing@huawei.com>
>
> Changes in v4:
>    Move "rdev->raid_disk >= 0" into rdev_needs_recovery().
>
> Changes in v3:
>    Code style modification in patch 1.
>
> Fix incorrect display of sync_action when raid is in resync.
>
> Zheng Qixing (2):
>    md: add helper rdev_needs_recovery()
>    md: fix sync_action incorrect display during resync
>
>   drivers/md/md.c | 60 ++++++++++++++++++++++++++++++++++++++-----------
>   1 file changed, 47 insertions(+), 13 deletions(-)

Applied to md-6.17

Thanks

