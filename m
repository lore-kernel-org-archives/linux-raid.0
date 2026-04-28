Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4046A3D47B1
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 08:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777364979; cv=none; b=CJQGfKBc5NblWSc8/G8FayawcoyRn8olAmQ3qPkWQdJso9mE4wRQ6q2uLrasq6+7dl6Mgj5DU4PBhm/mab3VzEMnihd8SMx2z7Nqjy9nkvcR8NCBHNtMkk0CujPrf/JLiYL9wm3h9Ax6cEd9g67fsw4unfyXspx6ny6X+TexG/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777364979; c=relaxed/simple;
	bh=2JUJvrEhHSbFSq2utk1VdncVdhYJ4c0a1z/GNG46j7c=;
	h=Subject:References:Content-Type:To:From:Cc:Date:Mime-Version:
	 Message-Id:In-Reply-To; b=Zxt/96JogyilshPyvW8Gr1BbfLsfzooXelnrs4HADVIdDirFsYdw2KCzaYwhRMw+MnjlT7m9VcBqkzsXEU1DyhCjbeF0wE4h0bJJqwZxjqk/JYROk29LqxYOzLSb3zFopL94BklykKpUdyJR9SmGi9HYEHoiamHrfSDFRK2+CLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=vYNRuvEQ; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="vYNRuvEQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1777364963;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=2JUJvrEhHSbFSq2utk1VdncVdhYJ4c0a1z/GNG46j7c=;
 b=vYNRuvEQ6hbKy3efxYa3Bfj15qcsuPJmAb1AwvZchA4yb5M9k/ljxqQZdu5DcDtei2WT1j
 VMAzARv9ItX9XVG2aeJgEPkCv5LnvBU8qbnRJ6Lt39f/scRYCWh/TB9eDBxodzyyaIdiqh
 7m4AAOpF19QvPDkqOQAF6DAnhBnTBtwEOCmW8S+NaXhelJX8QxzkmZ+p9NdgY0MTq0Wcxb
 dZnVOBurCMkT8O8nsDlz8M5NFhyxbO0o8Awt10ldCRmkhbMd1z9M6GiFoHZZMEZXNKx6zC
 /vGg44Mqkjc1ROC0ziQLyufzFgjsYbS6jNQgT5k6kdtwsAJMXbEU31lKanNltA==
Content-Language: en-US
X-Lms-Return-Path: <lba+269f06fe1+7e7b5b+vger.kernel.org+yukuai@fnnas.com>
Subject: Re: [PATCH] md/raid5: fix race between reshape and chunk-aligned read
References: <20260409051722.2865321-1-dannyshih@synology.com> <68b61dc3-f7fa-49ba-9f26-f07b7fa4768d@fnnas.com> <d298e159-1e47-4c97-80cd-41c4c1c74a04@synology.com>
Received: from [192.168.1.104] ([39.182.0.183]) by smtp.feishu.cn with ESMTPS; Tue, 28 Apr 2026 16:29:20 +0800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fnnas.com
To: "FengWei Shih" <dannyshih@synology.com>, <song@kernel.org>
From: "Yu Kuai" <yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Cc: <linan122@huawei.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yukuai@fnnas.com>
Date: Tue, 28 Apr 2026 16:29:18 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <f3a86781-07da-49c8-a3e9-e41b9d710727@fnnas.com>
In-Reply-To: <d298e159-1e47-4c97-80cd-41c4c1c74a04@synology.com>
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/4/21 15:09, FengWei Shih =E5=86=99=E9=81=93:
> Hi Kuai,
>
> Yu Kuai =E6=96=BC 2026/4/19 =E4=B8=8B=E5=8D=88 01:14 =E5=AF=AB=E9=81=93:
>> Hi,
>>
>> =E5=9C=A8 2026/4/9 13:17, FengWei Shih =E5=86=99=E9=81=93:
>>> raid5_make_request() checks mddev->reshape_position to decide whether
>>> to allow chunk-aligned reads. However in raid5_start_reshape(), the
>>> layout configuration (raid_disks, algorithm, etc.) is updated before
>>> mddev->reshape_position is set:
>>>
>>> =C2=A0=C2=A0=C2=A0 reshape (raid5_start_reshape)=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 read (raid5_make_request)
>>> =C2=A0=C2=A0=C2=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> =C2=A0=C2=A0=C2=A0 write_seqcount_begin
>>> =C2=A0=C2=A0=C2=A0 update raid_disks, algorithm...
>>> =C2=A0=C2=A0=C2=A0 set conf->reshape_progress
>>> =C2=A0=C2=A0=C2=A0 write_seqcount_end
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 check mddev->reshape_position
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * still MaxSector, allow
>>> raid5_read_one_chunk()
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * use new layout
>>> =C2=A0=C2=A0=C2=A0 raid5_quiesce()
>>> =C2=A0=C2=A0=C2=A0 set mddev->reshape_position
>> While we're here, I think it's pretty ugly to disable=20
>> raid5_read_one_chunk
>> when reshape is not fully done. So a better solution should be:
>>
>> - data behind reshape: read with new layout
>> - data ahead of reshape: read with old layout, reshape will also need=20
>> to wait
>> for this IO to be done, before reshape can make progress.
>> - data intersecting the active reshape window: wait for reshape to=20
>> make progress.
>
> Thanks for the feedback. I agree that using reshape_progress to=20
> distinguish
> the three cases (ahead/behind/inside reshape) would be more refined.
>
> But disabling chunk-aligned reads during reshape was already the=20
> existing design.
> In the original code, the check is at the caller level:
>
> =C2=A0 =C2=A0 if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 mddev->reshape_position =3D=3D MaxSector) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 bi =3D chunk_aligned_read(mddev, bi);
> =C2=A0 =C2=A0 }
>
> My patch is focused on fixing the race condition in the existing=20
> lockless check of whether
> reshape is in progress. So just to confirm: are you suggesting we add=20
> a mechanism to
> allow chunk-aligned reads during reshape (based on reshape progress),=20
> rather
> than simply disabling them?

Yes, I think this is a huge performance improvement. And in this case it's =
totally
fine to do chunk aligned read with old layout since reshape do not start ye=
t.

>
>>> Since reshape_position is not yet updated, raid5_make_request()
>>> considers no reshape is in progress and proceeds with the
>>> chunk-aligned path, but the layout has already changed, causing
>>> raid5_compute_sector() to return an incorrect physical address.
>>>
>>> Fix this by reading conf->reshape_progress under gen_lock in
>>> raid5_read_one_chunk() and falling back to the stripe path if a
>>> reshape is in progress.
>>>
>>> Signed-off-by: FengWei Shih <dannyshih@synology.com>
>>> ---
>>> =C2=A0=C2=A0 drivers/md/raid5.c | 8 ++++++++
>>> =C2=A0=C2=A0 1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>> index a8e8d431071b..bded2b86f0ef 100644
>>> --- a/drivers/md/raid5.c
>>> +++ b/drivers/md/raid5.c
>>> @@ -5421,6 +5421,11 @@ static int raid5_read_one_chunk(struct mddev=20
>>> *mddev, struct bio *raid_bio)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sector_t sector, end_sector;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int dd_idx;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool did_inc;
>>> +=C2=A0=C2=A0=C2=A0 int seq;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 seq =3D read_seqcount_begin(&conf->gen_lock);
>>> +=C2=A0=C2=A0=C2=A0 if (unlikely(conf->reshape_progress !=3D MaxSector)=
)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> =C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!in_chunk_boundar=
y(mddev, raid_bio)) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_debug("=
%s: non aligned\n", __func__);
>>> @@ -5431,6 +5436,9 @@ static int raid5_read_one_chunk(struct mddev=20
>>> *mddev, struct bio *raid_bio)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 &dd_idx, NULL);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 end_sector =3D sector + bio_sector=
s(raid_bio);
>>> =C2=A0=C2=A0 +=C2=A0=C2=A0=C2=A0 if (read_seqcount_retry(&conf->gen_loc=
k, seq))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (r5c_big_stripe_cached(conf, se=
ctor))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> Thanks,
> FengWei Shih
>
> Disclaimer: The contents of this e-mail message and any attachments=20
> are confidential and are intended solely for addressee. The=20
> information may also be legally privileged. This transmission is sent=20
> in trust, for the sole purpose of delivery to the intended recipient.=20
> If you have received this transmission in error, any use, reproduction=20
> or dissemination of this transmission is strictly prohibited. If you=20
> are not the intended recipient, please immediately notify the sender=20
> by reply e-mail or phone and delete this message and its attachments,=20
> if any.

--=20
Thansk,
Kuai
