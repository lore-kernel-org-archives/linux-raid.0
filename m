Received: from sg-1-22.ptr.blmpb.com (sg-1-22.ptr.blmpb.com [118.26.132.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037D12222CC
	for <linux-raid@vger.kernel.org>; Tue, 27 Jan 2026 02:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769480656; cv=none; b=TbSEE57mUfEyGeipU9fJAE8xNqRCDIX5VQtqLSjduzBgAFl18L6/2cbY9GmZnJqTHgGMzpS7eW2a/9vYH1LZSOegQ+xHK1z9dwqCxTVBh1/AaPQLOaDHUYSrptU/d3nxRTbc9lG2cFZba4RaRj8ER0/DVXkY01I0lmVyDIxMK8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769480656; c=relaxed/simple;
	bh=rqGQ/eI8Y3ESN/RcdcDg9/Zb6mORi9dB1BMENO4cWLE=;
	h=Message-Id:Mime-Version:References:Content-Type:To:Subject:Date:
	 Cc:From:In-Reply-To; b=pdPBsU1ZbDfzJzM42hsdytI3aZ+ZDlt8Xec4rWy56NjDc8e5nTAp5//QIQQd1HbSat9MIrK9V4bkBa1hLAFzfkJ6f02LYte4cBX9Pd3hH5178TcEW5Jol1G0YUYZX9HsCeeVDNBqTEKGZNTheP18SungyoNtYdHojyV2cujjEAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=wxi5fLL6; arc=none smtp.client-ip=118.26.132.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="wxi5fLL6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1769480642;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=rqGQ/eI8Y3ESN/RcdcDg9/Zb6mORi9dB1BMENO4cWLE=;
 b=wxi5fLL6OTaKsYP1Y8FDMfOQ7xS0HorOM4ByBeicQYugnw2J/5Zzxch5oCo4ApE8onpdhN
 /sJA5PUbgljMy7pfKjjpt0oiEBYYc+2okxCU8k/ir/NuMq1e9ZYLl9wCurrUCM4ve5b2oA
 H2Iov1FFFE6e/fYhDW0uV0X/vtFNkmMFHfLKIr7OmHak4zcpPSK6fCL/4VxO2vJWsvVIay
 ufZz3gYU1ILag815VlZAauYHI+3TyhDcmqwMDR0AghZtS2XjYolpnOdWg1voGZpp/VS31p
 lFXRIjR+tPRnhnJmXXP/9TbWQ4nw4UvZLtIqnKLc6TNPPWu9Sx2Qb+zTtpVufg==
Message-Id: <a5884dfa-4c09-4c35-8258-0f389d5d1451@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611073108.25463-1-xni@redhat.com> <20250611073108.25463-2-xni@redhat.com> <c0510f92-900d-4d63-aeae-85b2b8f5d59a@acm.org>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fnnas.com
To: "Bart Van Assche" <bvanassche@acm.org>, "Xiao Ni" <xni@redhat.com>, 
	<linux-raid@vger.kernel.org>
Subject: Re: [PATCH 1/3] md: call del_gendisk in control path
Date: Tue, 27 Jan 2026 10:23:57 +0800
Content-Transfer-Encoding: quoted-printable
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Language: en-US
Cc: <ncroxon@redhat.com>, <song@kernel.org>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+2697821c0+1c8ff6+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Tue, 27 Jan 2026 10:23:59 +0800
In-Reply-To: <c0510f92-900d-4d63-aeae-85b2b8f5d59a@acm.org>

Hi,

=E5=9C=A8 2026/1/27 10:13, Bart Van Assche =E5=86=99=E9=81=93:
> On 6/11/25 12:31 AM, Xiao Ni wrote:
>> =C2=A0 static inline int mddev_trylock(struct mddev *mddev)
>> =C2=A0 {
>> -=C2=A0=C2=A0=C2=A0 return mutex_trylock(&mddev->reconfig_mutex);
>> +=C2=A0=C2=A0=C2=A0 int ret;
>> +
>> +=C2=A0=C2=A0=C2=A0 ret =3D mutex_trylock(&mddev->reconfig_mutex);
>> +=C2=A0=C2=A0=C2=A0 if (!ret && test_bit(MD_DELETED, &mddev->flags)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENODEV;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mutex_unlock(&mddev->reconfi=
g_mutex);
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 return ret;
>> =C2=A0 }
>
> This change seems wrong to me. This change will cause mutex_unlock() to
> be called if mutex_trylock() *failed*. Additionally, returning -ENODEV
> from the failure path will cause the caller to call mutex_unlock() a
> second time if mutex_trylock() failed. Please fix this!

oops, this looks correct.

Just wonder why we didn't hit any strange bug with this, a try lock failure
should be quite possible.

>
> As a reminder, from include/linux/mutex.h:
>
> /*
> =C2=A0* NOTE: mutex_trylock() follows the spin_trylock() convention,
> =C2=A0*=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 not the down_trylock() conven=
tion!
> =C2=A0*
> =C2=A0* Returns 1 if the mutex has been acquired successfully, and 0 on=
=20
> contention.
> =C2=A0*/
>
> Bart.
>
--=20
Thansk,
Kuai
