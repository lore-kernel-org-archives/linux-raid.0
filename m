Received: from sg-3-30.ptr.tlmpb.com (sg-3-30.ptr.tlmpb.com [101.45.255.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE273DB62E
	for <linux-raid@vger.kernel.org>; Wed, 20 May 2026 11:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276857; cv=none; b=uNdwwQjV41GXNZdjs6pAPSwcicJrf1bDjajv8Yd4hJWA10alP6sz53F+OWmJLtN5YPE5lHhXusnWSYUIz29ERTFZQgxOqlJQibR04StgdHiR15t5y6zym860g1AWRQD17qbis6A4DeWxyqIM8ejFpaos4ccs1OnbaV+2dx90h3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276857; c=relaxed/simple;
	bh=0o2nObvqH3u9BNUBiv/gFGv5X833OTocMIFEP9/n+ns=;
	h=To:From:Cc:Subject:Message-Id:Mime-Version:Content-Type:Date:
	 References:In-Reply-To; b=tD2pUkVdG8EWgQ9Pf1iLEtQgyJzQHzKG5KPrXebL4eRgVZ+d+owi0QOE7nFQ3i16PqghfS2agDQ1PJhZWCLh04jvq4fgqL5lD3YAlz4dKe6b20ePyiJmFXUXwReGuQV5EutwBOYw7Yj5vaipamkJQkmd0NWDBX98kDS9U5L+oic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=NOH0PlIK; arc=none smtp.client-ip=101.45.255.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="NOH0PlIK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1779276765;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=8zM2yHtNrDRHYMdxATXW/B9PcSMlgIID6KvV0ofnQL0=;
 b=NOH0PlIKHKOcLfs00R5xtlaXeeSfJDRBwfzCOADtyVMcW1comSwkALtoRNPgGNDnGz5NfS
 voQyAGjNsuyb2mp0XFtEE7nqaMrxKSdo9hHaFxEj2WVTkY1yHlbb4lj/4RgE0/tL7bw3vc
 UhHlDDGYNZs7qoiF6+xyEPfWaDdwbSGfCfG/Ulnr7Cr4bBWiYct6V6vc09TesXS5/pP7GT
 9kQIquNBtayXKFN/MYVi+Qac5bnwDfIBDknrKqjTOg4VPFdCskMbCm2FqCMv28CVTY++kJ
 CbYQZ1u77Ag4S/sRoRJ9SFNms0PkafskpCs7Og9kQJjMnMzqV9igCk8a40UWAA==
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
To: "Li Nan" <magiclinan@foxmail.com>, <song@kernel.org>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fygo.io>
X-Original-From: Yu Kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a0d9bdc+b39055+vger.kernel.org+yukuai@fygo.io>
Cc: <zhangtonghao@didiglobal.com>, <linux-kernel@vger.kernel.org>, 
	<linux-raid@vger.kernel.org>, <xiao@kernel.org>, 
	<magiclinan@didiglobal.com>
Subject: Re: [PATCH RESEND] MAINTAINERS: Update Li Nan's E-mail address
Message-Id: <1c3a139f-454c-4d92-8185-3af4a6c47278@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.larksuite.com with ESMTPS; Wed, 20 May 2026 11:32:44 +0000
Content-Type: text/plain; charset=UTF-8
Date: Wed, 20 May 2026 19:32:40 +0800
References: <tencent_8F8173BEDF20E98550D5429DF802F34A7108@qq.com>
Content-Language: en-US
In-Reply-To: <tencent_8F8173BEDF20E98550D5429DF802F34A7108@qq.com>

=E5=9C=A8 2026/5/8 17:55, Li Nan =E5=86=99=E9=81=93:

> From: Li Nan <magiclinan@didiglobal.com>
>
> Change to my new email address on didiglobal.com.
>
> Signed-off-by: Li Nan <magiclinan@didiglobal.com>
> ---
> add cc linux-raid
>
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 06c00e40999f..96702de58cc1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24763,7 +24763,7 @@ F:	include/linux/property.h
>   SOFTWARE RAID (Multiple Disks) SUPPORT
>   M:	Song Liu <song@kernel.org>
>   M:	Yu Kuai <yukuai@fnnas.com>
> -R:	Li Nan <linan122@huawei.com>
> +R:	Li Nan <magiclinan@didiglobal.com>
>   R:	Xiao Ni <xiao@kernel.org>
>   L:	linux-raid@vger.kernel.org
>   S:	Supported
Applied

--=20
Thansk,
Kuai
