Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52B8212564
	for <linux-raid@vger.kernel.org>; Sun, 22 Mar 2026 18:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774204295; cv=none; b=OueNOgBRP5uhNd13rdY0mcxfb5O58kCgnRlUiSzHceZekVhHr/0frviiQMk6neeatGp2FaIhxlZAt3EdJy3nkWb4f5WF0nMly3L/jsLEdwFtSh/XpQRqLmtBMfmYFbWZGVmZ6qvVO4bWZxzOdy8fXd0ib/OhqTyEkSSxCY8qbsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774204295; c=relaxed/simple;
	bh=41vGL7bRrxrFIqTJHOiljvblWiGlT/ooj40XUlODx70=;
	h=Cc:Mime-Version:To:References:Date:Content-Type:In-Reply-To:From:
	 Subject:Message-Id; b=s+DHZth8icuUeFlQgUjTFB0YW7HKVHCqgflsMneyeUyA1u/ziY8zy+QAM8bZfh2cIWM32KLxzR1V2wW9lR5eI20cJ9dRmKpsDgb7eEPHdvQgcPR1iszKfMysxVf23mCYp9VwufSdiIkAtcx1FeBVrfC9zQSgzePlcfGUD1veEEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=baipqHE6; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="baipqHE6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1774204290;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=KxCuwNHYV4+uH2SvvKT8h//N5Foh8jIdp7KAP8uAdtk=;
 b=baipqHE6G5Z/OTUitbJpOmBr3LtM5o5v1AeViL49onQooxlgSf7jOJ4nYP23DXOcIjwWT+
 BbsY0yNeZM+x9f7eG5+naSIto2UYCP3CmeoOaWBfKyH3H+qc9SwGM45tjSoB+3+EqJ0qAl
 R7TqgvpmV10B8ZnYB9TtGWOlDQRiRTrK+lP2fE1yoOhbxntESueFJ84I+dBkaWhtnfIjDm
 H5JcgRvX2+tSmgDItQO5WUXTptwhL20PQeftynD1Pt6jdtqpiQDRowEiYZGuOcS/zBYyRn
 NWaGh7Kux/Pm1JxnVNAJCE7Y0AFsL2c7wJ6G4CvUfJjewEeuhvHBCOj2Xu3j1g==
Cc: <linan122@huawei.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Reply-To: yukuai@fnnas.com
To: "FengWei Shih" <dannyshih@synology.com>, <song@kernel.org>, 
	<yukuai@fnnas.com>
Content-Language: en-US
References: <20260319053351.3676794-1-dannyshih@synology.com>
Received: from [192.168.1.104] ([39.182.0.158]) by smtp.feishu.cn with ESMTPS; Mon, 23 Mar 2026 02:31:27 +0800
Date: Mon, 23 Mar 2026 02:31:25 +0800
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260319053351.3676794-1-dannyshih@synology.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+269c03580+0e90cc+vger.kernel.org+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH] md/raid5: skip 2-failure compute when other disk is R5_LOCKED
Message-Id: <52b28767-c272-4ace-9082-648976ca6a20@fnnas.com>

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
Applied

--=20
Thansk,
Kuai
