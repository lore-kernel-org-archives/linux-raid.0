Received: from sg-1-22.ptr.blmpb.com (sg-1-22.ptr.blmpb.com [118.26.132.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BD41A3160
	for <linux-raid@vger.kernel.org>; Thu, 25 Dec 2025 08:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766651983; cv=none; b=ADoGmwcWepCQdB3jyRJAzSf54laqHOdtlxb161x4lwFUmEMPuQk3ZkzRrrUYKK10TbzdvEZObwel/NTV9wjfsW6In7Qevcl2wC3ctG0oi5DkV3M5WuiEczbwkCTW/sPGbDBDza0Aab7+uqr19ISVRT4SaN5zfxMaqIASrKHKPOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766651983; c=relaxed/simple;
	bh=2OOydMStwyMgWiD4v2h/g7aotrwNkvzfORqna4lC3Uw=;
	h=From:Message-Id:In-Reply-To:To:Cc:Subject:Date:Content-Type:
	 References:Mime-Version; b=RIrlUDDisV1Vx77REWVsALR6LAb0vfCy/98e74F5M3MyrbVqAn6+/p1vZ3s+vnqG0bEcllz3ex5C85nVOTmtEvffeRj4dcw1hLqiOP+UhTiNZxtkO5fP0AaN57IpgIimqP4GfmVdJC900Vz6PUBNB1iVRjMxfAc5jdMaYbUWO9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=GtBFarG3; arc=none smtp.client-ip=118.26.132.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="GtBFarG3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1766651974;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=e21Z6uxx6ZUlyW1mDV+zSZqpC6zqnVKQfMbKgYhxMBU=;
 b=GtBFarG3YC/JVkIFsoGPQ1o9ftHaUo5CGV9APW5loTL2ufQWqlaLIWOF1nOYR+QKJJkXxt
 U+X9Zx9A0QwTGdf4KBvsNvxHxaNUPslXZNKx2so0U64VCoIQ3O3VkDxoj/XI4DXpg4TrxS
 gd1KA1OqEMm+BmiMwAEd3gcXPrtA7zXTxhQKduuPBnX4eBOraIW6PhDzdy6Z/lZC9XS29P
 3IKgyB6/sIv8xUmRY9ArnnDQov95alMwgC53ByiVorhP65wGAMo5NzklR+NaQL2nWBqPjo
 mZE9dm0tnHXANJKJI7WCy1j/WVB4LOvV9T/inEIpw7S3MYMnRjT8cGxbrUyJzQ==
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <f4fba874-9ad7-4efd-9240-79c452494b8a@fnnas.com>
In-Reply-To: <20251219092127.1815922-2-linan666@huaweicloud.com>
Content-Language: en-US
To: <linan666@huaweicloud.com>, <song@kernel.org>, <xni@redhat.com>, 
	<linan122@huawei.com>
Content-Transfer-Encoding: quoted-printable
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>, <bugreports61@gmail.com>, 
	<yukuai@fnnas.com>
Subject: Re: [PATCH 2/2] md: Fix forward incompatibility from configurable logical block size
Date: Thu, 25 Dec 2025 16:39:30 +0800
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+2694cf844+d1818e+vger.kernel.org+yukuai@fnnas.com>
References: <20251219092127.1815922-1-linan666@huaweicloud.com> <20251219092127.1815922-2-linan666@huaweicloud.com>
Reply-To: yukuai@fnnas.com
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Thu, 25 Dec 2025 16:39:31 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Hi,

=E5=9C=A8 2025/12/19 17:21, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> Commit 62ed1b582246 ("md: allow configuring logical block size") used
> reserved pad to add 'logical_block_size' to metadata. RAID rejects
> non-zero reserved pad, so arrays fail when rolling back to old kernels
> after booting new ones.
>
> Set 'logical_block_size' only for newly created arrays to support rollbac=
k
> to old kernels. Importantly new arrays still won't work on old kernels to
> prevent data loss issue from LBS changes.
>
> For arrays created on old kernels which confirmed not to rollback,
> configure LBS by echo 'enable' to md/logical_block_size.
>
> Fixes: 62ed1b582246 ("md: allow configuring logical block size")
> Reported-by: BugReports <bugreports61@gmail.com>
> Closes: https://lore.kernel.org/linux-raid/825e532d-d1e1-44bb-5581-692b7c=
091796@huaweicloud.com/T/#t
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.c | 44 ++++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 40 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7c0dd94a4d25..28c9435016fe 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2014,8 +2014,14 @@ static int super_1_validate(struct mddev *mddev, s=
truct md_rdev *freshest, struc
>  =20
>   		mddev->max_disks =3D  (4096-256)/2;
>  =20
> -		if (!mddev->logical_block_size)
> +		if (!mddev->logical_block_size) {
>   			mddev->logical_block_size =3D le32_to_cpu(sb->logical_block_size);
> +			if (!mddev->logical_block_size)
> +				pr_warn("%s: echo 'enable' to md/logical_block_size to prevent data =
loss issue from LBS changes.\n"
> +					"    Note: After enable, array will not be assembled in old kernels=
 (<=3D 6.18)\n",
> +					mdname(mddev));

Looks like this will print the same message for every rdev added to this ar=
ray, please move the warning to
mddev_stack_rdev_limits() as well.

> +		}
> +
>  =20
>   		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) &&
>   		    mddev->bitmap_info.file =3D=3D NULL) {
> @@ -5983,8 +5989,27 @@ lbs_store(struct mddev *mddev, const char *buf, si=
ze_t len)
>   	if (mddev->major_version =3D=3D 0)
>   		return -EINVAL;
>  =20
> -	if (mddev->pers)
> -		return -EBUSY;
> +	if (mddev->pers) {
> +		if (mddev->logical_block_size)
> +			return -EBUSY;
> +		/*
> +		 * To fix forward compatibility issues, LBS is not
> +		 * configured in old kernels array (<=3D6.18) by default.
> +		 * If the user confirms no rollback to old kernels,
> +		 * enable LBS by writing "enable" =E2=80=94 to prevent data
> +		 * loss from LBS changes.
> +		 */
> +		if (cmd_match(buf, "enable")) {
> +			mddev->logical_block_size =3D
> +				queue_logical_block_size(mddev->gendisk->queue);
> +			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> +			pr_info("%s: config logical block size success, array will not be ass=
embled in old kernels (<=3D 6.18)\n",
> +				mdname(mddev));

Instead of a new string "enabled", I'll prefer to echo the exact lbs.

> +			return len;
> +		} else {
> +			return -EBUSY;
> +		}
> +	}
>  =20
>   	err =3D kstrtouint(buf, 10, &lbs);
>   	if (err < 0)
> @@ -6165,7 +6190,18 @@ int mddev_stack_rdev_limits(struct mddev *mddev, s=
truct queue_limits *lim,
>   			mdname(mddev));
>   		return -EINVAL;
>   	}
> -	mddev->logical_block_size =3D lim->logical_block_size;
> +
> +	/*
> +	 * Fix forward compatibility issue. Only set LBS by default for
> +	 * new array, mddev->events =3D=3D 0 indicates the array was just
> +	 * created. When assembling an array, read LBS from the superblock
> +	 * instead =E2=80=94 LBS is 0 in superblocks created by old kernels.
> +	 */
> +	if (!mddev->events && mddev->major_version =3D=3D 1) {
> +		pr_info("%s: array will not be assembled in old kernels that lack conf=
igurable lbs support (<=3D 6.18)\n",
> +			mdname(mddev));
> +		mddev->logical_block_size =3D lim->logical_block_size;
> +	}
>  =20
>   	return 0;
>   }

--=20
Thansk,
Kuai
