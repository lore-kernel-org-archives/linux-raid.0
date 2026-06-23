Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3403F222597
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 12:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782219088; cv=none; b=kOuqtmsYHse3l9dRPcHJiXCD4Nglrm/o2emT8d3IDPxajNXDPnwhw+IWhc3H1zyk77dSvpFwqMd5T2rrtIkmLoCK5bFoerS91cNJWjYA3kK1mHY1EmLgT3kL4DLx6PVB+IqgysltsvlNWK3RmrEMMzRpG3XYtGr4VH4o3foVMsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782219088; c=relaxed/simple;
	bh=3XtlspSA1T0EtcAqXSUE0FKXGL7Eiw5VaTIR30igwSM=;
	h=Content-Type:To:Subject:References:Mime-Version:Cc:Date:
	 Message-Id:From:In-Reply-To; b=Mp32v4PYFB7GOhXMj+BedAY138sC7UUxgTYctk9iAdO0Emuio2/2Pm/2cwKeN+Lr7GMNtlpsjogC8LZgUPOgUiEGwMYn8wdLUEZr1ESaADFMaUvBluLPXcY0Srg86nCP9pMYKTjW9UYLZds3DJymZnaGczm0GLn+1zfTskba93o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=0Zg+wi9u; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="0Zg+wi9u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782219076;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=5397kGXq9BuZqiBMsUtgfQhHRZZtRApMK8NOvkq3vbA=;
 b=0Zg+wi9ugDOmBqE2bGEf8m5y5mPlTRbaFUhsEdOdneAN+q5K2IOpfe6ODLASis2MO/gxhi
 KXxQGIc+KoC+6x6eb8DH3m96mpDGsbFxO8ji+BpITmtk3enEEH3SiN8uKC4/a46cfDD0FI
 1nMjNMjbgGNsPY1+ZkicM7mn+41/a85E0XGNKjtJZxePiS197OCT37LpXm+R+i3P/SkcJe
 tV9M9ZlMGqk+84H6IcTNnlNu0BgnrvIOIqYJdGNUoGCheI2rEEBRlVmEQUpGuezCaSxP9f
 ORSVyI1tO4RxuvOLRpFQiLFnI8cLjgH1kBdc4NmHqCryP4LAIQ2rgb7uPcD8Kw==
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
X-Original-From: Chen Cheng <chencheng@fnnas.com>
To: <sashiko-reviews@lists.linux.dev>
Subject: Re: [PATCH v2] md: use READ_ONCE() for lockless reads of sb_flags
References: <20260623111617.2500313-1-chencheng@fnnas.com> <20260623112532.4D4761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.8.62] ([183.34.169.141]) by smtp.feishu.cn with ESMTPS; Tue, 23 Jun 2026 20:51:13 +0800
Cc: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>, 
	"Chen Cheng" <chencheng@fnnas.com>, <chenchneg33@gmail.com>
Date: Tue, 23 Jun 2026 20:51:12 +0800
Message-Id: <085ee11a-d5f5-4d68-aa21-647543f9ab4a@fnnas.com>
X-Lms-Return-Path: <lba+26a3a8142+a2dfd1+vger.kernel.org+chencheng@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260623112532.4D4761F000E9@smtp.kernel.org>

=E5=9C=A8 2026/6/23 19:25, sashiko-bot@kernel.org =E5=86=99=E9=81=93:
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>=20
> Pre-existing issues:
> - [Low] Lockless plain reads of `mddev->recovery` will cause KCSAN data r=
ace warnings, similar to the ones fixed for `sb_flags`.
> --
>=20
> commit f286787fa23a14cb6ec022eb99574f7a85f9957d
> Author: Chen Cheng <chencheng@fnnas.com>
>=20
> md: use READ_ONCE() for lockless reads of sb_flags
>=20
> This patch adds READ_ONCE() annotations to lockless reads of mddev->sb_fl=
ags
> across md, raid1, raid5, and raid10. It aims to fix KCSAN data race warni=
ngs
> caused by concurrent set_bit() operations on sb_flags.
>=20
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 096bb64e87bd5..c5c50640b6849 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6832,7 +6832,7 @@ int md_run(struct mddev *mddev)
>>   		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>>   	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>=20
> [Severity: Low]
> This is a pre-existing issue, but since this patch targets KCSAN warnings=
 for
> atomic bitmasks, could plain lockless reads of mddev->recovery trigger si=
milar
> data races?
>=20
> There are places where mddev->recovery is read without locks and without
> READ_ONCE(), potentially causing KCSAN noise against set_bit() updates:
>=20
> drivers/md/md.c:md_sync_action() {
>      ...
>      unsigned long recovery =3D mddev->recovery;
>      ...
> }
>=20
> drivers/md/md.c:set_bitmap_file() {
>      ...
>      if (mddev->recovery || mddev->sync_thread)
>      ...
> }
>=20
> drivers/md/md.c:update_array_info() {
>      ...
>      if (mddev->recovery || mddev->sync_thread) {
>      ...
> }
>=20
> Should READ_ONCE() also be applied to these reads of mddev->recovery to
> provide a more complete fix?
>=20
>> -	if (mddev->sb_flags)
>> +	if (READ_ONCE(mddev->sb_flags))
>>   		md_update_sb(mddev, 0);
>=20

Only md_sync_action() do lockless u64 plain read, READ_ONCE could be=20
safer in here ..
