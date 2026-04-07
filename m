Received: from sg-3-27.ptr.tlmpb.com (sg-3-27.ptr.tlmpb.com [101.45.255.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E018C3314D0
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 05:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775538212; cv=none; b=BGT40YILcW14YcSpOmfutJ404CLhjp9vX3bL/BRpPMa3qCpoEC3bF1DJzebdl1h1RCzUdIOMtTBlUf+ITZWx1Z3xqj1LS1l0TisFrWeYiZiyi5TTkte17oZZpoYmWGBSiIPa9i2Lo26aw/CwJTaAs0+p7tJucBWHZgsTomCueRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775538212; c=relaxed/simple;
	bh=ljwPfD6zEvVSN7ZaHxeeB7r5VLb2IKPSFQ364SaO9pg=;
	h=Subject:In-Reply-To:Message-Id:To:Cc:From:Date:Mime-Version:
	 References:Content-Type; b=pCtgsxtY+BOI6AnnHxlcUFS4Whl7q9rnLfLfBR2YQDHHfTMZR9C/7tXljN57pQPaA12Ekn5QPJ0Slx/WRI4rc3QPd3EsIBZWSgLtUeXYDdU/u9TLhJYXncMqvgKlXvlZzPProrYxt+wUyU9ilpvbxbEkmszuLqvfm/6BGkc3Itg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=d39FQEV8; arc=none smtp.client-ip=101.45.255.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="d39FQEV8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775538157;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=IlJSLoyYww16diX9MWRtVxet8qQKT8KlD9zbEVQkGL4=;
 b=d39FQEV8v3/q7runRQawZb2MjfigkvwQfyaoU86NgDu35XhPr4a+Xn2w85+zkGJumgzcxO
 jYkw1CdZS15k5Pdrgf12Xg03pNizkNKp19xMWiQLYYNwVKCRy/SGckNFsH95aIkfi/1zNB
 NLrRsSfjbNLykl66f3II6w16CzjTzlZgp2erg98tqgmFnxiNize+BJx8YZMSg/yU8jl3Vs
 AqIxWu5UxoDBbv+XlaAmQu76gYg6QlJoQIP0S+QkcJQRBp7uQ+/sgQcJgWCEkWS+6FOdSA
 xULzH/XjRdYDwXDOGDaz7e9RGjH9F7KoM4b/OwhPmaWCvPg9LxlWoi+bqBh3Xg==
Subject: Re: [PATCH] md: fix array_state=clear sysfs deadlock
In-Reply-To: <20260330055213.3976052-1-yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.129]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 13:02:34 +0800
Message-Id: <2660f553-3635-4606-b90e-7398e5561341@fnnas.com>
To: <song@kernel.org>
Cc: <linan122@huawei.com>, <xni@redhat.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Tue, 7 Apr 2026 13:02:32 +0800
Content-Language: en-US
X-Original-From: Yu Kuai <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+269d48feb+9cf83d+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260330055213.3976052-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/3/30 13:52, Yu Kuai =E5=86=99=E9=81=93:

> From: Yu Kuai<yukuai3@huawei.com>
>
> When "clear" is written to array_state, md_attr_store() breaks sysfs
> active protection so the array can delete itself from its own sysfs
> store method.
>
> However, md_attr_store() currently drops the mddev reference before
> calling sysfs_unbreak_active_protection(). Once do_md_stop(..., 0)
> has made the mddev eligible for delayed deletion, the temporary
> kobject reference taken by sysfs_break_active_protection() can become
> the last kobject reference protecting the md kobject.
>
> That allows sysfs_unbreak_active_protection() to drop the last
> kobject reference from the current sysfs writer context. kobject
> teardown then recurses into kernfs removal while the current sysfs
> node is still being unwound, and lockdep reports recursive locking on
> kn->active with kernfs_drain() in the call chain.
>
> Reproducer on an existing level:
> 1. Create an md0 linear array and activate it:
>     mknod /dev/md0 b 9 0
>     echo none > /sys/block/md0/md/metadata_version
>     echo linear > /sys/block/md0/md/level
>     echo 1 > /sys/block/md0/md/raid_disks
>     echo "$(cat /sys/class/block/sdb/dev)" > /sys/block/md0/md/new_dev
>     echo "$(($(cat /sys/class/block/sdb/size) / 2))" > \
> 	/sys/block/md0/md/dev-sdb/size
>     echo 0 > /sys/block/md0/md/dev-sdb/slot
>     echo active > /sys/block/md0/md/array_state
> 2. Wait briefly for the array to settle, then clear it:
>     sleep 2
>     echo clear > /sys/block/md0/md/array_state
>
> The warning looks like:
>
>    WARNING: possible recursive locking detected
>    bash/588 is trying to acquire lock:
>    (kn->active#65) at __kernfs_remove+0x157/0x1d0
>    but task is already holding lock:
>    (kn->active#65) at sysfs_unbreak_active_protection+0x1f/0x40
>    ...
>    Call Trace:
>     kernfs_drain
>     __kernfs_remove
>     kernfs_remove_by_name_ns
>     sysfs_remove_group
>     sysfs_remove_groups
>     __kobject_del
>     kobject_put
>     md_attr_store
>     kernfs_fop_write_iter
>     vfs_write
>     ksys_write
>
> Restore active protection before mddev_put() so the extra sysfs
> kobject reference is dropped while the mddev is still held alive. The
> actual md kobject deletion is then deferred until after the sysfs
> write path has fully returned.
>
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Signed-off-by: Yu Kuai<yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
Applied to md-7.1

--=20
Thansk,
Kuai
