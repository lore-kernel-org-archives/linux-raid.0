Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1222E28469F
	for <linux-raid@vger.kernel.org>; Fri, 20 Mar 2026 04:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773979472; cv=none; b=f2VPtCAsSSJDL2ADWFUfETL7ze65tUVe5f/fyTQVfZNXFna7PgZoM18dJczcMgUdlXn7FD3WMBdk6V3LjXLxRbWaGjnaAKDeTtP1sCgxkZosiv9yCxNw8EfQl/rvTtTdy7mUpLPf08+2VHEepuDl78+EnoZVhCiYeYgSRxkmvkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773979472; c=relaxed/simple;
	bh=tGG7/srvOqJ6xJDzhUQ+g8Rn+rnNk4N6v7Y/+xizGog=;
	h=Date:Message-Id:Cc:From:Subject:References:Content-Type:To:
	 In-Reply-To:Mime-Version; b=lPncR4JOFOUf3knVPCbODAAbXV4qc86X34FmvIgpXfXRPPD+DOEhOX2XxvG8/SMowv9fRWEQOO+4v823gc3nxUajqRE6bvz3CqOwvBWzk6VVTW3ejW1he5Q8R88Ks9RYNf1IMBXrRXuLbRiyHVrBqyUmm5U8ERrrhoYXuEj8nhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=tpiukr7h; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="tpiukr7h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1773979459;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=B9gxA3niPjKrJ4CtRDkYEFjh6MElBEpDNSRdbJH4UiA=;
 b=tpiukr7hlkdRj2KubxfuzTveOqNwfdm98gWV6etO7xjYFZQ9UxtXMLmNx0cBfGN7J5hTFA
 PWU5AhcHGSjfv1DFyPb85GthDjvcBExAE/fcRCZib+QGK4+qk35HP4abqxWaSe1NvAXBrN
 uNFwWm69WHY3yJzTiwuPLC+26mDj9yEixgv8XikEBmg5blryY56lKXX5gKz7SVDPcZMadE
 GOhjnfceUXbnMBavxYsNxzTPoxiAR9hni7z3rUDendekMLsf+rwQoI8Q0yTw9ljGrhBUvJ
 +kZJiH0jIDd7BujQzYyyoLDFuTjJYX0NG3iky+Cx2fUHq5UWOszvY3M27gsjIA==
Date: Fri, 20 Mar 2026 12:04:14 +0800
Message-Id: <9ee1c559-d4cb-41c8-91d1-a4cf5ce93385@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.175]) by smtp.feishu.cn with ESMTPS; Fri, 20 Mar 2026 12:04:16 +0800
Cc: <linan122@huawei.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH] md/raid5: skip 2-failure compute when other disk is R5_LOCKED
References: <20260319053351.3676794-1-dannyshih@synology.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To: "FengWei Shih" <dannyshih@synology.com>, <song@kernel.org>, 
	<yukuai@fnnas.com>
In-Reply-To: <20260319053351.3676794-1-dannyshih@synology.com>
X-Lms-Return-Path: <lba+269bcc741+2a5578+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
X-Original-From: Yu Kuai <yukuai@fnnas.com>

=E5=9C=A8 2026/3/19 13:33, FengWei Shih =E5=86=99=E9=81=93:

> When skip_copy is enabled on a doubly-degraded RAID6, a device that is
> being written to will be in R5_LOCKED state with R5_UPTODATE cleared.
> If a new read triggers fetch_block() while the write is still in
> flight, the 2-failure compute path may select this locked device as a
> compute target because it is not R5_UPTODATE.
>
> Because skip_copy makes the device page point directly to the bio page,
> reconstructing data into it might be risky. Also, since the compute
> marks the device R5_UPTODATE, it triggers WARN_ON in ops_run_io()
> which checks that R5_SkipCopy and R5_UPTODATE are not both set.
>
> This can be reproduced by running small-range concurrent read/write on
> a doubly-degraded RAID6 with skip_copy enabled, for example:
>
>    mdadm -C /dev/md0 -l6 -n6 -R -f /dev/loop[0-3] missing missing
>    echo 1 > /sys/block/md0/md/skip_copy
>    fio --filename=3D/dev/md0 --rw=3Drandrw --bs=3D4k --numjobs=3D8 \
>        --iodepth=3D32 --size=3D4M --runtime=3D30 --time_based --direct=3D=
1
>
> Fix by checking R5_LOCKED before proceeding with the compute. The
> compute will be retried once the lock is cleared on IO completion.
>
> Signed-off-by: FengWei Shih<dannyshih@synology.com>
> ---
>   drivers/md/raid5.c | 2 ++
>   1 file changed, 2 insertions(+)

Reviewed-by: Yu Kuai <yukuai@fnnas.com>

--=20
Thansk,
Kuai
