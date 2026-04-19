Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB388212B2F
	for <linux-raid@vger.kernel.org>; Sun, 19 Apr 2026 05:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776576401; cv=none; b=AM2XTrs5fCedWlWzlsRrmVVEbe4cL9rahPzr4WEmw00W37at78vwjnfPFaRDMABJTpYqImnkGUTUPUiCADmSUwcYrIwshrGT5VAlWszwKW9stxjat2OJnLI3SFFGluT01GYTG/OVOO6fWydmFxnXB50C+bCMZI3FMRSlOC3Uixg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776576401; c=relaxed/simple;
	bh=qAe/+Kka1oSLw343hUCRaBlchDxBb1d4r7MWHz6d+P4=;
	h=To:Date:Message-Id:From:Content-Type:Subject:Mime-Version:
	 References:Cc:In-Reply-To; b=i7q3dzHLkvvrncnlzzIYU7DEnHxSTRCvYNCYPQeXpBshNl6ygobQEA84s1Wxd3PQHtLYAir86MIlq/kcUjfeLsNfHQeHPbrTuHXhoy42O5VdsUNcCMH+AOZLz7/NrXT/QWlXtJDwaFlRT1owPbvuHuHDFvm6e7qWZz5J4LnKh38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=j3S765cO; arc=none smtp.client-ip=209.127.231.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="j3S765cO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776576393;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=TW3wPZr8kBOV33ROTqPuH6BMLqYBw3wHJQ8Jo+j277E=;
 b=j3S765cOxES3mNooEqMbmkt20dr/Ewt46eP4kCECs+v3etlg5md3H4prRvJKOZIN1JQJO8
 4et/Ne9CGIhpNoSatkN3UQV0gWfU7A8ipXKJUMs3frXSs1NO20bCOWH6twvGUUi/k5uD9C
 JyRU1k8Dq9M2KiZ2Efjjjy5aF2tAUm2nz08IrmZ/nJt+dvMy6EgC9ckvRUvj/DeBEqmkwx
 zZCRdQrU6TjyzzHH/2WTLo/2AmkDuHEWRRYyz85WE+qwBlix4vulH5Gd9sUZm9hZUv5l+M
 93pDGvWzC+OKFDe9CAMy2sU7n04f9XJvUmQiR+VT/iaRy/bxgqdre02vQeo9eg==
Reply-To: yukuai@fnnas.com
To: "Keith Busch" <kbusch@meta.com>, <linux-raid@vger.kernel.org>, 
	<song@kernel.org>
Date: Sun, 19 Apr 2026 13:26:28 +0800
Message-Id: <fd07b6bb-a277-4984-a449-11c9bfc40436@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.feishu.cn with ESMTPS; Sun, 19 Apr 2026 13:26:30 +0800
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH] md/raid1,raid10: don't fail devices for invalid IO errors
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260416140345.3872265-1-kbusch@meta.com>
X-Lms-Return-Path: <lba+269e46787+76576b+vger.kernel.org+yukuai@fnnas.com>
Cc: <linan122@huawei.com>, <axboe@kernel.dk>, 
	"Keith Busch" <kbusch@kernel.org>, 
	=?utf-8?q?Tom=C3=A1=C5=A1_Trnka?= <trnka@scm.com>, <yukuai@fnnas.com>
In-Reply-To: <20260416140345.3872265-1-kbusch@meta.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Language: en-US

=E5=9C=A8 2026/4/16 22:03, Keith Busch =E5=86=99=E9=81=93:

> From: Keith Busch<kbusch@kernel.org>
>
> BLK_STS_INVAL indicates the IO request itself was invalid, not that the
> device has failed. When raid1 treats this as a device error, it retries
> on alternate mirrors which fail the same way, eventually exceeding the
> read error threshold and removing the device from the array.
>
> This happens when stacking configurations bypass bio_split_to_limits()
> in the IO path: dm-raid calls md_handle_request() directly without going
> through md_submit_bio(), skipping the alignment validation that would
> otherwise reject invalid bios early. The invalid bio reaches the
> lower block layers, which fail the bio with  BLK_STS_INVAL, and raid1
> wrongly interprets this as a device failure.
>
> Add BLK_STS_INVAL to raid1_should_handle_error() so that invalid IO
> errors are propagated back to the caller rather than triggering device
> removal. This is consistent with the previous kernel behavior when
> alignment checks were done earlier in the direct-io path.
>
> Fixes: 5ff3f74e145adc7 ("block: simplify direct io validity check")
> Link:https://lore.kernel.org/linux-block/2982107.4sosBPzcNG@electra/
> Reported-by: Tom=C3=A1=C5=A1 Trnka<trnka@scm.com>
> Signed-off-by: Keith Busch<kbusch@kernel.org>
> ---
>   drivers/md/raid1-10.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
Applied

--=20
Thansk,
Kuai
