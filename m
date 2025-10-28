Received: from sg-1-17.ptr.blmpb.com (sg-1-17.ptr.blmpb.com [118.26.132.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295E43161BB
	for <linux-raid@vger.kernel.org>; Tue, 28 Oct 2025 11:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761652762; cv=none; b=TW/K6olxYLmpUAEodYYbYnmpsDBlcYFlMMB4B7rGxBKDpXEDWeIcG7tVHikLQb/jR2UtMv6c28cCLoEmwPL/97dvKBlFp3qhDTtuIpvHZH7A1f/i5G/Hl/uuoNQ9z6bVhpAYnb4xt8lDZCbtGkqb4x41H7SWqr48DYySOcCtH00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761652762; c=relaxed/simple;
	bh=8kAxUUpvPH+tLSUkOL+TdaqlC7BCFNAQ+DNQrsXJdlg=;
	h=References:Mime-Version:Subject:In-Reply-To:To:Content-Type:From:
	 Cc:Date:Message-Id; b=KJxZZl8nh2pFo0PB885DfPRNTeLoRjfDCs5OfzBVllBPcRGXObhZ8ksttQvMsUbvk8ewrMQTBgheaBkliXa5HTpyjBhT58fEoIABcAvNrAEfNEFjxM4X54Fj5XvI1+ebkmwZf/ddNZSRX/fmd5aqesAuTcNLk3dRLVmUwKwQIpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=pfWTrq2I; arc=none smtp.client-ip=118.26.132.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="pfWTrq2I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761652630;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Gh0h+kP+TFCFkPq7jxPJn9esXy4V4wufNyCV3J/qzQE=;
 b=pfWTrq2Idjdu3tkVgwYopTANtJ0yssIsk6qd5vHF/lFNi51T0r/Lut84cEOq9ntsNiTIRp
 j+e0bd3p69nlCE+n4RVaH8L8U746xhcgI4OpJJqVyt/GIB4hx+sIPmGLX2cLXQKtEObTI3
 P8kDUtp5B2b6pQe99mmoHIrWNfk6coyVkn4IoOTtozqmDgBTKFRwB49EGQUYQs5L1AUVd9
 3CV1VoYdU63Pfkah9jLPO4osNbNgb3XLOa2FIGc6jnmyXLM6XdC6Mkjwwyd3ps9M4JpwCM
 2hS57v6Cft/i6+ppBB0CnsROgZXrOzDK6Z3coSW5G/hZ+vqPRMQd2Bcw/joB2A==
References: <20251027072915.3014463-1-linan122@huawei.com> <20251027072915.3014463-2-linan122@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH v7 1/4] md: delete md_redundancy_group when array is becoming inactive
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20251027072915.3014463-2-linan122@huawei.com>
To: <linan122@huawei.com>, <corbet@lwn.net>, <song@kernel.org>, 
	<hare@suse.de>, <xni@redhat.com>
X-Lms-Return-Path: <lba+26900af94+a0a778+vger.kernel.org+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
From: "Yu Kuai" <yukuai@fnnas.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-raid@vger.kernel.org>, <linan666@huaweicloud.com>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Date: Tue, 28 Oct 2025 19:57:05 +0800
Message-Id: <0ef2d9c7-62c7-4e3e-9eab-48cbb2d7e6fd@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Tue, 28 Oct 2025 19:57:07 +0800
Reply-To: yukuai@fnnas.com

=E5=9C=A8 2025/10/27 15:29, linan122@huawei.com =E5=86=99=E9=81=93:

> From: Li Nan <linan122@huawei.com>
>
> 'md_redundancy_group' are created in md_run() and deleted in del_gendisk(=
),
> but these are not paired. Writing inactive/active to sysfs array_state ca=
n
> trigger md_run() multiple times without del_gendisk(), leading to
> duplicate creation as below:
>
>   sysfs: cannot create duplicate filename '/devices/virtual/block/md0/md/=
sync_action'
>   Call Trace:
>    dump_stack_lvl+0x9f/0x120
>    dump_stack+0x14/0x20
>    sysfs_warn_dup+0x96/0xc0
>    sysfs_add_file_mode_ns+0x19c/0x1b0
>    internal_create_group+0x213/0x830
>    sysfs_create_group+0x17/0x20
>    md_run+0x856/0xe60
>    ? __x64_sys_openat+0x23/0x30
>    do_md_run+0x26/0x1d0
>    array_state_store+0x559/0x760
>    md_attr_store+0xc9/0x1e0
>    sysfs_kf_write+0x6f/0xa0
>    kernfs_fop_write_iter+0x141/0x2a0
>    vfs_write+0x1fc/0x5a0
>    ksys_write+0x79/0x180
>    __x64_sys_write+0x1d/0x30
>    x64_sys_call+0x2818/0x2880
>    do_syscall_64+0xa9/0x580
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>   md: cannot register extra attributes for md0
>
> Creation of it depends on 'pers', its lifecycle cannot be aligned with
> gendisk. So fix this issue by triggering 'md_redundancy_group' deletion
> when the array is becoming inactive.
>
> Fixes: 790abe4d77af ("md: remove/add redundancy group only in level chang=
e")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index fa13eb02874e..f6fd55a1637b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6878,6 +6878,10 @@ static int do_md_stop(struct mddev *mddev, int mod=
e)
>   		if (!md_is_rdwr(mddev))
>   			set_disk_ro(disk, 0);
>  =20
> +		if (mode =3D=3D 2 && mddev->pers->sync_request &&
> +		    mddev->to_remove =3D=3D NULL)
> +			mddev->to_remove =3D &md_redundancy_group;
> +
>   		__md_stop_writes(mddev);
>   		__md_stop(mddev);
>  =20

Reviewed-by: Yu Kuai <yukuai@fnnas.com>
